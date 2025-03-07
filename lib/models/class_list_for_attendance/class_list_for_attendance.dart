import 'package:equatable/equatable.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/models/subject/subject_model.dart';

class ClassesForAttendanceModel extends Equatable {
  const ClassesForAttendanceModel({
    required this.documentID,
    required this.id,
    required this.faculty,
    required this.subject,
    required this.college,
    required this.studentList,
    required this.lectureDate,
    required this.startingTime,
    required this.endingTime,
    this.presentStudentList,
    this.absentStudentList,
    this.notes,
    this.tasks,
    this.description,
  });

  final String documentID;
  final int id;
  final Faculty faculty;
  final Subject subject;
  final College college;
  final List<Student> studentList;
  final List<Student>? presentStudentList;
  final List<Student>? absentStudentList;
  final String? notes;
  final List<String>? tasks;
  final String? description;
  final String lectureDate;
  final String startingTime;
  final String endingTime;

  @override
  List<Object?> get props => [
        documentID,
        id,
        faculty,
        subject,
        college,
        tasks,
        studentList,
        presentStudentList,
        absentStudentList,
        notes,
        description,
        lectureDate,
        startingTime,
        endingTime,
      ];

  factory ClassesForAttendanceModel.fromJson(
    Map<String, dynamic> json,
    String documentID,
  ) {
    return ClassesForAttendanceModel(
      documentID: json['documentID'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      faculty: Faculty.fromJson(json['faculty'] as Map<String, dynamic>, ''),
      subject: Subject.fromJson(json['subject'] as Map<String, dynamic>, ''),
      college: College.fromJson(json['college'] as Map<String, dynamic>),
      studentList: (json['studentList'] as List).map((e) => Student.fromJson(e as Map<String, dynamic>)).toList(),
      presentStudentList: (json['presentStudentList'] as List<dynamic>?)
              ?.map(
                (e) => Student.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      absentStudentList: (json['absentStudentList'] as List<dynamic>?)
              ?.map(
                (e) => Student.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      tasks: json['tasks'] as List<String>? ?? [],
      notes: json['notes'] as String? ?? '',
      description: json['description'] as String? ?? '',
      lectureDate: json['lectureDate'] as String? ?? '',
      startingTime: json['startingTime'] as String? ?? '',
      endingTime: json['endingTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'documentID': documentID,
        'id': id,
        'faculty': faculty.toJson(),
        'subject': subject.toJson(),
        'college': college.toJson(),
        if (studentList.isNotEmpty) 'studentList': studentList.map((e) => e.toJson()).toList(),
        if (presentStudentList != null && presentStudentList!.isNotEmpty) 'presentStudentList': presentStudentList!.map((e) => e.toJson()).toList(),
        if (absentStudentList != null && absentStudentList!.isNotEmpty) 'absentStudentList': absentStudentList!.map((e) => e.toJson()).toList(),
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
        if (tasks != null && tasks!.isNotEmpty) 'tasks': tasks,
        if (description != null && description!.isNotEmpty) 'description': description,
        if (lectureDate.isNotEmpty) 'lectureDate': lectureDate,
        if (startingTime.isNotEmpty) 'startingTime': startingTime,
        if (endingTime.isNotEmpty) 'endingTime': endingTime,
      };

  ClassesForAttendanceModel copyWith({
    int? id,
    Faculty? faculty,
    Subject? subject,
    College? college,
    List<String>? tasks,
    List<Student>? studentList,
    List<Student>? presentStudentList,
    List<Student>? absentStudentList,
    String? notes,
    String? description,
    String? lectureDate,
    String? startingTime,
    String? endingTime,
  }) {
    return ClassesForAttendanceModel(
      documentID: documentID,
      id: id ?? this.id,
      faculty: faculty ?? this.faculty,
      subject: subject ?? this.subject,
      college: college ?? this.college,
      tasks: tasks ?? this.tasks,
      studentList: studentList ?? this.studentList,
      presentStudentList: presentStudentList ?? this.presentStudentList,
      absentStudentList: absentStudentList ?? this.absentStudentList,
      notes: notes ?? this.notes,
      description: description ?? this.description,
      lectureDate: lectureDate ?? this.lectureDate,
      startingTime: startingTime ?? this.startingTime,
      endingTime: endingTime ?? this.endingTime,
    );
  }
}

class Tasks extends Equatable {
  const Tasks({
    required this.task,
    required this.index,
    required this.completed,
  });

  final String task;
  final int index;
  final bool completed;

  @override
  List<Object?> get props => [
        task,
        index,
        completed,
      ];

  factory Tasks.fromJson(
    Map<String, dynamic> json,
    String documentID,
  ) {
    return Tasks(
      task: json['task'] as String? ?? '',
      index: json['index'] as int? ?? 0,
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'task': task,
        'index': index,
        'completed': completed,
      };

  Tasks copyWith({
    String? task,
    int? index,
    bool? completed,
  }) {
    return Tasks(
      task: task ?? this.task,
      index: index ?? this.index,
      completed: completed ?? this.completed,
    );
  }
}
