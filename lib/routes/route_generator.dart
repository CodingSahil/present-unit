import 'package:flutter/material.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/admin/course/add_edit_course.dart';
import 'package:present_unit/view/admin/dashboard/admin_dashboard_view.dart';
import 'package:present_unit/view/college_registration.dart';
import 'package:present_unit/view/login_view.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );

      case Routes.registration:
        return MaterialPageRoute(
          builder: (context) => const CollegeRegistrationView(),
        );

      /// Admin
      case Routes.adminDashboard:
        return MaterialPageRoute(
          builder: (context) => const AdminDashboardView(),
        );

      case Routes.addEditCourse:
        var arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => AddEditCourseView(
            arguments: arguments,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );
    }
  }
}
