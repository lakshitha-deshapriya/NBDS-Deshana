import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/provider/download_provider.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_indicator.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_scaffold.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class Downloads extends StatelessWidget {
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
                    // refreshData(dataProvider, connectivity);
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
          Selector<DownloadProvider, bool>(
            selector: (_, provider) => provider.isDownloadsInitialized,
            builder: (_, initialized, childWidget) => initialized
                ? Container(
                    height: height * 0.91,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: height * 0.005),
                      itemBuilder: (ctx, index) {
                        List<DownloadTask> list =
                            downloadProvider.downloadTaskList;

                        return Text(list[index].filename);
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
