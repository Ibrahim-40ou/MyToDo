import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mytodo/Controllers/app_controller.dart';
import 'package:mytodo/View/App/edit_task.dart';
import 'package:mytodo/Widgets/text.dart';
import 'package:mytodo/colors.dart';
import 'package:sizer/sizer.dart';
import '../../Models/task.dart';
import '../../Widgets/app_bar.dart';
import '../../common_functions.dart';

class ViewTasks extends StatelessWidget {
  final List<Task> tasks;
  final bool deleted;

  const ViewTasks({
    super.key,
    required this.tasks,
    required this.deleted,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.pages['view'] == true) {
              CommonFunctions().showDialogue(
                false,
                '',
                'Are you sure you want to exit the page? All selected tasks will be unselected.',
                Get.back,
                () {
                  Get.back();
                  Get.back();
                  controller.cancelEditing('view');
                },
                false,
              );
            }
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: MyColors().background,
              appBar: MyAppBar(
                title: deleted ? 'Deleted Tasks' : 'Completed Tasks',
                leadingExists: true,
                actionExists: tasks.isEmpty ? false : true,
                actionIcon: controller.pages['view']!
                    ? 'assets/deleteRed.png'
                    : 'assets/edit.png',
                actionFunction: () async {
                  if (controller.pages['view']!) {
                    CommonFunctions().showDialogue(
                      false,
                      '',
                      'All selected tasks will be deleted. Are you sure you want to continue?',
                      Get.back,
                      () async {
                        Get.back();
                        await controller.deleteTasks(context);
                        for (int i = 0; i < tasks.length; i++) {
                          tasks.removeWhere(
                            (task) => controller.toBeDeleted.contains(
                              task.task_id,
                            ),
                          );
                          controller.update();
                        }
                        controller.cancelEditing('view');
                      },
                      false,
                    );
                  } else {
                    controller.toggleEditing(true, 'view');
                  }
                },
                leadingFunction: controller.pages['view']!
                    ? () {
                        CommonFunctions().showDialogue(
                          false,
                          '',
                          'Are you sure you want to exit the page? All selected tasks will be unselected.',
                          Get.back,
                          () {
                            Get.back();
                            Get.back();
                            controller.cancelEditing('view');
                          },
                          false,
                        );
                      }
                    : Get.back,
              ),
              body: tasks.isEmpty
                  ? Center(
                      child: MyText(
                        text: deleted
                            ? 'You have no deleted tasks.'
                            : 'You have no finished tasks.',
                        size: 18,
                        weight: FontWeight.normal,
                        color: MyColors().text,
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isContained = controller.toBeDeleted
                            .contains(tasks[index].task_id);
                        return Container(
                          decoration: BoxDecoration(
                            border: index == tasks.length
                                ? Border.symmetric(
                                    horizontal: BorderSide(
                                      width: 1,
                                      color: MyColors().secondary,
                                    ),
                                  )
                                : Border(
                                    top: BorderSide(
                                      width: 1,
                                      color: MyColors().secondary,
                                    ),
                                  ),
                          ),
                          child: Slidable(
                            startActionPane: deleted
                                ? ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed:
                                            (BuildContext context) async {
                                          await controller.changeTaskStatus(
                                            tasks[index].task_id!,
                                            'pending',
                                          );
                                          tasks.removeWhere((task) =>
                                              task.task_id ==
                                              tasks[index].task_id);
                                          controller.update();
                                        },
                                        backgroundColor: MyColors().main,
                                        icon: CupertinoIcons.arrow_left,
                                      )
                                    ],
                                  )
                                : null,
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (BuildContext context) async {
                                    CommonFunctions().showDialogue(
                                      false,
                                      '',
                                      'Are you sure you want to delete the task permanently?',
                                      Get.back,
                                      () async {
                                        Get.back();
                                        await controller.deleteTask(
                                          tasks[index].task_id!,
                                        );
                                        tasks.removeWhere((task) =>
                                            task.task_id ==
                                            tasks[index].task_id);
                                        controller.update();
                                      },
                                      false,
                                    );
                                  },
                                  backgroundColor: MyColors().red,
                                  icon: CupertinoIcons.delete,
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: () {
                                if (controller.pages['view']!) {
                                  controller.selectTask(tasks[index].task_id!);
                                } else {
                                  controller.titleController.text =
                                      tasks[index].title;
                                  controller.bodyController.text =
                                      tasks[index].body;
                                  controller.editingPriority =
                                      tasks[index].prioritized!;
                                  Get.to(
                                    () => EditTask(
                                      editing: false,
                                      task: controller.tasks[index],
                                    ),
                                  );
                                }
                              },
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 75.w,
                                    child: MyText(
                                      text: tasks[index].title,
                                      size: 18,
                                      weight: FontWeight.w600,
                                      color: isContained
                                          ? Colors.white
                                          : MyColors().text,
                                    ),
                                  ),
                                  MyText(
                                    text: controller.formatCustomDateTime(
                                      tasks[index].date_time,
                                    ),
                                    size: 12,
                                    weight: FontWeight.w400,
                                    color: isContained
                                        ? Colors.white
                                        : MyColors().grey,
                                  ),
                                ],
                              ),
                              subtitle: MyText(
                                text: tasks[index].body,
                                size: 14,
                                weight: FontWeight.normal,
                                color: isContained
                                    ? Colors.white
                                    : MyColors().text,
                              ),
                              tileColor: isContained ? MyColors().main : null,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
