import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/view/splash_view.dart';

class AddEditClassListController extends GetxController {
  RxBool loader = false.obs;
  RxBool submitLoader = false.obs;
  List<ClassListModel> globalClassList = [];
  List<ClassListModel> classList = [];
  Admin? admin;

  Future<void> getListOfClassList({
    required BuildContext context,
  }) async {
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
