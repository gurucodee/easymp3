class Tracks {
  final int id;
  final int bpm;
  final String title;
  final String duration;

  Tracks({
    required this.bpm,
    required this.duration,
    required this.id,
    required this.title,
  });

  factory Tracks.fromJson(Map<String, dynamic> json) {
    return Tracks(
      id: json['id'] as int,
      bpm: json['bpm'] as int,
      title: json['title'] as String,
      duration: json['duration'] as String,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': this.id,
  //     'title': this.title,
  //     'bpm': this.bpm,
  //     'duration': this.duration,
  //   };
  // }
  //
  // Tracks createTrack(record) {
  //   Map<String, dynamic> attributes = {
  //     'id': "",
  //     'title': "",
  //     'bpm': "",
  //     'duration': "",
  //   };
  //
  //   record.forEach((key, value) => {attributes[key] = value});
  //
  //   Tracks track = new Tracks(
  //       attributes['id'],
  //       attributes['title'],
  //       attributes['bpm'],
  //       attributes['duration']
  //   );
  //
  //   return track;
  // }
}