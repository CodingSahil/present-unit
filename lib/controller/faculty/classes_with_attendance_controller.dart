import 'dart:convert';

import 'package:get/get.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/class_list_for_attendance/class_list_for_attendance.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/models/subject/subject_model.dart';
import 'package:present_unit/view/splash_view.dart';

class ClassesWithAttendanceController extends GetxController {
  ClassesWithAttendanceController();

  RxBool loader = false.obs;
  RxBool submitLoader = false.obs;
  List<ClassesForAttendanceModel> globalClassesForAttendanceModel = [];
  List<ClassesForAttendanceModel> classesForAttendanceModel = [];
  List<ClassListModel> globalClassList = [];
  List<ClassListModel> classList = [];
  List<Subject> globalSubjectList = [];
  List<Subject> subjectList = [];
  Faculty? faculty;

  Future<void> getClassesList({
    bool isLoaderRequire = true,
  }) async {
    if (userDetails != null && userDetails!.faculty != null) {
      faculty = userDetails!.faculty!;
    }
    if (isLoaderRequire) loader(true);
    globalClassesForAttendanceModel = await getListFromFirebase<ClassesForAttendanceModel>(
      collection: CollectionStrings.classListForAttendance,
      fromJson: ClassesForAttendanceModel.fromJson,
    );
    if (globalClassesForAttendanceModel.isNotEmpty) {
      classesForAttendanceModel = globalClassesForAttendanceModel
          .where(
            (e) => e.faculty.id == faculty!.id,
          )
          .toList();
    }
    if (isLoaderRequire) loader(false);
  }

  Future<void> getListOfClassListStudent() async {
    loader(true);
    if (userDetails != null && userDetails!.faculty != null) {
      faculty = userDetails!.faculty!;
    }
    globalClassList = await getListFromFirebase<ClassListModel>(
      collection: CollectionStrings.classList,
      fromJson: ClassListModel.fromJson,
    );

    classList = globalClassList
        .where(
          (element) => element.admin?.id == faculty?.admin?.id,
        )
        .toList();
    if (globalClassList.isNotEmpty) {
      jsonEncode(
        globalClassList
            .map(
              (e) => e.toJson(),
            )
            .toList(),
      ).logOnString('classList');
    }
    loader(false);
  }

  Future<void> getListOfSubject() async {
    loader(true);
    if (userDetails != null && userDetails!.faculty != null) {
      faculty = userDetails!.faculty!;
    }
    globalSubjectList = await getListFromFirebase<Subject>(
      collection: CollectionStrings.subject,
      fromJson: Subject.fromJson,
    );
    subjectList = globalSubjectList
        .where(
          (element) => element.admin?.id == faculty?.admin?.id,
        )
        .toList();
    loader(false);
  }

  Future<void> addLecture(ClassesForAttendanceModel request) async {
    submitLoader(true);
    await writeAnObject(
      collection: CollectionStrings.classListForAttendance,
      newDocumentName: request.documentID,
      newMap: request.toJson(),
    );
    submitLoader(false);
  }

  Future<void> updateLecture(ClassesForAttendanceModel request) async {
    submitLoader(true);
    await updateAnObject(
      collection: CollectionStrings.classListForAttendance,
      documentName: request.documentID,
      newMap: request.toJson(),
    );
    submitLoader(false);
  }

  Future<void> deleteLecture(String documentName) async {
    await deleteAnObject(
      collection: CollectionStrings.classListForAttendance,
      documentName: documentName,
    );
    await getClassesList(
      isLoaderRequire: false,
    );
  }
}
