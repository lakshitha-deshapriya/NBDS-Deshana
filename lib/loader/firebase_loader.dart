import 'package:dharma_deshana/handler/firebase_handler.dart';
import 'package:dharma_deshana/loader/abstract_loader.dart';
import 'package:dharma_deshana/models/music_category.dart';
import 'package:dharma_deshana/models/song.dart';

class FirebaseLoader extends AbstractLoader {
  final FirebaseHandler firebaseHandler = FirebaseHandler();

  @override
  void initData() async {
    firebaseHandler.initData();
  }

  @override
  Future<List<Song>> loadSongs() async {
    return await firebaseHandler.getData(Song.tableName).then((value) {
      List<Song> songs = value;
      return songs;
    });
  }

  @override
  Future<List<MusicCategory>> loadCategories() async {
    return await firebaseHandler.getData(MusicCategory.tableName).then((value) {
      List<MusicCategory> categories = value;
      print(categories.length);
      return categories;
    });
  }
}
