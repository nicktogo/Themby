import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // Initialize MediaKit for video playback
  MediaKit.ensureInitialized();

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

