import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/models/persistent-bottom-nav-bar-styles.widget.dart';
import 'package:persistent_bottom_nav_bar/models/persistent-nav-bar-scaffold.widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';

class TabNaigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    AppConstant.navbarHeight =
        Templates.getAvailableHeight(null, context) * 0.08;

    return PersistentTabView(
      navBarHeight: AppConstant.navbarHeight,
      controller: controller,
      screens: Templates.buildScreens(),
      items: Templates.navBarsItems(AppConstant.navbarHeight),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      navBarCurve: NavBarCurve.upperCorners,
      popAllScreensOnTapOfSelectedTab: false,
      showElevation: true,
      itemCount: 3,
      navBarStyle: NavBarStyle.style1,
    );
  }
}
