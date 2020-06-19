import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/models/song.dart';
import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/widgets/item/song_item.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_indicator.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_scaffold.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SongList extends StatelessWidget {
  final String category;
  final String type;

  SongList({@required this.category, @required this.type});

  void popWidget(BuildContext context) {
    Navigator.of(context).pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final String key = category + '-' + type;

    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);

    final double height =
        Templates.getAvailableHeight(null, context) - AppConstant.navbarHeight;

    final double width = Templates.getWidth(context);

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                NeumorphicButton(
                  padding: EdgeInsets.zero,
                  drawSurfaceAboveChild: true,
                  onClick: () => popWidget(context),
                  child: Container(
                    padding: EdgeInsets.all(height * 0.015),
                    child: Icon(
                      Ionicons.ios_arrow_back,
                      color: Colors.blueGrey,
                      size: height * 0.044,
                    ),
                  ),
                  boxShape: NeumorphicBoxShape.circle(),
                  style: NeumorphicStyle(
                    color: Colors.lightBlueAccent.withOpacity(0.1),
                    shape: NeumorphicShape.convex,
                    shadowLightColor: Colors.transparent,
                    intensity: 10,
                  ),
                ),
              ],
            ),
          ),
          Selector<DataProvider, bool>(
            selector: (_, provider) => provider.isTypesInitialized,
            builder: (_, initialized, childWidget) => initialized
                ? Container(
                    height: height * 0.91,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: height * 0.005),
                      itemBuilder: (ctx, index) {
                        Song song =
                            dataProvider.getSongsForCategoryTypeKey(key)[index];
                        return Column(
                          children: <Widget>[
                            SongItem(
                              song: song,
                              categoryTypeKey: key,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            )
                          ],
                        );
                      },
                      itemCount:
                          dataProvider.getSongsForCategoryTypeKey(key).length,
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
