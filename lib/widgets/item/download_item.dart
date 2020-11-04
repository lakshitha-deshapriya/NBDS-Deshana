import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/models/download_info.dart';
import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/provider/download_provider.dart';
import 'package:dharma_deshana/provider/song_provider.dart';
import 'package:dharma_deshana/widgets/player/music_player.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_text.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class DownloadItem extends StatelessWidget {
  final String songName;
  final DownloadTask task;

  DownloadItem({@required this.songName, @required this.task});

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

    double textContainerWidth = width * 0.72;

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
            Selector<DownloadProvider, String>(
              selector: (_, provider) => provider.taskDetail,
              builder: (_, taskDetail, __) {
                DownloadInfo info;
                for (DownloadInfo downloadInfo
                    in downloadProvider.downloadInfoList) {
                  if (song.taskId == downloadInfo.taskId) {
                    info = downloadInfo;
                  }
                }
                int downloadStatus = Templates.downloadState(info, song.name);
                if (AppConstant.DOWNLOADING_STATE == downloadStatus) {
                  return Container(
                    width: width * 0.08,
                    height: width * 0.08,
                    padding: EdgeInsets.all(height * 0.011),
                    child: CircularProgressIndicator(
                      value: info.progress / 100,
                      backgroundColor: Colors.lightBlueAccent.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  );
                } else {
                  return Container(
                    width: width * 0.08,
                    height: width * 0.08,
                    padding: EdgeInsets.all(height * 0.011),
                  );
                }
              },
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
}
