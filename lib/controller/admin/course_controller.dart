import 'package:get/get.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:present_unit/view/splash_view.dart';

class CourseController extends GetxController {
  Admin? admin;
  RxBool loader = false.obs;
  RxBool deleteLoader = false.obs;
  List<Course> globalCourseList = [];
  List<Course> courseList = [];

  Future<void> getListOfCourse() async {
    loader(true);
    if (userDetails != null && userDetails!.admin != null) {
      admin = userDetails!.admin;
    }
    globalCourseList = await getListFromFirebase<Course>(
      collection: CollectionStrings.course,
      fromJson: Course.fromJson,
    );
    courseList = globalCourseList
        .where(
          (element) => element.admin?.id == admin?.id && element.admin?.name.toLowerCase() == admin?.name.toLowerCase(),
        )
        .toList();
    courseList.sort((a, b) => a.id.compareTo(b.id));
    loader(false);
    update([UpdateKeys.updateCourses]);
  }

  Future<void> deleteData({
    required Course course,
  }) async {
    deleteLoader(true);
    await deleteAnObject(
      collection: CollectionStrings.course,
      documentName: course.documentID,
    );
    getListOfCourse();
    deleteLoader(false);
    update([UpdateKeys.updateCourses]);
  }
}
