import 'package:flutter/material.dart';
import 'app_colors.dart';

final themeApp = ThemeData.from(
  colorScheme: const ColorScheme(
      primary: AppColors.white,
      secondary: AppColors.purple,
      surface: AppColors.darkBlue,
      background: AppColors.background,
      error: AppColors.functionalred,
      onPrimary: Colors.black,
      onSecondary: AppColors.blue,
      onSurface: AppColors.purple,
      onBackground: AppColors.purple,
      onError: AppColors.purple,
      brightness: Brightness.dark
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 96,
      fontWeight: FontWeight.w300,
      //height: 117,
      letterSpacing: -1.5
    ),
    headline2: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 60,
        fontWeight: FontWeight.w300,
        //height: 73,
        letterSpacing: -0.5
    ),
    headline3: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 48,
        fontWeight: FontWeight.w400,
        //height: 59,
    ),
    headline4: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 30,
        fontWeight: FontWeight.w600,
        //height: 37,
    ),
    headline5: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        //height: 29
    ),
    headline6: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.purple
        //height: 24,
    ),
    bodyText1: TextStyle(
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat',
      //height: 20,
      letterSpacing: 0.15,
      color: AppColors.white,
      fontSize: 18
    ),
    bodyText2: TextStyle(
      fontWeight: FontWeight.w700,
      fontFamily: 'Montserrat',
      //height: 20,
      letterSpacing: 0.15,
      color: AppColors.purple,
      fontSize: 15
    ),
    button: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      //height: 16,
      letterSpacing: 1.25,
      color: AppColors.purple
    ),
    caption: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 12,
      fontWeight: FontWeight.w700,
      //height: 16,
      letterSpacing: 0.4,
      color: AppColors.white
    ),
    overline: TextStyle(
      fontWeight: FontWeight.w600,
      //height: 16,
      fontFamily: 'Montserrat',
      fontSize: 12,
      letterSpacing: 1
    ),
    subtitle1: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 15,
      fontWeight: FontWeight.w600,
      //height: 24,
      letterSpacing: 0.15,
      color: AppColors.white
    ),
    subtitle2: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        //height: 24,
        letterSpacing: 0.15,
        color: AppColors.white
    )
  )
);