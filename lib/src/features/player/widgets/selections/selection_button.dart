

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:themby/src/common/constants.dart';
import 'package:themby/src/features/emby/domain/emby/item.dart';
import 'package:themby/src/features/player/constants.dart';
import 'package:themby/src/features/player/widgets/selections/item_sheet.dart';

class SelectionButton extends ConsumerWidget{
  const SelectionButton({super.key, this.size = 30, this.color = CupertinoColors.white});

  final double size;
  final Color color;


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 44,
      onPressed: () async {
        ///打开选集的弹窗
        SmartDialog.show(
            tag: TagsString.episodeSheetDialog,
            alignment: Alignment.centerRight,
            maskColor: CupertinoColors.transparent,
            builder: (context) => const ItemSheet()
        );
      },
      child: Text(
        '选集',
        style: StyleString.titleStyle.copyWith(color: CupertinoColors.white),
      ),
    );
  }
}

