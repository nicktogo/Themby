

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themby/src/common/constants.dart';
import 'package:themby/src/features/emby/data/view_repository.dart';
import 'package:themby/src/features/emby/presentation/emby_library/widgets/library_filter_tool.dart';
import 'package:themby/src/features/emby/presentation/emby_library/widgets/library_grid_items.dart';
import 'package:themby/src/features/emby/presentation/emby_library/widgets/sort_button.dart';

import 'emby_library_query_notifier.dart';

class EmbyLibraryItemsScreen extends ConsumerWidget{
  const EmbyLibraryItemsScreen({super.key,required this.title, required this.parentId, required this.filter,this.genreIds,});

  final String title;
  final String parentId;
  final String? genreIds;
  final String filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final itemQuery = ref.watch(embyLibraryQueryNotifierProvider);

    final response = ref.watch(getItemProvider(
      itemQuery: (
        page: 0,
        parentId: parentId,
        genreIds: genreIds ?? '',
        includeItemTypes: itemQuery.includeItemTypes,
        sortBy: itemQuery.sortBy,
        sortOrder: itemQuery.sortOrder,
        filters: filter,
      ),
    ));

    final totalRecordCount = response.valueOrNull?.totalRecordCount;

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              ref.invalidate(getItemProvider);
              await ref.read(getItemProvider(
                  itemQuery: (
                  page: 0,
                  parentId: parentId,
                  genreIds: genreIds ?? '',
                  includeItemTypes: itemQuery.includeItemTypes,
                  sortBy: itemQuery.sortBy,
                  sortOrder: itemQuery.sortOrder,
                  filters: filter,
                  )).future);
            },
          ),
          CupertinoSliverNavigationBar(
            largeTitle: Text(title),
            trailing: const SortButton(),
            border: null,
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 6, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: StyleString.safeSpace),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${totalRecordCount ?? 0} 项",
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          LibraryGridItems(parentId: parentId, filter: filter, genreIds: genreIds),
        ],
      ),
    );
  }

}