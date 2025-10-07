// Model for Track Data Storage and Access
class Track {
  final String name;
  final String previewURL;
  final String imgURL;

  Track({required this.name, required this.previewURL, required this.imgURL});

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      name: json['name'],
      previewURL: json['preview_url'] ?? '',
      imgURL: json['album']['images'][0]['url'],
    );
  }
}
