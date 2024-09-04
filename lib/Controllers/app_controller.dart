import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mytodo/Models/task.dart';
import 'package:mytodo/View/App/prioritized_tasks.dart';
import 'package:mytodo/View/App/settings.dart';
import 'package:mytodo/View/App/tasks.dart';
import 'package:mytodo/colors.dart';
import 'package:mytodo/common_functions.dart';
import 'package:mytodo/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppController extends GetxController {
  late String? userId;

  @override
  void onInit() async {
    super.onInit();
    userId = Supabase.instance.client.auth.currentUser?.id;
    await fetchTasks();
  }

  PageController pageController = PageController();

  int currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 1),
      curve: Curves.linear,
    );
    update();
  }

  List<BottomNavigationBarItem> navigationBarItems = [
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/tasks.png',
        height: 24,
        width: 24,
      ),
      activeIcon: Image.asset(
        'assets/tasksFilled.png',
        height: 24,
        width: 24,
      ),
      label: 'Tasks',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/star.png',
        height: 24,
        width: 24,
      ),
      activeIcon: Image.asset(
        'assets/starFilled.png',
        height: 24,
        width: 24,
      ),
      label: 'Prioritized Tasks',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/settings.png',
        height: 24,
        width: 24,
      ),
      activeIcon: Image.asset(
        'assets/settingsFilled.png',
        height: 24,
        width: 24,
      ),
      label: 'Settings',
    ),
  ];

  List<Widget> pageViewItems = [
    const Tasks(),
    const PrioritizedTasks(),
    const Settings(),
  ];

  DateTime now = DateTime.now();
  DateTime startOfWeek =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime endOfWeek = DateTime.now()
      .subtract(Duration(days: DateTime.now().weekday - 1))
      .add(const Duration(days: 7));

  String formatCustomDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    if (DateFormat('yyyy-MM-dd').format(dateTime) ==
        DateFormat('yyyy-MM-dd').format(now)) {
      return DateFormat('h:mm a').format(dateTime);
    } else if (dateTime.isAfter(startOfWeek) && dateTime.isBefore(endOfWeek)) {
      return DateFormat('EEE').format(dateTime);
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  bool isLoading = false;

  void toggleLoading(bool status) {
    isLoading = status;
    update();
  }

  bool isPrioritized = false;

  void prioritizeTask() {
    isPrioritized = !isPrioritized;
    update();
  }

  DateTime? date;
  TimeOfDay? time;
  DateTime? dateTime;

  Future<void> pickDateTime(BuildContext context) async {
    date = await showDatePicker(
      barrierDismissible: false,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Get.isDarkMode
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    surface: MyColors().background,
                    primary: MyColors().main,
                    onPrimary: Colors.white,
                    onSurface: MyColors().text,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: MyColors().main, // Button text color
                    ),
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    surface: MyColors().background,
                    primary: MyColors().main,
                    onPrimary: Colors.white,
                    onSurface: MyColors().text,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: MyColors().main, // Button text color
                    ),
                  ),
                ),
          child: child!,
        );
      },
    );
    time = await showTimePicker(
      barrierDismissible: false,
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Get.isDarkMode
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    surface: MyColors().background,
                    primary: MyColors().main,
                    onPrimary: Colors.white,
                    onSurface: MyColors().text,
                    secondary: MyColors().main,
                    onSecondary: Colors.white,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: MyColors().main, // Button text color
                    ),
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    surface: MyColors().background,
                    primary: MyColors().main,
                    onPrimary: Colors.white,
                    onSurface: MyColors().text,
                    secondary: MyColors().main,
                    onSecondary: Colors.white,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: MyColors().main, // Button text color
                    ),
                  ),
                ),
          child: child!,
        );
      },
    );
    if (date != null && time != null) {
      dateTime = DateTime(
        date!.year,
        date!.month,
        date!.day,
        time!.hour,
        time!.minute,
      );
    }
    update();
  }

  void clearTaskParameters() {
    titleController.clear();
    titleController.text = '';
    bodyController.clear();
    bodyController.text = '';
    dateTime = null;
    isPrioritized = false;
    update();
  }

  bool addingTask = false;

  Future<void> addTask(BuildContext context) async {
    try {
      addingTask = true;
      update();
      if (dateTime == null || titleController.text.isEmpty) {
        CommonFunctions().showDialogue(
          true,
          dateTime == null && titleController.text.isEmpty
              ? 'Please enter a title and a time for the task.'
              : titleController.text.isEmpty
                  ? 'Please enter a title for the task.'
                  : 'Please enter a time for the task.',
          '',
          Get.back,
          () {},
          true,
        );
        addingTask = false;
        update();
        return;
      }
      if (userId != null &&
          dateTime != null &&
          titleController.text.isNotEmpty) {
        await Supabase.instance.client.from('tasks').insert(
              Task(
                user_id: userId!,
                title: titleController.text,
                body: bodyController.text,
                prioritized: isPrioritized,
                status: 'pending',
                date_time: dateTime!.toIso8601String(),
              ).toJson(),
            );
        clearTaskParameters();
      }
      addingTask = false;
      update();
      await fetchTasks();
      Get.back();
      CommonFunctions().showSnackBar(context, 'Task is added successfully');
    } on Exception catch (e) {
      addingTask = false;
      update();
      CommonFunctions().showDialogue(
        true,
        '$e',
        '',
        Get.back,
        () {},
        false,
      );
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  List<Task> tasks = [];
  bool fetchingTasks = false;

  bool fetchedTasks = false;

  Future<void> fetchTasks() async {
    try {
      tasks = [];
      fetchingTasks = true;
      fetchedTasks = false;
      update();
      final List<Map<String, dynamic>> response = await Supabase.instance.client
          .from('tasks')
          .select('*')
          .eq('user_id', userId!);
      for (Map<String, dynamic> column in response) {
        tasks.add(
          Task.fromJson(column),
        );
      }
      fetchingTasks = false;
      fetchedTasks = true;
      update();
    } on Exception catch (e) {
      fetchingTasks = false;
      fetchedTasks = false;
      update();
      CommonFunctions().showDialogue(
        true,
        '$e',
        '',
        Get.back,
        () {},
        false,
      );
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<void> changeTaskStatus(String id, String status) async {
    try {
      await Supabase.instance.client
          .from('tasks')
          .update({'status': status}).eq('task_id', id);
      tasks.where((task) => task.task_id == id).first.status = status;
      update();
    } on Exception catch (e) {
      update();
      CommonFunctions().showDialogue(
        true,
        '$e',
        '',
        Get.back,
        () {},
        false,
      );
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<void> changeTaskPriority(String id, bool priority) async {
    try {
      await await Supabase.instance.client
          .from('tasks')
          .update({'prioritized': priority}).eq('task_id', id);
      tasks.where((task) => task.task_id == id).first.prioritized = priority;
      update();
    } on Exception catch (e) {
      update();
      CommonFunctions().showDialogue(
        true,
        '$e',
        '',
        Get.back,
        () {},
        false,
      );
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await await Supabase.instance.client
          .from('tasks')
          .delete()
          .eq('task_id', id);
      tasks.removeWhere((task) => task.task_id == id);
      update();
    } on Exception catch (e) {
      update();
      CommonFunctions().showDialogue(
        true,
        '$e',
        '',
        Get.back,
        () {},
        false,
      );
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  bool savingChanges = false;
  bool editingPriority = false;

  Future<void> saveChanges(
      BuildContext context, Task task, String dateAndTime) async {
    try {
      savingChanges = true;
      update();
      if (userId != null) {
        Task updatedTask = Task(
          task_id: task.task_id,
          user_id: userId!,
          title: titleController.text,
          body: bodyController.text,
          prioritized: editingPriority,
          status: task.status,
          date_time: dateTime != null
              ? dateTime!.toIso8601String()
              : DateTime.parse(dateAndTime).toIso8601String(),
        );
        await await Supabase.instance.client
            .from('tasks')
            .update(
              updatedTask.toJson(),
            )
            .eq('task_id', task.task_id!);
        int index = tasks.indexWhere((xTask) => xTask.task_id == task.task_id);
        tasks[index] = updatedTask;
        savingChanges = false;
        update();
        CommonFunctions().showSnackBar(context, 'Task is edited successfully');
      }
    } on Exception catch (e) {
      savingChanges = false;
      update();
      CommonFunctions().showDialogue(
        true,
        '$e',
        '',
        Get.back,
        () {},
        false,
      );
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  void onLeaveTaskEdit() {
    titleController.clear();
    bodyController.clear();
    editingPriority = false;
    dateTime = null;
    update();
    Get.back();
  }

  List<String> toBeDeleted = [];

  Map<String, bool> pages = {
    'pending': false,
    'prioritized': false,
    'view': false,
  };

  void toggleEditing(bool status, String page) {
    pages[page] = status;
    update();
  }

  void selectTask(String id) {
    if (toBeDeleted.contains(id)) {
      toBeDeleted.removeWhere((taskId) => taskId == id);
    } else {
      toBeDeleted.add(id);
    }
    update();
  }

  void cancelEditing(String page) {
    toBeDeleted.clear();
    toggleEditing(false, page);
  }

  Future<void> markTaskDeleted(BuildContext context) async {
    try {
      for (String id in toBeDeleted) {
        await Supabase.instance.client.from('tasks').update(
          {'status': 'deleted'},
        ).eq('task_id', id);
        int index = tasks.indexWhere((task) => task.task_id == id);
        tasks[index].status = 'deleted';
        update();
        CommonFunctions().showSnackBar(
          context,
          toBeDeleted.length > 1
              ? 'Tasks moved to deleted tasks'
              : 'Task moved to deleted tasks',
        );
      }
    } on Exception catch (e) {
      update();
      CommonFunctions().showDialogue(
        true,
        '$e',
        '',
        Get.back,
        () {},
        false,
      );
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<void> deleteTasks(BuildContext context) async {
    try {
      for (String id in toBeDeleted) {
        await Supabase.instance.client.from('tasks').delete().eq('task_id', id);
        tasks.removeWhere((task) => task.task_id == id);
        update();
        CommonFunctions().showSnackBar(
          context,
          toBeDeleted.length > 1
              ? 'Tasks deleted permanently'
              : 'Task deleted permanently',
        );
      }
    } on Exception catch (e) {
      update();
      CommonFunctions().showDialogue(
        true,
        '$e',
        '',
        Get.back,
        () {},
        false,
      );
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      await GoogleSignIn().signOut();
      signInCheck!.setString('signedIn', 'false');
      Get.offAllNamed('/');
    } on Exception catch (e) {
      update();
      CommonFunctions().showDialogue(
        true,
        '$e',
        '',
        Get.back,
        () {},
        false,
      );
      if (kDebugMode) {
        print('$e');
      }
    }
  }
}
