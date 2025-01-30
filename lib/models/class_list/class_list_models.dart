import 'package:equatable/equatable.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';

class ClassListModel extends Equatable {
  const ClassListModel({
    required this.documentID,
    required this.id,
    required this.name,
    required this.division,
    required this.course,
    required this.courseBatchYear,
    required this.admin,
    required this.college,
    required this.studentList,
  });

  final String documentID;
  final num id;
  final String name;
  final String division;
  final Course? course;
  final CourseBatchYear? courseBatchYear;
  final Admin? admin;
  final College? college;
  final List<Student>? studentList;

  factory ClassListModel.fromJson(
    Map<String, dynamic> json,
    String documentID,
  ) {
    return ClassListModel(
      documentID: documentID,
      id: json['id'] as num,
      name: json['name'] as String,
      division: json['division'] as String,
      course: json['course'] != null
          ? Course.fromJson(
              json['course'] as Map<String, dynamic>,
              '',
            )
          : null,
      courseBatchYear: json['courseBatchYear'] != null
          ? CourseBatchYear.fromJson(
              json['courseBatchYear'] as Map<String, dynamic>,
            )
          : null,
      admin: json['admin'] != null
          ? Admin.fromJson(
              json['admin'] as Map<String, dynamic>,
            )
          : null,
      college: json['college'] != null
          ? College.fromJson(
              json['college'] as Map<String, dynamic>,
            )
          : null,
      studentList: (json['studentList'] as List<dynamic>?)
              ?.map(
                (e) => Student.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  factory ClassListModel.empty() => ClassListModel(
        documentID: '',
        id: -1000,
        name: '',
        division: '',
        course: Course.empty(),
        courseBatchYear: CourseBatchYear.empty(),
        admin: Admin.empty(),
        college: College.empty(),
        studentList: const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'division': division,
        if (course != null && course!.id != -1000) 'course': course!.toJson(),
        if (courseBatchYear != null &&
            courseBatchYear!.admissionYear != -1000 &&
            courseBatchYear!.passingYear != -1000)
          'courseBatchYear': courseBatchYear!.toJson(),
        if (admin != null && admin!.id != -1000) 'admin': admin!.toJson(),
        if (college != null && college!.id != -1000)
          'college': college!.toJson(),
        if (studentList != null && studentList!.isNotEmpty)
          'studentList': studentList!
              .map(
                (e) => e.toJson(),
              )
              .toList(),
      };

  ClassListModel copyWith({
    num? id,
    String? name,
    String? division,
    Course? course,
    CourseBatchYear? courseBatchYear,
    Admin? admin,
    College? college,
    List<Student>? studentList,
  }) {
    return ClassListModel(
      documentID: documentID,
      id: id ?? this.id,
      name: name ?? this.name,
      division: division ?? this.division,
      course: course ?? this.course,
      courseBatchYear: courseBatchYear ?? this.courseBatchYear,
      admin: admin ?? this.admin,
      college: college ?? this.college,
      studentList: studentList ?? this.studentList,
    );
  }

  @override
  List<Object?> get props => [
        documentID,
        id,
        name,
        division,
        course,
        courseBatchYear,
        admin,
        college,
        studentList,
      ];
}

class CourseBatchYear extends Equatable {
  const CourseBatchYear({
    this.id,
    required this.admissionYear,
    required this.passingYear,
  });

  final num? id;
  final num admissionYear;
  final num passingYear;

  factory CourseBatchYear.fromJson(Map<String, dynamic> json) {
    return CourseBatchYear(
      admissionYear: json['admissionYear'] as num,
      passingYear: json['passingYear'] as num,
    );
  }

  factory CourseBatchYear.empty() {
    return const CourseBatchYear(
      admissionYear: -1000,
      passingYear: -1000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admissionYear': admissionYear,
      'passingYear': passingYear,
    };
  }

  CourseBatchYear copyWith({
    num? admissionYear,
    num? passingYear,
  }) {
    return CourseBatchYear(
      admissionYear: admissionYear ?? this.admissionYear,
      passingYear: passingYear ?? this.passingYear,
    );
  }

  @override
  List<Object?> get props => [
        admissionYear,
        passingYear,
      ];
}

class Student extends Equatable {
  const Student({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.password,
    required this.course,
    required this.admin,
    required this.college,
  });

  final num id;
  final String name;
  final String mobileNumber;
  final String email;
  final String? password;
  final Course? course;
  final Admin? admin;
  final College? college;

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as num,
      name: json['name'] as String,
      mobileNumber: json['mobileNumber'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      course: json['course'] != null
          ? Course.fromJson(
              json['course'] as Map<String, dynamic>,
              '',
            )
          : null,
      admin: json['admin'] != null
          ? Admin.fromJson(
              json['admin'] as Map<String, dynamic>,
            )
          : null,
      college: json['college'] != null
          ? College.fromJson(
              json['college'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  factory Student.empty() => Student(
        id: -1000,
        name: '',
        mobileNumber: '',
        email: '',
        password: '',
        course: Course.empty(),
        admin: Admin.empty(),
        college: College.empty(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobileNumber': mobileNumber,
        'email': email,
        if (password != null && password!.isNotEmpty) 'password': password,
        if (course != null && course!.id != -1000) 'course': course!.toJson(),
        if (admin != null && admin!.id != -1000) 'admin': admin!.toJson(),
        if (college != null && college!.id != -1000)
          'college': college!.toJson(),
      };

  Student copyWith({
    num? id,
    String? name,
    String? mobileNumber,
    String? email,
    String? password,
    Course? course,
    Admin? admin,
    College? college,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      course: course ?? this.course,
      admin: admin ?? this.admin,
      college: college ?? this.college,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        mobileNumber,
        email,
        password,
        course,
        admin,
        college,
      ];
}
