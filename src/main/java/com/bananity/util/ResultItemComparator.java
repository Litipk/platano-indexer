package com.bananity.util;


import java.util.Comparator;
import java.util.HashMap;


/**
 * Comparator class, compares search results using a String as a reference
 *
 * @author 	Andreu Correa Casablanca
 * @see 	java.util.Comparator
 */
public class ResultItemComparator implements Comparator<SearchTerm>
{
	private final SearchTerm base;
	private final HashMap<SearchTerm, Double> distancesCache;

	/**
	 * Constructor, base is used to compare the distances from the comparables to it.
	 */
	public ResultItemComparator (SearchTerm base) {
		this.base = base;
		distancesCache = new HashMap<SearchTerm, Double>();
	}

	/**
	 * Compares 'st1' and 'st2' (compares it's distances to 'base', see the constructor param)
	 */
	public int compare (SearchTerm st1, SearchTerm st2) {
		
		if (st1.equals(st2)) {
			return 0;
		}

		int result;

		Double d1 = distancesCache.get(st1);
		Double d2 = distancesCache.get(st2);

		if (d1 == null) {
			d1 = computeLcFlattenDistance(st1);
		}
		if (d2 == null) {
			d2 = computeLcFlattenDistance(st2);
		}

		result = d1.compareTo(d2);

		if (result == 0) {
			d1 = computeLowerCaseDistance(st1);
			d2 = computeLowerCaseDistance(st2);

			result = d1.compareTo(d2);

			if (result == 0) {
				d1 = computeOriginalDistance(st1);
				d2 = computeOriginalDistance(st2);

				result = d1.compareTo(d2);
			}
		}

		return result;
	}

	/**
	 * First distance (the most used, the only cached distance)
	 */
	private double computeLcFlattenDistance (SearchTerm st) {
		double d = base.getLcFlattenStrings().getTextBag().distance(st.getLcFlattenStrings().getTextBag());
		distancesCache.put(st, d);

		return d;
	}

	/**
	 * Second distance
	 */
	private double computeLowerCaseDistance (SearchTerm st) {
		return base.getLowerCaseStrings().getTextBag().distance(st.getLowerCaseStrings().getTextBag());
	}

	/**
	 * Third distance
	 */
	private double computeOriginalDistance (SearchTerm st) {
		return base.getOriginalStrings().getTextBag().distance(st.getOriginalStrings().getTextBag());
	}
}