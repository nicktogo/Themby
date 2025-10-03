

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:themby/src/features/emby/application/emby_common_service.dart';
import 'package:themby/src/features/emby/domain/emby/item.dart';
import 'package:themby/src/router/app_router.dart';

class EmbyDetailContent extends StatelessWidget{
  const EmbyDetailContent({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(item.type == "Episode") ...[
          Padding(
            padding: const EdgeInsets.only(left: 12,bottom: 10),
            child: Text(
                'S${item.parentIndexNumber}E${item.indexNumber} - ${item.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)
            ),
          ),
          if(item.seriesName != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 10),
              child: Row(
                children: [
                  // 跳转到剧集系列
                  if(item.seriesId != null)
                    InkWell(
                      onTap: () {
                        context.pushNamed(
                          AppRoute.details.name,
                          pathParameters: {'id': item.seriesId!},
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.live_tv,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '剧集: ${item.seriesName!}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 分隔符
                  if(item.seriesId != null && item.seasonId != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '/',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),

                  // 跳转到季
                  if(item.seasonId != null)
                    InkWell(
                      onTap: () {
                        context.pushNamed(
                          AppRoute.season.name,
                          pathParameters: {'id': item.seasonId!},
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.video_library,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '第${item.parentIndexNumber}季',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],

        _labelContent(item),

        const SizedBox(height: 10),

        _overviewContent(item.overview ?? '')

      ],
    );
  }
}

Widget _labelContent(Item item){
  return Wrap(
    alignment: WrapAlignment.start,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 12,
    runSpacing: 5,
    children: [
      const SizedBox(width: 0),
      /// 评分
      if(item.communityRating != null)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.yellow, size: 20),
            Text(
              item.communityRating!.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

      /// 评级
      if(item.officialRating != null)
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // 设置边框颜色
              width: 1.0, // 设置边框宽度
            ),
            borderRadius: BorderRadius.circular(6.0), // 设置边框圆角
          ),
          padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 0), // 设置内边距
          child: Text(
            item.officialRating ?? '',
            style: const TextStyle(
              fontSize: 13,
            ),// 使用空字符串作为默认值
          ),
        ),

      /// 时间区域
      Text(
          yearArea(item),
          style: const TextStyle(
            fontSize: 14,
          ),
        ),

      /// 时长
      if(item.mediaType == 'Video') ...{
        Text(
          tickToTime(item.runTimeTicks ?? 0),
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal
          ),
        ),
      },
    ],
  );
}


Widget _overviewContent(String overview){
  return Padding(
    padding: const EdgeInsets.only(left: 12, right: 10),
    child: ExpandableText(
      overview,
      maxLines: 3,
      expandText: '更多',
      collapseText: '收起',
    ),
  );
}