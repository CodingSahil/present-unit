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

class SubjectController extends GetxController {
  late GetStorage getStorage;
  RxBool loader = false.obs;
  List<Subject> globalSubjectList = [];
  List<Subject> subjectList = [];

  @override
  void onInit() {
    super.onInit();
    getStorage = GetStorage();
  }

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


  Future<void> deleteData({
    required Subject subject,
    required BuildContext context,
  }) async {
    await deleteAnObject(
      collection: CollectionStrings.subject,
      documentName: subject.documentID,
    );
    getListOfSubject(context: context);
  }

}
