import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mytodo/Controllers/auth_controller.dart';
import 'package:mytodo/Widgets/button.dart';
import 'package:mytodo/Widgets/text.dart';
import 'package:mytodo/Widgets/text_form_field.dart';
import 'package:mytodo/colors.dart';
import 'package:mytodo/common_functions.dart';
import 'package:sizer/sizer.dart';

import '../../Controllers/theme_controller.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        if (controller.signInError) {
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
          builder: (themeController) => SafeArea(
            child: Scaffold(
              backgroundColor: MyColors().background,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: controller.signInFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 13.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/logo.svg'),
                            const SizedBox(width: 16),
                            MyText(
                              text: 'My',
                              size: 26,
                              weight: FontWeight.w600,
                              color: MyColors().main,
                            ),
                            MyText(
                              text: 'ToDo',
                              size: 26,
                              weight: FontWeight.w600,
                              color: MyColors().text,
                            ),
                          ],
                        ),
                        SizedBox(height: 13.h),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyText(
                                  text: 'Welcome back to',
                                  size: 24,
                                  weight: FontWeight.w600,
                                  color: MyColors().text,
                                ),
                                MyText(
                                  text: ' My',
                                  size: 24,
                                  weight: FontWeight.w600,
                                  color: MyColors().main,
                                ),
                                MyText(
                                  text: 'ToDo',
                                  size: 24,
                                  weight: FontWeight.w600,
                                  color: MyColors().text,
                                ),
                              ],
                            ),
                            MyText(
                              text:
                                  'Enter your email address and password to continue and use the app.',
                              size: 14,
                              weight: FontWeight.normal,
                              color: themeController.isDarkMode.value
                                  ? MyColors().text
                                  : MyColors().grey,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        MyField(
                          width: 100.w,
                          controller: controller.emailController,
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
                          controller: controller.passwordController,
                          hintText: 'Password',
                          isPassword: false,
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
                              width: 24,
                              height: 24,
                            ),
                          ),
                          validatorFunction: controller.validatePassword,
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            controller.onLeaveSignIn();
                            controller.onLeavePasswordReset();
                            Get.toNamed('/password_reset');
                          },
                          child: MyText(
                            text: 'Forgot Password?',
                            size: 16,
                            weight: FontWeight.w500,
                            color: MyColors().text,
                          ),
                        ),
                        const SizedBox(height: 16),
                        MyButton(
                          buttonFunction: () {
                            if (controller.signInFormKey.currentState!
                                .validate()) {
                              controller.signIn();
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
                                text: 'Sign in',
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
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyText(
                              text: "Don't have an account?",
                              size: 16,
                              weight: FontWeight.normal,
                              color: MyColors().text,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.onLeaveSignIn();
                                controller.onLeaveRegister();
                                Get.toNamed('/register');
                              },
                              child: MyText(
                                text: ' Register',
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
        );
      },
    );
  }
}
