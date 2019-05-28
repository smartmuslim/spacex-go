import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData _baseTheme = ThemeData(
  fontFamily: DateTime.now().month == 4 && DateTime.now().day == 1
      ? 'ComicSans'
      : 'ProductSans',
);

class AppTheme extends ThemeData {
  factory AppTheme.light() => _baseTheme.copyWith(
        brightness: Brightness.light,
        primaryColor: lightPrimaryColor,
        accentColor: lightAccentColor,
      );

  factory AppTheme.dark() => _baseTheme.copyWith(
        brightness: Brightness.dark,
        primaryColor: darkPrimaryColor,
        accentColor: darkAccentColor,
        canvasColor: darkCanvasColor,
        scaffoldBackgroundColor: darkBackgroundColor,
        cardColor: darkCardColor,
        dividerColor: darkDividerColor,
        dialogBackgroundColor: darkCardColor,
      );

  factory AppTheme.oled() => _baseTheme.copyWith(
        brightness: Brightness.dark,
        primaryColor: blackPrimaryColor,
        accentColor: blackAccentColor,
        canvasColor: blackBackgroundColor,
        scaffoldBackgroundColor: blackBackgroundColor,
        cardColor: blackCardColor,
        dividerColor: blackDividerColor,
        dialogBackgroundColor: darkCardColor,
      );
}
