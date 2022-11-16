import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_app/src/helpers/music_helper.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../models/song.dart';

class AlbumArtContainer extends StatefulWidget {
  const AlbumArtContainer({
    Key? key,
    required double radius,
    required double albumArtSize,
    required Song currentSong,
  })  : _radius = radius,
        _albumArtSize = albumArtSize,
        _currentSong = currentSong,
        super(key: key);

  final double _radius;
  final double _albumArtSize;
  final Song _currentSong;

  @override
  State<AlbumArtContainer> createState() => _AlbumArtContainerState();
}

class _AlbumArtContainerState extends State<AlbumArtContainer> {
  Uint8List? encodedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      encodedImage = await MusicHelper.getAlbumArt(
        SongModel({
          '_id': widget._currentSong.id,
          '_uri': widget._currentSong.uri,
          'album': widget._currentSong.album,
          'album_id': widget._currentSong.albumId,
          'artist': widget._currentSong.artist,
          'duration': widget._currentSong.duration,
          'title': widget._currentSong.title,
        }),
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget._radius),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: widget._albumArtSize,
            child: encodedImage != null
                ? FadeInImage(
                    placeholder: MemoryImage(encodedImage!),
                    image: MemoryImage(encodedImage!),
                    // placeholder: AssetImage(_currentSong.albumArt),
                    // image: AssetImage(_currentSong.albumArt),
                    fit: BoxFit.fill,
                    placeholderErrorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/album_art.png'),
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/album_art.png'),
                  )
                : Image.asset('assets/album_art.png'),
          ),
          Opacity(
            opacity: 0.55,
            child: Container(
              width: double.infinity,
              height: widget._albumArtSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [
                    0.0,
                    0.85,
                  ],
                  colors: [
                    Color(0xFF47ACE1),
                    Color(0xFFDF5F9D),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
