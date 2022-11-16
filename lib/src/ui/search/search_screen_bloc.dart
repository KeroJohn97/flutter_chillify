// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:rxdart/rxdart.dart';

import '../../models/song.dart';

class SearchScreenBloc {
  late BehaviorSubject<List<Song>?> _filteredSongs$;

  BehaviorSubject<List<Song>?> get filteredSongs$ => _filteredSongs$;

  SearchScreenBloc() {
    _filteredSongs$ = BehaviorSubject<List<Song>>.seeded([]);
  }

  void updateFilteredSongs(String filter, List<Song> songs) {
    final _phrase = filter.replaceAll(" ", "").toLowerCase();
    List<Song> _filteredSongs = [];
    if (_phrase.length == 0) {
      _filteredSongs$.add(_filteredSongs);
      return;
    }
    for (Song song in songs) {
      final _songName = song.title.replaceAll(" ", "").toLowerCase();
      final _albumName = song.album.replaceAll(" ", "").toLowerCase();
      final _artistNames =
          song.artist.replaceAll(" ", "").replaceAll(";", "").toLowerCase();
      final _songString = _songName + _albumName + _artistNames;

      if (_songString.contains(_phrase)) {
        _filteredSongs.add(song);
      }
    }

    if (_filteredSongs.length == 0) {
      _filteredSongs$.add(null);
    }

    _filteredSongs$.add(_filteredSongs);
  }

  void dispose() {
    _filteredSongs$.close();
  }
}
