import 'package:cherry/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Themes { light, dark, black }
enum ImageQuality { low, medium, high }

/// APP MODEL
/// Specific general settings about the app.
class AppModel extends Model {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  ImageQuality _imageQuality = ImageQuality.medium;

  get imageQuality => _imageQuality;

  set imageQuality(ImageQuality imageQuality) {
    _imageQuality = imageQuality;
    notifyListeners();
  }

  FlutterLocalNotificationsPlugin get notifications => _notifications;

  Themes _theme = Themes.dark;

  ThemeData _themeData = AppTheme.dark();

  get theme => _theme;

  set theme(Themes theme) {
    if (theme != null) {
      _theme = theme;
      themeData = theme;
      notifyListeners();
    }
  }

  get themeData => _themeData;

  set themeData(Themes theme) {
    _themeData = _themes[theme.index];
    notifyListeners();
  }

  Future init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Loads the theme
    try {
      theme = Themes.values[prefs.getInt('theme')];
    } catch (e) {
      prefs.setInt('theme', 1);
    }

    // Loads image quality
    try {
      imageQuality = ImageQuality.values[prefs.getInt('quality')];
    } catch (e) {
      prefs.setInt('quality', 1);
    }

    // Inits notifications system
    notifications.initialize(InitializationSettings(
      AndroidInitializationSettings('notification_launch'),
      IOSInitializationSettings(),
    ));

    notifyListeners();
  }
}
