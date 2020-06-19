import 'package:dharma_deshana/handler/database_handler.dart';
import 'package:dharma_deshana/loader/db_data_loader.dart';
import 'package:dharma_deshana/loader/firebase_loader.dart';
import 'package:dharma_deshana/models/music_category.dart';
import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/provider/data_provider.dart';

class DataLoader {
  loadData(DataProvider provider) async {
    await DbDataLoader().loadSongs().then((songs) {
      if (songs.isNotEmpty) {
        DateTime nextInsertTime = songs[0].dateTime.add(Duration(days: 1));
        if (nextInsertTime.isBefore(DateTime.now())) {
          loadFromFirebase(provider);
        } else {
          loadFromDatabase(provider, songs);
        }
      } else {
        loadFromFirebase(provider);
      }
    });
  }

  loadFromFirebase(DataProvider provider) async {
    FirebaseLoader firebaseLoader = FirebaseLoader();
    firebaseLoader.initData();

    await firebaseLoader.loadSongs().then((songs) {
      provider.setSongs(songs);

      firebaseLoader.loadCategories().then((categories) {
        provider.setMusicCategories(categories);

        provider.categorizeData();
        provider.setInitialized(true);

        insertSongsToDb(songs, true);
        insertCategoriesToDb(categories, true);
      });
    });
    print('Initliazed from firebase');
  }

  loadFromDatabase(DataProvider provider, List<Song> songs) async {
    await DbDataLoader().loadCategories().then((categories) {
      provider.setSongs(songs);
      provider.setMusicCategories(categories);

      provider.categorizeData();
      provider.setInitialized(true);
    });
    print('Initialized from DB');
  }

  void insertSongsToDb(List<Song> songs, bool remove) async {
    if (remove) {
      DatabaseHandler().deleteAll(Song.tableName);
    }
    DatabaseHandler().insertAll(songs);
  }

  void insertCategoriesToDb(List<MusicCategory> categories, bool remove) async {
    if (remove) {
      DatabaseHandler().deleteAll(MusicCategory.tableName);
    }
    DatabaseHandler().insertAll(categories);
  }
}
