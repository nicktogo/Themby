
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themby/src/common/constants.dart';

import 'emby_search_item.dart';
import 'emby_search_query_notifier.dart';
import 'emby_search_suggests.dart';

class EmbySearchScreen extends ConsumerStatefulWidget {
  const EmbySearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmbySearchScreenState();
}

class _EmbySearchScreenState extends ConsumerState<EmbySearchScreen>  {

  final _controller = TextEditingController();


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final String query = ref.watch(embySearchQueryNotifierProvider);

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context).withOpacity(0.3),
            width: 0.5,
          ),
        ),
        padding: const EdgeInsetsDirectional.all(0),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.search, size: 22),
          onPressed: () {

          },
        ),
        middle: CupertinoSearchTextField(
          autofocus: true,
          controller: _controller,
          placeholder: '搜索电影和剧集',
          suffixMode: OverlayVisibilityMode.editing,
          onSubmitted: (value) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: (value) {
            ref.read(embySearchQueryNotifierProvider.notifier)
                .setQuery(value);
          },
          onSuffixTap: () {
            ref.read(embySearchQueryNotifierProvider.notifier)
                .setQuery('');
            _controller.clear();
          },
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: query.isNotEmpty
              ? const EmbySearchItem()
              : const EmbySearchSuggests(),
        ),
      ),
    );
  }
}



Widget _searchHistory() {
  return const SizedBox();
}