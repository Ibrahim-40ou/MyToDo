import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Controllers/app_controller.dart';
import '../../Controllers/theme_controller.dart';
import '../../colors.dart';

class App extends StatelessWidget {
  const App({super.key});

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
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: controller.changePage,
                children: controller.pageViewItems,
              ),
              bottomNavigationBar: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: MyColors().background,
                onTap: controller.changePage,
                currentIndex: controller.currentIndex,
                items: controller.navigationBarItems,
                selectedLabelStyle: GoogleFonts.poppins(
                  color: MyColors().main,
                  fontWeight: FontWeight.normal,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  color: MyColors().main,
                  fontWeight: FontWeight.normal,
                ),
                selectedItemColor: MyColors().main,
                unselectedItemColor: MyColors().main,
              ),
            ),
          ),
        );
      },
    );
  }
}
