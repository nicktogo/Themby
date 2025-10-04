
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:internet_speed_meter/internet_speed_meter.dart';

class InternetSpeedChip extends StatefulWidget{
  const InternetSpeedChip({super.key});

  @override
  State<StatefulWidget> createState() => _InternetSpeedChip();
}

class _InternetSpeedChip extends State<InternetSpeedChip>{

  late String _currentSpeed;

  final InternetSpeedMeter _internetSpeedMeterPlugin = InternetSpeedMeter();

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _currentSpeed = '';
    init();
  }

  void init() async {
    // Check if platform supports internet speed measurement
    if (!Platform.isAndroid) {
      // Internet speed meter plugin only works on Android
      setState(() {
        _currentSpeed = '--';
      });
      return;
    }

    try {
      _subscription = _internetSpeedMeterPlugin.getCurrentInternetSpeed().listen(
        (event) {
          if (mounted) {
            setState(() {
              _currentSpeed = event;
            });
          }
        },
        onError: (error) {
          // Handle errors gracefully
          if (mounted) {
            setState(() {
              _currentSpeed = '--';
            });
          }
        },
      );
    } catch (e) {
      // Fallback if plugin fails to initialize
      if (mounted) {
        setState(() {
          _currentSpeed = '--';
        });
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xAA333333),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.arrow_up_arrow_down, color: CupertinoColors.white, size: 14),
          const SizedBox(width: 2),
          Text(_currentSpeed, style: const TextStyle(color: CupertinoColors.white, fontSize: 11),),
        ],
      ),
    );
  }
}