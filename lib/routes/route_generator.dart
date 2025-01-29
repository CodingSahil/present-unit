import 'package:flutter/material.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/admin/class-list/add_edit_class_list_view.dart';
import 'package:present_unit/view/admin/class-list/class_list_view.dart';
import 'package:present_unit/view/admin/course/add_edit_course.dart';
import 'package:present_unit/view/admin/course/course_view.dart';
import 'package:present_unit/view/admin/dashboard/admin_dashboard_view.dart';
import 'package:present_unit/view/admin/faculty/add_edit_faculty.dart';
import 'package:present_unit/view/admin/faculty/faculty_view.dart';
import 'package:present_unit/view/admin/subject/add_edit_subject.dart';
import 'package:present_unit/view/admin/subject/subject_view.dart';
import 'package:present_unit/view/college_registration.dart';
import 'package:present_unit/view/login_view.dart';
import 'package:present_unit/view/splash_view.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashView(),
        );

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

      case Routes.courseView:
        return MaterialPageRoute(
          builder: (context) => const CourseView(),
        );

      case Routes.facultyView:
        return MaterialPageRoute(
          builder: (context) => const FacultyView(),
        );

      case Routes.subjectView:
        return MaterialPageRoute(
          builder: (context) => const SubjectView(),
        );

      case Routes.classListView:
        return MaterialPageRoute(
          builder: (context) => const ClassListView(),
        );

      case Routes.addEditCourse:
        var arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => AddEditCourseView(
            arguments: arguments,
          ),
        );

      case Routes.addEditFaculty:
        var arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => AddEditFacultyView(
            arguments: arguments,
          ),
        );

      case Routes.addEditSubject:
        var arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => AddEditSubjectView(
            arguments: arguments,
          ),
        );

      case Routes.addEditClassList:
        var arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => AddEditClassListView(
            arguments: arguments,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const SplashView(),
        );
    }
  }
}
