import 'package:dharma_deshana/loader/data_loader.dart';
import 'package:dharma_deshana/provider/connectivity_provider.dart';
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

  refreshData(DataProvider provider, ConnectivityProvider connectivity) async {
    provider.setInitialized(false);
    await DataLoader().loadFromFirebase(provider, connectivity);
  }

  @override
  Widget build(BuildContext context) {
    final ConnectivityProvider connectivity =
        Provider.of<ConnectivityProvider>(context, listen: false);
    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);

    final double width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Selector<ConnectivityProvider, bool>(
          selector: (_, provider) => provider.isConnected,
          builder: (_, connected, childWidget) => Container(
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
                  isEnabled: connected,
                  onClick: () {
                    refreshData(dataProvider, connectivity);
                  },
                  child: childWidget,
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
          child: Container(
            padding: EdgeInsets.all(height * 0.015),
            child: Icon(
              Fontisto.spinner_refresh,
              color: Colors.blueGrey,
              size: height * 0.044,
            ),
          ),
        ),
        Selector<DataProvider, bool>(
          selector: (_, model) => model.isCategoriesInitialized,
          builder: (_, initialized, childWidget) => initialized
              ? Container(
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
                )
              : childWidget,
          child: CustomIndicator(
            color: Theme.of(context).primaryColor.withOpacity(0.6),
            width: Templates.getWidth(context),
          ),
        ),
      ],
    );
  }
}
