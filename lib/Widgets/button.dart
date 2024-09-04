import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/theme_controller.dart';

class MyButton extends StatelessWidget {
  final VoidCallback buttonFunction;
  final double height;
  final double width;
  final Color color;
  final Widget child;
  final double elevation;
  final bool disabled;
  final bool border;

  const MyButton({
    super.key,
    required this.buttonFunction,
    required this.height,
    required this.width,
    required this.color,
    required this.child,
    this.elevation = 0,
    this.disabled = false,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (themeController) => Container(
        height: height,
        width: width,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: MaterialButton(
          elevation: elevation,
          onPressed: disabled ? () {} : buttonFunction,
          color: disabled ? color.withOpacity(0.7) : color,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: border
                ? BorderSide(
                    width: 1,
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                  )
                : BorderSide.none,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
