import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voicify/view/styles/colors/app_colors.dart';

class MyText extends Text {
  const MyText(super.data,
      {this.color = AppColors.blackText,
      this.fontSize = 18,
      this.fontWeight = FontWeight.w500,
      this.languageCode = 'en',
      this.textAlign = TextAlign.justify,
      this.maxLines,
      super.key});
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final String languageCode;
  @override
  final TextAlign textAlign;
  @override
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      data!,
      textAlign: textAlign,
      maxLines: maxLines,
      style: GoogleFonts.urbanist(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          locale: Locale(languageCode)),
    );
  }
}
