package com.bananity.util;


import com.bananity.util.Jaccard;
import com.bananity.util.SearchesTokenizer;

import java.util.Comparator;
import java.util.HashMap;


public class ResultItemComparator implements Comparator<String>
{
	private final HashBag<String> searchTermBag;
	private final HashMap<String, Double> distancesCache;

	public ResultItemComparator (HashBag<String> searchTermBag) {
		this.searchTermBag = searchTermBag;
		distancesCache = new HashMap<String, Double>();
	}

	public int compare(String r1, String r2) {
		Double d1 = distancesCache.get(r1);
		Double d2 = distancesCache.get(r2);

		try {
			if (d1 == null) {
				d1 = Jaccard.distance(SearchesTokenizer.getSubTokensBag(r1), searchTermBag);
				distancesCache.put(r1, d1);
			}

			if (d2 == null) {
				d2 = Jaccard.distance(SearchesTokenizer.getSubTokensBag(r2), searchTermBag);
				distancesCache.put(r2, d2);
			}
		} catch (Exception e) {
			// TODO: Comprobar que efectivamente no se lanzan IOExceptions
		}

		return d1.compareTo(d2);
	}
}