import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytodo/Controllers/auth_controller.dart';
import 'package:mytodo/Widgets/button.dart';
import 'package:mytodo/Widgets/text.dart';
import 'package:mytodo/Widgets/text_form_field.dart';
import 'package:mytodo/colors.dart';
import 'package:sizer/sizer.dart';

import '../../Controllers/theme_controller.dart';
import '../../common_functions.dart';

class PasswordReset extends StatelessWidget {
  const PasswordReset({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        if (controller.resetPasswordError) {
          Future.microtask(
            () => CommonFunctions().showDialogue(
              true,
              controller.errorText,
              '',
              () {
                controller.resetError();
                Get.back();
              },
              () {},
              false,
            ),
          );
        }
        return GetBuilder<ThemeController>(
          init: ThemeController(),
          builder: (themeController) => WillPopScope(
            onWillPop: () async {
              CommonFunctions().showDialogue(
                controller.resetPasswordError,
                controller.errorText,
                'Are you sure you want to exit the page? All information entered will be lost.',
                Get.back,
                () {
                  controller.onLeaveSignIn();
                  controller.onLeavePasswordReset();
                  Get.back();
                  Get.back();
                },
                false,
              );
              return true;
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: MyColors().background,
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: controller.resetPasswordFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 13.h),
                          MyButton(
                            buttonFunction: () {
                              CommonFunctions().showDialogue(
                                controller.resetPasswordError,
                                controller.errorText,
                                'Are you sure you want to exit the page? All information entered will be lost.',
                                Get.back,
                                () {
                                  controller.onLeaveSignIn();
                                  controller.onLeavePasswordReset();
                                  Get.back();
                                  Get.back();
                                },
                                false,
                              );
                            },
                            height: 56,
                            width: 56,
                            color: MyColors().main,
                            child: const Icon(
                              CupertinoIcons.back,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 13.h),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  MyText(
                                    text: 'Forgot',
                                    size: 26,
                                    weight: FontWeight.w600,
                                    color: MyColors().text,
                                  ),
                                  MyText(
                                    text: ' Password?',
                                    size: 26,
                                    weight: FontWeight.w600,
                                    color: MyColors().main,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 90.w,
                                child: MyText(
                                  text:
                                      'Enter the email address the corresponds with your account.',
                                  size: 14,
                                  weight: FontWeight.normal,
                                  color: themeController.isDarkMode.value
                                      ? MyColors().text
                                      : MyColors().grey,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 48),
                          MyField(
                            width: 100.w,
                            controller: controller.resetPasswordEmailController,
                            hintText: 'Email',
                            isPassword: false,
                            isLast: true,
                            isName: false,
                            type: TextInputType.text,
                            prefixIcon: Image.asset(
                              themeController.isDarkMode.value
                                  ? 'assets/emailWhite.png'
                                  : 'assets/email.png',
                              width: 24,
                              height: 24,
                            ),
                            validatorFunction: controller.validateEmail,
                          ),
                          const SizedBox(height: 16),
                          MyButton(
                            buttonFunction: () {
                              if (controller.resetPasswordFormKey.currentState!
                                  .validate()) {
                                controller.resetPassword();
                              }
                            },
                            disabled: controller.isLoading,
                            height: 40,
                            width: 100.w,
                            color: MyColors().main,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                controller.isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Image.asset('assets/send.png'),
                                const SizedBox(width: 8),
                                const MyText(
                                  text: 'Send',
                                  size: 16,
                                  weight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                text: 'Remembered your password?',
                                size: 16,
                                weight: FontWeight.normal,
                                color: MyColors().text,
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.onLeaveSignIn();
                                  controller.onLeavePasswordReset();
                                  Get.back();
                                },
                                child: MyText(
                                  text: ' Sign in',
                                  size: 16,
                                  weight: FontWeight.normal,
                                  color: MyColors().main,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
