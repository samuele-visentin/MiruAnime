import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miru_anime/backend/database/app_settings.dart';
import 'app_colors.dart';

const statusBarLight = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark
);

const statusBarDark = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light
);

enum TypeTheme {
  purple,
  amoled,
  light
}

class AppTheme extends ChangeNotifier {
  late TypeTheme _type;
  late ThemeMode _mode;
  AppTheme(final TypeTheme type) {
    _type = type;
    _mode = _getMode(type);
  }

  TypeTheme get type => _type;
  ThemeMode get mode => _mode;

  set setTheme(final TypeTheme themeType) {
    AppSettings.saveInt(AppSettings.themeSetting, themeType.index);
    _mode = _getMode(themeType);
    _type = themeType;
    notifyListeners();
  }

  ThemeMode _getMode(final TypeTheme themeType) {
    switch (themeType) {
      case TypeTheme.purple:
        return ThemeMode.light;
      case TypeTheme.amoled:
        return ThemeMode.dark;
      case TypeTheme.light:
        return ThemeMode.light;
    }
  }
}

const _textTheme = TextTheme(
    headlineLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        //color: AppColors.white
      //height: 29
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 15,
      fontWeight: FontWeight.w600,
      //color: AppColors.white,
    ),
    headlineSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        //color: AppColors.white
      //height: 24,
    ),
    bodyLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat',
        letterSpacing: 0.15,
        //color: AppColors.white,
        fontSize: 13
    ),
    bodyMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat',
        letterSpacing: 0.15,
        //color: AppColors.white,
        fontSize: 12
    ),
    bodySmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat',
        letterSpacing: 0.15,
        //color: AppColors.white,
        fontSize: 11
    ),
    titleLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        //color: AppColors.white
    ),
    titleMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        //color: AppColors.white
    ),
    titleSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        //color: AppColors.white
    )
);

final themeAppPurple = ThemeData.from(
  colorScheme: const ColorScheme(
      primary: Colors.black,
      secondary: AppColors.purple,
      secondaryContainer: AppColors.darkBlue,
      surface: AppColors.background,
      error: AppColors.functionalred,
      onPrimary: AppColors.purple,
      onSecondary: AppColors.blue,
      onSurface: Colors.white,
      onError: AppColors.background,
      brightness: Brightness.dark
    ),
  textTheme: _textTheme
);

final themeAppAmoled = ThemeData.from(
    colorScheme: const ColorScheme(
        primary: Colors.black,
        secondary: AppColors.ocean8,
        secondaryContainer: AppColors.background,
        surface: Colors.black,
        error: AppColors.functionalred,
        onPrimary: AppColors.white,
        onSecondary: AppColors.darkBlue,
        onSurface: Colors.white,
        onError: AppColors.background,
        brightness: Brightness.dark
    ),
    textTheme: _textTheme
);

/*final _themeAppLight = ThemeData.from(
    colorScheme: const ColorScheme(
        primary: AppColors.white,
        secondary: AppColors.purple,
        secondaryContainer: AppColors.ocean4,
        surface: AppColors.functionalDarkGrey,
        error: AppColors.functionalred,
        onPrimary: Colors.black,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onError: AppColors.background,
        brightness: Brightness.light
    ),
    textTheme: _textTheme
);*/
