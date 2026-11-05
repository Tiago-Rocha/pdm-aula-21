class Island {
  const Island({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double latitude; // the centre of the island, from the API
  final double longitude;

  factory Island.fromJson(Map<String, dynamic> json) {
    return Island(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
