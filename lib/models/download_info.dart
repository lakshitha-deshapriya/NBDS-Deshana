import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadInfo {
  String taskId;
  String songName;
  int progress;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  DownloadInfo({
    @required this.taskId,
    @required this.songName,
    this.progress = 0,
    this.status = DownloadTaskStatus.undefined,
  });
}
