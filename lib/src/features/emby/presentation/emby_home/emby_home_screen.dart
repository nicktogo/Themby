import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:themby/src/common/domiani/site.dart';
import 'package:themby/src/features/emby/application/emby_state_service.dart';
import 'package:themby/src/features/emby/data/image_repository.dart';
import 'package:themby/src/features/emby/data/view_repository.dart';
import 'package:themby/src/features/emby/presentation/emby_view/emby_media_library.dart';
import 'package:themby/src/features/emby/presentation/emby_view/emby_recommendations_media.dart';
import 'package:themby/src/features/emby/presentation/emby_view/emby_resume_media.dart';
import 'package:themby/src/features/emby/presentation/emby_view/emby_view.dart';

class EmbyHomeScreen extends ConsumerWidget {
  const EmbyHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final site = ref.watch(embyStateServiceProvider.select((value) => value.site));

    return CupertinoPageScaffold(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await ref.refresh(getResumeMediaProvider().future);
                  await ref.refresh(getViewsProvider.future).then((data) {
                    data.items.map((item) async {
                      ref.refresh(getLastMediaProvider(item.id!));
                    });
                  });
                },
              ),
              const SliverToBoxAdapter(
                child: EmbyRecommendationsMedia(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 18),
              ),
              const SliverToBoxAdapter(
                child: EmbyResumeMedia(),
              ),
              const SliverToBoxAdapter(
                child: EmbyView(),
              ),
              const SliverToBoxAdapter(
                child: EmbyMediaLibrary(),
              ),
            ],
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: _buildNavigationBar(site!, context),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildNavigationBar(Site site, BuildContext context) {
  return Container(
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: SvgPicture.asset('assets/emby.svg', width: 30, height: 30),
            onPressed: () {
              GoRouter.of(context).go('/home');
            },
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.search,
                size: 30,
                color: CupertinoColors.white,
              ),
              onPressed: () {
                GoRouter.of(context).push('/emby/search');
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: site.imageTag != null
              ? CachedNetworkImage(
                  imageUrl: getAvatarUrl(site),
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                  imageBuilder: (context, imageProvider) => Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupertinoTheme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        (site.username ?? 'T')[0].toUpperCase(),
                        style: const TextStyle(color: CupertinoColors.white),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CupertinoTheme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      (site.username ?? 'A')[0].toUpperCase(),
                      style: const TextStyle(color: CupertinoColors.white),
                    ),
                  ),
                ),
              onPressed: () {
                SmartDialog.showToast('别点我，我是头像');
              },
            ),
          ],
        ),
      ],
    ),
  );
}