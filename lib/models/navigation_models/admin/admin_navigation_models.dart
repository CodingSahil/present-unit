import 'package:equatable/equatable.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';

class CourseNavigation extends Equatable {
  const CourseNavigation({
    required this.documentID,
    required this.id,
    required this.name,
    required this.duration,
    this.admin,
  });

  final String documentID;
  final num id;
  final String name;
  final String duration;
  final Admin? admin;

  Map<String, dynamic> toJson() => {
        'documentID': documentID,
        'id': id,
        'name': name,
        'duration': duration,
        if (admin != null && admin!.id != -1000) 'admin': admin!.toJson(),
      };

  @override
  List<Object?> get props => [
        documentID,
        id,
        name,
        duration,
        admin,
      ];
}

class SubjectNavigation extends Equatable {
  final String documentID;
  final num id;
  final String name;
  final Course course;
  final Admin admin;
  final College? college;
  final num credit;
  final num semester;
  final String subjectCode;

  SubjectNavigation({
    required this.documentID,
    required this.id,
    required this.name,
    required this.course,
    required this.admin,
    this.college,
    required this.credit,
    required this.semester,
    required this.subjectCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'documentID': documentID,
      'id': id,
      'name': name,
      if (course.id != -1000) 'course': course.toJson(),
      if (admin.id != -1000) 'admin': admin.toJson(),
      if (college != null && college!.id != -1000) 'college': college?.toJson(),
      'credit': credit,
      'semester': semester,
      if (subjectCode.isNotEmpty) 'subjectCode': subjectCode,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        course,
        admin,
        college,
        credit,
        semester,
        subjectCode,
      ];
}
