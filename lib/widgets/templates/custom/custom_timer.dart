import 'package:dharma_deshana/provider/song_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CustomTimer extends StatelessWidget {
  final double height;
  final Color color;

  CustomTimer({@required this.height, @required this.color});

  static String formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = "$minute" + ":" + ((second < 10) ? "0$second" : "$second");
    return format;
  }

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
      color: color,
      fontSize: height,
    );

    return Selector<SongProvider, Tuple2<Duration, Duration>>(
      selector: (_, model) => Tuple2(model.position, model.duration),
      builder: (_, tuple, __) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            formatDuration(tuple.item1),
            style: style,
          ),
          Text(
            formatDuration(tuple.item2),
            style: style,
          ),
        ],
      ),
    );
  }
}
