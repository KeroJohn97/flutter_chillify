class Song {
  final int id;
  final String artist;
  final String title;
  final String album;
  final int albumId;
  final int duration;
  final String uri;
  final String albumArt;

  Song(
    this.id,
    this.artist,
    this.title,
    this.album,
    this.albumId,
    this.duration,
    this.uri,
    this.albumArt,
  );

  factory Song.fromMap(Map m) {
    return Song(
      m["id"],
      m["artist"],
      m["title"],
      m["album"],
      m["albumId"],
      m["duration"],
      m["uri"],
      m["albumArt"],
    );
  }

  @override
  String toString() {
    return 'Song - Id: $id, Artist: $artist, Title: $title, Album: $album, Album Id: $albumId, Duration: $duration, Uri: $uri, Album Art: $albumArt';
  }
}
