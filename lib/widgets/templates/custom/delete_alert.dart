import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/provider/download_provider.dart';
import 'package:flutter/material.dart';

class DeleteAlert {
  final BuildContext context;
  final DownloadProvider downloadProvider;
  final DataProvider dataProvider;
  final String taskId;
  final String songName;

  DeleteAlert({
    this.context,
    this.downloadProvider,
    this.dataProvider,
    this.taskId,
    this.songName,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.redAccent.withOpacity(0.6),
              ),
              SizedBox(
                width: 4.0,
              ),
              Flexible(
                child: Text(
                  'Do you want to delete?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "You won't be able to recover this file",
                style: TextStyle(color: Colors.black87),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    color: Colors.lightBlueAccent.withOpacity(0.4),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  FlatButton(
                    color: Colors.redAccent.withOpacity(0.6),
                    onPressed: () {
                      downloadProvider.deleteDownload(taskId, songName);
                      dataProvider.updateSongTaskId(songName, null);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
