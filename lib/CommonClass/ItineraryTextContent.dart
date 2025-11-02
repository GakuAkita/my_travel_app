class ItineraryTextContent {
  final String? sectionName;
  final String data;

  ItineraryTextContent({required this.sectionName, required this.data});

  ItineraryTextContent copyWith({String? sectionName, String? data}) {
    return ItineraryTextContent(
      sectionName: sectionName ?? this.sectionName,
      data: data ?? this.data,
    );
  }
}
