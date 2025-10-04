import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themby/src/common/data/cache_setting.dart';
import 'package:themby/src/features/mine/widgets/setting_item.dart';

class CacheSettingScreen extends ConsumerWidget {
  const CacheSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizeFuture = ref.watch(cacheSettingProvider).getCacheSize();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("缓存管理"),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            FutureBuilder<String>(
              future: sizeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SettingItem(
                    leading: const Icon(CupertinoIcons.clear),
                    title: const Text("清除图片缓存"),
                    subtitle: const Text("加载中..."),
                    onTap: (){

                    },
                  );
                } else if (snapshot.hasError) {
                  return SettingItem(
                    leading: const Icon(CupertinoIcons.clear),
                    title: const Text("清除图片缓存"),
                    subtitle: const Text("加载失败"),
                    onTap: (){
                    },
                  );
                } else {
                  return SettingItem(
                    leading: const Icon(CupertinoIcons.clear),
                    title: const Text("清除图片缓存"),
                    subtitle: Text(snapshot.data ?? "未知大小"),
                    onTap: () async{
                     await ref.read(cacheSettingProvider).clearAllCache();
                     ref.invalidate(cacheSettingProvider);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}