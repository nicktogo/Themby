

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themby/src/features/home/presentation/home_search_query_notifier.dart';
import 'package:themby/src/localization/string_hardcoded.dart';


class HomeSearch extends ConsumerStatefulWidget {
  const HomeSearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeSearchState();
}

class _HomeSearchState extends ConsumerState<HomeSearch> {

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CupertinoSearchTextField(
        controller: _controller,
        placeholder: '搜索站点'.hardcoded,
        onSubmitted: (text) {
          FocusScope.of(context).unfocus();
        },
        onChanged: (text) => ref
            .read(homeSearchQueryNotifierProvider.notifier)
            .setQuery(text),
      ),
    );
  }
}