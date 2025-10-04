
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:themby/src/common/constants.dart';
import 'package:themby/src/helper/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('About'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            const SizedBox(height: 12),
            Image.asset(
              'assets/images/logo_splash.png',
              width: 86,
              height: 86,
            ),
            const SizedBox(height: 8),
            const SizedBox(width: double.infinity,),
            Text(
              ref.read(packageInfoProvider).appName,
              style: StyleString.headerStyle.copyWith(fontSize: 28),
            ),
            Text(
              ref.read(packageInfoProvider).version,
              style: StyleString.titleStyle,
            ),
            const SizedBox(height: 12),
            _aboutItem(
              const Icon(CupertinoIcons.arrow_2_circlepath),
              "检查应用更新",
              (){
                SmartDialog.showToast("待完善");
              }
            ),
            _aboutItem(
                const Icon(CupertinoIcons.star),
                "Github",
                 (){
                    launchUrl(
                      Uri.parse("https://github.com/chicring/Themby"),
                      mode: LaunchMode.externalApplication
                    );
                 }
            ),
            _aboutItem(
                const Icon(CupertinoIcons.chat_bubble),
                "Telegram 频道",
                 (){
                   launchUrl(
                     Uri.parse("https://t.me/themby_official"),
                     mode: LaunchMode.externalNonBrowserApplication
                   );
                 }
            ),
            _aboutItem(
                const Icon(CupertinoIcons.square_list),
                "依赖库",
                 (){
                   SmartDialog.showToast("待完善");
                 }
            ),
            _aboutItem(
                const Icon(CupertinoIcons.question_circle),
                "常见问题",
                 (){
                   SmartDialog.showToast("待完善");
                 }
            ),
            const SizedBox(height: 5),
            const Text(
              "第三方emby客户端",
              style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutItem(Icon icon, String text, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 12),
              Text(text, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              const Icon(CupertinoIcons.chevron_right, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}