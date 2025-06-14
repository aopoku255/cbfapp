import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'MainText.dart';

class Button extends StatelessWidget {
  final onTap;
  final String label;
  final Color? backgroundColor;
  const Button({super.key, this.onTap, required this.label, this.backgroundColor = AppColors.primaryVoilet});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      child: Container(
        margin: EdgeInsets.only(top: 40),
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(100)
        ),
        child: Center(child: MainText(text: label, color: Colors.white, fontSize: 18,)),
      ),
    );
  }
}
