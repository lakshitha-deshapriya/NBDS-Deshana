import 'package:dharma_deshana/widgets/tabs/categories.dart';
import 'package:dharma_deshana/widgets/tabs/downloads.dart';
import 'package:dharma_deshana/widgets/tabs/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:persistent_bottom_nav_bar/models/persisten-bottom-nav-item.widget.dart';

class Templates {
  static double getAvailableHeight(
      PreferredSizeWidget appBar, BuildContext ctx) {
    return MediaQuery.of(ctx).size.height -
        (appBar != null ? appBar.preferredSize.height : 0.0) -
        MediaQuery.of(ctx).padding.top;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static BoxDecoration backgroundImage(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).primaryColorLight.withOpacity(0.1),
      image: DecorationImage(
        colorFilter: ColorFilter.mode(
          Colors.lightBlueAccent.withOpacity(0.2),
          BlendMode.dstIn,
        ),
        image: AssetImage("assets/images/background.png"),
        fit: BoxFit.fitHeight,
      ),
    );
  }

  static Size getTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textScaleFactor: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static TextStyle getTitleStyle(double size, Color color) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static List<Widget> buildScreens() {
    return [
      Categories(),
      Downloads(),
      // Settings(),
    ];
  }

  static List<PersistentBottomNavBarItem> navBarsItems(double navBarHeight) {
    final iconHeight = navBarHeight * 0.45;
    final fontSize = navBarHeight * 0.25;
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Ionicons.ios_home,
          size: iconHeight,
        ),
        title: 'Home',
        titleFontSize: fontSize,
        activeColor: Colors.blue,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Ionicons.ios_cloud_download,
          size: iconHeight,
        ),
        title: 'Downloads',
        titleFontSize: fontSize,
        activeColor: Colors.teal,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      // PersistentBottomNavBarItem(
      //   icon: Icon(
      //     Ionicons.md_settings,
      //     size: iconHeight,
      //   ),
      //   title: 'Settings',
      //   titleFontSize: fontSize,
      //   activeColor: Colors.teal,
      //   inactiveColor: Colors.grey,
      //   isTranslucent: false,
      // ),
    ];
  }
}
