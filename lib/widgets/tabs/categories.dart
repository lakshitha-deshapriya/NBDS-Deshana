import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/widgets/list/category_list.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_indicator.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_scaffold.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);

    dataProvider.initData();

    final double height =
        Templates.getAvailableHeight(null, context) - AppConstant.navbarHeight;

    return CustomScaffold(
      body: Selector<DataProvider, bool>(
        selector: (_, model) => model.isInitialized,
        builder: (context, value, child) =>
            dataProvider.isInitialized ? CategoryList(height) : child,
        child: CustomIndicator(
          color: Theme.of(context).primaryColor.withOpacity(0.6),
          width: Templates.getWidth(context),
          showText: true,
        ),
      ),
    );
  }
}
