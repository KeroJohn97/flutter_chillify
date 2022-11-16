import 'dart:io';
import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';

class MusicHelper {
  MusicHelper._();
  static final OnAudioQuery _audioQuery = OnAudioQuery();

  static Future<Uint8List?> getAlbumArt(SongModel song) async {
    return await _audioQuery.queryArtwork(song.id, ArtworkType.ALBUM);
  }

  static Future<List<SongModel>> getAllSongs() async {
    if (Platform.isAndroid || Platform.isIOS) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      return await _audioQuery.querySongs();
    }
    return [];
  }
}
