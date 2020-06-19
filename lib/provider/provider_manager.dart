import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/provider/player_button_provider.dart';
import 'package:dharma_deshana/provider/song_provider.dart';
import 'package:provider/provider.dart';

List<ChangeNotifierProvider> providers = [
  ChangeNotifierProvider<SongProvider>(
    create: (context) => SongProvider(),
  ),
  ChangeNotifierProvider<DataProvider>(
    create: (context) => DataProvider(),
  ),
  ChangeNotifierProvider<PlayerButtonProvider>(
    create: (context) => PlayerButtonProvider(),
  ),
];
