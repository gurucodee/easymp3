import 'dart:io';
import 'dart:convert';
import 'package:EasyMP3/models/track_info.dart';
import 'package:http/http.dart' as http;
import 'package:EasyMP3/models/track.dart';

// A function that converts a response body into a List<Tracks>.
List<Tracks> parseTracks(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Tracks>((json) => Tracks.fromJson(json)).toList();
}

// A function that converts a response body into a List<TrackInfo>.
TrackInfo parseTrackInfo(String responseBody) {
  // final parsed = jsonDecode(responseBody);
  return TrackInfo.fromJson(jsonDecode(responseBody));
}

Future<List<Tracks>> fetchTracks({String? query}) async {
  var queryParameters = {'q': query ?? ''};
  var uri = Uri.https('expl.lillill.li', '/2/unknown', queryParameters);

  var response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  print(response.body);
  return parseTracks(response.body);
}

Future<TrackInfo> fetchTrackInfo({String? track_id}) async {

  var trackInfoQueryParameters = {'id': track_id};
  var uri = Uri.https('hub.ilill.li', '/', trackInfoQueryParameters);

  print(uri);

  var response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  return TrackInfo.fromJson(jsonDecode(response.body));
}
