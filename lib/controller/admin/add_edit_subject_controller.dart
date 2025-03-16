import 'package:get/get.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/subject/subject_model.dart';
import 'package:present_unit/view/splash_view.dart';

class AddEditSubjectController extends GetxController {
  RxBool submitLoader = false.obs;
  List<Subject> globalSubjectList = [];
  List<Subject> subjectList = [];
  Admin? admin;

  bool validateFields({
    required String subjectName,
    required num subjectCredit,
    required num semester,
    required String subjectCode,
    required bool isAdminFilled,
    required bool isCourseFilled,
  }) =>
      subjectName.isNotEmpty && subjectCredit != 0 && subjectCredit <= 10 && semester != 0 && semester <= 10 && subjectCode.isNotEmpty && isAdminFilled && isCourseFilled;

  Future<void> getListOfSubject() async {
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
  }

  Future<void> writeSubjectData({
    required Subject subject,
  }) async {
    await writeAnObject(
      collection: CollectionStrings.subject,
      newDocumentName: subject.documentID,
      newMap: subject.toJson(),
    );
    getListOfSubject();
  }

  Future<void> updateSubjectData({
    required Subject subject,
  }) async {
    await updateAnObject(
      collection: CollectionStrings.subject,
      documentName: subject.documentID,
      newMap: subject.toJson(),
    );
    getListOfSubject();
  }
}
