import 'package:get/get.dart';

import '../Controllers/app_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppController());
  }
}
