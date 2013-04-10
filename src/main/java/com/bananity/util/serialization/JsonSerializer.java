package com.bananity.util.serialization;

import java.util.Collection;
import java.util.Map;

/**
 * This class encapsulates static methods to serialize objects to JSON representations 
 *
 * @author 	Andreu Correa Casablanca
 * @see 	com.bananity.util.serialization.IJsonSerializable
 */
public class JsonSerializer {

	/**
	 * Generic method to serialize "any" object to a JSON string
	 *
	 * @param 	jsonObject 	Object to be serialized
	 * @return 				JSON string
	 */
	public static String ObjectToJsonString (Object jsonObject) {
		if (jsonObject == null) {

			return "null";

		} if (jsonObject instanceof Boolean) {

			return ((Boolean)jsonObject).toString();

		} if (jsonObject instanceof Integer) {

			return ((Integer)jsonObject).toString();

		} if (jsonObject instanceof Long) {

			return ((Long)jsonObject).toString();

		} if (jsonObject instanceof Float) {

			return ((Float)jsonObject).toString();

		} if (jsonObject instanceof Double) {

			return ((Double)jsonObject).toString();

		} if (jsonObject instanceof String) {

			return StringToJsonString((String)jsonObject);

		} if (jsonObject instanceof Collection) {

			return CollectionToJsonString((Collection)jsonObject);

		} if (jsonObject instanceof Object[]) {

			return ArrayToJsonString((Object[])jsonObject);

		} if (jsonObject instanceof Map) {

			return MapToJsonString((Map)jsonObject);

		} if (jsonObject instanceof IJsonSerializable) {

			return ((IJsonSerializable)jsonObject).toJsonStr();

		} else {
			return ""; // TODO : throw an Exception
		}
	}

	/**
	 * @return 	Escaped and quoted valid JSON string value
	 */
	public static String StringToJsonString (String str) {
		return new StringBuilder()
			.append("\"")
			.append(
				str
					.replace("\"", "\\\"")
					.replace("\n", "\\n")
					.replace("\t", "\\t")
					.replace("\r", "\\r")
			)
			.append("\"")
			.toString();
	}

	/**
	 * Serializes collections as if were arrays to JSON strings
	 */
	public static String CollectionToJsonString (Collection jsonCollection) {
		StringBuilder result = new StringBuilder("[");

		boolean isStart = true;
		for (Object item : jsonCollection) {
			if (isStart) {
				isStart = false;
			} else {
				result.append(",");
			}

			result.append(ObjectToJsonString(item));
		}

		return result.append("]").toString();
	}

	/**
	 * Serializes arrays to JSON strings
	 */
	public static String ArrayToJsonString (Object[] jsonArray) {
		StringBuilder result = new StringBuilder("[");

		boolean isStart = true;
		for (Object item : jsonArray) {
			if (isStart) {
				isStart = false;
			} else {
				result.append(",");
			}

			result.append(ObjectToJsonString(item));
		}

		return result.append("]").toString();
	}

	/**
	 * Serializes maps to JSON Object values
	 */
	public static String MapToJsonString (Map<String, Object> jsonMap) {
		StringBuilder result = new StringBuilder("{");

		boolean isStart = true;
		for (Map.Entry<String, Object> entry : jsonMap.entrySet()) {
			if (isStart) {
				isStart = false;
			} else {
				result.append(",");
			}

			result.append("\"").append(entry.getKey()).append("\":").append(ObjectToJsonString(entry.getValue()));
		}

		return result.append("}").toString();
	}
}
