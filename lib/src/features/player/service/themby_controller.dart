
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:themby/src/common/data/player_setting.dart';

part 'themby_controller.g.dart';

class ThembyController{

  ThembyController({required this.mpvBufferSize, required this.mpvHardDecoding}) {
    _initController();
  }

  int mpvBufferSize;

  bool mpvHardDecoding;

  late VideoController videoController;

  VideoController get controller => videoController;

  void _initController() {
    Player player =  Player(
        configuration: PlayerConfiguration(
            bufferSize: 1024 * 1024 * mpvBufferSize,
            libass: true,
            logLevel: MPVLogLevel.debug
        )
    );

    // Font loading for Android only - skip async font loading for now
    // This can be added back later if needed

    videoController = VideoController(
      player,
      configuration: VideoControllerConfiguration(
        enableHardwareAcceleration: mpvHardDecoding,
        androidAttachSurfaceAfterVideoParameters: false,
      ),
    );
  }
}

@riverpod
ThembyController thembyController(ThembyControllerRef ref) {
  return ThembyController(
    mpvBufferSize: ref.watch(playerSettingProvider).mpvBufferSize,
    mpvHardDecoding: ref.watch(playerSettingProvider).mpvHardDecoding
  );
}

@riverpod
VideoController videoController(VideoControllerRef ref) {
  return ref.watch(thembyControllerProvider).controller;
}

