import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:present_unit/helpers/database/collection_string.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';

class CollegeRegistrationController extends GetxController {
  RxBool loader = false.obs;
  List<College> collegeList = [];
  List<Admin> adminList = [];

  /// read data
  Future<void> getCollegeList() async {
    loader(true);
    QuerySnapshot collectedObject = await FirebaseFirestore.instance
        .collection(CollectionStrings.college)
        .get();

    collegeList = collectedObject.docs
        .map(
          (e) => College.fromJson(
            e.data() as Map<String, dynamic>,
          ),
        )
        .toList();
    collegeList.length.toString().logOnString('collegeList.length =>');

    loader(false);
  }

  Future<void> getAdminList() async {
    loader(true);
    QuerySnapshot collectedObject = await FirebaseFirestore.instance
        .collection(CollectionStrings.admin)
        .get();

    adminList = collectedObject.docs
        .map(
          (e) => Admin.fromJson(
            e.data() as Map<String, dynamic>,
          ),
        )
        .toList();

    adminList.length.toString().logOnString('adminList.length =>');

    loader(false);
  }

  /// write data
  Future<void> writeCollegeObject({
    required College college,
  }) async {
    await FirebaseFirestore.instance
        .collection(CollectionStrings.college)
        .doc(
          '${(college.name.length > 10 ? college.name.substring(0, 10).toLowerCase() : college.name.toLowerCase()).trim().split(" ").join("_")}${collegeList.length + 1}',
        )
        .set(
          college.toJson(),
        );
    getCollegeList();
  }

  Future<void> writeAdminObject({
    required Admin admin,
  }) async {
    await FirebaseFirestore.instance
        .collection(CollectionStrings.admin)
        .doc('admin${collegeList.length + 1}')
        .set(
          admin.toJson(),
        );
    getAdminList();
  }
}
