import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/widgets/list/type_list.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final double height;

  CategoryItem(this.title, this.height);

  void selectCategory(BuildContext ctx) {
    pushNewScreen(
      ctx,
      screen: TypeList(
        category: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
        
    return CustomGridItem(
      title: title,
      onTap: () => selectCategory(context),
      height: height,
      image: dataProvider.getImageUrlForCategory(title),
    );
  }
}
