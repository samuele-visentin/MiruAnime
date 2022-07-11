import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miru_anime/backend/database/app_settings.dart';
import 'package:resize/resize.dart';
import 'app_colors.dart';

const statusBarLight = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  //TODO: check if this work on ios
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark
);

const statusBarDark = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light
);

enum TypeTheme {
  purple,
  amoled,
  light
}

class AppTheme extends ChangeNotifier {
  late ThemeData _theme;
  late TypeTheme _type;
  AppTheme(final TypeTheme type) {
    _type = type;
    _theme = _getType(type);
  }

  ThemeData get theme => _theme;
  TypeTheme get type => _type;

  set setTheme(final TypeTheme themeType) {
    AppSettings.saveInt(AppSettings.themeSetting, themeType.index);
    _theme = _getType(themeType);
    notifyListeners();
  }

  ThemeData _getType(final TypeTheme themeType) {
    switch (themeType) {
      case TypeTheme.purple:
        return _themeAppPurple;
      case TypeTheme.amoled:
        return _themeAppAmoled;
      case TypeTheme.light:
        return _themeAppLight;
    }
  }
}

final _textTheme = TextTheme(
    headlineLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        //color: AppColors.white
      //height: 29
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      //color: AppColors.white,
    ),
    headlineSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        //color: AppColors.white
      //height: 24,
    ),
    bodyLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat',
        letterSpacing: 0.15,
        //color: AppColors.white,
        fontSize: 15.sp
    ),
    bodyMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat',
        letterSpacing: 0.15,
        //color: AppColors.white,
        fontSize: 14.sp
    ),
    bodySmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat',
        letterSpacing: 0.15,
        //color: AppColors.white,
        fontSize: 13.sp
    ),
    titleLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.15,
        //color: AppColors.white
    ),
    titleMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        //color: AppColors.white
    ),
    titleSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        //color: AppColors.white
    )
);

final _themeAppPurple = ThemeData.from(
  colorScheme: const ColorScheme(
      primary: AppColors.background,
      secondary: AppColors.purple,
      secondaryContainer: AppColors.darkBlue,
      surface: AppColors.white,
      background: AppColors.background,
      error: AppColors.functionalred,
      onPrimary: AppColors.purple,
      onSecondary: AppColors.blue,
      onSurface: Colors.black,
      onBackground: AppColors.white,
      onError: AppColors.background,
      brightness: Brightness.dark
    ),
  textTheme: _textTheme
);

final _themeAppAmoled = ThemeData.from(
    colorScheme: const ColorScheme(
        primary: Colors.black,
        secondary: AppColors.ocean8,
        secondaryContainer: AppColors.background,
        surface: AppColors.white,
        background: Colors.black,
        error: AppColors.functionalred,
        onPrimary: AppColors.white,
        onSecondary: AppColors.darkBlue,
        onSurface: Colors.black,
        onBackground: AppColors.white,
        onError: AppColors.background,
        brightness: Brightness.dark
    ),
    textTheme: _textTheme
);

final _themeAppLight = ThemeData.from(
    colorScheme: const ColorScheme(
        primary: AppColors.white,
        secondary: AppColors.purple,
        secondaryContainer: AppColors.ocean4,
        surface: AppColors.functionalDarkGrey,
        background: AppColors.white,
        error: AppColors.functionalred,
        onPrimary: Colors.black,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onBackground: Colors.black,
        onError: AppColors.background,
        brightness: Brightness.light
    ),
    textTheme: _textTheme
);