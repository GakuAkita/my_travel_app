dynamic normalizeMapStructure(dynamic value) {
  if (value is Map) {
    return value.map(
      (key, val) => MapEntry(key.toString(), normalizeMapStructure(val)),
    );
  }

  if (value is List) {
    return value.map(normalizeMapStructure).toList();
  }

  return value;
}
