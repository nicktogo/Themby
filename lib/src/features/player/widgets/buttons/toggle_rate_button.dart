


import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:themby/src/common/constants.dart';
import 'package:themby/src/features/player/constants.dart';
import 'package:themby/src/features/player/service/controls_service.dart';

class ToggleRateButton extends ConsumerWidget{
  const ToggleRateButton({super.key, this.size = 30, this.color = CupertinoColors.white});

  final double size;
  final Color color;


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final rate = ref.watch(controlsServiceProvider).rate;


    return CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 44,
        child: Text('${rate}x', style: StyleString.titleStyle.copyWith(color: color,)),
        onPressed: () async {
          SmartDialog.show(
            tag: TagsString.rateSheetDialog,
            alignment: Alignment.centerRight,
            maskColor: CupertinoColors.transparent,
            builder: (context) => _rateSheet(rate)
          );
        }
    );
  }
}

Widget _rateSheet(double rate){
  return Consumer(builder: (context, ref, child){
    return Container(
      width: 200,
      color: CupertinoColors.black.withOpacity(0.85),
      child: SingleChildScrollView(
        child: Column(
          children: [
            for(int i = 0; i < TagsString.rateList.length; i++)
              CupertinoButton(
                  child: Text(
                      '${TagsString.rateList[i]}x',
                      style: StyleString.titleStyle.copyWith(color: rate == TagsString.rateList[i] ? CupertinoColors.systemRed : CupertinoColors.white,)
                  ),
                  onPressed: () async {
                    ref.read(controlsServiceProvider.notifier).setRate(TagsString.rateList[i]);
                    SmartDialog.dismiss(tag: TagsString.rateSheetDialog);
                  }
              )
          ],
        ),
      ),
    );
  });
}

