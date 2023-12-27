import 'package:flutter/material.dart';
import 'package:voicify/view/styles/colors/app_colors.dart';

final darkTheme = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    background: AppColors.bgGreyDark,
  ),
  primaryTextTheme: TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.white,
    ),
  ),
);
