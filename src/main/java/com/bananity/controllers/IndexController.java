package com.bananity.controllers;


// Bananity Classes
import com.bananity.models.IndexModelBean;
import com.bananity.text.TextNormalizer;
import com.bananity.util.SearchTerm;
import com.bananity.util.SearchTermFactory;
import com.bananity.util.SortedLists;
import com.bananity.util.StorageItemComparator;

// Cache
import com.google.common.cache.Cache;

// Java utils
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import java.io.IOException;
import java.io.PrintWriter;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 *  This webservlet allows to insert items into the index collections (and remove it)
 *
 *  @author 	Andreu Correa Casablanca
 *  @version 	0.5
 */
@WebServlet("/index")
public class IndexController extends BaseController {

	/**
	 *  IndexModelBean reference
	 */
	@EJB
	private IndexModelBean imB;

	/**
	 *  Handles Post requests, and calls insert or remove methods
	 *
	 *  @see javax.servlet.http.HttpServlet#doPost
	 */
	@Override
		public void doPost (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			// Here we take care of possible excessive memory usage
			long freeMem = Runtime.getRuntime().freeMemory();
			long usedMem = Runtime.getRuntime().totalMemory();
			long maxMem  = Runtime.getRuntime().maxMemory();
			if ( ((double)(maxMem-usedMem+freeMem))/((double)maxMem) < 0.10 ) {
				cB.freeSpace();
			}

			try {
				String 	method 		= request.getParameter("m");
				String 	collName 	= request.getParameter("c");
				String 	item 		= TextNormalizer.normalizeText(request.getParameter("item"), true);

				if (collName == null || collName.length() == 0 || item == null || item.length() == 0) {
					throw new Exception( "Invalid parameters" );
				}

				if (method.equals("insert")) {
					insertLogic(collName, item);
				} else if (method.equals("remove")) {
					removeLogic(collName, item);
				} else {
					throw new Exception("Inexistent method : m="+method);
				}

				sendResponse(request, response, HttpServletResponse.SC_OK, 0, null);

			} catch (OutOfMemoryError oome) {
				cB.hardFreeSpace();
				log.error("Out of Memory Error", oome);
				sendResponse(request, response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 1, null);
			} catch (Exception e) {
				log.warn("BAD_REQUEST from "+request.getRemoteAddr()+", params: "+request.getQueryString()+", body: "+request.getReader().readLine(), e);
				sendResponse(request, response, HttpServletResponse.SC_BAD_REQUEST, 1, null);
			}
		}

	/**
	 *  Insert an item into the specifiec collection (and updates caches)
	 *
	 *  @param collName Index collection name
	 *  @param item 	Item to be inserted in the collection
	 */
		private void insertLogic (String collName, String item) throws Exception {
			SearchTerm stItem = SearchTermFactory.get(item);

			imB.insert(collName, stItem);
			addToCache(collName, stItem);
		}

	/**
	 *  Removes an item from the specifiec collection (and updates caches)
	 *
	 *  @param collName Index collection name
	 *  @param item 	Item to be inserted in the collection
	 */
		private void removeLogic (String collName, String item) throws Exception {
			// WARNING : There aren't locks

			SearchTerm stItem = SearchTermFactory.get(item);

			imB.remove(collName, stItem);
			removeFromCache(collName, stItem);
		}

	/**
	 *  Adds an item to the results cache tied to the specified collection
	 *
	 *  @param collName Index collection name
	 *  @param item 	Item to be inserted in the collection
	 */
		private void  addToCache (String collName, SearchTerm item) throws Exception {
			Cache<String, ArrayList<SearchTerm>> cache = cB.getResultCache(collName);
			
			if (cache == null) {
				throw new Exception("¡Cache not foud for collection \""+collName+"\"!");
			}

			HashSet<String> expandedCacheKeyBase = item.getLcFlattenStrings().getUniqueByLength(2);

			for (String cacheKeyBaseItem : expandedCacheKeyBase) {
				addToCacheToken (cache, item, cacheKeyBaseItem, 5);
				addToCacheToken (cache, item, cacheKeyBaseItem, 10);
				addToCacheToken (cache, item, cacheKeyBaseItem, 15);
				addToCacheToken (cache, item, cacheKeyBaseItem, 20);
			}
		}

	/**
	 *  Removes an item from the results cache tied to the specified collection
	 *
	 * @param collName 	Index collection name
	 * @param item 		Item to be removed from the collection
	 */
		private void removeFromCache (String collName, SearchTerm item) throws Exception {
			Cache<String, ArrayList<SearchTerm>> cache = cB.getResultCache(collName);
			
			if (cache == null) {
				throw new Exception("¡Cache not foud for collection \""+collName+"\"!");
			}

			HashSet<String> expandedCacheKeyBase = item.getLcFlattenStrings().getUniqueByLength(2);

			for (String cacheKeyBaseItem : expandedCacheKeyBase) {
				removeCacheToken (cache, cacheKeyBaseItem, 5);
				removeCacheToken (cache, cacheKeyBaseItem, 10);
				removeCacheToken (cache, cacheKeyBaseItem, 15);
				removeCacheToken (cache, cacheKeyBaseItem, 20);
			}
		}

	/**
	 *  Adds an item to a results cache value (given with the key cacheKeyBaseItem@limit)
	 *
	 *  @param cache 			cache to be updated
	 *  @param item 			item 
	 *  @param cacheKeyBaseItem complete or partial searchTerm (as a part of cache key)
	 *  @param limit 			limit imposed to search result size (as a part of cache key)
	 */
		private void addToCacheToken (Cache<String, ArrayList<SearchTerm>> cache, SearchTerm item, String cacheKeyBaseItem, int limit) throws Exception {
			String cacheKey 					= new StringBuilder(cacheKeyBaseItem).append("@").append(limit).toString();
			ArrayList<SearchTerm>  cachedResult = cache.getIfPresent(cacheKey);
			if (cachedResult == null) return;

			SortedLists.sortedInsert(new StorageItemComparator(cacheKeyBaseItem), cachedResult, limit, item);
		}

	/**
	 *  Removes an item from the results cache tied to the specified collection (given a result length)
	 *
	 *  @param cache 			cache to be updated
	 *  @param cacheKeyBaseItem complete or partial searchTem (as a part of cache key)
	 *  @param limit 			limit imposed to search result size (as a part of cache key)
	 */
		private void removeCacheToken (Cache<String, ArrayList<SearchTerm>> cache, String cacheKeyBaseItem, int limit) {
			String cacheKey = new StringBuilder(cacheKeyBaseItem).append("@").append(limit).toString();
			cache.invalidate(cacheKey);
		}
}