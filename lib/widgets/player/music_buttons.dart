import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/models/download_info.dart';
import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/provider/download_provider.dart';
import 'package:dharma_deshana/provider/song_provider.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_download_button.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_neumorphic_button.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class MusicButtons extends StatelessWidget {
  final double height;
  // final Song song;
  final TargetPlatform platform;

  const MusicButtons({@required this.height, this.platform});

  Widget getDownloadButton(
      int downloadStatus,
      DownloadProvider downloadProvider,
      DataProvider dataProvider,
      DownloadInfo info,
      Song song) {
    return NeumorphicButton(
      padding: EdgeInsets.zero,
      drawSurfaceAboveChild: true,
      isEnabled: downloadStatus == AppConstant.DOWNLOADABLE_STATE,
      onClick: () async {
        if (AppConstant.DOWNLOADABLE_STATE == downloadStatus) {
          String taskId = await downloadProvider.requestDownload(
              song.url, song.name, platform);
          dataProvider.updateSongTaskId(song.name, taskId);
          song.taskId = taskId;
        } else if (AppConstant.DOWNLOAD_FAIL == downloadStatus) {
          String taskId = await downloadProvider.requestDownload(
              song.url, song.name, platform);
          dataProvider.updateSongTaskId(song.name, taskId);
          song.taskId = taskId;
        } else if (AppConstant.DOWNLOADING_STATE == downloadStatus) {}
      },
      child: CustomDownloadButton(
        height: height,
        info: info,
        status: downloadStatus,
      ),
      boxShape:
          NeumorphicBoxShape.roundRect(BorderRadius.circular(height * 0.02)),
      style: NeumorphicStyle(
        color: Colors.lightBlueAccent.withOpacity(0.1),
        shape: NeumorphicShape.convex,
        shadowLightColor: Colors.transparent,
        intensity: 10,
        depth: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DownloadProvider downloadProvider =
        Provider.of<DownloadProvider>(context);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    SongProvider songProvider =
        Provider.of<SongProvider>(context, listen: false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        CustomNeumorphicButton(
          shape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(height * 0.02)),
          icon: Ionicons.ios_repeat,
          height: height * 0.04,
          onTap: () {},
          backgroundColor: Colors.lightBlueAccent.withOpacity(0.1),
          depth: 5,
        ),
        Selector<DownloadProvider, List<DownloadInfo>>(
            selector: (_, provider) => provider.downloadTasks,
            builder: (_, infoList, __) {
              Song song = songProvider.song;

              DownloadInfo info;
              for (DownloadInfo downloadInfo in infoList) {
                if (song.taskId == downloadInfo.taskId) {
                  info = downloadInfo;
                }
              }
              int downloadStatus = Templates.downloadState(info, song.name);

              if (downloadProvider.hasDownloads(song.name)) {
                downloadStatus = AppConstant.DOWNLOADED_STATE;
              }

              return getDownloadButton(
                  downloadStatus, downloadProvider, dataProvider, info, song);
            }),
        // )
      ],
    );
  }
}
