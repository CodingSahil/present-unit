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
  List<Student> globalStudentList = [];
  List<ClassListModel> classList = [];
  List<Student> studentList = [];
  Admin? admin;

  Future<void> getListOfClassList() async {
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

  Future<void> getListOfStudentList() async {
    if (userDetails != null && userDetails!.admin != null) {
      admin = userDetails!.admin;
    }
    globalStudentList = await getListFromFirebase<Student>(
      collection: CollectionStrings.students,
      fromJson: Student.fromJsonWithDocumentID,
    );
    studentList = globalStudentList
        .where(
          (element) => element.admin?.id == admin?.id,
        )
        .toList();
  }

  Future<void> writeClassListData({
    required ClassListModel classListModel,
  }) async {
    submitLoader(true);
    await writeAnObject(
      collection: CollectionStrings.classList,
      newDocumentName: classListModel.documentID,
      newMap: classListModel.toJson(),
    );
    await writeStudentListData(
      classListModel: classListModel,
    );
    getListOfClassList();
    submitLoader(false);
  }

  Future<void> writeStudentListData({
    required ClassListModel classListModel,
  }) async {
    submitLoader(true);
    await writeAnObject(
      collection: CollectionStrings.students,
      newDocumentName: classListModel.documentID,
      newMap: Student.toJsonWithList(
        classListModel.studentList ?? [],
      ),
    );
    getListOfStudentList();
    submitLoader(false);
  }

  Future<void> updateClassListData({
    required ClassListModel classListModel,
  }) async {
    submitLoader(true);
    await updateAnObject(
      collection: CollectionStrings.classList,
      documentName: classListModel.documentID,
      newMap: classListModel.toJson(),
    );
    await updateStudentListData(
      classListModel: classListModel,
    );
    getListOfClassList();
    submitLoader(false);
  }

  Future<void> updateStudentListData({
    required ClassListModel classListModel,
  }) async {
    submitLoader(true);
    await updateAnObject(
      collection: CollectionStrings.students,
      documentName: classListModel.documentID,
      newMap: Student.toJsonWithList(
        classListModel.studentList ?? [],
      ),
    );
    getListOfStudentList();
    submitLoader(false);
  }
}
