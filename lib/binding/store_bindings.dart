import 'package:get/get.dart';
import 'package:present_unit/controller/login_controller.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
