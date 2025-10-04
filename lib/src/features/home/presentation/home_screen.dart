
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:themby/src/common/constants.dart';
import 'package:themby/src/features/emby/application/emby_state_service.dart';
import 'package:themby/src/features/home/data/site_repository.dart';
import 'package:themby/src/features/home/presentation/home_server_edit.dart';
import 'package:themby/src/features/home/presentation/home_server_notifier.dart';
import 'package:themby/src/features/home/widgets/sync_button.dart';
import 'package:themby/src/localization/string_hardcoded.dart';

import 'home_ search.dart';
import 'home_search_query_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final String query = ref.watch(homeSearchQueryNotifierProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('连接'.hardcoded),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SyncButton(),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.settings),
              onPressed: () {
                GoRouter.of(context).push('/mine');
              },
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const HomeSearch(),
            const SizedBox(height: 10),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      ref.refresh(finaAllByTextProvider(text: query));
                    },
                  ),
                  const ServerList(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton.filled(
                onPressed: () {
                  ref.read(homeServerNotifierProvider.notifier).openAddDialog();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.add, color: CupertinoColors.white),
                    SizedBox(width: 8),
                    Text('Add Server', style: TextStyle(color: CupertinoColors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServerList extends ConsumerWidget {
  const ServerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final String query = ref.watch(homeSearchQueryNotifierProvider);

    final sites = ref.watch(finaAllByTextProvider(text: query));

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: StyleString.safeSpace),
      sliver: sites.when(
        error: (error, stack) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('Error')),
          );
        },
        loading: () {
          return const SliverToBoxAdapter(
            child: Center(child: CupertinoActivityIndicator()),
          );
        },
        data: (data) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CupertinoListTile(
                    padding: const EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                    leading: SvgPicture.asset('assets/emby.svg', width: 36, height: 36),
                    title: Text(
                      (data[index].remake?.isNotEmpty == true ? data[index].remake : data[index].serverName)!,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(data[index].username!, style: const TextStyle(fontWeight: FontWeight.w300)),
                    trailing: _menuButton(
                      context,
                      () {
                        SmartDialog.show(
                          alignment: Alignment.centerRight,
                          builder: (_) {
                            return HomeServerEdit(site: data[index]);
                          },
                        );
                      },
                      () {
                        ref.read(homeServerNotifierProvider.notifier).removeSite(data[index]);
                      },
                    ),
                    onTap: () async {
                      ref.read(embyStateServiceProvider.notifier).updateSite(data[index]);
                      ref.read(embyStateServiceProvider.notifier).addUserIdToToken(data[index].userId!);
                      GoRouter.of(context).go('/emby');
                    },
                  ),
                );
              },
              childCount: data.length,
            ),
          );
        },
      ),
    );
  }

  Widget _menuButton(BuildContext context, VoidCallback onTapItem1, VoidCallback onTapItem2) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(CupertinoIcons.ellipsis),
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  onTapItem1.call();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.pencil),
                    SizedBox(width: 8),
                    Text('编辑'),
                  ],
                ),
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  onTapItem2.call();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.delete),
                    SizedBox(width: 8),
                    Text('删除'),
                  ],
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
          ),
        );
      },
    );
  }
}