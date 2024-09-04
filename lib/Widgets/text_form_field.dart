import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytodo/Controllers/theme_controller.dart';

import '../colors.dart';

class MyField extends StatelessWidget {
  final double width;
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool showPassword;
  final bool isLast;
  final bool isName;
  final TextInputType type;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final Function? suffixIconFunction;
  final String? Function(String?)? validatorFunction;
  final bool? enabled;

  const MyField({
    super.key,
    required this.width,
    required this.controller,
    required this.hintText,
    required this.isPassword,
    this.showPassword = false,
    required this.isLast,
    required this.isName,
    required this.type,
    required this.prefixIcon,
    this.suffixIcon,
    this.suffixIconFunction,
    this.validatorFunction,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (themeController) => SizedBox(
        width: width,
        child: TextFormField(
          enabled: enabled,
          controller: controller,
          obscureText: showPassword,
          textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
          textCapitalization:
              isName ? TextCapitalization.sentences : TextCapitalization.none,
          keyboardType: type,
          style: GoogleFonts.poppins(
            color:
                themeController.isDarkMode.value ? Colors.white : Colors.black,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              color: themeController.isDarkMode.value
                  ? Colors.white
                  : MyColors().grey,
              fontSize: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                width: 1,
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: MyColors().main,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: MyColors().red,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: MyColors().red,
                width: 1,
              ),
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: MyColors().red,
              fontWeight: FontWeight.normal,
            ),
            errorMaxLines: 10,
          ),
          validator: validatorFunction,
        ),
      ),
    );
  }
}
