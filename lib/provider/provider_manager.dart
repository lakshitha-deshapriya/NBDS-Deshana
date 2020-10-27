import 'package:dharma_deshana/provider/connectivity_provider.dart';
import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/provider/carousel_provider.dart';
import 'package:dharma_deshana/provider/download_provider.dart';
import 'package:dharma_deshana/provider/song_provider.dart';
import 'package:provider/provider.dart';

List<ChangeNotifierProvider> providers = [
  ChangeNotifierProvider<SongProvider>(
    create: (context) => SongProvider(),
  ),
  ChangeNotifierProvider<DataProvider>(
    create: (context) => DataProvider(),
  ),
  ChangeNotifierProvider<CarouselProvider>(
    create: (context) => CarouselProvider(),
  ),
  ChangeNotifierProvider<ConnectivityProvider>(
    create: (context) => ConnectivityProvider(),
  ),
  ChangeNotifierProvider<DownloadProvider>(
    create: (context) => DownloadProvider(),
  ),
];
