import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytodo/Controllers/auth_controller.dart';
import 'package:mytodo/Widgets/button.dart';
import 'package:mytodo/Widgets/text_form_field.dart';
import 'package:mytodo/colors.dart';
import 'package:sizer/sizer.dart';

import '../../Controllers/theme_controller.dart';
import '../../Widgets/text.dart';
import '../../common_functions.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        if (controller.registerError) {
          Future.microtask(
            () => CommonFunctions().showDialogue(true, controller.errorText, '',
                () {
              controller.resetError();
              Get.back();
            }, () {}, false),
          );
        }
        return GetBuilder<ThemeController>(
          init: ThemeController(),
          builder: (themeController) => WillPopScope(
            onWillPop: () async {
              CommonFunctions().showDialogue(
                  controller.registerError,
                  controller.errorText,
                  'Are you sure you want to exit the page? All information entered will be lost.',
                  Get.back, () {
                controller.onLeaveSignIn();
                controller.onLeaveRegister();
                Get.back();
                Get.back();
              }, false);
              return true;
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: MyColors().background,
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: controller.registerFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 11.h),
                          MyButton(
                            buttonFunction: () {
                              CommonFunctions().showDialogue(
                                  controller.registerError,
                                  controller.errorText,
                                  'Are you sure you want to exit the page? All information entered will be lost.',
                                  Get.back, () {
                                controller.onLeaveSignIn();
                                controller.onLeaveRegister();
                                Get.back();
                                Get.back();
                              }, false);
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
                          const SizedBox(height: 48),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  MyText(
                                    text: 'Create',
                                    size: 26,
                                    weight: FontWeight.w600,
                                    color: MyColors().text,
                                  ),
                                  MyText(
                                    text: ' Account',
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
                                      'Fill all the information to create an account and use the app.',
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
                          const SizedBox(height: 32),
                          MyField(
                            width: 100.w,
                            controller: controller.fullNameController,
                            hintText: 'Full Name',
                            isPassword: false,
                            isLast: false,
                            isName: true,
                            type: TextInputType.text,
                            prefixIcon: Image.asset(
                              themeController.isDarkMode.value
                                  ? 'assets/userBlack.png'
                                  : 'assets/user.png',
                              width: 24,
                              height: 24,
                            ),
                            validatorFunction: controller.validateField,
                          ),
                          const SizedBox(height: 16),
                          MyField(
                            width: 100.w,
                            controller: controller.registerEmailController,
                            hintText: 'Email',
                            isPassword: false,
                            isLast: false,
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
                          MyField(
                            width: 100.w,
                            controller: controller.registerPasswordController,
                            hintText: 'Password',
                            isPassword: true,
                            isLast: false,
                            isName: false,
                            type: TextInputType.text,
                            prefixIcon: Image.asset(
                              themeController.isDarkMode.value
                                  ? 'assets/passwordWhite.png'
                                  : 'assets/password.png',
                              width: 24,
                              height: 24,
                            ),
                            showPassword: controller.showPassword,
                            suffixIcon: GestureDetector(
                              onTap: controller.showPasswordFunction,
                              child: Image.asset(
                                themeController.isDarkMode.value
                                    ? controller.showPassword
                                        ? 'assets/showPasswordWhite.png'
                                        : 'assets/hidePasswordWhite.png'
                                    : controller.showPassword
                                        ? 'assets/showPassword.png'
                                        : 'assets/hidePassword.png',
                              ),
                            ),
                            validatorFunction: controller.validatePassword,
                          ),
                          const SizedBox(height: 16),
                          MyField(
                            width: 100.w,
                            controller: controller.confirmPasswordController,
                            hintText: 'Confirm Password',
                            isPassword: true,
                            showPassword: controller.showPassword,
                            isLast: true,
                            isName: false,
                            type: TextInputType.text,
                            prefixIcon: Image.asset(
                              themeController.isDarkMode.value
                                  ? 'assets/passwordWhite.png'
                                  : 'assets/password.png',
                              width: 24,
                              height: 24,
                            ),
                            suffixIcon: null,
                            validatorFunction:
                                controller.validateConfirmPassword,
                          ),
                          const SizedBox(height: 32),
                          MyButton(
                            buttonFunction: () {
                              if (controller.registerFormKey.currentState!
                                  .validate()) {
                                controller.register();
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
                                    : Image.asset('assets/signin.png'),
                                const SizedBox(width: 8),
                                const MyText(
                                  text: 'Create Account',
                                  size: 16,
                                  weight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          MyButton(
                            buttonFunction: controller.signInWithGoogle,
                            height: 40,
                            width: 100.w,
                            border: true,
                            color: MyColors().background,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/google.png'),
                                const SizedBox(width: 8),
                                MyText(
                                  text: 'Sign in with Google',
                                  size: 16,
                                  weight: FontWeight.normal,
                                  color: MyColors().text,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                text: 'Already have an account?',
                                size: 16,
                                weight: FontWeight.normal,
                                color: MyColors().text,
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.onLeaveSignIn();
                                  controller.onLeaveRegister();
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
