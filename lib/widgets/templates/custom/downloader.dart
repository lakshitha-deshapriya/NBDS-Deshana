import 'dart:isolate';
import 'dart:ui';

import 'package:dharma_deshana/models/download_info.dart';
import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_neumorphic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

const debug = true;

class Downloader extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;
  final double height;
  final Song song;

  Downloader({Key key, this.platform, this.height, this.song});

  @override
  _DownloaderState createState() => _DownloaderState();
}

class _DownloaderState extends State<Downloader> {
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;

    _prepare();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      downloadNotifier(data);
    });
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void downloadNotifier(dynamic data) {
    String id = data[0];
    DownloadTaskStatus status = data[1];
    int progress = data[2];

    DownloadInfo info =
        DownloadInfo(taskId: id, progress: progress, status: status);

    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');

    // final task = _tasks?.firstWhere((task) => task.taskId == id);
    // if (task != null) {
    //   setState(() {
    //     task.status = status;
    //     task.progress = progress;
    //   });
    // }
  }

  void _requestDownload(Song song) async {
    bool hasPermission = await _checkPermission();
    print(hasPermission);
    if (hasPermission) {
      await FlutterDownloader.enqueue(
        url: song.url,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        fileName: song.name + ".mp3",
        showNotification: true,
        openFileFromNotification: true,
      );
    }
  }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      final status = await Permission.storage.status;

      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> _prepare() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.height,
      child: CustomNeumorphicButton(
        shape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(widget.height * 0.02)),
        icon: MaterialCommunityIcons.cloud_download_outline,
        height: widget.height,
        onTap: () {
          _requestDownload(widget.song);
        },
        backgroundColor: Colors.lightBlueAccent.withOpacity(0.1),
        depth: 5,
      ),
    );
  }
}
