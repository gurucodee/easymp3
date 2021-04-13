import 'package:EasyMP3/components/get_tracks.dart';
import 'package:EasyMP3/components/tracks_builder.dart';
import 'package:EasyMP3/models/track.dart';
import 'package:flutter/material.dart';
import 'package:EasyMP3/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool fetchingSongs = false;
  List<Tracks> _homeTracks = [];
  TextEditingController searchBar = TextEditingController();

  search() async {
    String searchQuery = searchBar.text;

    if (searchQuery.isEmpty) return;
      fetchingSongs = true;
      setState(() {});

    _homeTracks = await fetchTracks(query: searchQuery);

    fetchingSongs = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF00BF6D),
            Color(0xFF3FC988),
            Color(0xFF4FAC80),
          ],
        ),
      ),
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        extendBody: true,
        //backgroundColor: Color(0xff384850),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.0,),
                    Text(
                      "EasyMP3",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(
                        // fontWeight: FontWeight.bold,
                        // color: Colors.white,
                        fontSize: 40.0,
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    if (_homeTracks.isNotEmpty)
                      Text(
                        'Results: ${_homeTracks.length}',
                        style: TextStyle(
                          // color: kWarningColor,
                          fontSize: 16.0,
                          // fontWeight: FontWeight.w100
                        )
                      ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _homeTracks.isNotEmpty ?
                          TracksListBuilder(tracks: _homeTracks,):
                        Icon(
                          Icons.search_off_sharp,
                          size: 100.0,
                          // color: Colors.white.withOpacity(0.1),
                        )
                      ],
                    ),
                  )
                ),
                SizedBox(height: 10.0,),
                TextField(
                  onSubmitted: (String value) {
                    search();
                  },
                  controller: searchBar,
                  style: TextStyle(
                    fontSize: 25.0,
                    // color: Colors.white,
                  ),
                  // cursorColor: Colors.white,
                  decoration: InputDecoration(
                    // fillColor: Color(0xff263238),
                    // filled: false,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      borderSide: BorderSide(color: kWarningColor),
                    ),
                    suffixIcon: IconButton(
                      icon: fetchingSongs
                          ? SizedBox(
                        height: 18,
                        width: 18,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        ),
                      ) : Icon(
                        Icons.search,
                        // color: Colors.white,
                      ),
                      color: kPrimaryColor,
                      onPressed: () {
                        print("Search!");
                      },
                      splashColor: Colors.transparent,
                    ),
                    border: InputBorder.none,
                    hintText: "Search...",
                    hintStyle: TextStyle(
                      // color: Colors.white,
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 18,
                      right: 20,
                      top: 14,
                      bottom: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
