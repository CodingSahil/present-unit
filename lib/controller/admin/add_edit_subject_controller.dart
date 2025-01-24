import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/subject/subject_model.dart';

class AddEditSubjectController extends GetxController {
  RxBool submitLoader = false.obs;
  List<Subject> globalSubjectList = [];
  List<Subject> subjectList = [];
  late GetStorage getStorage;

  @override
  void onInit() {
    super.onInit();
    getStorage = GetStorage();
  }

  bool validateFields({
    required String subjectName,
    required num subjectCredit,
    required num semester,
    required String subjectCode,
    required bool isAdminFilled,
    required bool isCourseFilled,
  }) =>
      subjectName.isNotEmpty &&
      subjectCredit != 0 &&
      subjectCredit <= 10 &&
      semester != 0 &&
      semester <= 10 &&
      subjectCode.isNotEmpty &&
      isAdminFilled &&
      isCourseFilled;

  Future<void> getListOfSubject({
    required BuildContext context,
  }) async {
    Admin? admin;
    try {
      var adminDetails = getStorage.read(StorageKeys.adminDetails);
      admin = adminDetails != null
          ? Admin.fromJson(
        jsonDecode(adminDetails),
      )
          : null;
    } catch (e) {
      showErrorSnackBar(
        context: context,
        title: 'Something went wrong',
      );
    }
    globalSubjectList = await getListFromFirebase<Subject>(
      collection: CollectionStrings.subject,
      fromJson: Subject.fromJson,
    );
    subjectList = globalSubjectList
        .where(
          (element) => element.admin?.id == admin?.id,
    )
        .toList();
  }

  Future<void> writeData({
    required Subject subject,
  }) async {
    await writeAnObject(
      collection: CollectionStrings.subject,
      newDocumentName: subject.documentID,
      newMap: subject.toJson(),
    );
    subjectList = await getListFromFirebase<Subject>(
      collection: CollectionStrings.subject,
      fromJson: Subject.fromJson,
    );
  }

  Future<void> updateData({
    required Subject subject,
    required BuildContext context,
  }) async {
    await updateAnObject(
      collection: CollectionStrings.subject,
      documentName: subject.documentID,
      newMap: subject.toJson(),
    );
    getListOfSubject(context: context);
  }
}
