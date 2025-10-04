

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:themby/src/common/constants.dart';
import 'package:themby/src/common/domiani/Select.dart';
import 'package:themby/src/features/emby/application/emby_common_service.dart';
import 'package:themby/src/features/emby/data/play_repository.dart';
import 'package:themby/src/features/emby/data/view_repository.dart';
import 'package:themby/src/features/emby/domain/playback_info.dart';
import 'package:themby/src/features/player/constants.dart';
import 'package:themby/src/features/player/service/controls_service.dart';

class ToggleAudioButtoon extends ConsumerWidget{
  const ToggleAudioButtoon({super.key, this.size = 28, this.color = CupertinoColors.white});

  final double size;
  final Color color;


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 44,
        child: Icon(
          CupertinoIcons.music_note_2,
          size: size,
          color: color,
        ),
        onPressed: () async {
          ///选择音轨的弹窗
          SmartDialog.show(
            tag: TagsString.audioSheetDialog,
            alignment: Alignment.centerRight,
            builder: (_) => _audioSheet(),
          );
        }
    );
  }
}

Widget _audioSheet(){
  return Consumer(builder: (context, ref, child){

    final state = ref.read(controlsServiceProvider);

    final resp = ref.watch(GetMediaProvider(state.currentMediaId!));

    return Container(
      width: 250,
      color: CupertinoColors.black.withOpacity(0.85),
      child: resp.when(
        data: (data)  {
          List<Select> audioStreams = getMediaStreams(data.mediaSources![0].mediaStreams!,'Audio');
          return audioStreams.isNotEmpty ?
          ListView.builder(
            itemCount: audioStreams.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CupertinoListTile(
                  title: Text(
                    audioStreams[index].title,
                    style: StyleString.subtitleStyle.copyWith(color: CupertinoColors.white),
                  ),
                  onTap: () async {
                    ref.read(controlsServiceProvider.notifier).toggleAudio(int.parse(audioStreams[index].value));
                    SmartDialog.dismiss(tag: TagsString.audioSheetDialog);
                  },
                ),
              );
            },
          )
          : const Center(child: Text('没有可选的', style: TextStyle(color: CupertinoColors.white)));
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error,_) => const Center(child: Text('空', style: TextStyle(color: CupertinoColors.white))),
      ),
    );
  });
}