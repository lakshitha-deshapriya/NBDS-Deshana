import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/models/music_category.dart';
import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/provider/data_provider.dart';

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

  void initData(Function callback, DataProvider provider) async {
    print('Json retrieve started');
    Firestore.instance.collection('MyApp').document(AppConstant.prod).get().then(
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

        callback( songs, categories, provider );
      },
    ).catchError((_) {
      callback(List<Song>(), List<MusicCategory>(), provider);
    });
  }
}
