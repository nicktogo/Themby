

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:themby/src/features/player/service/lock_service.dart';

part 'volume_brightness_service.g.dart';

class VolumeBrightnessInfo {
  final bool isVolumeDrag;
  final bool isBrightnessDrag;
  final double volume;
  final double brightness;

  const VolumeBrightnessInfo({
    this.isBrightnessDrag = false,
    this.isVolumeDrag = false,
    required this.volume,
    required this.brightness,
  });

  VolumeBrightnessInfo copyWith({
    bool? isVolumeDrag,
    bool? isBrightnessDrag,
    double? volume,
    double? brightness,
  }) {
    return VolumeBrightnessInfo(
      isVolumeDrag: isVolumeDrag ?? this.isVolumeDrag,
      isBrightnessDrag: isBrightnessDrag ?? this.isBrightnessDrag,
      volume: volume ?? this.volume,
      brightness: brightness ?? this.brightness,
    );
  }
}

class _VolumeBrightnessToast extends StatelessWidget {
  final double value;
  final bool isVolume;

  const _VolumeBrightnessToast({
    required this.value,
    required this.isVolume,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            '$percentage%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    if (isVolume) {
      if (value == 0) return Icons.volume_off;
      if (value < 0.5) return Icons.volume_down;
      return Icons.volume_up;
    } else {
      return value > 0.5 ? Icons.brightness_high : Icons.brightness_low;
    }
  }
}

@Riverpod(keepAlive: true)
class VolumeBrightnessService extends _$VolumeBrightnessService {
  static const String _toastTag = "volume_brightness_toast";
  static const double _sensitivityMultiplier = 3.0;

  bool _toastShowing = false;

  @override
  VolumeBrightnessInfo build() {
    return const VolumeBrightnessInfo(
      volume: 0.0,
      brightness: 0.0,
    );
  }

  Future<void> update() async {
    final volume = await FlutterVolumeController.getVolume();
    if (volume != null) {
      state = state.copyWith(volume: volume);
    }
  }

  Future<void> onVerticalDragStart(DragStartDetails details, double width) async {
    if (ref.read(lockServiceProvider).controlsLock) return;

    _resetState();

    // Determine drag type based on horizontal position
    final isLeftSide = details.globalPosition.dx < width * 0.5;

    if (isLeftSide) {
      await _startBrightnessDrag();
    } else {
      await _startVolumeDrag();
    }
  }

  Future<void> _startBrightnessDrag() async {
    try {
      final currentBrightness = await ScreenBrightness().current;
      state = state.copyWith(
        isBrightnessDrag: true,
        brightness: currentBrightness,
      );
    } catch (e) {
      state = state.copyWith(
        isBrightnessDrag: true,
        brightness: 0.5,
      );
    }
  }

  Future<void> _startVolumeDrag() async {
    FlutterVolumeController.updateShowSystemUI(false);
    final currentVolume = await FlutterVolumeController.getVolume() ?? 0.5;
    state = state.copyWith(
      isVolumeDrag: true,
      volume: currentVolume,
    );
  }

  void onVerticalDragUpdate(DragUpdateDetails details, double height) {
    if (ref.read(lockServiceProvider).controlsLock) return;

    if (state.isBrightnessDrag) {
      _updateBrightness(details, height);
    } else if (state.isVolumeDrag) {
      _updateVolume(details, height);
    }
  }

  void _updateBrightness(DragUpdateDetails details, double height) {
    final deltaChange = _calculateDeltaChange(details.delta.dy, height);
    final newBrightness = (state.brightness + deltaChange).clamp(0.0, 1.0);

    try {
      // TODO: Brightness changes have noticeable lag - the actual brightness doesn't keep up with
      // the displayed value. This might be a limitation of the screen_brightness package or
      // the underlying platform API. Consider investigating alternative approaches.
      ScreenBrightness().setScreenBrightness(newBrightness);
      state = state.copyWith(brightness: newBrightness);
      _showToast();
    } catch (e) {
      // Handle error silently
    }
  }

  void _updateVolume(DragUpdateDetails details, double height) {
    final deltaChange = _calculateDeltaChange(details.delta.dy, height);
    final newVolume = (state.volume + deltaChange).clamp(0.0, 1.0);

    FlutterVolumeController.setVolume(newVolume);
    state = state.copyWith(volume: newVolume);
    _showToast();
  }

  double _calculateDeltaChange(double deltaY, double height) {
    return -deltaY / (height * 0.5 * _sensitivityMultiplier);
  }

  void onVerticalDragEnd(_) async {
    if (ref.read(lockServiceProvider).controlsLock) return;

    if (_toastShowing) {
      await SmartDialog.dismiss(tag: _toastTag);
      _toastShowing = false;
    }
    _resetState();
  }

  void _resetState() {
    state = state.copyWith(
      isBrightnessDrag: false,
      isVolumeDrag: false,
    );
  }

  void _showToast() {
    if (!_toastShowing) {
      _toastShowing = true;
      SmartDialog.show(
        tag: _toastTag,
        alignment: Alignment.center,
        maskColor: Colors.transparent,
        clickMaskDismiss: false,
        usePenetrate: true,
        builder: (_) => Consumer(
          builder: (context, ref, __) {
            final state = ref.watch(volumeBrightnessServiceProvider);
            final value = state.isBrightnessDrag ? state.brightness : state.volume;
            final isVolume = state.isVolumeDrag;
            return _VolumeBrightnessToast(value: value, isVolume: isVolume);
          },
        ),
      );
    }
  }
}

