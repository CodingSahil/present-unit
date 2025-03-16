import 'package:get/get.dart';
import 'package:present_unit/app-repository/firestore_method.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordController();

  RxBool loader = true.obs;
  RxBool submitLoader = true.obs;
  List<Admin> adminList = [];
  List<Faculty> facultyList = [];

  Future<void> getAdminList() async {
    loader(true);
    adminList = await getListFromFirebase<Admin>(
      collection: CollectionStrings.admin,
      fromJson: Admin.fromJson,
    );
    adminList.map((e) => '${e.documentID} : ${e.name}').toList().toString().logOnString('adminList => ');
    loader(false);
  }

  Future<void> getFacultyList() async {
    loader(true);
    facultyList = await getListFromFirebase<Faculty>(
      collection: CollectionStrings.faculty,
      fromJson: Faculty.fromJson,
    );
    facultyList.map((e) => '${e.documentID} : ${e.name}').toList().toString().logOnString('facultyList => ');
    loader(false);
  }

  Future<void> updateAdmin(Admin admin) async {
    submitLoader(true);
    await updateAnObject(
      collection: CollectionStrings.admin,
      documentName: admin.documentID != null && admin.documentID!.isNotEmpty ? admin.documentID! : '',
      newMap: admin.toJson(),
    );
    submitLoader(false);
  }

  Future<void> updateFaculty(Faculty faculty) async {
    submitLoader(true);
    await updateAnObject(
      collection: CollectionStrings.faculty,
      documentName: faculty.documentID,
      newMap: faculty.toJson(),
    );
    submitLoader(false);
  }
}
