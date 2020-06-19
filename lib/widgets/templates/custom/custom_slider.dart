import 'package:dharma_deshana/provider/song_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CustomSlider extends StatelessWidget {
  final Color color;

  CustomSlider({@required this.color});

  @override
  Widget build(BuildContext context) {
    final SongProvider songProvider = Provider.of(context, listen: false);
    return Selector<SongProvider, Tuple2<Duration, Duration>>(
      selector: (_, provider) => Tuple2(provider.duration, provider.position),
      builder: (_, tuple, __) => Slider(
        onChangeStart: (v) {
          songProvider.setSeeking(true);
        },
        onChanged: (value) {
          songProvider.setPosition(
              Duration(seconds: (tuple.item1.inSeconds * value).round()));
        },
        onChangeEnd: (value) {
          Duration position =
              Duration(seconds: (tuple.item1.inSeconds * value).round());
          songProvider.setPosition(position);
          songProvider.audioPlayer.seek(position);
        },
        value: (tuple.item2 != null &&
                tuple.item1 != null &&
                tuple.item2.inSeconds > 0 &&
                tuple.item2.inSeconds < tuple.item1.inSeconds)
            ? tuple.item2.inSeconds / tuple.item1.inSeconds
            : 0.0,
        activeColor: color,
      ),
    );
  }
}
