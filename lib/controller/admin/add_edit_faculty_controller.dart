import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';

class AddEditFacultyController extends GetxController {
  late GetStorage getStorage;
  RxBool loader = false.obs;
  RxBool submitLoader = false.obs;
  List<Faculty> globalFacultyList = [];
  List<Faculty> facultyList = [];

  @override
  void onInit() {
    super.onInit();
    getStorage = GetStorage();
  }

  Future<void> getListOfFaculty({
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
    globalFacultyList = await getListFromFirebase<Faculty>(
      collection: CollectionStrings.faculty,
      fromJson: Faculty.fromJson,
    );
    facultyList = globalFacultyList
        .where(
          (element) => element.admin?.id == admin?.id,
    )
        .toList();
  }

  Future<void> writeData({
    required Faculty faculty,
    required BuildContext context,
  }) async {
    await writeAnObject(
      collection: CollectionStrings.faculty,
      newDocumentName: faculty.documentID,
      newMap: faculty.toJson(),
    );
    getListOfFaculty(context: context);
  }

  Future<void> updateData({
    required Faculty faculty,
    required BuildContext context,
  }) async {
    await updateAnObject(
      collection: CollectionStrings.faculty,
      documentName: faculty.documentID,
      newMap: faculty.toJson(),
    );
    getListOfFaculty(context: context);
  }
}