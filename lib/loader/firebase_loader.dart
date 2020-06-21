import 'package:dharma_deshana/handler/firebase_handler.dart';
import 'package:dharma_deshana/loader/abstract_loader.dart';
import 'package:dharma_deshana/models/music_category.dart';
import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/provider/data_provider.dart';

class FirebaseLoader extends AbstractLoader {
  final FirebaseHandler firebaseHandler = FirebaseHandler();

  @override
  void initData( Function callback, DataProvider provider ) async {
    firebaseHandler.initData(callback, provider);
  }

  @override
  Future<List<Song>> loadSongs() async {
  }

  @override
  Future<List<MusicCategory>> loadCategories() async {
  }
}
