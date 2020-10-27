import 'dart:collection';
import 'dart:isolate';
import 'dart:ui';

import 'package:dharma_deshana/models/download_info.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DownloadProvider with ChangeNotifier {
  static final String downloadPort = 'downloader_send_port';

  ReceivePort _port = ReceivePort();
  String _localPath = '';

  bool _portRegistered = false;
  bool _hasPermission = false;

  Map<String, DownloadInfo> _downloadingTasks = HashMap();
  List<DownloadTask> _downloads = List();

  Future<Null> initDownloads() async {
    _downloads = await FlutterDownloader.loadTasks();
  }

  Future<Null> prepare(TargetPlatform platform) async {
    if (!_hasPermission) {
      _hasPermission = await Templates.checkPermission(platform);
    }

    if (_hasPermission) {
      if (_localPath == null || _localPath.isEmpty) {
        _localPath = (await Templates.findLocalPath(platform)) +
            Platform.pathSeparator +
            'Songs';
      }

      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }
    }

    await bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future<Null> bindBackgroundIsolate() async {
    dynamic val = IsolateNameServer.lookupPortByName('downloader_send_port');
    if (val == null) {
      bool isSuccess = IsolateNameServer.registerPortWithName(
          _port.sendPort, 'downloader_send_port');
      if (!isSuccess) {
        bindBackgroundIsolate();
        return;
      }

      _port.listen((dynamic data) {
        downloadNotifier(data);
      });
    }
    setDownloadPortRegistered(true);
  }

  void downloadNotifier(dynamic data) {
    String taskId = data[0];
    DownloadTaskStatus status = data[1];
    int progress = data[2];

    print(
        'Background Isolate Callback: task ($taskId) is in status ($status) and process ($progress)');

    Map<String, DownloadInfo> infoMap = HashMap();
    _downloadingTasks.values.forEach((info) {
      if (info.taskId == taskId) {
        info.progress = progress;
        info.status = status;
      }
      infoMap[taskId] = info;
    });
    setDownloadingTasks(infoMap);
    if (status == DownloadTaskStatus.complete) {
      initDownloads();
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<String> requestDownload(
      String url, String songName, TargetPlatform platform) async {
    await prepare(platform);

    String taskId = '';
    if (hasPermission && isDownloadPortRegistered) {
      taskId = await FlutterDownloader.enqueue(
        url: url,
        headers: {'auth': 'test_for_sql_encoding'},
        savedDir: _localPath,
        fileName: songName + '.mp3',
        showNotification: true,
        openFileFromNotification: true,
      );

      _downloadingTasks.update(
        taskId,
        (value) => DownloadInfo(taskId: taskId, songName: songName),
        ifAbsent: () => DownloadInfo(taskId: taskId, songName: songName),
      );
    }
    return taskId;
  }

  bool get isDownloadPortRegistered => _portRegistered;
  setDownloadPortRegistered(bool registered) {
    _portRegistered = registered;
    notifyListeners();
  }

  bool get hasPermission => _hasPermission;

  Map get downloadTasks => _downloadingTasks;
  setDownloadingTasks(Map<String, DownloadInfo> map) {
    _downloadingTasks = map;
    notifyListeners();
  }

  bool hasDownloads(String songName) {
    String fileName = songName + '.mp3';
    bool hasDownloads = false;

    for (DownloadTask task in _downloads) {
      if (!hasDownloads && task.filename == fileName) {
        hasDownloads = true;
        break;
      }
    }
    return hasDownloads;
  }
}
