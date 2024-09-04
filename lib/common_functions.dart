import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'Controllers/theme_controller.dart';
import 'Widgets/text.dart';
import 'colors.dart';

class CommonFunctions {
  final ThemeController themeController = Get.find();

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        content: Row(
          children: [
            Icon(
              Icons.check,
              color: MyColors().main,
              size: 24,
            ),
            const SizedBox(width: 8),
            MyText(
              text: text,
              size: 16,
              weight: FontWeight.normal,
              color: themeController.isDarkMode.value
                  ? Colors.black
                  : Colors.white,
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor:
            themeController.isDarkMode.value ? Colors.white : Colors.black,
      ),
    );
  }

  void showDialogue(bool isError, String errorText, String message,
      Function exitDialogue, Function confirmFunction, bool confirmation) {
    Get.dialog(
      barrierDismissible: false,
      WillPopScope(
        onWillPop: () async {
          exitDialogue();
          return true;
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                width: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MyText(
                        text: confirmation
                            ? 'Message'
                            : isError
                                ? 'Error Occurred'
                                : 'Confirmation',
                        size: 16,
                        weight: FontWeight.normal,
                        color: confirmation ? MyColors().main : MyColors().red,
                        overflow: TextOverflow.visible,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MyText(
                      text: isError ? errorText : message,
                      size: 16,
                      weight: FontWeight.normal,
                      color: Colors.black,
                      overflow: TextOverflow.visible,
                      decoration: TextDecoration.none,
                    ),
                    const SizedBox(height: 24),
                    isError
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                exitDialogue();
                              },
                              child: MyText(
                                text: 'Okay',
                                size: 14,
                                weight: FontWeight.normal,
                                color: MyColors().main,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  exitDialogue();
                                },
                                child: MyText(
                                  text: 'Cancel',
                                  size: 14,
                                  weight: FontWeight.normal,
                                  color: MyColors().main,
                                  overflow: TextOverflow.visible,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(width: 24),
                              GestureDetector(
                                onTap: () {
                                  confirmFunction();
                                },
                                child: MyText(
                                  text: 'Okay',
                                  size: 14,
                                  weight: FontWeight.normal,
                                  color: MyColors().main,
                                  overflow: TextOverflow.visible,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
