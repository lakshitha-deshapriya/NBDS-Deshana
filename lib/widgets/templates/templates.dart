import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/models/download_info.dart';
import 'package:dharma_deshana/widgets/tabs/categories.dart';
import 'package:dharma_deshana/widgets/tabs/downloads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

  static Future<bool> checkPermission(TargetPlatform platform) async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;

      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  static Future<String> findLocalPath(TargetPlatform platform) async {
    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static int downloadState(DownloadInfo info, String songName ) {
    if (info == null) {
      return AppConstant.DOWNLOADABLE_STATE;
    }
    DownloadTaskStatus status = info.status;
    if (status == DownloadTaskStatus.undefined) {
      return AppConstant.DOWNLOADABLE_STATE;
    } else if (status == DownloadTaskStatus.enqueued ||
        status == DownloadTaskStatus.running ||
        status == DownloadTaskStatus.paused) {
      return AppConstant.DOWNLOADING_STATE;
    } else if (status == DownloadTaskStatus.complete) {
      return AppConstant.DOWNLOADED_STATE;
    } else if (status == DownloadTaskStatus.failed ||
        status == DownloadTaskStatus.canceled) {
      return AppConstant.DOWNLOAD_FAIL;
    }
    return AppConstant.DOWNLOADED_STATE;
  }
}
