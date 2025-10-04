import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:media_kit/media_kit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:themby/src/common/data/app_setting_repository.dart';
import 'package:themby/src/common/widget/custom_dialog.dart';
import 'package:themby/src/router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

part 'app.g.dart';


@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  // WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid){
    await FlutterDisplayMode.setHighRefreshRate();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
  } else if (Platform.isIOS) {
    // iOS performance optimizations
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));

    // Enable preferred frame rate for smoother video playback
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  MediaKit.ensureInitialized();
}

class App extends ConsumerWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.watch(appStartupProvider);

    final themeMode = [
      ThemeMode.light,
      ThemeMode.dark,
      ThemeMode.system,
    ][ref.watch(appSettingRepositoryProvider).themeMode];

    // Determine brightness based on theme mode
    Brightness brightness;
    if (themeMode == ThemeMode.system) {
      brightness = MediaQueryData.fromView(View.of(context)).platformBrightness;
    } else {
      brightness = themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
    }

    return CupertinoApp.router(
      routerConfig: ref.watch(goRouterProvider),
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: CupertinoColors.activeBlue,
        scaffoldBackgroundColor: brightness == Brightness.dark
            ? CupertinoColors.black
            : CupertinoColors.systemBackground,
        barBackgroundColor: brightness == Brightness.dark
            ? CupertinoColors.darkBackgroundGray
            : CupertinoColors.systemBackground,
        textTheme: CupertinoTextThemeData(
          primaryColor: brightness == Brightness.dark
              ? CupertinoColors.white
              : CupertinoColors.black,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
      ],
      builder: FlutterSmartDialog.init(
        toastBuilder: (String message) => CustomToastWidget(message: message),
      ),
    );
  }
}