import 'dart:isolate';
import 'dart:ui';

import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_scaffold.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {

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

    // _prepare();
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
      print('UI Isolate Callback2: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      print(
        'Background Isolate Callback2: task ($id) is in status ($status) and process ($progress)');

      // final task = _tasks?.firstWhere((task) => task.taskId == id);
      // if (task != null) {
      //   setState(() {
      //     task.status = status;
      //     task.progress = progress;
      //   });
      // }
    });
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
  @override
  Widget build(BuildContext context) {
    final height =
        Templates.getAvailableHeight(null, context) - AppConstant.navbarHeight;
    return CustomScaffold(
      body: Center(
        child: Text(
          'No Downloads',
          style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: height * 0.03),
        ),
      ),
    );
  }
}
