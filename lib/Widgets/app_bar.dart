import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytodo/Controllers/theme_controller.dart';

import '../colors.dart';
import 'text.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool leadingExists;
  final bool actionExists;
  final VoidCallback? leadingFunction;
  final VoidCallback? actionFunction;
  final String? actionIcon;

  const MyAppBar({
    super.key,
    required this.title,
    required this.leadingExists,
    this.actionExists = false,
    this.leadingFunction,
    this.actionFunction,
    this.actionIcon,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (controller) => AppBar(
        backgroundColor: MyColors().background,
        shadowColor: MyColors().secondary,
        surfaceTintColor: MyColors().background,
        elevation: 1,
        titleSpacing: leadingExists ? 0 : 16,
        title: MyText(
          text: title,
          size: 22,
          weight: FontWeight.bold,
          color: MyColors().text,
        ),
        leading: leadingExists
            ? IconButton(
                onPressed: leadingFunction ?? () => Get.back(),
                icon: Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: MyColors().main,
                ),
              )
            : null,
        actions: actionExists
            ? [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: actionFunction!,
                    child: Image.asset(actionIcon!),
                  ),
                ),
              ]
            : null,
      ),
    );
  }
}
