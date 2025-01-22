import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';

class CourseController extends GetxController {
  late GetStorage getStorage;
  RxBool loader = false.obs;
  List<Course> globalCourseList = [];
  List<Course> courseList = [];

  @override
  void onInit() {
    super.onInit();
    getStorage = GetStorage();
  }

  Future<void> getListOfCourse({
    required BuildContext context,
  }) async {
    loader(true);
    Admin? admin;
    try {
      var adminDetails = getStorage.read(StorageKeys.adminDetails);
      admin = adminDetails != null
          ? Admin.fromJson(jsonDecode(adminDetails))
          : null;
    } catch (e) {
      showErrorSnackBar(
        context: context,
        title: 'Something went wrong',
      );
    }
    globalCourseList = await getListFromFirebase<Course>(
      collection: CollectionStrings.course,
      fromJson: Course.fromJson,
    );
    courseList = globalCourseList
        .where(
          (element) => element.admin?.id == admin?.id,
    )
        .toList();
    loader(false);

  }


}