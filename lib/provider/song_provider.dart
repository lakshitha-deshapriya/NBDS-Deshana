import 'package:audioplayers/audioplayers.dart';
import 'package:dharma_deshana/models/song.dart';
import 'package:flutter/material.dart';

class SongProvider with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _songs;

  Song _song;
  String _url;
  Duration _position;
  Duration _duration;
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isRepeat = true;
  bool _isSeeking = false;
  bool _playerInitialized = false;
  int _playingSongId = -1;
  bool _showCarousel = false;

  Song get song => _song;
  setSong(Song newSong) {
    if (newSong.songId != _playingSongId) {
      _song = newSong;
      notifyListeners();
    }
  }

  String get url => _url;
  setUrl(String url) {
    _url = url;
    notifyListeners();
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  bool get isPlaying => _isPlaying;
  setPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  bool get isPaused => _isPaused;
  setPaused(bool paused) {
    _isPaused = paused;
  }

  bool get isRepeat => _isRepeat;
  changeRepeat(bool repeat) {
    _isRepeat = repeat;
    notifyListeners();
  }

  bool get isSeeking => _isSeeking;
  setSeeking(bool seeking) {
    _isSeeking = seeking;
    notifyListeners();
  }

  bool get isPlayerInitialized => _playerInitialized;
  setPlayerInitialized(bool initialized) {
    _playerInitialized = initialized;
  }

  int get playingSongId => _playingSongId;
  setPlayingSongId(int songId) {
    _playingSongId = songId;
    notifyListeners();
  }

  List<Song> get songs => _songs;
  setSongs(List<Song> songs) {
    _songs = songs;
    notifyListeners();
  }

  addSongs(List<Song> songs) {
    _songs.addAll(songs);
    notifyListeners();
  }

  int get length => _songs.length;

  Duration get position => _position;
  void setPosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  Duration get duration => _duration;
  void setDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  void setPositionAndDuration(Duration position, Duration duration) {
    _duration = duration;
    _position = position;
  }

  bool get isShowCarousel => _showCarousel;
  void showCarousel(bool showCarousel){
    this._showCarousel = showCarousel;
    notifyListeners();
  }

  int selectNextSong() {
    int nextIndex = songs.indexOf(song) + 1;
    if (songs.length > nextIndex) {
      setSong(songs[nextIndex]);
      return 1;
    }
    return 0;
  }

  int selectPreviousSong() {
    int prevIndex = songs.indexOf(song) - 1;
    if (prevIndex >= 0) {
      setSong(songs[prevIndex]);
      return 1;
    }
    return 0;
  }
}
