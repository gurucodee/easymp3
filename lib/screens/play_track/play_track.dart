import 'dart:io';

import 'package:EasyMP3/components/track_control_buttons.dart';
import 'package:EasyMP3/components/track_seek_bar.dart';
import 'package:EasyMP3/constants.dart';
import 'package:EasyMP3/models/track_info.dart';
import 'package:EasyMP3/models/track_meta_data.dart';
import 'package:EasyMP3/models/track_position_data.dart';
import 'package:EasyMP3/services/user_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class PlayTrackScreen extends StatefulWidget {

  final TrackInfo track;

  PlayTrackScreen({Key? key, required this.track}) : super(key: key);

  @override
  _PlayTrackState createState() => _PlayTrackState();
}

class _PlayTrackState extends State<PlayTrackScreen> {

  late dynamic _playlist = ConcatenatingAudioSource(
    children: [
      ClippingAudioSource(
        start: Duration(seconds: 0),
        // end: Duration(seconds: 90),
        child: AudioSource.uri(
            Uri.parse('${widget.track.live}')
        ),
        tag: AudioMetadata(
          album: "${widget.track.artist}",
          title: "${widget.track.title.split('-')[1]}",
          artwork: "",
        ),
      ),
    ],
  );

  late AudioPlayer _player;
  late Future<TrackInfo> _trackInfo;

  final Dio dio = Dio();
  bool loading = false;
  double progress = 0;

  @override
  void initState() {

    super.initState();

    _player = AudioPlayer();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
      )
    );

    _init();

    _player.play();

  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }
  }

  Future<bool> saveTrack(String url, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Download";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(url, saveFile.path,
            onReceiveProgress: (value1, value2) {
              setState(() {
                progress = value1 / value2;
              });
            });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(
            saveFile.path,
            isReturnPathOfIOS: true,
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  downloadTrack() async {
    setState(() {
      loading = true;
      progress = 0;
    });
    bool downloaded = await saveTrack(
      widget.track.live,
      widget.track.filename
    );
    if (downloaded) {
      toastUserMsg(context, "File Downloaded");
    } else {
      toastUserMsg(context, "Problem Downloading File");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Scaffold(
        backgroundColor: kContentColorLightTheme,
        appBar: AppBar(
          backgroundColor: kContentColorLightTheme,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${widget.track.title}")
            ],
          ),
          actions: [
            IconButton(
              color: kPrimaryColor,
              icon: Icon(Icons.cloud_download_outlined),
              onPressed: () async {
                await downloadTrack();
              },
            ),
          ],
        ),
        body: loading ?
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Downloading file: ${progress.toString()}%'
              ),
            ),
          ) : SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<SequenceState?>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) return SizedBox();
                    final metadata = state!.currentSource!.tag as AudioMetadata;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            // Center(child: Image.network(metadata.artwork)),
                            Center(
                              child: Image.asset(
                                'assets/images/track_placeholder.png',
                                width: 150.0,
                              ),
                            ),
                          ),
                        ),
                        Text(metadata.album, style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.white
                        )),
                        Text(
                          metadata.title,
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ControlButtons(
                _player,
              ),
              StreamBuilder<Duration?>(
                stream: _player.durationStream,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  return StreamBuilder<PositionData>(
                    stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                      _player.positionStream,
                      _player.bufferedPositionStream,
                      (position, bufferedPosition) =>
                      PositionData(position, bufferedPosition),
                    ),
                    builder: (context, snapshot) {
                      final positionData = snapshot.data ??
                          PositionData(Duration.zero, Duration.zero);
                      var position = positionData.position;
                      if (position > duration) {
                        position = duration;
                      }
                      var bufferedPosition = positionData.bufferedPosition;
                      if (bufferedPosition > duration) {
                        bufferedPosition = duration;
                      }
                      return SeekBar(
                        duration: duration,
                        position: position,
                        bufferedPosition: bufferedPosition,
                        onChangeEnd: (newPosition) {
                          _player.seek(newPosition);
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  StreamBuilder<LoopMode>(
                    stream: _player.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      const icons = [
                        Icon(Icons.repeat, color: Colors.grey),
                        Icon(Icons.repeat, color: Colors.orange),
                        Icon(Icons.repeat_one, color: Colors.orange),
                      ];
                      const cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
                      final index = cycleModes.indexOf(loopMode);
                      return IconButton(
                        icon: icons[index],
                        onPressed: () {
                          _player.setLoopMode(cycleModes[
                          (cycleModes.indexOf(loopMode) + 1) %
                              cycleModes.length]);
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      "repeate",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: _player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? Icon(Icons.shuffle, color: Colors.orange)
                            : Icon(Icons.shuffle, color: Colors.grey),
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          if (enable) {
                            await _player.shuffle();
                          }
                          await _player.setShuffleModeEnabled(enable);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
