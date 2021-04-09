class TrackInfo {
  final String id;
  final String status;
  final String artist;
  final String filename;
  final String live;
  final String title;

  TrackInfo(
      {
        required this.id,
        required this.status,
        required this.artist,
        required this.filename,
        required this.live,
        required this.title,
      });

  factory TrackInfo.fromJson(Map<String, dynamic> json) {
    return TrackInfo(
      id: json['_id'] as String,
      status: json['status'] as String,
      artist: json['artist'] as String,
      filename: json['filename'] as String,
      live: json['live'] as String,
      title: json['title'] as String,
    );
  }

}