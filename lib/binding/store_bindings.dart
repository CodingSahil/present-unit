import 'package:get/get.dart';
import 'package:present_unit/controller/admin/add_edit_course_controller.dart';
import 'package:present_unit/controller/admin/admin_dashboard_controller.dart';
import 'package:present_unit/controller/admin/course_controller.dart';
import 'package:present_unit/controller/college_registration_controller.dart';
import 'package:present_unit/controller/login_controller.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => CollegeRegistrationController());
    Get.lazyPut(() => AdminDashboardController());
    Get.lazyPut(() => CourseController());
    Get.lazyPut(() => AddEditCourseController());
  }
}
