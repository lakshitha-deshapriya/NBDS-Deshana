import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/models/download_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CustomDownloadButton extends StatelessWidget {
  CustomDownloadButton(
      {@required this.height, @required this.info, @required this.status});

  final double height;
  final DownloadInfo info;
  final int status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AppConstant.DOWNLOADABLE_STATE:
        return Container(
          padding: EdgeInsets.all(height * 0.011),
          child: Icon(
            MaterialCommunityIcons.cloud_download_outline,
            color: Colors.blue,
            size: height * 0.04,
          ),
        );
      case AppConstant.DOWNLOADING_STATE:
        return Container(
          padding: EdgeInsets.all(height * 0.011),
          child: CircularProgressIndicator(
            value: info.progress.toDouble() / 100,
            backgroundColor: Colors.lightBlueAccent.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      case AppConstant.DOWNLOADED_STATE:
        return Container(
          padding: EdgeInsets.all(height * 0.011),
          child: Icon(
            MaterialCommunityIcons.cloud_download_outline,
            color: Colors.grey,
            size: height * 0.04,
          ),
        );
      default:
        return Container(
          padding: EdgeInsets.all(height * 0.011),
          child: Icon(
            MaterialCommunityIcons.cloud_download_outline,
            color: Colors.blueGrey,
            size: height * 0.04,
          ),
        );
    }
  }
}
