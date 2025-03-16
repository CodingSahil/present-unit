import 'dart:developer';

import 'package:get/get.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/helpers/database/update_state_keys.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/subject/subject_model.dart';
import 'package:present_unit/view/splash_view.dart';

class SubjectController extends GetxController {
  RxBool loader = false.obs;
  List<Subject> globalSubjectList = [];
  List<Subject> subjectList = [];

  Future<void> getListOfSubject() async {
    loader(true);
    Admin? admin;
    if (userDetails != null && userDetails!.admin != null) {
      admin = userDetails!.admin;
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
    subjectList.sort((a, b) => a.id.compareTo(b.id));
    await Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );
    loader(false);
    update([UpdateKeys.updateSubject]);
  }

  void getListOfSubjectAccordingToSelectedCourse({
    required List<num> courseIDs,
  }) {
    Admin? admin;
    if (userDetails != null && userDetails!.admin != null) {
      admin = userDetails!.admin;
    }

    subjectList = globalSubjectList
        .where(
          (element) =>
              element.admin?.id == admin?.id &&
              courseIDs.any(
                (elementInner) => element.course?.id == elementInner,
              ),
        )
        .toList();
  }

  Future<void> deleteData({
    required Subject subject,
  }) async {
    log('subject => ${subject.id} ${subject.name}');
    await deleteAnObject(
      collection: CollectionStrings.subject,
      documentName: subject.documentID,
    );
  }
}
