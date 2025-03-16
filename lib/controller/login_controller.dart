import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';

class LoginController extends GetxController {
  RxBool loader = false.obs;
  RxBool submitLoader = false.obs;

  late GetStorage getStorage;

  List<Admin> adminList = [];
  List<Faculty> facultyList = [];

  @override
  void onInit() {
    getStorage = GetStorage();
    super.onInit();
  }

  Future<void> getAdminList() async {
    loader(true);
    QuerySnapshot collectedObject = await FirebaseFirestore.instance.collection(CollectionStrings.admin).get();

    adminList = collectedObject.docs
        .map(
          (e) => Admin.fromJson(
            e.data() as Map<String, dynamic>,'',
          ),
        )
        .toList();
    adminList.length.toString().logOnString(
          'adminList.length =>',
        );

    loader(false);
  }

  Future<void> getFacultyList() async {
    loader(true);
    QuerySnapshot collectedObject = await FirebaseFirestore.instance.collection(CollectionStrings.faculty).get();

    facultyList = collectedObject.docs
        .map(
          (e) => Faculty.fromJson(
            e.data() as Map<String, dynamic>,
            e.id,
          ),
        )
        .toList();
    facultyList.length.toString().logOnString(
          'facultyList.length =>',
        );

    loader(false);
  }
}
