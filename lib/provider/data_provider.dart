import 'package:collection/collection.dart';
import 'package:dharma_deshana/loader/data_loader.dart';
import 'package:dharma_deshana/models/music_category.dart';
import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/provider/connectivity_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  bool _initialized = false;
  bool _local = false;
  List<Song> _songs;
  List<MusicCategory> _musicCategories;

  bool _categoryInitialized = false;
  List<String> _categories = List();

  bool _categoryTypesInitialized = false;
  Map<String, List<String>> _categoryTypes = Map();

  bool _categoryTypeSongsInitialized = false;
  Map<String, List<Song>> _categoryTypeSongs = Map();

  Map<String, String> _categoryImages = Map();

  bool get isInitialized => _initialized;
  void setInitialized(bool initialized) {
    this._initialized = initialized;
    notifyListeners();
  }

  bool get isLocal => _local;
  void setLocal(bool local) {
    this._local = local;
    notifyListeners();
  }

  List<Song> get songsList => _songs;
  void setSongs(List<Song> songs) {
    this._songs = songs;
    notifyListeners();
  }

  void setMusicCategories(List<MusicCategory> categories) {
    this._musicCategories = categories;
  }

  void addSong(Song song) {
    if (this._songs == null) {
      this._songs = List();
    }
    this._songs.add(song);
  }

  bool get isCategoriesInitialized => _categoryInitialized;
  void setCategoryInitialized(bool initialized) {
    this._categoryInitialized = initialized;
    notifyListeners();
  }

  bool get isTypesInitialized => _categoryTypesInitialized;
  void setTypesInitialized(bool initialized) {
    this._categoryTypesInitialized = initialized;
    notifyListeners();
  }

  bool get isCategoryTypeSongsInitialized => _categoryTypeSongsInitialized;
  void setCategoryTypeSongsInitialized(bool initialized) {
    this._categoryTypeSongsInitialized = initialized;
    notifyListeners();
  }

  List<String> get getCategories => _categories;
  void setCategories(List<String> categories) {
    this._categories = categories;
    notifyListeners();
  }

  Map<String, List<String>> get getCategoryTypes => _categoryTypes;
  void setCategoryTypes(Map<String, List<String>> categoryTypes) {
    this._categoryTypes = categoryTypes;
    notifyListeners();
  }

  Map<String, List<Song>> get categoryTypeSongs => _categoryTypeSongs;
  void setCategoryTypeSongs(Map<String, List<Song>> data) {
    this._categoryTypeSongs = data;
    notifyListeners();
  }

  updateSongTaskId(int songId, String taskId) {
    Song song = this._songs?.firstWhere((song) => song.songId == songId);
    if (song != null) {
      song.taskId = taskId;
    }
  }

  List<String> getTypesForCategory(String category) {
    return _categoryTypes[category];
  }

  List<Song> getSongsForCategoryTypeKey(String key) {
    return _categoryTypeSongs[key];
  }

  List<String> getImagesForCategoryTypeKey(String key) {
    return getSongsForCategoryTypeKey(key)
        .map((song) => song.coverUrl)
        .toSet()
        .toList();
  }

  String getImageUrlForCategory(String category) {
    if (_categoryImages.containsKey(category)) {
      return _categoryImages[category];
    }
    return 'https://res.cloudinary.com/lakshithadev/image/upload/v1590227298/Images/music_ab7bmx.png'; //Default category image
  }

  void initData(ConnectivityProvider connectivity) async {
    if (!isInitialized) {
      await DataLoader().loadData(this, connectivity);
    }
  }

  void categorizeData() async {
    _categories =
        _musicCategories.map((category) => category.category).toSet().toList();
    _categories.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    setCategoryInitialized(true);

    _musicCategories.forEach((cat) {
      _categoryImages[cat.category] = cat.imageUrl;
    });

    groupBy(_songs, (song) => song.category)
        .forEach((key, value) => addToCategoryTypeMap(key, value));

    setTypesInitialized(true);

    _categoryTypeSongs = groupBy(_songs, (song) => song.categoryTypeKey);

    _categoryTypeSongs.forEach((key, value) {
      value.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    });

    setCategoryTypeSongsInitialized(true);
  }

  void addToCategoryTypeMap(String key, List<Song> songs) {
    List<String> types = songs.map((song) => song.type).toSet().toList();
    types.sort((a, b) => b.toLowerCase().compareTo(a.toLowerCase()));
    _categoryTypes[key] = types;
  }
}
