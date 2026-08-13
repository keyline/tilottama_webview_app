import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppConstants {
  static const appName = 'Tilottamaa Hair and Skin';
  static const portalUrl = 'https://tilottamaahairandskin.com/clients/';
  static const brandColor = Color(0xFF7A1F47);

  static const systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: brandColor,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}
