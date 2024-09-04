import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mytodo/View/App/add_task.dart';
import 'package:mytodo/View/Auth/register.dart';
import 'package:mytodo/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Bindings/app_bindings.dart';
import 'Bindings/auth_bindings.dart';
import 'Controllers/theme_controller.dart';
import 'View/App/app.dart';
import 'View/Auth/sign_in.dart';
import 'View/Auth/password_reset.dart';

SharedPreferences? signInCheck;
SharedPreferences? darkModeCheck;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://oonuqdnkoghbrcxfytyj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vbnVxZG5rb2doYnJjeGZ5dHlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM2Mjc4MTEsImV4cCI6MjAzOTIwMzgxMX0.g-DoCRQcuIcVYKbZTI-bX1so8xMcWZWD5CfHF6J1gkM',
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  signInCheck = await SharedPreferences.getInstance();
  darkModeCheck = await SharedPreferences.getInstance();

  runApp(
    Sizer(
      builder: (context, orientation, screenType) => GetMaterialApp(
        themeMode: darkModeCheck!.getBool('isDark') == null ||
                darkModeCheck!.getBool('isDark') == false
            ? ThemeMode.light
            : ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        locale: const Locale('en'),
        builder: (context, child) {
          Get.put(ThemeController());
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: MyColors().background),
          );
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        getPages: [
          GetPage(
            name: '/',
            page: () => signInCheck!.getString('signedIn') == null ||
                    signInCheck!.getString('signedIn') == 'false'
                ? const SignIn()
                : const App(),
            bindings: (signInCheck!.getString('signedIn') == null)
                ? [AuthBindings()]
                : [AuthBindings(), AppBindings()],
          ),
          GetPage(
            name: '/password_reset',
            page: () => const PasswordReset(),
          ),
          GetPage(
            name: '/register',
            page: () => const Register(),
          ),
          GetPage(
            name: '/add_task',
            page: () => const AddTask(),
          ),
        ],
      ),
    ),
  );
}
