import 'package:dharma_deshana/provider/provider_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        builder: (context, child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1),
            child: child,
          );
        },
        title: 'Deshana',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Color.fromRGBO(232, 170, 89, 1),
          fontFamily: 'OpenSans',
        ),
        initialRoute: RouteName.initial,
        debugShowCheckedModeBanner: false,
        routes: Routers.routesList(context),
      ),
    );
  }
}
