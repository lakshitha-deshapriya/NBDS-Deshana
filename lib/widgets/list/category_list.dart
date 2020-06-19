import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/widgets/item/category_item.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_indicator.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  final double height;

  CategoryList(this.height);

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);

    final double width = MediaQuery.of(context).size.width;

    return Selector<DataProvider, bool>(
      selector: (_, model) => model.isCategoriesInitialized,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      NeumorphicButton(
                        padding: EdgeInsets.zero,
                        drawSurfaceAboveChild: true,
                        onClick: () {
                          print('came');
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
                Container(
                  height: height * 0.91,
                  child: GridView.builder(
                    padding: EdgeInsets.only(
                      left: width * 0.04,
                      right: width * 0.04,
                      bottom: width * 0.04,
                      top: width * 0.02,
                    ),
                    itemBuilder: (_, index) =>
                        CategoryItem(dataProvider.getCategories[index], height),
                    itemCount: dataProvider.getCategories.length,
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
    );
  }
}
