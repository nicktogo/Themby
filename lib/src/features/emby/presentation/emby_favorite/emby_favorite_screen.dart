
import 'package:flutter/cupertino.dart';

import 'emby_favorite_item.dart';

class EmbyFavoriteScreen extends StatelessWidget {
  const EmbyFavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('我的收藏'),
      ),
      child: SafeArea(
        child: ListView(
          children: const [
            EmbyFavoriteItem(type: 'movie'),
            EmbyFavoriteItem(type: 'series'),
          ],
        ),
      ),
    );
  }
}
