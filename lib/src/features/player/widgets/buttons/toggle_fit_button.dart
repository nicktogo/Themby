

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themby/src/features/player/service/fit_type_service.dart';

class ToggleFitButton extends ConsumerWidget{
  const ToggleFitButton({super.key, this.size = 28, this.color = CupertinoColors.white});

  final double size;
  final Color color;


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 44,
        child: Icon(
          CupertinoIcons.rectangle_expand_vertical,
          size: size,
          color: color,
        ),
        onPressed: () async {
          ref.read(fitTypeServiceProvider.notifier).toggleFitType();
        }
    );
  }
}

