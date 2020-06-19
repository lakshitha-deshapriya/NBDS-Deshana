import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/widgets/item/type_item.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_indicator.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_scaffold.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class TypeList extends StatelessWidget {
  final String category;

  TypeList({this.category});

  void popWidget(BuildContext context) {
    Navigator.of(context).pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);

    final double height =
        Templates.getAvailableHeight(null, context) - AppConstant.navbarHeight;

    final double width = Templates.getWidth(context);

    return CustomScaffold(
      body: Selector<DataProvider, bool>(
        selector: (_, provider) => provider.isTypesInitialized,
        builder: (_, initialized, child) => initialized
            ? Column(
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
                        NeumorphicButton(
                          isEnabled: false, //TODO: change the logic here
                          padding: EdgeInsets.zero,
                          drawSurfaceAboveChild: true,
                          onClick: () {},
                          child: Container(
                            padding: EdgeInsets.all(height * 0.015),
                            child: Icon(
                              Icons.expand_more,
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
                  Container(
                    height: height * 0.7,
                    child: GridView.builder(
                      padding: EdgeInsets.only(
                        left: width * 0.04,
                        right: width * 0.04,
                        bottom: width * 0.04,
                        top: width * 0.02,
                      ),
                      itemBuilder: (context, index) {
                        String type =
                            dataProvider.getTypesForCategory(category)[index];
                        return TypeItem(
                            category, type, (width - (width * 0.04 * 3)) / 2);
                      },
                      itemCount:
                          dataProvider.getTypesForCategory(category).length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: width * 0.45,
                        childAspectRatio: 1,
                        crossAxisSpacing: width * 0.04,
                        mainAxisSpacing: width * 0.05,
                      ),
                    ),
                  ),
                ],
              )
            : child,
        child: CustomIndicator(
          color: Theme.of(context).primaryColor.withOpacity(0.6),
          width: Templates.getWidth(context),
        ),
      ),
    );
  }
}
