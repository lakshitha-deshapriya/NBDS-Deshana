import 'package:audioplayers/audioplayers.dart';
import 'package:dharma_deshana/provider/song_provider.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_button.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_neumorphic_button.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_slider.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_timer.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class SongPlayer extends StatelessWidget {
  final double height;
  final double paddingFactor;

  SongPlayer({
    this.height,
    this.paddingFactor,
  });

  void initAudioPlayer(SongProvider songProvider) {
    AudioPlayer player = songProvider.audioPlayer;
    player.onDurationChanged.listen((duration) {
      songProvider.setDuration(duration);
    });

    player.onAudioPositionChanged.listen((position) {
      if (songProvider.isSeeking) return;
      songProvider.setPosition(position);
    });

    player.onPlayerCompletion.listen((event) {
      next(songProvider, true);
    });

    player.onSeekComplete.listen((finished) {
      songProvider.setSeeking(false);
    });

    player.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      songProvider.setPositionAndDuration(
          Duration(seconds: 0), Duration(seconds: 0));
    });

    player.onPlayerStateChanged.listen((state) {
      songProvider.setPaused(state == AudioPlayerState.PAUSED);
      songProvider.setPlaying(state == AudioPlayerState.PLAYING);
    });

    player.onNotificationPlayerStateChanged.listen((state) {
      songProvider.setPaused(state == AudioPlayerState.PAUSED);
      songProvider.setPlaying(state == AudioPlayerState.PLAYING);
    });
    songProvider.setPlayerInitialized(true);
  }

  void playSong(SongProvider songProvider) async {
    if (songProvider.isPlaying) {
      if (songProvider.playingSongId != songProvider.song.songId) {
        songProvider.audioPlayer.stop();
        resetPlayerData(songProvider);
        play(songProvider, songProvider.song.url);
      }
    } else if (songProvider.isPaused) {
      if (songProvider.playingSongId != songProvider.song.songId) {
        songProvider.audioPlayer.stop();
        resetPlayerData(songProvider);
        play(songProvider, songProvider.song.url);
      }
    } else {
      play(songProvider, songProvider.song.url);
    }
  }

  void play(SongProvider provider, String url) async {
    int result = await provider.audioPlayer.play(Uri.encodeFull(url));
    if (result == 1) {
      provider.setPaused(false);
      provider.setPlaying(true);
      provider.setPlayingSongId(provider.song.songId);
    } else {
      print('Error while playing');
    }
  }

  void resetPlayerData(SongProvider provider) {
    provider.setPositionAndDuration(null, null);
  }

  void pause(SongProvider songProvider) async {
    final result = await songProvider.audioPlayer.pause();
    if (result == 1) {
      songProvider.setPaused(true);
      songProvider.setPlaying(false);
    }
  }

  void resume(SongProvider songProvider) async {
    final result = await songProvider.audioPlayer.resume();
    if (result == 1) {
      songProvider.setPaused(false);
      songProvider.setPlaying(true);
    }
  }

  void next(SongProvider songProvider, bool finished) {
    int success = songProvider.selectNextSong();
    if (success == 1) {
      songProvider.audioPlayer.stop();
      resetPlayerData(songProvider);
      playSong(songProvider);
    } else if ( finished ) {
      resetPlayerData(songProvider);
      songProvider.setPaused(false);
      songProvider.setPlaying(false);
    }
  }

  void previous(SongProvider songProvider) {
    int success = songProvider.selectPreviousSong();
    if (success == 1) {
      songProvider.audioPlayer.stop();
      resetPlayerData(songProvider);
      playSong(songProvider);
    } else {
      songProvider.setPaused(false);
      songProvider.setPlaying(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SongProvider songProvider =
        Provider.of<SongProvider>(context, listen: false);

    if (!songProvider.isPlayerInitialized) {
      initAudioPlayer(songProvider);
    }

    final double width = Templates.getWidth(context);

    playSong(songProvider);

    return Column(
      children: <Widget>[
        SizedBox(height: height * 0.1),
        Container(
          height: height * 0.12,
          child: CustomSlider(color: Colors.lightBlueAccent.withOpacity(0.6)),
        ),
        Container(
          height: height * 0.08,
          padding: EdgeInsets.symmetric(
            horizontal: width * paddingFactor,
          ),
          child: CustomTimer(height: height * 0.07, color: Colors.blueGrey),
        ),
        SizedBox(height: height * 0.05),
        Container(
          height: height * 0.65,
          padding: EdgeInsets.symmetric(horizontal: height * 0.2),
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: height * 0.35,
                height: height * 0.35,
                child: NeumorphicButton(
                  padding: EdgeInsets.only(right: height * 0.03),
                  drawSurfaceAboveChild: true,
                  onClick: () => previous(songProvider),
                  child: Icon(
                    Fontisto.backward,
                    size: height * 0.13,
                  ),
                  boxShape: NeumorphicBoxShape.circle(),
                  style: NeumorphicStyle(
                    border: NeumorphicBorder(
                      color: Colors.lightBlueAccent.withOpacity(0.2),
                    ),
                    color: Colors.lightBlueAccent.withOpacity(0.1),
                    shape: NeumorphicShape.convex,
                    shadowLightColor: Colors.transparent,
                    intensity: 10,
                    depth: 10,
                  ),
                ),
              ),
              Selector<SongProvider, bool>(
                selector: (_, model) => model.isPlaying,
                builder: (_, isPlaying, __) => Container(
                  width: height * 0.45,
                  height: height * 0.45,
                  child: NeumorphicButton(
                    padding: EdgeInsets.only(left: height * 0.02),
                    drawSurfaceAboveChild: true,
                    onClick: () {
                      isPlaying ? pause(songProvider) : resume(songProvider);
                    },
                    child: Icon(
                      isPlaying ? Fontisto.pause : Fontisto.play,
                      size: height * 0.18,
                    ),
                    boxShape: NeumorphicBoxShape.circle(),
                    style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Colors.lightBlueAccent.withOpacity(0.2),
                      ),
                      color: Colors.lightBlueAccent.withOpacity(0.1),
                      shape: !isPlaying
                          ? NeumorphicShape.convex
                          : NeumorphicShape.concave,
                      shadowLightColor: Colors.transparent,
                      intensity: 10,
                      depth: isPlaying ? 4 : 10,
                    ),
                  ),
                ),
              ),
              Container(
                width: height * 0.35,
                height: height * 0.35,
                child: NeumorphicButton(
                  padding: EdgeInsets.only(left: height * 0.03),
                  drawSurfaceAboveChild: true,
                  onClick: () => next(songProvider, false),
                  child: Icon(
                    Fontisto.forward,
                    size: height * 0.13,
                  ),
                  boxShape: NeumorphicBoxShape.circle(),
                  style: NeumorphicStyle(
                    border: NeumorphicBorder(
                      color: Colors.lightBlueAccent.withOpacity(0.2),
                    ),
                    color: Colors.lightBlueAccent.withOpacity(0.1),
                    shape: NeumorphicShape.convex,
                    shadowLightColor: Colors.transparent,
                    intensity: 10,
                    depth: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
