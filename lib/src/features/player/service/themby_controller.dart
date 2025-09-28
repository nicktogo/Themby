
import 'dart:io';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:themby/src/common/data/player_setting.dart';
import 'package:themby/src/features/player/service/font_extractor.dart';
import 'package:themby/src/helper/logger.dart';

part 'themby_controller.g.dart';

class ThembyController{

  ThembyController({
    required this.mpvBufferSize,
    required this.mpvHardDecoding,
    required this.iosVideoToolboxDecoding,
    required this.iosBufferMultiplier,
  }) {
    _initController();
  }

  int mpvBufferSize;
  bool mpvHardDecoding;
  bool iosVideoToolboxDecoding;
  int iosBufferMultiplier;

  late VideoController videoController;

  VideoController get controller => videoController;

  void _initController() {
    // iOS-specific optimizations for better performance
    final isIOS = Platform.isIOS;

    Player player = Player(
        configuration: PlayerConfiguration(
            // Significantly increase buffer size for iOS to prevent audio underruns
            bufferSize: 1024 * 1024 * (isIOS ? mpvBufferSize * iosBufferMultiplier : mpvBufferSize),
            // Keep libass enabled for all platforms as requested
            libass: true,
            logLevel: MPVLogLevel.warn,
            // Set title for iOS identification
            title: 'Themby Player',
            // Enable pitch adjustment for better audio processing on iOS
            pitch: isIOS,
            // Configure libass font for Android, iOS uses custom font directory
            libassAndroidFont: isIOS ? null : 'assets/fonts/subfont.ttf',
        )
    );

    final logger = ThembyLogger();
    logger.i('Initializing video player - Platform: ${isIOS ? 'iOS' : 'Android'}');

    if (isIOS) {
      logger.i('iOS: Using custom font directory solution for Chinese subtitles');
    } else {
      logger.i('Android: Using libassAndroidFont configuration');
    }

    // iOS-specific post-initialization optimizations
    if (isIOS) {
      // Optimize audio device selection for iOS after player creation
      player.setAudioDevice(AudioDevice.auto());

      // Set up custom font directory for iOS subtitle rendering
      _setupIOSFontDirectory(player);
    }

    videoController = VideoController(
      player,
      configuration: VideoControllerConfiguration(
        enableHardwareAcceleration: mpvHardDecoding,
        androidAttachSurfaceAfterVideoParameters: false,
        // iOS-specific configurations for optimal resolution detection
        width: null,
        height: null,
      ),
    );
  }

  /// Sets up custom font directory for iOS libass subtitle rendering.
  ///
  /// This method extracts the bundled Chinese font to a writable directory
  /// and configures MPV to use it via the sub-fonts-dir property.
  /// This approach bypasses iOS 18+ system font access restrictions.
  void _setupIOSFontDirectory(Player player) async {
    final logger = ThembyLogger();

    try {
      logger.d('Setting up iOS font directory for libass');

      // Extract font to accessible directory
      final String fontsDirPath = await getLibassFontsDir();

      // Access the native player handle and set the property
      if (player.platform is NativePlayer) {
        final nativePlayer = player.platform as NativePlayer;

        // Configure MPV to use our custom font directory for libass
        await nativePlayer.setProperty('sub-fonts-dir', fontsDirPath);
        await nativePlayer.setProperty('sub-font', 'Noto Sans SC');

        logger.i('Successfully configured iOS font directory: $fontsDirPath');
      } else {
        logger.w('Player platform is not NativePlayer, cannot set sub-fonts-dir');
      }
    } catch (e, stackTrace) {
      logger.e('Failed to set up iOS font directory', error: e, stackTrace: stackTrace);
    }
  }
}

@riverpod
ThembyController thembyController(ThembyControllerRef ref) {
  final playerSetting = ref.watch(playerSettingProvider);
  return ThembyController(
    mpvBufferSize: playerSetting.mpvBufferSize,
    mpvHardDecoding: playerSetting.mpvHardDecoding,
    iosVideoToolboxDecoding: playerSetting.iosVideoToolboxDecoding,
    iosBufferMultiplier: playerSetting.iosBufferMultiplier,
  );
}

@riverpod
VideoController videoController(VideoControllerRef ref) {
  return ref.watch(thembyControllerProvider).controller;
}

