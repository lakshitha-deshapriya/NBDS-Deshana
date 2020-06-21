import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/widgets/templates/custom/custom_scaffold.dart';
import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height =
        Templates.getAvailableHeight(null, context) - AppConstant.navbarHeight;
        
    return CustomScaffold(
      body: Center(
        child: Text(
          'Settings',
          style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: height * 0.03),
        ),
      ),
    );
  }
}
