
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themby/src/common/data/app_setting_repository.dart';
import 'package:themby/src/common/domiani/color_type.dart';
import 'package:themby/src/features/mine/presentation/mine_app_setting/mine_app_setting_handle.dart';
import 'package:themby/src/localization/string_hardcoded.dart';

class MineAppSettingScreen extends ConsumerWidget {
  const MineAppSettingScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final appSetting = ref.watch(appSettingRepositoryProvider);
    final color = colorType[appSetting.customColor];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('外观'.hardcoded),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListTile(
              leading: const Icon(CupertinoIcons.globe),
              title: Text('语言'.hardcoded),
              subtitle: Text('跟随系统'.hardcoded),
              trailing: const Icon(CupertinoIcons.chevron_right),
              onTap: () {

              },
            ),
            CupertinoListTile(
              leading: const Icon(CupertinoIcons.circle_lefthalf_fill),
              title: Text('主题'.hardcoded),
              subtitle: Text(
                  appSetting.themeMode == 0
                      ? '浅色模式'.hardcoded
                      : appSetting.themeMode == 1
                      ? '深色模式'.hardcoded
                      : '跟随系统'.hardcoded
              ),
              trailing: const Icon(CupertinoIcons.chevron_right),
              onTap: () async {
                  ref.read(OpenThemeModeDialogProvider(currentMode: appSetting.themeMode));
              },
            ),
            CupertinoListTile(
              leading: const Icon(CupertinoIcons.color_filter),
              title: Text('主题颜色'.hardcoded),
              trailing: Icon(CupertinoIcons.circle_fill, color: color),
              onTap: () {
                ref.read(OpenThemeColorDialogProvider(currentColor: appSetting.customColor));
              },
            ),
          ],
        ),
      )
    );
  }
}