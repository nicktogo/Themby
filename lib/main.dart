import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:media_kit/media_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:themby/app.dart';
import 'package:themby/src/helper/device_info_provider.dart';
import 'package:themby/src/helper/objectbox_provider.dart';
import 'package:themby/src/helper/package_info.dart';
import 'package:themby/src/helper/prefs_provider.dart';
import 'package:path/path.dart';
import 'objectbox.g.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 强制重置系统UI模式，确保App总是以正确的状态启动
  // 这样可以避免上次运行时的沉浸模式状态污染整个App
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: SystemUiOverlay.values, // 显示所有系统UI
  );

  // Initialize MediaKit for video playback
  MediaKit.ensureInitialized();

  // Configure FlutterVolumeController audio session for iOS silent mode
  if (Platform.isIOS) {
    try {
      await FlutterVolumeController.setIOSAudioSessionCategory(
        category: AudioSessionCategory.playback,
      );
    } catch (e) {
      debugPrint('Failed to set iOS audio session category: $e');
    }
  }

  final prefs = await SharedPreferences.getInstance();
  final directory = await getApplicationDocumentsDirectory();
  final store = Store(getObjectBoxModel(), directory: join(directory.path, 'objectbox'));
  final deviceInfo = await initDevice();
  final packageInfo = await PackageInfo.fromPlatform();

  runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          storeProvider.overrideWithValue(store),
          deviceInfoProvider.overrideWithValue(deviceInfo),
          packageInfoProvider.overrideWithValue(packageInfo)
        ],
        child: const App()
      )
  );
}

