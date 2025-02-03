import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:present_unit/controller/admin/add_edit_class_list_controller.dart';
import 'package:present_unit/controller/admin/course_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/bottom-sheet/bottom_sheet.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/course/course_model.dart';
import 'package:present_unit/models/navigation_models/common_models/bottomsheet_selection_model.dart';

class AddEditClassListView extends StatefulWidget {
  const AddEditClassListView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<AddEditClassListView> createState() => _AddEditClassListViewState();
}

class _AddEditClassListViewState extends State<AddEditClassListView> {
  late CourseController courseController;
  late AddEditClassListController addEditClassListController;
  late TextEditingController classDivisionController;
  late GetStorage getStorage;
  List<CourseBatchYear> listOfCourseBatchYear = [];
  List<List<dynamic>> rowsAsListOfValues = [];
  List<Student> studentList = [];

  bool isError = false;
  Admin? admin;
  Course? selectedCourse;
  CourseBatchYear? selectedCourseBatchYear;
  FilePickerResult? filePicker;
  ClassListModel? classListModelForUpdate;

  @override
  void initState() {
    super.initState();
    courseController = Get.find<CourseController>();
    addEditClassListController = Get.find<AddEditClassListController>();
    classDivisionController = TextEditingController();
    getStorage = GetStorage();
    var adminDetails = getStorage.read(StorageKeys.adminDetails);
    admin = adminDetails != null
        ? Admin.fromJson(
            jsonDecode(adminDetails),
          )
        : null;

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await courseController.getListOfCourse();
        await addEditClassListController.getListOfClassList();
      },
    );

    if (widget.arguments != null && widget.arguments is ClassListModel) {
      classListModelForUpdate = widget.arguments as ClassListModel;
      if (classListModelForUpdate != null) {
        classDivisionController.text = classListModelForUpdate!.division;
        selectedCourse = courseController.courseList.any(
          (element) => element.id == classListModelForUpdate!.course?.id,
        )
            ? courseController.courseList.firstWhere(
                (element) => element.id == classListModelForUpdate!.course?.id,
              )
            : courseController.courseList.first;
        generateListForCourseBatchYear();
        studentList = classListModelForUpdate!.studentList != null &&
                classListModelForUpdate!.studentList!.isNotEmpty
            ? classListModelForUpdate!.studentList!
            : [];
        selectedCourseBatchYear = listOfCourseBatchYear.any(
          (element) =>
              element.admissionYear ==
                  classListModelForUpdate!.courseBatchYear?.admissionYear &&
              element.passingYear ==
                  classListModelForUpdate!.courseBatchYear?.passingYear,
        )
            ? listOfCourseBatchYear.firstWhere(
                (element) =>
                    element.admissionYear ==
                        classListModelForUpdate!
                            .courseBatchYear?.admissionYear &&
                    element.passingYear ==
                        classListModelForUpdate!.courseBatchYear?.passingYear,
              )
            : null;
      }
    }
  }

  bool validateFields() =>
      classDivisionController.text.isNotEmpty &&
      selectedCourse != null &&
      selectedCourse!.id != -1000 &&
      selectedCourseBatchYear != null &&
      studentList.isNotEmpty;

  void generateListForCourseBatchYear() {
    listOfCourseBatchYear.clear();
    if (selectedCourse != null) {
      num startDate = DateTime.now().year - 15;
      num duration = selectedCourse!.duration;
      for (int index = 0; index < 40; index++) {
        listOfCourseBatchYear.add(
          CourseBatchYear(
              id: index + 1,
              admissionYear: startDate + index,
              passingYear: (startDate + index) + duration),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: widget.arguments != null ? 'Edit Class' : 'Add Class',
        isAdd: false,
      ),
      body: Obx(
        () => courseController.loader.value
            ? Center(
                child: Loader(
                  color: AppColors.primaryColor,
                ),
              )
            : ListView(
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.height60,
                  horizontal: Dimens.width40,
                ),
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  LabeledTextFormField(
                    controller: classDivisionController,
                    hintText: 'Enter Class Division',
                    isError: isError && classDivisionController.text.isEmpty,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: Dimens.height30),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      await showCommonBottomSheet(
                        context: context,
                        title: 'Select Course',
                        listOfItems: courseController.courseList
                            .map(
                              (e) => BottomSheetSelectionModel(
                                id: e.id,
                                name: e.name,
                              ),
                            )
                            .toList(),
                        selectValue: selectedCourse != null &&
                                selectedCourse!.id != -1000
                            ? BottomSheetSelectionModel(
                                id: selectedCourse!.id,
                                name: selectedCourse!.name,
                              )
                            : null,
                        onSubmit: (selectValue) {
                          if (courseController.courseList.any(
                            (element) => element.id == selectValue.id,
                          )) {
                            setState(() {
                              selectedCourse =
                                  courseController.courseList.singleWhere(
                                (element) => element.id == selectValue.id,
                              );
                              generateListForCourseBatchYear();
                            });
                          }
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.radius16,
                        ),
                        border: Border.all(
                          color: isError && selectedCourse == null
                              ? AppColors.red
                              : AppColors.black,
                          width: isError && selectedCourse == null ? 1 : 0.75,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.height24,
                        horizontal: Dimens.width30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTextTheme.textSize14(
                            label: selectedCourse != null
                                ? selectedCourse!.name
                                : 'Select Course',
                            color: AppColors.black.withAlpha(
                              (255 * 0.7).toInt(),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.black,
                            size: Dimens.height36,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (selectedCourse != null &&
                      listOfCourseBatchYear.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimens.height30),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            await showCommonBottomSheet(
                              context: context,
                              title: 'Select Year',
                              listOfItems: listOfCourseBatchYear
                                  .map(
                                    (e) => BottomSheetSelectionModel(
                                      id: e.id ?? 0,
                                      name:
                                          '${e.admissionYear} - ${e.passingYear}',
                                    ),
                                  )
                                  .toList(),
                              selectValue: selectedCourseBatchYear != null
                                  ? BottomSheetSelectionModel(
                                      id: selectedCourseBatchYear!.id ?? 0,
                                      name:
                                          '${selectedCourseBatchYear!.admissionYear} - ${selectedCourseBatchYear!.passingYear}',
                                    )
                                  : null,
                              onSubmit: (selectValue) {
                                num admissionYear = num.tryParse(selectValue
                                        .name
                                        .split("-")
                                        .first
                                        .trim()) ??
                                    0;
                                num passingYear = num.tryParse(selectValue.name
                                        .split("-")
                                        .last
                                        .trim()) ??
                                    0;
                                if (listOfCourseBatchYear.any(
                                  (element) =>
                                      element.admissionYear == admissionYear &&
                                      element.passingYear == passingYear,
                                )) {
                                  setState(() {
                                    selectedCourseBatchYear =
                                        listOfCourseBatchYear.singleWhere(
                                      (element) =>
                                          element.admissionYear ==
                                              admissionYear &&
                                          element.passingYear == passingYear,
                                    );
                                  });
                                }
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.radius16,
                              ),
                              border: Border.all(
                                color: isError && selectedCourse == null
                                    ? AppColors.red
                                    : AppColors.black,
                                width: isError && selectedCourse == null
                                    ? 1
                                    : 0.75,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: Dimens.height24,
                              horizontal: Dimens.width30,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTextTheme.textSize14(
                                  label: selectedCourseBatchYear != null
                                      ? '${selectedCourseBatchYear!.admissionYear} - ${selectedCourseBatchYear!.passingYear}'
                                      : 'Select Course Batch Year',
                                  color: AppColors.black.withAlpha(
                                    (255 * 0.7).toInt(),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.black,
                                  size: Dimens.height36,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: Dimens.height30),
                  if (classListModelForUpdate != null && studentList.isNotEmpty)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height * 0.35,
                          child: studentList.isNotEmpty
                              ? ListView(
                                  children: studentList
                                      .map(
                                        (student) => Container(
                                          margin: EdgeInsets.only(
                                            top: Dimens.height8,
                                            bottom: Dimens.height12,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: Dimens.height8,
                                            horizontal: Dimens.width18,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            border: Border.all(
                                              color: AppColors.black.withAlpha(
                                                (255 * 0.1).toInt(),
                                              ),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              Dimens.radius15,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () async {
                                                    await showAddEditStudentBottomSheet(
                                                      context: context,
                                                      title: 'Edit Student',
                                                      listOfItems:
                                                      studentList,
                                                      selectValue: student,
                                                      onSubmit: (selectValue) {
                                                        setState(() {
                                                          int index = studentList.indexOf(student);
                                                          studentList[index] = selectValue;
                                                        });
                                                      },
                                                    );
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppTextTheme.textSize18(
                                                        label: student.name,
                                                        color:
                                                            AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            Dimens.height4,
                                                      ),
                                                      AppTextTheme.textSize14(
                                                        label: student.email,
                                                        color:
                                                            AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            Dimens.height4,
                                                      ),
                                                      AppTextTheme.textSize14(
                                                        label: student
                                                            .mobileNumber,
                                                        color:
                                                            AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                behavior: HitTestBehavior
                                                    .translucent,
                                                onTap: () async {
                                                  studentList.removeWhere(
                                                    (element) =>
                                                        element.id ==
                                                        student.id,
                                                  );
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: AppColors.red,
                                                  size: Dimens.height32,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )
                              : Center(
                                  child: AppTextTheme.textSize12(
                                    label: LabelStrings.noData,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                        ),
                        SizedBox(height: Dimens.height20),
                        if (studentList.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  await showAddEditStudentBottomSheet(
                                    context: context,
                                    title: 'Add Student',
                                    listOfItems:
                                        addEditClassListController.studentList,
                                    selectValue: null,
                                    onSubmit: (selectValue) {
                                      setState(() {
                                        studentList.add(selectValue);
                                      });
                                    },
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.width28,
                                    vertical: Dimens.height16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(
                                      Dimens.radius18,
                                    ),
                                  ),
                                  child: AppTextTheme.textSize14(
                                    label: 'Add More',
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    )
                  else
                    StatefulBuilder(
                      builder: (context, setInnerState) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            await Permission.storage.request();
                            // if (await Permission.storage.isGranted) {
                            filePicker = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              withData: true,
                              type: FileType.custom,
                              allowedExtensions: [
                                "csv",
                              ],
                            );
                            // }

                            if (filePicker != null) {
                              String filePath =
                                  filePicker!.paths.first != null &&
                                          filePicker!.paths.first!.isNotEmpty
                                      ? filePicker!.paths.first!
                                      : '';
                              File file = File(filePath);
                              String content = await file.readAsString();
                              rowsAsListOfValues =
                                  const CsvToListConverter().convert(
                                content,
                                allowInvalid: false,
                              );
                              studentList = rowsAsListOfValues.map(
                                (e) {
                                  int index = rowsAsListOfValues.indexOf(e);
                                  num id = index + 1;
                                  String name = e[0].toString();
                                  String mobileNumber = e[1].toString();
                                  String email = e[2].toString();
                                  String password = e[3].toString();
                                  return Student(
                                    id: id,
                                    name: name,
                                    mobileNumber: mobileNumber,
                                    email: email,
                                    password: password,
                                    course: Course.empty(),
                                    admin: Admin.empty(),
                                    college: College.empty(),
                                  );
                                },
                              ).toList();
                            } else {
                              showErrorSnackBar(
                                context: context,
                                title: 'Something went wrong',
                              );
                            }
                            setInnerState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.sizeOf(context).height * 0.35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.radius35,
                              ),
                              border: Border.all(
                                width: 2.5,
                                color: AppColors.black.withAlpha(
                                  (255 * 0.15).toInt(),
                                ),
                              ),
                            ),
                            child: rowsAsListOfValues.isNotEmpty
                                ? Stack(
                                    alignment: Alignment.center,
                                    fit: StackFit.expand,
                                    children: [
                                      Positioned(
                                        top: Dimens.height30,
                                        right: Dimens.width30,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            setInnerState(() {
                                              rowsAsListOfValues.clear();
                                            });
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: AppColors.red,
                                            size: Dimens.height40,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: Dimens.height150,
                                          horizontal: Dimens.width150,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              AssetsPaths.sheetsSVG,
                                              height: Dimens.height175,
                                              width: Dimens.width175,
                                            ),
                                            if (filePicker != null) ...[
                                              SizedBox(height: Dimens.height12),
                                              AppTextTheme.textSize14(
                                                label:
                                                    filePicker!.names.first ??
                                                        '',
                                                maxLines: 3,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.black,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : AppTextTheme.textSize14(
                                    label:
                                        'Upload CSV by clicking inside the Box',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black.withAlpha(
                                      (255 * 0.5).toInt(),
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  if (classListModelForUpdate == null &&
                      studentList.isEmpty) ...[
                    SizedBox(height: Dimens.height12),
                    AppTextTheme.textSize13(
                      label:
                          'Note :- Please upload a CSV file containing the data in the following format: name, mobile number, email, and password, with no titles - just the data itself.',
                      maxLines: 3,
                      color: AppColors.black,
                    ),
                  ],
                  SizedBox(height: Dimens.height50),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      setState(() {
                        isError = !validateFields();
                      });
                      if (!isError) {
                        if (widget.arguments != null &&
                            classListModelForUpdate != null) {
                          ClassListModel classListModel = ClassListModel(
                            documentID: classListModelForUpdate!.documentID,
                            id: classListModelForUpdate!.id,
                            name: classListModelForUpdate!.name,
                            division: classDivisionController.text,
                            course: selectedCourse ?? Course.empty(),
                            courseBatchYear: selectedCourseBatchYear ??
                                CourseBatchYear.empty(),
                            admin: addEditClassListController.admin,
                            college: classListModelForUpdate!.college ??
                                (admin?.college ?? College.empty()),
                            studentList: studentList,
                          );
                          await addEditClassListController.updateClassListData(
                            classListModel: classListModel,
                          );
                        } else {
                          ClassListModel classListModel = ClassListModel(
                            documentID:
                                '${selectedCourse?.name.replaceAll(RegExp(r'[.\s]'), '')}${selectedCourseBatchYear != null ? '_${selectedCourseBatchYear!.admissionYear.toString()}-${selectedCourseBatchYear!.passingYear.toString()}' : '_000'}${addEditClassListController.admin != null ? '_${addEditClassListController.admin!.id}_${addEditClassListController.admin!.name.replaceAll(RegExp(r'[.\s]'), '')}' : 'temp_${addEditClassListController.globalClassList.length + 1}'}',
                            id: addEditClassListController
                                    .globalClassList.isNotEmpty
                                ? addEditClassListController
                                        .globalClassList.length +
                                    1
                                : 1,
                            name:
                                '${selectedCourse?.name} ${selectedCourseBatchYear?.admissionYear}-${selectedCourseBatchYear?.passingYear}',
                            division: classDivisionController.text,
                            course: selectedCourse ?? Course.empty(),
                            courseBatchYear: selectedCourseBatchYear ??
                                CourseBatchYear.empty(),
                            admin: addEditClassListController.admin ??
                                Admin.empty(),
                            college:
                                addEditClassListController.admin?.college ??
                                    College.empty(),
                            studentList: studentList,
                          );
                          await addEditClassListController.writeClassListData(
                            classListModel: classListModel,
                          );
                        }
                        Get.back<bool>(
                          result: true,
                        );
                      }
                    },
                    child: SubmitButtonHelper(
                      height: Dimens.height70,
                      width: MediaQuery.sizeOf(context).width,
                      child: Obx(
                        () => addEditClassListController.submitLoader.value
                            ? const ButtonLoader()
                            : AppTextTheme.textSize16(
                                label: widget.arguments != null &&
                                        classListModelForUpdate != null
                                    ? 'Update Class List'
                                    : 'Add Class List',
                                color: AppColors.white,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
