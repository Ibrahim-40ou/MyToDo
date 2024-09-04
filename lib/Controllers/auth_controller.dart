import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mytodo/Models/user.dart';
import 'package:mytodo/common_functions.dart';
import 'package:mytodo/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  String? userId;

  @override
  void onInit() {
    super.onInit();
    Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        userId = data.session?.user.id;
      },
    );
    update();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController resetPasswordEmailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final signInFormKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  String errorText = '';
  bool signInError = false;
  bool resetPasswordError = false;
  bool registerError = false;

  void onLeaveSignIn() {
    emailController.clear();
    emailController.text = '';
    passwordController.clear();
    passwordController.text = '';
    signInFormKey.currentState?.reset();
    update();
  }

  void onLeavePasswordReset() {
    resetPasswordEmailController.clear();
    resetPasswordEmailController.text = '';
    resetPasswordFormKey.currentState?.reset();
    update();
  }

  void onLeaveRegister() {
    fullNameController.clear();
    fullNameController.text = '';
    registerEmailController.clear();
    registerEmailController.text = '';
    registerPasswordController.clear();
    registerPasswordController.text = '';
    confirmPasswordController.clear();
    confirmPasswordController.text = '';
    registerFormKey.currentState?.reset();
    update();
  }

  bool showPassword = true;

  void showPasswordFunction() {
    showPassword = !showPassword;
    update();
  }

  String? validateField(String? value) =>
      value == null || value.isEmpty ? 'This field is required' : null;

  String? validateEmail(String? email) =>
      EmailValidator.validate(email!.trim()) ? null : 'Enter a valid email';

  String? validatePassword(String? value) => value == null || value.isEmpty
      ? 'This field is required'
      : value.length < 6
          ? 'Password must be longer than 6 characters'
          : null;

  String? validateConfirmPassword(String? value) => value == null ||
          value.isEmpty
      ? 'This field is required'
      : value.length < 6
          ? 'Password must be longer than 6 characters'
          : registerPasswordController.text != confirmPasswordController.text
              ? 'Passwords do not match'
              : null;

  bool isLoading = false;

  void toggleLoading(bool state) {
    isLoading = state;
    update();
  }

  Future<void> register() async {
    toggleLoading(true);
    try {
      final AuthResponse response = await Supabase.instance.client.auth.signUp(
        email: registerEmailController.text.trim(),
        password: registerPasswordController.text,
      );
      if (response.user != null) {
        await Supabase.instance.client.from('users').insert(
              MyUser(
                user_id: response.user!.id,
                user_name: fullNameController.text,
                user_email: registerEmailController.text.trim(),
              ).toJson(),
            );
      }
      signInCheck!.setString('signedIn', 'true');
      errorText = '';
      registerError = false;
      toggleLoading(false);
      Get.offAllNamed('/');
    } on Exception catch (e) {
      errorText = '$e';
      registerError = true;
      toggleLoading(false);
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<void> signIn() async {
    toggleLoading(true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      signInCheck!.setString('signedIn', 'true');
      signInError = false;
      errorText = '';
      toggleLoading(false);
      Get.offAllNamed('/');
    } on Exception catch (e) {
      signInError = true;
      errorText = '$e';
      toggleLoading(false);
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<void> signInWithGoogle() async {
    await Supabase.instance.client.auth.signOut();
    await GoogleSignIn().signOut();
    userId = null;
    update();
    const webClientId =
        '213998481896-bpfdskndlvgkrpih5e6fp1eerdrsss80.apps.googleusercontent.com';
    const iosClientId =
        '213998481896-sqd50voopv98epv6ls163jrlpj3vicaj.apps.googleusercontent.com';
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      toggleLoading(false);
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      toggleLoading(false);
      throw 'No ID Token found.';
    }

    try {
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      final User? user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client.from('users').insert(
              MyUser(
                user_id: user.id,
                user_name: user.userMetadata?['full_name'] ?? 'No name',
                user_email: user.email ?? 'No Email',
              ).toJson(),
            );
      }
      registerError = false;
      signInError = false;
      errorText = '';
      update();
      signInCheck!.setString('signedIn', 'true');
      Get.offAllNamed('/');
    } on Exception catch (e) {
      registerError = true;
      signInError = true;
      errorText = '$e';
      update();
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<void> resetPassword() async {
    try {
      toggleLoading(true);
      await Supabase.instance.client.auth
          .resetPasswordForEmail(resetPasswordEmailController.text.trim());
      resetPasswordError = false;
      errorText = '';
      toggleLoading(false);
      CommonFunctions().showDialogue(
        true,
        'A message was sent to your email with a link to reset your password.',
        '',
        Get.back,
        () {},
        true,
      );
    } on Exception catch (e) {
      resetPasswordError = true;
      errorText = '$e';
      toggleLoading(false);
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  void resetError() {
    signInError = false;
    registerError = false;
    resetPasswordError = false;
    errorText = '';
    update();
  }
}
