import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytodo/Controllers/theme_controller.dart';
import 'package:mytodo/View/App/view_tasks.dart';
import 'package:mytodo/Widgets/app_bar.dart';
import 'package:mytodo/Widgets/settings_card.dart';
import 'package:mytodo/Widgets/text.dart';
import '../../Controllers/app_controller.dart';
import '../../colors.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(),
      builder: (controller) {
        return GetBuilder<ThemeController>(
          init: ThemeController(),
          builder: (themeController) => SafeArea(
            child: Scaffold(
              backgroundColor: MyColors().background,
              appBar: const MyAppBar(
                title: 'Settings',
                leadingExists: false,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        MyCard(
                          buttonColor: themeController.isDarkMode.value
                              ? Colors.black
                              : MyColors().main,
                          label: 'Theme',
                          text: 'Light',
                          textsColor: themeController.isDarkMode.value
                              ? MyColors().text
                              : Colors.white,
                          function: () {
                            themeController.toggleTheme(false);
                          },
                          icon: themeController.isDarkMode.value
                              ? Icon(
                                  Icons.light_mode_outlined,
                                  size: 24,
                                  color: MyColors().text,
                                )
                              : const Icon(
                                  Icons.light_mode_rounded,
                                  size: 24,
                                  color: Colors.white,
                                ),
                        ),
                        const SizedBox(width: 16),
                        MyCard(
                          buttonColor: themeController.isDarkMode.value
                              ? MyColors().main
                              : Colors.white,
                          label: 'Theme',
                          text: 'Dark',
                          textsColor: MyColors().text,
                          function: () {
                            themeController.toggleTheme(true);
                          },
                          icon: themeController.isDarkMode.value
                              ? Icon(
                                  Icons.dark_mode_rounded,
                                  size: 24,
                                  color: MyColors().text,
                                )
                              : Icon(
                                  Icons.dark_mode_outlined,
                                  size: 24,
                                  color: MyColors().text,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ViewTasks(
                            tasks: controller.tasks
                                .where((task) => task.status == 'finished')
                                .toList(),
                            deleted: false,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                CupertinoIcons.checkmark_alt,
                                size: 24,
                                color: MyColors().text,
                              ),
                              const SizedBox(width: 8),
                              MyText(
                                text: 'Completed Tasks',
                                size: 18,
                                weight: FontWeight.w500,
                                color: MyColors().text,
                              ),
                            ],
                          ),
                          Icon(
                            CupertinoIcons.right_chevron,
                            size: 24,
                            color: MyColors().text,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ViewTasks(
                            tasks: controller.tasks
                                .where((task) => task.status == 'deleted')
                                .toList(),
                            deleted: true,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                CupertinoIcons.delete,
                                size: 24,
                                color: MyColors().text,
                              ),
                              const SizedBox(width: 8),
                              MyText(
                                text: 'Deleted Tasks',
                                size: 18,
                                weight: FontWeight.w500,
                                color: MyColors().text,
                              ),
                            ],
                          ),
                          Icon(
                            CupertinoIcons.right_chevron,
                            size: 24,
                            color: MyColors().text,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: controller.signOut,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                size: 24,
                                color: MyColors().text,
                              ),
                              const SizedBox(width: 8),
                              MyText(
                                text: 'Sign Out',
                                size: 18,
                                weight: FontWeight.w500,
                                color: MyColors().text,
                              ),
                            ],
                          ),
                          Icon(
                            CupertinoIcons.right_chevron,
                            size: 24,
                            color: MyColors().text,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
