import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/models/music_category.dart';
import 'package:dharma_deshana/provider/data_provider.dart';

abstract class AbstractLoader {
  void initData(Function callback, DataProvider provider);

  Future<List<Song>> loadSongs();

  Future<List<MusicCategory>> loadCategories();
}
