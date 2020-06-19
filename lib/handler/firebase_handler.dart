import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dharma_deshana/models/music_category.dart';
import 'package:dharma_deshana/models/song.dart';

class FirebaseHandler {
  static FirebaseHandler _firebaseHandler;

  List<Song> songs;
  List<MusicCategory> categories;
  bool initialized = false;
  bool success;

  FirebaseHandler._createInstance();

  factory FirebaseHandler() {
    if (_firebaseHandler == null) {
      _firebaseHandler = FirebaseHandler._createInstance();
    }
    return _firebaseHandler;
  }

  void initData() async {
    print('Json retrieve started');
    Firestore.instance.collection('MyApp').document('directory').get().then(
      (snapshot) {
        print('Json retrival finished');
        var dataJson = jsonDecode(snapshot['url'])['data'] as List;
        var categoryJson = jsonDecode(snapshot['url'])['categoryData'] as List;

        int songId = 1;
        DateTime dateTime = DateTime.now();
        songs = dataJson
            .map((json) => Song.fromJson(json, songId++, dateTime))
            .toList();

        int categoryId = 1;
        categories = categoryJson
            .map((json) => MusicCategory.fromJson(json, categoryId++))
            .toList();

        success = true;
        initialized = true;
      },
    ).catchError((_) {
      initialized = true;
      success = false;
    });
  }

  Future<List<dynamic>> getData(String identifier) async {
    if (!initialized) {
      return Future.delayed(
        Duration(milliseconds: 500),
        () => getData(identifier),
      );
    }
    if (Song.tableName == identifier) {
      return songs;
    } else if (MusicCategory.tableName == identifier) {
      return categories;
    }
    return List<dynamic>();
  }
}
