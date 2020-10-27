import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/widgets/templates/custom/app_background.dart';
import 'package:dharma_deshana/widgets/templates/custom/connectivity_widget.dart';
import 'package:dharma_deshana/widgets/templates/custom/player_button.dart';
import 'package:flutter/material.dart';

import '../templates.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;

  CustomScaffold({@required this.body, this.appBar});

  @override
  Widget build(BuildContext context) {
    final double height = Templates.getAvailableHeight(appBar, context) -
        AppConstant.navbarHeight;
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: ConnectivityWidget(
          child: Stack(
            children: <Widget>[
              AppBackground(),
              body,
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: PlayerButton(height: height),
    );
  }
}
