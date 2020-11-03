import 'dart:ui';

import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/provider/download_provider.dart';
import 'package:dharma_deshana/provider/song_provider.dart';
import 'package:dharma_deshana/widgets/player/album_cover.dart';
import 'package:dharma_deshana/widgets/player/music_buttons.dart';
import 'package:dharma_deshana/widgets/player/song_player.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_neumorphic_button.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_scaffold.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_text.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class MusicPlayer extends StatelessWidget {
  void popWidget(BuildContext context) {
    Navigator.of(context).pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final DownloadProvider downloadProvider =
        Provider.of<DownloadProvider>(context, listen: false);

    final double titleFactor = 0.035;
    final double paddingFactor = 0.05;

    final double height = Templates.getAvailableHeight(null, context);
    final double width = Templates.getWidth(context);

    return CustomScaffold(
      body: Container(
        height: height,
        child: Column(
          children: <Widget>[
            Container(
              height: height * 0.085,
              padding: EdgeInsets.only(
                left: width * 0.04,
                right: width * 0.04,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomNeumorphicButton(
                    shape: NeumorphicBoxShape.circle(),
                    icon: Ionicons.ios_arrow_back,
                    height: height * 0.045,
                    onTap: () => popWidget(context),
                    backgroundColor: Colors.lightBlueAccent.withOpacity(0.1),
                  ),
                ],
              ),
            ),
            Selector<SongProvider, Song>(
              selector: (_, provider) => provider.song,
              builder: (_, song, __) => Container(
                height: height * 0.915,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      width: height * 0.4,
                      height: height * 0.4,
                      child: Hero(
                        tag: 'image${song.songId}',
                        child: AlbumCover(
                          song.coverUrl,
                          height * 0.4,
                          animate: false,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Container(
                      height: height * 0.06,
                      child: MusicButtons(height: height),
                    ),
                    SizedBox(height: height * 0.03),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * paddingFactor,
                      ),
                      height: height * (titleFactor + 0.02),
                      child: CustomText(
                        text: song.name,
                        color: Colors.black87.withOpacity(0.6),
                        height: height * titleFactor,
                        width: width - 2 * width * paddingFactor,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * paddingFactor,
                      ),
                      height: height * 0.031,
                      child: Text(
                        song.sub,
                        style: TextStyle(
                          fontSize: height * 0.023,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.279,
                      child: SongPlayer(
                        height: height * 0.279,
                        paddingFactor: paddingFactor,
                        downloadProvider: downloadProvider,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
