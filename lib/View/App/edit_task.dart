import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mytodo/Controllers/app_controller.dart';
import 'package:mytodo/Widgets/app_bar.dart';
import 'package:mytodo/Widgets/text.dart';
import 'package:mytodo/colors.dart';

import '../../Models/task.dart';

class EditTask extends StatelessWidget {
  final Task task;
  final bool editing;

  const EditTask({
    super.key,
    required this.task,
    required this.editing,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: MyColors().background,
            appBar: MyAppBar(
              title: 'Edit Task',
              leadingExists: true,
              leadingFunction: () {
                controller.onLeaveTaskEdit();
              },
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: editing,
                        controller: controller.titleController,
                        textCapitalization: TextCapitalization.sentences,
                        style: GoogleFonts.poppins(
                          color: MyColors().text,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
                          hintStyle: GoogleFonts.poppins(
                            color: Get.isDarkMode
                                ? MyColors().text
                                : MyColors().grey,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: editing
                                ? () {
                                    controller.editingPriority =
                                        !controller.editingPriority;
                                    controller.update();
                                  }
                                : null,
                            child: controller.editingPriority
                                ? Icon(
                                    CupertinoIcons.star_fill,
                                    size: 24,
                                    color: editing
                                        ? MyColors().main
                                        : MyColors().main.withOpacity(0.5),
                                  )
                                : Icon(
                                    CupertinoIcons.star,
                                    size: 24,
                                    color: editing
                                        ? MyColors().main
                                        : MyColors().main.withOpacity(0.5),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: editing
                                ? () async {
                                    await controller.pickDateTime(context);
                                  }
                                : null,
                            child: Icon(
                              CupertinoIcons.clock,
                              size: 24,
                              color: editing
                                  ? MyColors().main
                                  : MyColors().main.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          controller.dateTime != null
                              ? Container(
                                  margin: EdgeInsets.zero,
                                  height: 24,
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    bottom: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 1,
                                      color: MyColors().text,
                                    ),
                                  ),
                                  child: Center(
                                    child: MyText(
                                      text: DateFormat('EEE, MMM d, h:mm a')
                                          .format(
                                        controller.dateTime!,
                                      ),
                                      size: 14,
                                      weight: FontWeight.normal,
                                      color: MyColors().text,
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.zero,
                                  height: 24,
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    bottom: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 1,
                                      color: MyColors().text,
                                    ),
                                  ),
                                  child: Center(
                                    child: MyText(
                                      text: DateFormat('EEE, MMM d, h:mm a')
                                          .format(
                                        DateTime.parse(task.date_time),
                                      ),
                                      size: 14,
                                      weight: FontWeight.normal,
                                      color: MyColors().text,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Divider(
                  color: MyColors().secondary,
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    enabled: editing,
                    controller: controller.bodyController,
                    textCapitalization: TextCapitalization.sentences,
                    style: GoogleFonts.poppins(
                      color: MyColors().text,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    minLines: 1,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description',
                      hintStyle: GoogleFonts.poppins(
                        color:
                            Get.isDarkMode ? MyColors().text : MyColors().grey,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: editing
                ? FloatingActionButton(
                    onPressed: () async {
                      await controller.saveChanges(
                          context, task, task.date_time);
                    },
                    backgroundColor: MyColors().main,
                    child: controller.savingChanges
                        ? const Center(
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 24,
                          ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
