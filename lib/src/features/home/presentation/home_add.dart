

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:themby/src/common/constants.dart';
import 'package:themby/src/common/domiani/site.dart';
import 'package:themby/src/features/home/data/site_repository.dart';
import 'package:themby/src/features/home/presentation/home_server_notifier.dart';

class HomeAddSite extends ConsumerStatefulWidget{
  const HomeAddSite({super.key});

  @override
  ConsumerState<HomeAddSite> createState() => _HomeAddState();
}


class _HomeAddState extends ConsumerState<HomeAddSite> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? hostError;
  String? usernameError;

  bool _validate() {
    setState(() {
      hostError = null;
      usernameError = null;
    });

    final state = ref.read(homeServerNotifierProvider);
    bool isValid = true;

    if (state.hostController.text.isEmpty) {
      setState(() {
        hostError = 'Please enter a host';
      });
      isValid = false;
    }

    if (state.usernameController.text.isEmpty) {
      setState(() {
        usernameError = 'Please enter your username';
      });
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(homeServerNotifierProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () {
            SmartDialog.dismiss();
          },
        ),
        middle: const Text('添加连接'),
      ),
      child: SafeArea(
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          margin: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    child: SvgPicture.asset(
                      'assets/emby.svg',
                      width: 60,
                    )
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    _buildTextField(
                      controller: state.hostController,
                      placeholder: '例如: http(s)://example.com',
                      prefix: const Icon(CupertinoIcons.globe),
                      keyboardType: TextInputType.url,
                      error: hostError,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: state.usernameController,
                      placeholder: 'Enter your username',
                      prefix: const Icon(CupertinoIcons.person_circle),
                      error: usernameError,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: state.passwordController,
                      placeholder: 'Enter your password',
                      prefix: const Icon(CupertinoIcons.lock),
                      obscureText: !state.isPasswordVisible,
                      suffix: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          state.isPasswordVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                        ),
                        onPressed: () {
                          setState(() {
                            state.isPasswordVisible = !state.isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    child: const Text('连接'),
                    onPressed: () async{
                      if (_validate()) {
                        SmartDialog.showLoading();

                        Uri uri = Uri.parse(state.hostController.text);

                        await ref.read(addEmbySiteProvider(site: Site(
                          scheme: uri.scheme,
                          host: uri.host,
                          port: uri.port,
                          username: state.usernameController.text,
                          password: state.passwordController.text,
                        )).future);

                        await SmartDialog.showToast('添加成功');

                        SmartDialog.dismiss().then((v) async {
                          ref.refresh(finaAllByTextProvider(text: ''));
                          SmartDialog.dismiss();
                        });

                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    Widget? prefix,
    Widget? suffix,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          prefix: prefix != null ? Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: prefix,
          ) : null,
          suffix: suffix != null ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: suffix,
          ) : null,
          obscureText: obscureText,
          keyboardType: keyboardType,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: error != null
                ? CupertinoColors.systemRed
                : CupertinoColors.systemGrey4,
            ),
            borderRadius: StyleString.lgRadius,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              error,
              style: const TextStyle(
                color: CupertinoColors.systemRed,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}