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
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class MusicButtons extends StatelessWidget {
  final double height;
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
        Provider.of<DownloadProvider>(context, listen: false);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    SongProvider songProvider =
        Provider.of<SongProvider>(context, listen: false);

    final iconWidth = height * 0.05;

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
        Selector<DownloadProvider, String>(
            selector: (_, provider) => provider.taskDetail,
            builder: (_, taskMap, __) {
              Song song = songProvider.song;

              Tuple3<int, DownloadInfo, DownloadTask> details =
                  downloadProvider.getDownloadState(song.name);

              return NeumorphicButton(
                padding: EdgeInsets.zero,
                isEnabled: AppConstant.DOWNLOADABLE_STATE == details.item1 ||
                    AppConstant.DOWNLOAD_FAIL == details.item1,
                onClick: () async {
                  if (AppConstant.DOWNLOADABLE_STATE == details.item1) {
                    String taskId = await downloadProvider.requestDownload(
                        song.url, song.name, platform);
                    dataProvider.updateSongTaskId(song.name, taskId);
                    song.taskId = taskId;
                  } else if (AppConstant.DOWNLOAD_FAIL == details.item1) {
                    String taskId = await downloadProvider.requestDownload(
                        song.url, song.name, platform);
                    dataProvider.updateSongTaskId(song.name, taskId);
                    song.taskId = taskId;
                  }
                },
                drawSurfaceAboveChild: true,
                child: getIcon(details, iconWidth),
                boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(height * 0.02)),
                style: NeumorphicStyle(
                  color: Colors.lightBlueAccent.withOpacity(0.1),
                  shape: NeumorphicShape.convex,
                  shadowLightColor: Colors.transparent,
                  intensity: 10,
                  depth: 5,
                ),
              );

              DownloadInfo info;
              for (DownloadInfo downloadInfo
                  in downloadProvider.downloadInfoList) {
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

  Widget getIcon(
      Tuple3<int, DownloadInfo, DownloadTask> details, double iconWidth) {
    final double containerHeight = height * 0.06;
    final double iconHeight = height * 0.04;
    final double paddingHeight = (containerHeight - iconHeight) / 2;
    if (AppConstant.DOWNLOADABLE_STATE == details.item1) {
      return Container(
        padding: EdgeInsets.all(paddingHeight),
        height: containerHeight,
        width: containerHeight,
        child: Icon(
          MaterialCommunityIcons.cloud_download_outline,
          color: Colors.blue,
          size: iconHeight,
        ),
      );
    } else if (AppConstant.DOWNLOADED_STATE == details.item1) {
      return Container(
        padding: EdgeInsets.all(paddingHeight),
        height: containerHeight,
        width: containerHeight,
        child: Icon(
          MaterialCommunityIcons.cloud_download_outline,
          color: Colors.grey,
          size: iconHeight,
        ),
      );
    } else if (AppConstant.DOWNLOADING_STATE == details.item1) {
      int progress = details.item2 != null
          ? details.item2.progress
          : details.item3.progress;
      return Container(
        padding: EdgeInsets.all(paddingHeight),
        height: containerHeight,
        width: containerHeight,
        child: CircularProgressIndicator(
          value: progress.toDouble() / 100,
          backgroundColor: Colors.lightBlueAccent.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(paddingHeight),
      height: containerHeight,
      width: containerHeight,
      child: Icon(
        MaterialCommunityIcons.cloud_download_outline,
        color: Colors.redAccent,
      ),
    );
  }
}
