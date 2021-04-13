import 'package:EasyMP3/components/get_tracks.dart';
import 'package:EasyMP3/constants.dart';
import 'package:EasyMP3/models/track.dart';
import 'package:EasyMP3/screens/play_track/play_track.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TracksListBuilder extends StatefulWidget {
  final List<Tracks> tracks;

  TracksListBuilder({Key? key, required this.tracks}) : super(key: key);

  @override
  _TracksListBuilderState createState() => _TracksListBuilderState();
}

class _TracksListBuilderState extends State<TracksListBuilder> {
  bool fetchTrack = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.tracks.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return Card(
          color: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {
              try {
                fetchTrackInfo(track_id: widget.tracks[index].id.toString()).then((value) {
                  if (value.title.isNotEmpty)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayTrackScreen(track: value,),
                        )
                    );
                  else
                    print('Hello baba!');
                });
              } on Exception catch(e){
                print(e);
              }
            },
            onLongPress: () {
              print('Baba!');
            },
            splashColor: kPrimaryColor,
            // hoverColor: kContentColorLightTheme,
            // focusColor: kContentColorLightTheme,
            // highlightColor: kContentColorLightTheme,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Container(
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.music_note_outlined,
                        size: 30,
                      ),
                    ),
                  ),
                  title: Text(
                    (widget.tracks[index].title).toString().split("(")[0].replaceAll("&quot;", "\"").replaceAll("&amp;", "&"),
                    // style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Bitrate: ${widget.tracks[index].bpm} Kbps',
                    // style: TextStyle(color: Colors.white38),
                  ),
                  trailing: Text(
                    '${widget.tracks[index].duration}',
                    style: TextStyle(
                      color: kPrimaryColor,
                    ),
                  ),
                  // trailing: IconButton(
                  //   color: kPrimaryColor,
                  //   tooltip: 'BPM quality',
                  //   icon: Icon(Icons.cloud_download_outlined),
                  //   onPressed: () => { print('Download track!')},
                  // ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}