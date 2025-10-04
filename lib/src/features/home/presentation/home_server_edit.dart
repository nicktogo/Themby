

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:themby/src/common/constants.dart';
import 'package:themby/src/common/domiani/site.dart';
import 'package:themby/src/features/home/data/site_repository.dart';

class HomeServerEdit extends ConsumerStatefulWidget{
  const HomeServerEdit({super.key,required this.site});

  final Site site;

  @override
  ConsumerState<HomeServerEdit> createState() => _HomeAddState();
}


class _HomeAddState extends ConsumerState<HomeServerEdit> {

  late final TextEditingController remakeController;
  late final TextEditingController schemeController;
  late final TextEditingController hostController;
  late final TextEditingController portController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  String? schemeError;
  String? hostError;
  String? portError;
  String? usernameError;

  @override
  void initState(){
    super.initState();
    remakeController = TextEditingController(text: widget.site.remake);
    schemeController = TextEditingController(text: widget.site.scheme);
    hostController = TextEditingController(text: widget.site.host);
    portController = TextEditingController(text: widget.site.port.toString());
    usernameController = TextEditingController(text: widget.site.username);
    passwordController = TextEditingController(text: widget.site.password);
  }

  @override
  void dispose(){
    remakeController.dispose();
    schemeController.dispose();
    hostController.dispose();
    portController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      schemeError = null;
      hostError = null;
      portError = null;
      usernameError = null;
    });

    bool isValid = true;

    if (schemeController.text.isEmpty) {
      setState(() {
        schemeError = 'Please enter scheme';
      });
      isValid = false;
    }

    if (hostController.text.isEmpty) {
      setState(() {
        hostError = 'Please enter host';
      });
      isValid = false;
    }

    if (portController.text.isEmpty) {
      setState(() {
        portError = 'Please enter your port';
      });
      isValid = false;
    }

    if (usernameController.text.isEmpty) {
      setState(() {
        usernameError = 'Please enter your username';
      });
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () {
            SmartDialog.dismiss();
          },
        ),
        middle: const Text('编辑'),
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                      controller: remakeController,
                      placeholder: '站点备注',
                      prefix: const Icon(CupertinoIcons.info_circle),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: schemeController,
                      placeholder: 'http / https',
                      prefix: const Icon(CupertinoIcons.globe),
                      error: schemeError,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: hostController,
                      placeholder: '站点地址',
                      prefix: const Icon(CupertinoIcons.globe),
                      error: hostError,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: portController,
                      placeholder: 'Enter your 端口',
                      prefix: const Icon(CupertinoIcons.wifi),
                      keyboardType: TextInputType.number,
                      error: portError,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: usernameController,
                      placeholder: 'Enter your username',
                      prefix: const Icon(CupertinoIcons.person),
                      error: usernameError,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: passwordController,
                      placeholder: 'Enter your 密码',
                      prefix: const Icon(CupertinoIcons.lock),
                      obscureText: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    child: const Text('修改'),
                    onPressed: () async{
                      if (_validate()) {
                        SmartDialog.showLoading();
                        Site newSite = widget.site.copyWith(
                          remake: remakeController.text,
                          scheme: schemeController.text,
                          host: hostController.text,
                          port: int.parse(portController.text),
                          username: usernameController.text,
                          password: passwordController.text,
                        );

                        ref.read(updateEmbySiteProvider(site: newSite).future).then((v) {
                          SmartDialog.showToast('修改成功');
                          ref.refresh(finaAllByTextProvider(text: ''));
                          SmartDialog.dismiss();
                        });
                        SmartDialog.dismiss();
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