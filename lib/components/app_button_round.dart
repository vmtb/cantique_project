import 'package:cantique/utils/app_const.dart';
import 'package:flutter/material.dart';

import '../../utils/app_func.dart';
import 'app_text.dart';

class AppButtonRound extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color progressColor;
  final bool isLoading;
  final bool isEnable;
  final FontWeight weight;

  const AppButtonRound(
    this.text, {
    Key? key,
    this.backgroundColor = primaryColor_,
    this.textColor = Colors.white,
    this.isLoading = false,
    this.isEnable = true,
    this.progressColor = Colors.white,
    this.weight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: getSize(context).width,
      decoration: BoxDecoration(
          color:
          isLoading ? backgroundColor.withOpacity(0.5) : backgroundColor,
          borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: isLoading
            ? CircularProgressIndicator(
          backgroundColor: progressColor,
        )
            : AppText(
          text,
          weight: weight,
          color: isEnable == false
              ? textColor.withOpacity(0.7)
              : textColor,
          size: 20,
        ),
      ),
    );
  }
}
