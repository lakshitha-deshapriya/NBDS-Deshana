import 'package:dharma_deshana/handler/database_handler.dart';
import 'package:dharma_deshana/loader/abstract_loader.dart';
import 'package:dharma_deshana/models/music_category.dart';
import 'package:dharma_deshana/models/song.dart';

class DbDataLoader extends AbstractLoader {
  final DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  void initData() {}

  @override
  Future<List<Song>> loadSongs() async {
    return databaseHandler.getAll(Song.tableName).then(
          (value) => value.map((entry) => Song.fromMapObject(entry)).toList(),
        );
  }

  @override
  Future<List<MusicCategory>> loadCategories() async{
    return databaseHandler.getAll(MusicCategory.tableName).then(
          (value) =>
              value.map((entry) => MusicCategory.fromMapObject(entry)).toList(),
        );
  }
}
