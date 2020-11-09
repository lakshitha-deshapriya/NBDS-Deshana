import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/models/download_info.dart';
import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/provider/download_provider.dart';
import 'package:dharma_deshana/provider/song_provider.dart';
import 'package:dharma_deshana/widgets/player/music_player.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_text.dart';
import 'package:dharma_deshana/widgets/templates/custom/delete_alert.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tuple/tuple.dart';

class DownloadItem extends StatelessWidget {
  final String songName;
  final DownloadTask task;
  final TargetPlatform platform;

  DownloadItem({@required this.songName, @required this.task, this.platform});

  void playSong(
      BuildContext context, Song song, DownloadProvider downloadProvider) {
    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    final SongProvider songProvider =
        Provider.of<SongProvider>(context, listen: false);

    List<Song> songList = List();
    for (DownloadTask task in downloadProvider.downloadTaskList) {
      songList.add(
          dataProvider.getSongByName(task.filename.replaceAll('.mp3', '')));
    }

    songProvider.setSongs(songList);

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
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);

    DownloadProvider downloadProvider =
        Provider.of<DownloadProvider>(context, listen: false);

    final double width = Templates.getWidth(context);
    final double height = width * 0.14;
    final double iconWidth = width * 0.11;

    double textContainerWidth = width * 0.71;

    final Song song = dataProvider.getSongByName(songName);

    return Container(
      width: Templates.getWidth(context),
      height: height,
      padding: EdgeInsets.only(
        left: width * 0.01,
        right: width * 0.01,
      ),
      child: NeumorphicButton(
        padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01),
        isEnabled: true,
        onClick: () {
          playSong(context, song, downloadProvider);
        },
        boxShape:
            NeumorphicBoxShape.roundRect(BorderRadius.circular(height * 0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width * 0.13,
              height: width * 0.13,
              child: Neumorphic(
                boxShape: NeumorphicBoxShape.circle(),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: song.coverUrl,
                  fit: BoxFit.fill,
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
              width: iconWidth,
              height: iconWidth,
              child: Selector<DownloadProvider, String>(
                selector: (_, provider) => provider.taskDetail,
                builder: (_, taskDetail, __) {
                  Tuple3<int, DownloadInfo, DownloadTask> details =
                      downloadProvider.getDownloadState(song.name);

                  return NeumorphicButton(
                    padding: EdgeInsets.zero,
                    isEnabled: AppConstant.DOWNLOADED_STATE == details.item1,
                    onClick: () async {
                      if (AppConstant.DOWNLOADED_STATE == details.item1) {
                        DeleteAlert(
                          context: context,
                          dataProvider: dataProvider,
                          downloadProvider: downloadProvider,
                          songName: songName,
                          taskId: task.taskId,
                        );
                      }
                    },
                    drawSurfaceAboveChild: true,
                    child: getIcon(details, iconWidth),
                    style: NeumorphicStyle(
                      color: AppConstant.DOWNLOADED_STATE == details.item1
                          ? Colors.redAccent.withOpacity(0.15)
                          : Colors.lightBlueAccent.withOpacity(0.2),
                      shape: NeumorphicShape.convex,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        style: NeumorphicStyle(
          color: Colors.transparent,
          depth: 3,
          shape: NeumorphicShape.convex,
        ),
      ),
    );
  }

  Widget getIcon(
      Tuple3<int, DownloadInfo, DownloadTask> details, double iconWidth) {
    if (AppConstant.DOWNLOADED_STATE == details.item1) {
      return Icon(
        FontAwesome.trash,
        color: Colors.red,
      );
    } else if (AppConstant.DOWNLOADING_STATE == details.item1) {
      int progress = details.item2 != null
          ? details.item2.progress
          : details.item3.progress;
      return Padding(
        padding: EdgeInsets.all(iconWidth * 0.15),
        child: CircularProgressIndicator(
          value: progress.toDouble() / 100,
          backgroundColor: Colors.lightBlueAccent.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    }
    return Container();
  }
}
