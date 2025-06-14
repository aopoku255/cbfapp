import 'dart:ffi';

import 'package:cbfapp/theme/colors.dart';
import 'package:flutter/material.dart';

class MainText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  const MainText({super.key, required this.text,  this.fontWeight, this.fontSize, this.color = Colors.black, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize), textAlign: textAlign,);
  }
}
