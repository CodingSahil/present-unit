import 'dart:convert';

import 'package:get/get.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/view/splash_view.dart';

class ClassListController extends GetxController {
  RxBool loader = false.obs;
  List<ClassListModel> globalClassList = [];
  List<ClassListModel> classList = [];
  List<Student> globalStudentList = [];
  List<Student> studentList = [];
  Admin? admin;

  Future<void> getListOfClassList() async {
    loader(true);
    if (userDetails != null && userDetails!.admin != null) {
      admin = userDetails!.admin;
    }
    globalClassList = await getListFromFirebase<ClassListModel>(
      collection: CollectionStrings.classList,
      fromJson: ClassListModel.fromJson,
    );

    classList = globalClassList
        .where(
          (element) => element.admin?.id == admin?.id,
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
      classList.sort((a, b) => a.id.compareTo(b.id));
    }
    loader(false);
  }

  Future<void> getListOfStudentList() async {
    loader(true);
    if (userDetails != null && userDetails!.admin != null) {
      admin = userDetails!.admin;
    }
    globalStudentList = await getListFromFirebase<Student>(
      collection: CollectionStrings.students,
      fromJson: Student.fromJson,
    );

    studentList = globalStudentList
        .where(
          (element) => element.admin?.id == admin?.id,
        )
        .toList();
    loader(false);
  }

  Future<void> deleteClassListObject({
    required String documentName,
  }) async {
    await deleteAnObject(
      collection: CollectionStrings.classList,
      documentName: documentName,
    );
  }

  Future<void> deleteStudentListObject({
    required String documentName,
  }) async {
    await deleteAnObject(
      collection: CollectionStrings.students,
      documentName: documentName,
    );
  }
}
