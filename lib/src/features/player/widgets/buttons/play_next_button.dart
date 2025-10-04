

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themby/src/features/player/service/controls_service.dart';

class PlayNextButton extends ConsumerWidget{
  const PlayNextButton({super.key, this.size = 30, this.color = CupertinoColors.white});

  final double size;
  final Color color;


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 44,
        child: Icon(
          CupertinoIcons.forward_end_fill,
          size: size,
          color: color,
        ),
        onPressed: () async {
          ref.read(controlsServiceProvider.notifier).playNext();
        }
    );
  }
}