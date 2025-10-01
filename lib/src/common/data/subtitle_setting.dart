import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:themby/src/helper/prefs_provider.dart';
import 'constant.dart';

part 'subtitle_setting.g.dart';

class SubtitleSetting {
  SubtitleSetting({
    required this.prefs,
  });

  final SharedPreferences prefs;

  int get subtitleSize => prefs.getInt(Constant.subtitleSizeKey) ?? 32;
  set subtitleSize(int value) => prefs.setInt(Constant.subtitleSizeKey, value);

  int get subtitleColor => prefs.getInt(Constant.subtitleColorKey) ?? 0xFFFFFFFF;
  set subtitleColor(int value) => prefs.setInt(Constant.subtitleColorKey, value);

  bool get subtitleBold => prefs.getBool(Constant.subtitleBoldKey) ?? false;
  set subtitleBold(bool value) => prefs.setBool(Constant.subtitleBoldKey, value);

  int get subtitleBackgroundColor => prefs.getInt(Constant.subtitleBackgroundColorKey) ?? 0x00000000;
  set subtitleBackgroundColor(int value) => prefs.setInt(Constant.subtitleBackgroundColorKey, value);

  bool get subtitleShadow => prefs.getBool(Constant.subtitleShadowKey) ?? false;
  set subtitleShadow(bool value) => prefs.setBool(Constant.subtitleShadowKey, value);

  TextStyle get subtitleStyle => TextStyle(
    height: 1.4,
    fontSize: subtitleSize.toDouble(),
    letterSpacing: 0.0,
    wordSpacing: 0.0,
    color: Color(subtitleColor),
    fontWeight: subtitleBold ? FontWeight.bold : FontWeight.normal,
    backgroundColor: Colors.transparent,
    // Use platform-specific fonts that support Chinese characters
    fontFamily: _getChineseFontFamily(),
  );

  String? _getChineseFontFamily() {
    // Test: Let libass use system font fallback on iOS
    if (Platform.isIOS) {
      return null; // No font specified - let libass use system defaults
    } else {
      return 'NotoSansSC-Regular'; // Custom font for Android
    }
  }

}

@riverpod
SubtitleSetting subtitleSetting(SubtitleSettingRef ref) => SubtitleSetting(
  prefs: ref.watch(sharedPreferencesProvider),
);
