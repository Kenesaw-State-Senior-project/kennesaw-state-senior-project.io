// Model for Track Data Storage and Access
class Track {
  final String name;
  final String previewURL;
  final String imgURL;
  final String uri;

  Track({
    required this.name,
    required this.previewURL,
    required this.imgURL,
    required this.uri,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      name: json['name'],
      previewURL: json['preview_url'] ?? '',
      imgURL: json['album']?['images']?[0]?['url'] ?? '',
      uri: json['uri'],
    );
  }
}
