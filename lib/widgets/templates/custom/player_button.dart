import 'package:cached_network_image/cached_network_image.dart';
import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/provider/song_provider.dart';
import 'package:dharma_deshana/widgets/player/music_player.dart';
import 'package:dharma_deshana/widgets/templates/custom/draggable_button.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PlayerButton extends StatelessWidget {
  final double height;
  final PreferredSizeWidget appBar;

  PlayerButton({@required this.height, this.appBar});

  directToMusicPlayer(BuildContext context) {
    final SongProvider songProvider =
        Provider.of<SongProvider>(context, listen: false);
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

    return Selector<SongProvider, bool>(
      selector: (_, provider) => provider.isShowCarousel,
      builder: (_, playing, __) => Visibility(
        visible: playing,
        child: DraggableButton(
          appBar: appBar,
          widgetWidth: width * 0.2,
          child: Material(
            elevation: 15.0,
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.white,
                style: BorderStyle.solid,
                width: width * 0.005,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Ink(
              height: width * 0.2,
              width: width * 0.2,
              child: Container(
                child: InkWell(
                  onTap: () {
                    directToMusicPlayer(context);
                  },
                  child: Selector<SongProvider, Song>(
                    selector: (_, provider) => provider.song,
                    builder: (_, song, __) => Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.5),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(song.coverUrl),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
