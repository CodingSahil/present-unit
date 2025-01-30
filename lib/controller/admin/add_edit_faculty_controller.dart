import 'package:get/get.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/view/splash_view.dart';

class AddEditFacultyController extends GetxController {
  RxBool loader = false.obs;
  RxBool submitLoader = false.obs;
  List<Faculty> globalFacultyList = [];
  List<Faculty> facultyList = [];

  Future<void> getListOfFaculty() async {
    Admin? admin;
    if (userDetails != null && userDetails!.admin != null) {
      admin = userDetails!.admin;
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

  Future<void> writeFacultyData({
    required Faculty faculty,
  }) async {
    await writeAnObject(
      collection: CollectionStrings.faculty,
      newDocumentName: faculty.documentID,
      newMap: faculty.toJson(),
    );
    getListOfFaculty();
  }

  Future<void> updateFacultyData({
    required Faculty faculty,
  }) async {
    await updateAnObject(
      collection: CollectionStrings.faculty,
      documentName: faculty.documentID,
      newMap: faculty.toJson(),
    );
    getListOfFaculty();
  }
}