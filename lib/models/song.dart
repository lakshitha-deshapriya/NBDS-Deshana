import 'package:dharma_deshana/models/savable.dart';

class Song extends Savable {
  static String tableName = 'SONGS';

  final int songId;
  final String category;
  final String url;
  final String name;
  final String type;
  final String sub;
  final String coverUrl;
  final String categoryTypeKey;
  final DateTime dateTime;

  Song({
    this.songId,
    this.category,
    this.url,
    this.name,
    this.type,
    this.sub,
    this.coverUrl,
    this.categoryTypeKey,
    this.dateTime,
  });

  factory Song.fromJson(dynamic json, int songId, DateTime dateTime) {
    return Song(
      songId: songId,
      category: json['category'],
      url: json['url'],
      name: json['name'],
      type: json['type'],
      sub: json['sub'],
      coverUrl: json['cover'],
      categoryTypeKey: json['category'] + '-' + json['type'],
      dateTime: dateTime,
    );
  }

  @override
  String getTableName() {
    return tableName;
  }

  @override
  String getArgs() {
    return 'SONG_ID = ?';
  }

  @override
  List<dynamic> getArgValues() {
    return [songId];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['SONG_ID'] = songId;
    map['CATEGORY'] = category;
    map['SONG_URL'] = url;
    map['NAME'] = name;
    map['TYPE'] = type;
    map['SUB'] = sub;
    map['COVER_URL'] = coverUrl;
    map['INSERT_TIME'] = dateTime.millisecondsSinceEpoch;
    return map;
  }

  factory Song.fromMapObject(Map<String, dynamic> map) {
    return Song(
      songId: map['SONG_ID'],
      category: map['CATEGORY'],
      url: map['SONG_URL'],
      name: map['NAME'],
      type: map['TYPE'],
      sub: map['SUB'],
      coverUrl: map['COVER_URL'],
      categoryTypeKey: map['CATEGORY'] + '-' + map['TYPE'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['INSERT_TIME']),
    );
  }
}
