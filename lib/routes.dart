import 'package:dharma_deshana/anims/page_route_anim.dart';
import 'package:dharma_deshana/widgets/list/song_list.dart';
import 'package:dharma_deshana/widgets/list/type_list.dart';
import 'package:dharma_deshana/widgets/player/music_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/tab_navigator.dart';

class RouteName {
  static const String initial = '/';
  static const String category = '/category';
  static const String types = '/types';
  static const String songs = '/songs';
  static const String player = '/player';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.initial:
        return ValueNotifierRouteBuilder<int>(TabNaigator(), 0);
      case RouteName.types:
        return NoAnimRouteBuilder(TypeList());
      default:
        return null;
    }
  }

  static Map<String, WidgetBuilder> routesList(BuildContext ctx) {
    return {
      RouteName.initial: (ctx) => ChangeNotifierProvider<ValueNotifier<int>>(
            create: (context) => ValueNotifier<int>(0),
            child: TabNaigator(),
          ),
      // RouteName.types: (ctx) => TypeList(),
      // RouteName.songs: (ctx) => SongList(category: null,type: null,),
      // RouteName.player: (ctx) => MusicPlayer(),
    };
  }
}
