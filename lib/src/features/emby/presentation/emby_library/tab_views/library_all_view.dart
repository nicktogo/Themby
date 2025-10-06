
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themby/src/features/emby/data/view_repository.dart';
import 'package:themby/src/features/emby/presentation/emby_library/emby_library_query_notifier.dart';
import 'package:themby/src/features/emby/presentation/emby_library/widgets/library_filter_tool.dart';
import 'package:themby/src/features/emby/presentation/emby_library/widgets/library_grid_items.dart';

class LibraryAllView extends ConsumerWidget{
  const LibraryAllView({super.key, required this.parentId, required this.filter});

  final String parentId;
  final String filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final itemQuery = ref.watch(embyLibraryQueryNotifierProvider);

    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            ref.invalidate(getItemProvider);
            await ref.read(getItemProvider(
            itemQuery: (
              page: 0,
              parentId: parentId,
              genreIds: '',
              includeItemTypes: itemQuery.includeItemTypes,
              sortBy: itemQuery.sortBy,
              sortOrder: itemQuery.sortOrder,
              filters: filter,
            )).future);
          },
        ),
        LibraryFilterTool(parentId: parentId, filter: filter),
        LibraryGridItems(parentId: parentId, filter: filter),
      ],
    );
  }
}