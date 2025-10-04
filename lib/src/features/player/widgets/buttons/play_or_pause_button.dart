

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themby/src/features/player/service/themby_controller.dart';

class PlayOrPauseButton extends ConsumerStatefulWidget{
  const PlayOrPauseButton({super.key});


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayOrPauseButtonState();
}

class _PlayOrPauseButtonState extends ConsumerState<PlayOrPauseButton>{
  bool isPlaying = false;

  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = ref.read(thembyControllerProvider).controller.player.stream.playing.listen((event) {
      setState(() {
        isPlaying = event;
      });
    });
  }


  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 44,
      child: Icon(
        isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
        color: CupertinoColors.white,
        size: 30,
      ),
      onPressed: (){
        ref.read(videoControllerProvider).player.playOrPause();
      },
    );
  }
}