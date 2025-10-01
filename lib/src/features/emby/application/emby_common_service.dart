import 'dart:math';

import 'package:intl/intl.dart';
import 'package:themby/src/common/constants.dart';
import 'package:themby/src/common/domiani/Select.dart';
import 'package:themby/src/common/domiani/play_info.dart';
import 'package:themby/src/features/emby/domain/emby/item.dart';
import 'package:themby/src/features/emby/domain/emby/media_source.dart';
import 'package:themby/src/features/emby/domain/emby/media_stream.dart';
import 'package:themby/src/features/emby/domain/media.dart';


/// 获取视频播放信息
PlayInfo getPlayInfo(Item item) {

  final int duration = item.userData?.playbackPositionTicks ?? 0;

  return PlayInfo(
    id: item.id!,
    type: item.type!,
    index: item.indexNumber ?? 0,
    duration: Duration(milliseconds: duration ~/ 10000),
  );
}

/// 获取视频播放信息
PlayInfo getPlayInfoByMedia(Media media) {
  final int duration = media.userData.playbackPositionTicks ?? 0;

  return PlayInfo(
    id: media.id,
    type: media.type,
    index: media.indexNumber,
    duration:  Duration(milliseconds: duration ~/ 10000),
  );
}


/// Duration 转换成 HH:mm:ss 格式
String durationToTime(Duration duration) {
  final int hours = duration.inHours;
  final int minutes = duration.inMinutes.remainder(60);
  final int seconds = duration.inSeconds.remainder(60);

  return '${hours > 0 ? '${hours.toString().padLeft(2, '0')}:' : ''}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}


/// tick 转换成 HH h mm m 格式
String tickToTime(int ticks) {
  final int duration = ticks ~/ 10000000;
  final int hours = duration ~/ 3600;
  final int minutes = (duration % 3600) ~/ 60;

  return '${hours > 0 ? '$hours' 'h ' : ''}$minutes''m';
}

/// tick 转换成 HH h mm m s 格式
String tickToTimeWithSeconds(int ticks) {
  final int duration = ticks ~/ 10000000;
  final int hours = duration ~/ 3600;
  final int minutes = (duration % 3600) ~/ 60;
  final int seconds = duration % 60;

  return '${hours > 0 ? '$hours' 'h ' : ''}$minutes''m $seconds''s';
}

/// 返回 year - year  or year
String yearArea(Item item){
  String start = (item.productionYear ?? '').toString();
  String? end = item.endDate?.year.toString();
  return end != null ? '$start - $end' : start;
}

/// 格式化文件大小
String formatFileSize(int size) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  if (size <= 0) return '0 B';

  int digitGroups = (log(size) / log(1024)).floor();
  return '${(size / pow(1024, digitGroups)).toStringAsFixed(2)} ${units[digitGroups]}';
}

/// 格式化日期时间
String convertDateTime(DateTime? dateTime) {
  if(dateTime == null){
    return '';
  }
  final DateFormat formatter = DateFormat('yyyy/M/d HH:mm');
  return formatter.format(dateTime);
}

List<Select> getMediaSource(List<MediaSource> sources){
  return sources
      .asMap()
      .entries
      .map((e) {
        // 寻找视频流获取分辨率和编码信息
        String displayTitle = e.value.name ?? '';

        final videoStream = e.value.mediaStreams?.firstWhere(
          (stream) => stream.type == 'Video',
          orElse: () => MediaStream(),
        );

        if (videoStream?.displayTitle != null && videoStream!.displayTitle!.isNotEmpty) {
          displayTitle = videoStream.displayTitle!;
        }

        return Select(title: displayTitle, value: e.key.toString());
      })
      .toList();
}

List<Select> getMediaStreams(List<MediaStream> mediaStreams, String type){
  return mediaStreams
      .where((element) => element.type == type)
      .toList()
      .asMap()
      .entries
      .map((e) => Select(title: e.value.displayTitle!, subtitle: e.value.title, value: e.key.toString()))
      .toList();
}

String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}...';
  }
}

String formatImageUrl({required String url, int? width, int? height}) {
  // Validate URL before formatting
  if (url.isEmpty || Uri.tryParse(url)?.hasScheme != true) {
    return url; // Return original URL if invalid
  }

  if (width != null) {
    int finalWidth = width;
    for (int size in StyleString.imageSizes) {
      if (finalWidth <= size) {
        finalWidth = size;
        break;
      }
    }

    // Check if URL already has query parameters
    final separator = url.contains('?') ? '&' : '?';
    url = '$url${separator}maxWidth=$finalWidth';
  }
  return url;
}
