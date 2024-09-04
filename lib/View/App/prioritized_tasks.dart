import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mytodo/Widgets/app_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../Controllers/app_controller.dart';
import '../../Widgets/text.dart';
import '../../colors.dart';
import '../../common_functions.dart';
import 'edit_task.dart';

class PrioritizedTasks extends StatelessWidget {
  const PrioritizedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.pages['prioritized'] == true) {
              CommonFunctions().showDialogue(
                false,
                '',
                'Are you sure you want to stop editing? All selected tasks will be unselected.',
                Get.back,
                () {
                  Get.back();
                  controller.cancelEditing('prioritized');
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
                title: 'Prioritized',
                leadingExists: controller.pages['prioritized']!,
                actionExists: controller.tasks
                        .where((task) =>
                            task.status == 'pending' && task.prioritized!)
                        .toList()
                        .isEmpty
                    ? false
                    : true,
                actionIcon: controller.pages['prioritized']!
                    ? 'assets/deleteRed.png'
                    : 'assets/edit.png',
                actionFunction: () async {
                  if (controller.pages['prioritized']!) {
                    CommonFunctions().showDialogue(
                      false,
                      '',
                      'All selected tasks will be deleted. Are you sure you want to continue?',
                      Get.back,
                      () async {
                        Get.back();
                        await controller.markTaskDeleted(context);
                        controller.cancelEditing('prioritized');
                      },
                      false,
                    );
                  } else {
                    controller.toggleEditing(true, 'prioritized');
                  }
                },
                leadingFunction: controller.pages['prioritized']!
                    ? () {
                        CommonFunctions().showDialogue(
                          false,
                          '',
                          'Are you sure you want to stop editing? All selected tasks will be unselected.',
                          Get.back,
                          () {
                            Get.back();
                            controller.cancelEditing('prioritized');
                          },
                          false,
                        );
                      }
                    : null,
              ),
              body: controller.fetchingTasks
                  ? ListView.builder(
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Align(
                            alignment: Alignment.centerLeft,
                            child: Shimmer.fromColors(
                              baseColor: const Color(0xFFCCCCCC),
                              highlightColor: Colors.white,
                              child: Container(
                                width: 100,
                                height: 12,
                                color: const Color(0xFFCCCCCC),
                              ),
                            ),
                          ),
                          subtitle: Shimmer.fromColors(
                            baseColor: const Color(0xFFCCCCCC),
                            highlightColor: Colors.white,
                            child: Container(
                              width: 200,
                              height: 12,
                              color: const Color(0xFFCCCCCC),
                            ),
                          ),
                        );
                      },
                    )
                  : controller.tasks
                          .where((task) =>
                              task.status == 'pending' && task.prioritized!)
                          .toList()
                          .isEmpty
                      ? Center(
                          child: MyText(
                            text: 'You have no prioritized tasks.',
                            size: 18,
                            weight: FontWeight.normal,
                            color: MyColors().text,
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.tasks.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool isContained = controller.toBeDeleted
                                .contains(controller.tasks[index].task_id!);
                            return controller.tasks[index].status ==
                                        'pending' &&
                                    controller.tasks[index].prioritized == true
                                ? Container(
                                    decoration: BoxDecoration(
                                      border: index ==
                                              controller.tasks
                                                  .where((task) =>
                                                      task.status == 'pending')
                                                  .length
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
                                      startActionPane: ActionPane(
                                        motion: const StretchMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed:
                                                (BuildContext context) async {
                                              await controller.changeTaskStatus(
                                                controller
                                                    .tasks[index].task_id!,
                                                'finished',
                                              );
                                            },
                                            backgroundColor: MyColors().main,
                                            icon: CupertinoIcons.checkmark_alt,
                                          )
                                        ],
                                      ),
                                      endActionPane: ActionPane(
                                        motion: const StretchMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed:
                                                (BuildContext context) async {
                                              await controller.changeTaskStatus(
                                                controller
                                                    .tasks[index].task_id!,
                                                'deleted',
                                              );
                                            },
                                            backgroundColor: MyColors().red,
                                            icon: CupertinoIcons.delete,
                                          ),
                                          SlidableAction(
                                            onPressed:
                                                (BuildContext context) async {
                                              await controller
                                                  .changeTaskPriority(
                                                controller
                                                    .tasks[index].task_id!,
                                                false,
                                              );
                                            },
                                            backgroundColor: MyColors().main,
                                            icon: CupertinoIcons.arrow_left,
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          if (controller
                                              .pages['prioritized']!) {
                                            controller.selectTask(controller
                                                .tasks[index].task_id!);
                                          } else {
                                            controller.titleController.text =
                                                controller.tasks[index].title;
                                            controller.bodyController.text =
                                                controller.tasks[index].body;
                                            controller.editingPriority =
                                                controller
                                                    .tasks[index].prioritized!;
                                            Get.to(
                                              () => EditTask(
                                                editing: true,
                                                task: controller.tasks[index],
                                              ),
                                            );
                                          }
                                        },
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 75.w,
                                              child: MyText(
                                                text: controller
                                                    .tasks[index].title,
                                                size: 18,
                                                weight: FontWeight.w600,
                                                color: isContained
                                                    ? Colors.white
                                                    : MyColors().text,
                                              ),
                                            ),
                                            MyText(
                                              text: controller
                                                  .formatCustomDateTime(
                                                      controller.tasks[index]
                                                          .date_time),
                                              size: 12,
                                              weight: FontWeight.w400,
                                              color: isContained
                                                  ? Colors.white
                                                  : MyColors().grey,
                                            ),
                                          ],
                                        ),
                                        subtitle: MyText(
                                          text: controller.tasks[index].body,
                                          size: 14,
                                          weight: FontWeight.normal,
                                          color: isContained
                                              ? Colors.white
                                              : MyColors().text,
                                        ),
                                        tileColor: isContained
                                            ? MyColors().main
                                            : null,
                                      ),
                                    ),
                                  )
                                : Container();
                          },
                        ),
            ),
          ),
        );
      },
    );
  }
}
