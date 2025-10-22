// Model for Artist Data Storage and Access
class Artist {
  final String id;
  final String name;
  final String imgURL;

  Artist({required this.id, required this.name, required this.imgURL});

  factory Artist.fromJson(Map<String, dynamic> json) {
    final imgURL = (json['images'] as List).isNotEmpty
        ? json['images'][0]['url']
        : '';
    return Artist(id: json['id'], name: json['name'], imgURL: imgURL);
  }
}
