import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themby/src/extensions/constrains.dart';
import 'package:themby/src/features/emby/presentation/emby_library/tab_views/library_all_view.dart';
import 'package:themby/src/features/emby/presentation/emby_library/tab_views/library_collection_view.dart';
import 'package:themby/src/features/emby/presentation/emby_library/tab_views/library_favorite_view.dart';
import 'package:themby/src/features/emby/presentation/emby_library/tab_views/library_folder_view.dart';
import 'package:themby/src/features/emby/presentation/emby_library/tab_views/library_genre_view.dart';
import 'package:themby/src/features/emby/presentation/emby_library/tab_views/library_recent_view.dart';
import 'package:themby/src/features/emby/presentation/emby_library/tab_views/library_tag_view.dart';

import 'item_bars.dart';


class EmbyLibraryScreen extends ConsumerStatefulWidget{
  const EmbyLibraryScreen({super.key, required this.parentId,required this.filter, required this.title});
  final String title;
  final String parentId;
  final String filter;

  @override
  ConsumerState<EmbyLibraryScreen> createState() => _EmbyLibraryScreen();
}

class _EmbyLibraryScreen extends ConsumerState<EmbyLibraryScreen>  with AutomaticKeepAliveClientMixin {

  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bool isLandscape = MediaQuery.of(context).mdAndUp;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 0.0,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: isLandscape ? 12 : 5),
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: _currentTabIndex,
                  children: Map.fromIterable(
                    List.generate(tabs.length, (index) => index),
                    key: (index) => index,
                    value: (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        tabs[index].name,
                        style: TextStyle(
                          color: _currentTabIndex == index
                              ? CupertinoColors.white
                              : CupertinoColors.label.resolveFrom(context),
                        ),
                      ),
                    ),
                  ),
                  onValueChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        _currentTabIndex = value;
                      });
                    }
                  },
                ),
              ),
            ),
            // Tab View
            Expanded(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  LibraryAllView(parentId: widget.parentId, filter: widget.filter),
                  LibraryRecentView(parentId: widget.parentId, filter: widget.filter),
                  LibraryCollectionView(parentId: widget.parentId, filter: widget.filter),
                  LibraryGenreView(parentId: widget.parentId, filter: widget.filter),
                  LibraryTagView(parentId: widget.parentId, filter: widget.filter),
                  LibraryAllView(parentId: widget.parentId, filter: "IsFavorite"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
