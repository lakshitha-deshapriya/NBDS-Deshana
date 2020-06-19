import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/models/music_category.dart';

abstract class AbstractLoader {
  void initData();

  Future<List<Song>> loadSongs();

  Future<List<MusicCategory>> loadCategories();
}
