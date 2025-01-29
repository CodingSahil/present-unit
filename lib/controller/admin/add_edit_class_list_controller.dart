import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';

class AddEditClassListController extends GetxController {
  RxBool loader = false.obs;
  RxBool submitLoader = false.obs;
  List<ClassListModel> globalClassList = [];
  List<ClassListModel> classList = [];
  Admin? admin;
  late GetStorage getStorage;

  @override
  void onInit() {
    super.onInit();
    getStorage = GetStorage();
  }

  Future<void> getListOfClassList({
    required BuildContext context,
  }) async {
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
    globalClassList = await getListFromFirebase<ClassListModel>(
      collection: CollectionStrings.classList,
      fromJson: ClassListModel.fromJson,
    );
    classList = globalClassList
        .where(
          (element) => element.admin?.id == admin?.id,
        )
        .toList();
  }

  Future<void> writeClassListData({
    required ClassListModel classListModel,
    required BuildContext context,
  }) async {
    submitLoader(true);
    await writeAnObject(
      collection: CollectionStrings.classList,
      newDocumentName: classListModel.documentID,
      newMap: classListModel.toJson(),
    );
    getListOfClassList(
      context: context,
    );
    submitLoader(false);
  }

  Future<void> updateClassListData({
    required ClassListModel classListModel,
    required BuildContext context,
  }) async {
    submitLoader(true);
    await updateAnObject(
      collection: CollectionStrings.classList,
      documentName: classListModel.documentID,
      newMap: classListModel.toJson(),
    );
    getListOfClassList(
      context: context,
    );
    submitLoader(false);
  }
}
