import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themby/src/common/constants.dart';
import 'package:themby/src/common/widget/network_img_layer.dart';
import 'package:themby/src/features/emby/data/view_repository.dart';
import 'package:themby/src/features/emby/domain/emby/item.dart';
import 'package:themby/src/features/emby/presentation/widgets/episode_card.dart';
import 'package:themby/src/helper/screen_helper.dart';


class EmbySeasonDetails extends ConsumerStatefulWidget {
  const EmbySeasonDetails(this.id, {super.key});
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmbySeasonDetails();
}

class _EmbySeasonDetails extends ConsumerState<EmbySeasonDetails> {

  final ScrollController _scrollController = ScrollController();

  late StreamController<bool> titleStreamC;

  @override
  void initState() {
    super.initState();
    titleStreamC = StreamController<bool>.broadcast();

    _scrollController.addListener(() {
      if (_scrollController.offset > 150) {
        titleStreamC.add(true);
      } else if (_scrollController.offset <= 150) {
        titleStreamC.add(false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    titleStreamC.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final episodes = ref.watch(getEpisodesProvider(widget.id,widget.id));

    final item = ref.watch(GetMediaProvider(widget.id));

    double cardWidth = ScreenHelper.getPortionAuto(xs: 5, sm: 4, md: 3);
    double cardHeight = cardWidth * 9 / 16;

    return CupertinoPageScaffold(
      child: episodes.when(
        data: (data) => CupertinoScrollbar(
          controller: _scrollController,
          radius: const Radius.circular(12),
          thumbVisibility: true,
          thickness: 7,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              item.when(
                data: (value) => SeasonAppBar(
                  item: value,
                  titleStreamC: titleStreamC,
                ),
                loading: () => const SliverToBoxAdapter(child: SizedBox()),
                error: (error, stackTrace) => const SliverToBoxAdapter(child: SizedBox()),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return EpisodeCard(
                    item: data[index],
                    width: cardWidth,
                    height: cardHeight,
                  );
                },
                  childCount: data.length,
                ),
              ),
            ],
          ),
        ),
        loading: () => _buildLoading(),
        error: (error, stackTrace) => const SizedBox(),
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CupertinoActivityIndicator());

}


class SeasonAppBar extends StatelessWidget {
  final Item item;
  final StreamController<bool> titleStreamC;
  const SeasonAppBar({super.key, required this.item,required this.titleStreamC});


  @override
  Widget build(BuildContext context) {
    final double heightBar = MediaQuery.sizeOf(context).width * 0.65;

    final String imageUrl = (item.imagesCustom?.backdrop.isNotEmpty ?? false)
        ? item.imagesCustom?.backdrop ?? ''
        : item.imagesCustom?.primary ?? '';

    return CupertinoSliverNavigationBar(
      stretch: true,
      largeTitle: StreamBuilder(
        stream: titleStreamC.stream,
        initialData: false,
        builder: (context, snapshot) {
          return snapshot.data == true ? Text('${item.seriesName} ${item.name}', style: StyleString.titleStyle) : const SizedBox();
        },
      ),
      backgroundColor: CupertinoColors.systemBackground.resolveFrom(context).withOpacity(0.9),
      border: null,
      leading: CupertinoNavigationBarBackButton(
        color: CupertinoColors.systemGrey,
      ),
    );
  }
}
