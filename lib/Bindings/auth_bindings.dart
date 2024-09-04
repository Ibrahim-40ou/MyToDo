import 'package:get/get.dart';
import 'package:mytodo/Controllers/auth_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }

}