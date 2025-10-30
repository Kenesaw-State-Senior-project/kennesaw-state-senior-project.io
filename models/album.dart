// Model for Album Data Storage and Access
class Album {
  final String name;
  final String songID;
  final String imgURL;
  final String artistName; 
  final String releaseDate; 

  Album({required this.name, required this.songID, required this.imgURL, required this.artistName, required this.releaseDate});

  factory Album.fromJson(Map<String, dynamic> json) {
    final imgURL = (json['images'] as List).isNotEmpty
        ? json['images'][0]['url']
        : '';
    final artistName = (json['artists'] as List).isNotEmpty 
        ? json['artists'][0]['name']
        : 'Unknown Artist';
    
    return Album(
      name: json['name'],
      songID: json['id'],
      imgURL: imgURL,
      artistName: artistName,
      releaseDate: json['release_date'], 
    );
  }
}