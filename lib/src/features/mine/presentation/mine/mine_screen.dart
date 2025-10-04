
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:themby/src/features/mine/widgets/setting_item.dart';
import 'package:themby/src/localization/string_hardcoded.dart';

class MineScreen extends StatelessWidget {
  const MineScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("设置".hardcoded),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              SettingItem(
                leading: const Icon(CupertinoIcons.paintbrush, size: 24),
                title: Text("外观".hardcoded),
                subtitle: Text("语言, 暗色模式，主题色".hardcoded),
                onTap: () {
                  GoRouter.of(context).push('/app_setting');
                },
              ),
              SettingItem(
                leading: const Icon(CupertinoIcons.play_circle, size: 24),
                title: Text("播放器".hardcoded),
                subtitle: Text("播放器外观、手势、控件".hardcoded),
                onTap: () {
                  GoRouter.of(context).push('/play_setting');
                },
              ),
              SettingItem(
                leading: const Icon(CupertinoIcons.textformat, size: 24),
                title: Text("字幕外观".hardcoded),
                subtitle: Text("播放选项".hardcoded),
                onTap: () {
                  GoRouter.of(context).push('/subtitle_setting');
                },
              ),
              SettingItem(
                leading: const Icon(CupertinoIcons.folder, size: 24),
                title: Text("缓存".hardcoded),
                subtitle: Text("图片缓存".hardcoded),
                onTap: () {
                  GoRouter.of(context).push('/cache_setting');
                },
              ),
              SettingItem(
                leading: const Icon(CupertinoIcons.cloud, size: 24),
                title: Text("同步".hardcoded),
                subtitle: Text("webdav 同步站点".hardcoded),
                onTap: () {
                  GoRouter.of(context).push('/sync_setting');
                },
              ),
              SettingItem(
                leading: const Icon(CupertinoIcons.info_circle, size: 24),
                title: Text("关于".hardcoded),
                subtitle: Text("关于，鸣谢".hardcoded),
                onTap: () {
                  GoRouter.of(context).push('/about');
                },
              ),
            ],
          ),
        )
    );
  }

}
