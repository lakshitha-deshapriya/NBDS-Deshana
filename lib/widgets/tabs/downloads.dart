import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/provider/download_provider.dart';
import 'package:dharma_deshana/widgets/item/download_item.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_indicator.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_scaffold.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Downloads extends StatelessWidget {
  refreshData(DownloadProvider downloadProvider) {
    downloadProvider.setDownloadInitialized(false);
    downloadProvider.initDownloads();
  }

  @override
  Widget build(BuildContext context) {
    final DownloadProvider downloadProvider =
        Provider.of<DownloadProvider>(context, listen: false);

    downloadProvider.initDownloads();

    final height =
        Templates.getAvailableHeight(null, context) - AppConstant.navbarHeight;

    final double width = MediaQuery.of(context).size.width;

    return CustomScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: height * 0.09,
            padding: EdgeInsets.only(
              left: width * 0.04,
              right: width * 0.04,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                NeumorphicButton(
                  padding: EdgeInsets.zero,
                  drawSurfaceAboveChild: true,
                  onClick: () {
                    refreshData(downloadProvider);
                  },
                  child: Container(
                    padding: EdgeInsets.all(height * 0.015),
                    child: Icon(
                      Fontisto.spinner_refresh,
                      color: Colors.blueGrey,
                      size: height * 0.044,
                    ),
                  ),
                  boxShape: NeumorphicBoxShape.circle(),
                  style: NeumorphicStyle(
                    color: Colors.lightBlueAccent.withOpacity(0.3),
                    shape: NeumorphicShape.convex,
                    shadowLightColor: Colors.transparent,
                    intensity: 10,
                  ),
                ),
              ],
            ),
          ),
          Selector<DownloadProvider, Tuple2<bool, String>>(
            selector: (_, provider) =>
                Tuple2(provider.isDownloadsInitialized, provider.taskDetail),
            builder: (_, tuple, childWidget) => tuple.item1
                ? Container(
                    height: height * 0.91,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: height * 0.005),
                      itemBuilder: (ctx, index) {
                        DownloadTask task =
                            downloadProvider.downloadTaskList[index];

                        return DownloadItem(
                          songName: task.filename.replaceAll('.mp3', ''),
                          task: task,
                        );
                      },
                      itemCount: downloadProvider.downloadTaskList.length,
                    ),
                  )
                : childWidget,
            child: CustomIndicator(
              color: Theme.of(context).primaryColor.withOpacity(0.6),
              width: Templates.getWidth(context),
            ),
          ),
        ],
      ),
    );
  }
}
