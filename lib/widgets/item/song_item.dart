import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/provider/connectivity_provider.dart';
import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/provider/song_provider.dart';
import 'package:dharma_deshana/widgets/player/music_player.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_text.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class SongItem extends StatelessWidget {
  final Song song;
  final String categoryTypeKey;

  SongItem({@required this.song, @required this.categoryTypeKey});

  void playSong(BuildContext context, Song song) {
    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    final SongProvider songProvider =
        Provider.of<SongProvider>(context, listen: false);

    songProvider
        .setSongs(dataProvider.getSongsForCategoryTypeKey(categoryTypeKey));

    songProvider.setSong(song);

    songProvider.showCarousel(false);
    pushNewScreen(
      context,
      screen: MusicPlayer(),
      withNavBar: false,
    ).then((_) => songProvider.showCarousel(songProvider.isPlaying));
  }

  @override
  Widget build(BuildContext context) {
    final double width = Templates.getWidth(context);
    final double height = width * 0.14;

    final textContainerWidth = width * (0.72);

    return Selector<ConnectivityProvider, bool>(
      selector: (_, provider) => provider.isConnected,
      builder: (_, connected, childWidget) => Selector<SongProvider, bool>(
        selector: (_, songProvider) => songProvider.isPlaying,
        builder: (_, playing, __) => Container(
          width: Templates.getWidth(context),
          height: height,
          padding: EdgeInsets.only(
            left: width * 0.01,
            right: width * 0.01,
          ),
          child: NeumorphicButton(
            padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01),
            isEnabled: connected || playing,
            onClick: () {
              playSong(context, song);
            },
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(height * 0.1)),
            child: childWidget,
            style: NeumorphicStyle(
              color: Colors.transparent,
              depth: 3,
              shape: NeumorphicShape.convex,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: width * 0.13,
            height: width * 0.13,
            child: Neumorphic(
              boxShape: NeumorphicBoxShape.circle(),
              child: Hero(
                tag: 'image${song.songId}',
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: song.coverUrl,
                  fit: BoxFit.fill,
                ),
              ),
              style: NeumorphicStyle(
                color: Colors.lightBlueAccent.withOpacity(0.1),
                shape: NeumorphicShape.convex,
              ),
            ),
          ),
          SizedBox(width: width * 0.01),
          Container(
            padding: EdgeInsets.only(
              left: width * 0.01,
              right: width * 0.01,
            ),
            width: textContainerWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomText(
                  text: song.name,
                  color: Colors.black87.withOpacity(0.6),
                  height: height * 0.33,
                  width: textContainerWidth,
                ),
                Text(
                  song.sub != null ? song.sub : song.type,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: height * 0.25,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: width * 0.1,
            height: height * 0.8,
            child: NeumorphicButton(
              isEnabled: false, //Implement download
              padding: EdgeInsets.zero,
              onClick: () {},
              drawSurfaceAboveChild: true,
              child: Icon(
                Feather.more_vertical,
              ),
              style: NeumorphicStyle(
                color: Colors.lightBlueAccent.withOpacity(0.3),
                shape: NeumorphicShape.convex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
