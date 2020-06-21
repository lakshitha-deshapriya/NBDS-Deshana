import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/provider/connectivity_provider.dart';
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
            connected
                ? Container()
                : Container(
                    height: height * 0.085,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        color: Colors.lightBlueAccent.withOpacity(0.3),
                        depth: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Connect to Internet',
                            style: TextStyle(
                              fontSize: height * 0.03,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            childWidget,
          ],
        ),
      ),
      child: child,
    );
  }
}
