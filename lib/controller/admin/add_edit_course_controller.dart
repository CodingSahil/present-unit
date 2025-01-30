import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/view/splash_view.dart';

class AddEditCourseController extends GetxController {
  RxBool submitLoader = false.obs;
  List<Course> globalCourseList = [];
  List<Course> courseList = [];
  late GetStorage getStorage;

  @override
  void onInit() {
    super.onInit();
    getStorage = GetStorage();
  }

  bool validateFields({
    required String name,
    required num duration,
  }) =>
      name.isNotEmpty && duration > 0 && duration <= 10;

  Future<void> getListOfCourse({
    required BuildContext context,
  }) async {
    Admin? admin;
    if (userDetails != null && userDetails!.admin != null) {
      admin = userDetails!.admin;
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
  }

  Future<void> writeCourseData({
    required Course course,
  }) async {
    await writeAnObject(
      collection: CollectionStrings.course,
      newDocumentName: course.documentID,
      newMap: course.toJson(),
    );
    courseList = await getListFromFirebase<Course>(
      collection: CollectionStrings.course,
      fromJson: Course.fromJson,
    );
  }

  Future<void> updateCourseData({
    required Course course,
    required BuildContext context,
  }) async {
    await updateAnObject(
      collection: CollectionStrings.course,
      documentName: course.documentID,
      newMap: course.toJson(),
    );
    getListOfCourse(context: context);
  }
}
