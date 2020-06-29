import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/provider/connectivity_provider.dart';
import 'package:dharma_deshana/widgets/templates/custom/no_internet_widget.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class ConnectivityWidget extends StatelessWidget {
  final Widget child;
  final Alignment allign;

  ConnectivityWidget({
    @required this.child,
    this.allign = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    final height =
        Templates.getAvailableHeight(null, context) - AppConstant.navbarHeight;
    return Selector<ConnectivityProvider, bool>(
      selector: (_, provider) => provider.isConnected,
      builder: (_, connected, childWidget) => Container(
        child: Stack(
          alignment: allign,
          children: <Widget>[
            childWidget,
            connected ? Container() : NoInternetWidget(height: height * 0.09),
          ],
        ),
      ),
      child: child,
    );
  }
}
