
import 'dart:io';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:themby/src/common/data/player_setting.dart';

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
            // Disable libass on iOS to use Flutter native subtitle rendering for Chinese fonts
            libass: !isIOS,
            // Reduce debug logging on iOS for better performance
            logLevel: isIOS ? MPVLogLevel.warn : MPVLogLevel.debug,
            // Set title for iOS identification
            title: 'Themby Player',
            // Enable pitch adjustment for better audio processing on iOS
            pitch: isIOS,
        )
    );

    // iOS-specific post-initialization optimizations
    if (isIOS) {
      // Optimize audio device selection for iOS after player creation
      player.setAudioDevice(AudioDevice.auto());
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

