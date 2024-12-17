abstract class JsonUtil {
  static Map<String, dynamic> formatMap(Map<dynamic, dynamic> json) {
    final map = Map<String?, dynamic>.from(json)
      ..removeWhere((key, value) => key == null);

    return map.cast<String, dynamic>();
  }

  static T? fromJsonOrNull<T>(
    dynamic json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (json == null) return null;
    if (json is! Map) return null;

    return fromJson(formatMap(json));
  }

  static List<T> formatListMap<T>(
    List<dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      json.map((e) => fromJson(formatMap(e as Map))).toList();
}
