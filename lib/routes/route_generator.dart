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
import 'package:present_unit/view/auth/change_password_view.dart';
import 'package:present_unit/view/college_registration.dart';
import 'package:present_unit/view/faculty/assignment/add_edit_assignment/add_edit_assignment_view.dart';
import 'package:present_unit/view/faculty/assignment/assignment_list_view.dart';
import 'package:present_unit/view/faculty/classes/add_edit_classes/add_edit_classes_with_attendance_view.dart';
import 'package:present_unit/view/faculty/classes/add_edit_classes/task_list_view.dart';
import 'package:present_unit/view/faculty/classes/lecture_list_view.dart';
import 'package:present_unit/view/faculty/classes/lecture_details/lecture_details_view.dart';
import 'package:present_unit/view/faculty/dashboard/faculty_dashboard_view.dart';
import 'package:present_unit/view/faculty/dashboard/lecture_common_list_view.dart';
import 'package:present_unit/view/login_view.dart';
import 'package:present_unit/view/pdf_view.dart';
import 'package:present_unit/view/splash_view.dart';
import 'package:present_unit/view/student/dashboard/student_dashboard_view.dart';

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

      case Routes.changePasswordView:
        var arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => ChangePasswordView(
            arguments: arguments,
          ),
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

      /// faculty
      case Routes.facultyDashboard:
        return MaterialPageRoute(
          builder: (context) => const FacultyDashboardView(),
        );

      case Routes.classesForAttendance:
        dynamic arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => ClassListForAttendanceView(
            arguments: arguments,
          ),
        );

      case Routes.assignmentForAttendance:
        dynamic arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => AssignmentListView(
            arguments: arguments,
          ),
        );

      case Routes.addEditClassesWithAttendanceView:
        dynamic arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => AddEditClassesWithAttendanceView(
            arguments: arguments,
          ),
        );

      case Routes.taskListView:
        dynamic arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => TaskListView(
            arguments: arguments,
          ),
        );

      case Routes.lectureDetailsView:
        dynamic arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => LectureDetailsView(
            arguments: arguments,
          ),
        );

      case Routes.addEditAssignmentView:
        dynamic arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => AddEditAssignmentView(
            arguments: arguments,
          ),
        );

      case Routes.pdfView:
        dynamic arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => PdfView(
            arguments: arguments,
          ),
        );

      case Routes.lectureCommonListView:
        dynamic arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => LectureCommonListView(
            arguments: arguments,
          ),
        );

      case Routes.assignmentCommonListView:
        dynamic arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => AssignmentCommonListView(
            arguments: arguments,
          ),
        );

      case Routes.studentDashboardView:
        return MaterialPageRoute(
          builder: (context) => const StudentDashboardView(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const SplashView(),
        );
    }
  }
}
