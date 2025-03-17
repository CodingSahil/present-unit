import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:present_unit/controller/faculty/assignment_controller.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helper-widgets/bottom-sheet/bottom_sheet.dart';
import 'package:present_unit/helper-widgets/buttons/field_with_click_event.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helper-widgets/snackbar/snackbar.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/supabase_client_keys.dart';
import 'package:present_unit/helpers/date-time-convert/date_time_conversion.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/common_enums.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/helpers/get_new_id.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/models/assignment/assignment_model.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/models/navigation_models/common_models/bottomsheet_selection_model.dart';
import 'package:present_unit/models/subject/subject_model.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/splash_view.dart';

class AddEditAssignmentView extends StatefulWidget {
  const AddEditAssignmentView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<AddEditAssignmentView> createState() => _AddEditAssignmentViewState();
}

class _AddEditAssignmentViewState extends State<AddEditAssignmentView> {
  late final AssignmentController assignmentController;
  late final TextEditingController dateOfLectureController;

  RxBool uploadLoader = false.obs;
  AssignmentType selectedAssignmentType = AssignmentType.assignment;

  AssignmentModel? assignmentModel;
  BottomSheetSelectionModel? selectedClassList;
  BottomSheetSelectionModel? selectedSubjectList;
  Faculty? faculty;
  bool isError = false;
  DateTime? selectedDate;
  FilePickerResult? filePicker;
  String? fileURL;

  @override
  void initState() {
    assignmentController = Get.find<AssignmentController>();
    dateOfLectureController = TextEditingController();

    if (userDetails != null && userDetails!.faculty != null) {
      faculty = userDetails!.faculty!;
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await assignmentController.getAssignmentList();
        await assignmentController.getListOfSubject();
        await assignmentController.getClassesList();
        await assignmentController.getListOfClassListStudent();
        if (widget.arguments != null && widget.arguments is AssignmentModel) {
          assignmentModel = widget.arguments as AssignmentModel;

          if (assignmentModel != null) {
            ClassListModel? classListModel = assignmentController.classList.firstWhereOrNull((element) => element.id == assignmentModel!.classListModel.id);
            Subject? subject = assignmentController.subjectList.firstWhereOrNull((element) => element.id == assignmentModel!.subject.id);

            if (classListModel != null) {
              selectedClassList = BottomSheetSelectionModel(
                id: classListModel.id,
                name: classListModel.name,
              );
            }

            if (subject != null) {
              selectedSubjectList = BottomSheetSelectionModel(
                id: subject.id,
                name: subject.name,
              );
            }

            if (assignmentModel!.assignmentType.isNotEmpty) {
              selectedAssignmentType = getAssignmentTypeEnum(assignmentType: assignmentModel!.assignmentType);
            }

            if (assignmentModel!.submissionDate.isNotEmpty) {
              DateTimeConversion.convertStringToDate(assignmentModel!.submissionDate).toString().logOnString('submissionDate => ');
              selectedDate = DateTimeConversion.convertStringToDate(assignmentModel!.submissionDate);
              if (selectedDate != null) {
                dateOfLectureController.text = DateTimeConversion.convertDateIntoString(selectedDate!);
              }
            }

            if (assignmentModel!.assignmentURL.isNotEmpty) {
              fileURL = assignmentModel!.assignmentURL;
            }
          }
        }
      },
    );
    super.initState();
  }

  bool isValidate() => selectedClassList != null && selectedSubjectList != null && selectedDate != null && dateOfLectureController.text.isNotEmpty && fileURL != null && fileURL!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: assignmentModel != null ? 'Edit Assignment' : 'Add Assignment',
      ),
      body: Obx(
        () => assignmentController.loader.value
            ? Center(
                child: Loader(
                  color: AppColors.primaryColor,
                ),
              )
            : ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.width30,
                  vertical: Dimens.height36,
                ),
                children: [
                  /// select class-list
                  FieldWithClickEventHelper(
                    label: selectedClassList?.name ?? 'Select Class',
                    isValueFilled: selectedClassList != null && selectedClassList!.name.isNotEmpty,
                    isError: isError,
                    errorMessage: 'Select Class',
                    onTap: () async {
                      await showCommonBottomSheet(
                        context: context,
                        title: 'Select Class',
                        listOfItems: assignmentController.classList
                            .where(
                              (element) => faculty != null && faculty!.courseList != null && faculty!.courseList!.any((elementInner) => elementInner.id == element.course?.id),
                            )
                            .map(
                              (e) => BottomSheetSelectionModel(
                                id: e.id,
                                name: e.name,
                              ),
                            )
                            .toList(),
                        selectValue: selectedClassList,
                        onSubmit: (selectValue) {
                          setState(() {
                            selectedClassList = selectValue;
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: Dimens.height36),

                  /// select subject
                  FieldWithClickEventHelper(
                    label: selectedSubjectList?.name ?? 'Select Subject',
                    isValueFilled: selectedSubjectList != null && selectedSubjectList!.name.isNotEmpty,
                    isError: isError,
                    errorMessage: 'Select Subject',
                    onTap: () async {
                      await showCommonBottomSheet(
                        context: context,
                        title: 'Select Subject',
                        listOfItems: assignmentController.subjectList.isNotEmpty
                            ? assignmentController.subjectList
                                .where((element) {
                                  ClassListModel temp = assignmentController.classList.singleWhere((element) => element.id == selectedClassList?.id);
                                  return temp.course?.id == element.course?.id;
                                })
                                .map(
                                  (e) => BottomSheetSelectionModel(
                                    id: e.id,
                                    name: e.name,
                                  ),
                                )
                                .toList()
                            : [],
                        selectValue: selectedSubjectList,
                        onSubmit: (selectValue) {
                          setState(() {
                            selectedSubjectList = selectValue;
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: Dimens.height36),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimens.radius16,
                      ),
                      border: Border.all(
                        color: AppColors.lightTextColor.withAlpha((255 * 0.5).toInt()),
                        width: 0.5,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.width30,
                    ),
                    width: MediaQuery.sizeOf(context).width,
                    child: DropdownButton<AssignmentType>(
                      value: selectedAssignmentType,
                      isExpanded: true,
                      hint: AppTextTheme.textSize14(
                        label: 'Select Assignment Type',
                        color: AppColors.black.withAlpha(
                          (255 * 0.5).toInt(),
                        ),
                      ),
                      dropdownColor: AppColors.white,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.black,
                        size: Dimens.height36,
                      ),
                      // underline: null,
                      items: [
                        DropdownMenuItem<AssignmentType>(
                          value: AssignmentType.assignment,
                          child: AppTextTheme.textSize13(
                            label: 'Assignment',
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        DropdownMenuItem<AssignmentType>(
                          value: AssignmentType.journal,
                          child: AppTextTheme.textSize13(
                            label: 'Journal',
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        DropdownMenuItem<AssignmentType>(
                          value: AssignmentType.homeWork,
                          child: AppTextTheme.textSize13(
                            label: 'Home work',
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                      onChanged: (AssignmentType? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedAssignmentType = newValue;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: Dimens.height36),

                  /// select date
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      selectedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                        currentDate: selectedDate,
                        initialDate: selectedDate,
                      );
                      if (selectedDate != null) {
                        dateOfLectureController.text = DateTimeConversion.convertDateIntoString(selectedDate!);
                      }
                      setState(() {});
                    },
                    child: LabeledTextFormField(
                      controller: dateOfLectureController,
                      hintText: 'Select Submission Date',
                      enable: false,
                      suffix: Icon(
                        Icons.calendar_month_rounded,
                        size: Dimens.height32,
                        color: AppColors.lightTextColor.withAlpha((255 * 0.5).toInt()),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.height36),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      await Permission.storage.request();

                      if (selectedClassList == null) {
                        showErrorSnackBar(
                          context: context,
                          title: 'Select Class',
                        );
                        return;
                      }
                      if (selectedSubjectList == null) {
                        showErrorSnackBar(
                          context: context,
                          title: 'Select Subject',
                        );
                        return;
                      }
                      if (selectedDate == null) {
                        showErrorSnackBar(
                          context: context,
                          title: 'Select Submission Date',
                        );
                        return;
                      }

                      // if (await Permission.storage.isGranted) {
                      filePicker = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        withData: true,
                        type: FileType.custom,
                        allowedExtensions: [
                          "pdf",
                        ],
                      );
                      // }
                      setState(() {});

                      if (filePicker != null && filePicker!.files.isNotEmpty && filePicker!.files.single.path != null && filePicker!.files.single.path!.isNotEmpty) {
                        uploadLoader(true);
                        File file = File(filePicker!.files.single.path!);

                        ClassListModel? selectedClassListLocal = assignmentController.classList.firstWhereOrNull(
                          (element) => element.id == selectedClassList?.id,
                        );
                        Subject? selectedSubjectListLocal = assignmentController.subjectList.firstWhereOrNull(
                          (element) => element.id == selectedSubjectList?.id,
                        );
                        String facultyName = faculty != null ? '${faculty!.name.replaceAll(" ", "_")}_' : '';
                        String className = selectedClassListLocal != null ? '${selectedClassListLocal.name.replaceAll(" ", "_").replaceAll("-", "_")}_' : '';
                        String dateString = selectedDate != null ? DateTimeConversion.convertDateTimeIntoString(selectedDate!).replaceAll("-", "_") : '';
                        String subjectName = selectedSubjectListLocal != null ? '${selectedSubjectListLocal.name.replaceAll(" ", "_").replaceAll("-", "_")}_' : '';
                        String cloudFileName = '$subjectName$facultyName$className$dateString';
                        await supabase.storage.from(SupabaseClientKeys.assignmentBucketName).upload('$cloudFileName.pdf', file);
                        fileURL = supabase.storage.from(SupabaseClientKeys.assignmentBucketName).getPublicUrl('$cloudFileName.pdf');
                        uploadLoader(false);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.radius35,
                        ),
                        border: Border.all(
                          width: 1.5,
                          color: AppColors.black.withAlpha(
                            (255 * 0.15).toInt(),
                          ),
                        ),
                      ),
                      child: Obx(
                        () => uploadLoader.value
                            ? Center(
                                child: Loader(
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : fileURL != null && fileURL!.isNotEmpty
                                ? Center(
                                    child: Column(
                                      spacing: Dimens.height18,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Positioned(
                                              top: Dimens.height4,
                                              right: Dimens.width4,
                                              child: GestureDetector(
                                                behavior: HitTestBehavior.translucent,
                                                onTap: () {
                                                  setState(() {
                                                    filePicker = null;
                                                    fileURL = '';
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.cancel,
                                                  color: AppColors.red,
                                                  size: Dimens.height36,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: Dimens.height20,
                                                horizontal: Dimens.width20,
                                              ),
                                              // decoration: BoxDecoration(
                                              //   border: Border.all(
                                              //     color: AppColors.black,
                                              //     width: 1,
                                              //   ),
                                              // ),
                                              child: SvgPicture.asset(
                                                AssetsPaths.pdfSVG,
                                                alignment: Alignment.center,
                                                height: Dimens.height120,
                                                width: Dimens.width120,
                                                colorFilter: ColorFilter.mode(
                                                  AppColors.black,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (filePicker != null &&
                                            filePicker!.names.isNotEmpty &&
                                            filePicker!.names.first != null &&
                                            filePicker!.names.first!.isNotEmpty &&
                                            fileURL != null &&
                                            fileURL!.isNotEmpty)
                                          AppTextTheme.textSize13(
                                            label: filePicker!.names.first!,
                                            color: AppColors.black,
                                          ),
                                        if (fileURL != null && fileURL!.isNotEmpty) ...[
                                          SizedBox(height: Dimens.height30),
                                          GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: () {
                                              Get.toNamed(
                                                Routes.pdfView,
                                                arguments: fileURL,
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                AppTextTheme.textSize14(
                                                  label: 'Preview Assignment',
                                                  color: AppColors.black,
                                                ),
                                                SizedBox(width: Dimens.width12),
                                                SvgPicture.asset(
                                                  AssetsPaths.swipeRightSVG,
                                                  height: Dimens.height32,
                                                  width: Dimens.width40,
                                                  colorFilter: ColorFilter.mode(
                                                    AppColors.black,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  )
                                : AppTextTheme.textSize15(
                                    label: 'Upload Assignment',
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: Dimens.width12,
                      top: Dimens.height12,
                    ),
                    child: AppTextTheme.textSize13(
                      label: 'Note :- Please upload a PDF file only.',
                      maxLines: 3,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: Dimens.height125),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      setState(() {
                        isError = !isValidate();
                        isError.toString().logOnString('isError');
                      });

                      if (isError) return;

                      if (widget.arguments != null && widget.arguments is AssignmentModel && assignmentModel != null) {
                        ClassListModel? selectedClassListLocal = assignmentController.classList.firstWhereOrNull(
                          (element) => element.id == selectedClassList?.id,
                        );
                        Subject? selectedSubjectListLocal = assignmentController.subjectList.firstWhereOrNull(
                          (element) => element.id == selectedSubjectList?.id,
                        );

                        assignmentModel = AssignmentModel(
                          documentID: assignmentModel!.documentID,
                          id: assignmentModel!.id,
                          faculty: faculty ?? Faculty.empty(),
                          subject: selectedSubjectListLocal ?? Subject.empty(),
                          classListModel: selectedClassListLocal ?? ClassListModel.empty(),
                          studentList: selectedClassListLocal?.studentList ?? [],
                          submissionDate: dateOfLectureController.text.trim(),
                          assignmentURL: fileURL ?? '',
                          assignmentType: getAssignmentType(),
                        );

                        if (assignmentModel != null) {
                          await assignmentController.updateInAssignment(assignmentModel!);
                          Get.back<bool>(result: true);
                        }
                      } else {
                        ClassListModel? selectedClassListLocal = assignmentController.classList.firstWhereOrNull(
                          (element) => element.id == selectedClassList?.id,
                        );
                        Subject? selectedSubjectListLocal = assignmentController.subjectList.firstWhereOrNull(
                          (element) => element.id == selectedSubjectList?.id,
                        );
                        String facultyName = faculty != null ? '${faculty!.name.replaceAll(" ", "_")}_' : '';
                        String className = selectedClassListLocal != null ? '${selectedClassListLocal.name.replaceAll(" ", "_").replaceAll("-", "_")}_' : '';
                        String dateString = selectedDate != null ? DateTimeConversion.convertDateTimeIntoString(selectedDate!).replaceAll("-", "_") : '';
                        String subjectName = selectedSubjectListLocal != null ? '${selectedSubjectListLocal.name.replaceAll(" ", "_").replaceAll("-", "_")}_' : '';

                        String documentID = '$facultyName${faculty != null ? '${faculty!.id}_' : ''}$subjectName$className$dateString';
                        assignmentModel = AssignmentModel(
                          documentID: documentID,
                          id: assignmentController.globalAssignmentList.isNotEmpty ? getNewID(assignmentController.globalAssignmentList.map((e) => e.id).toList()) : 1,
                          faculty: faculty ?? Faculty.empty(),
                          subject: selectedSubjectListLocal ?? Subject.empty(),
                          classListModel: selectedClassListLocal ?? ClassListModel.empty(),
                          studentList: selectedClassListLocal?.studentList ?? [],
                          submissionDate: dateOfLectureController.text.trim(),
                          assignmentURL: fileURL ?? '',
                          assignmentType: getAssignmentType(),
                        );

                        if (assignmentModel != null) {
                          await assignmentController.writeInAssignment(assignmentModel!);
                          Get.back<bool>(result: true);
                        }
                      }
                    },
                    child: SubmitButtonHelper(
                        height: Dimens.height80,
                        width: MediaQuery.sizeOf(context).width,
                        child: Obx(
                          () => assignmentController.submitLoader.value
                              ? const ButtonLoader()
                              : AppTextTheme.textSize14(
                                  label: assignmentModel != null ? 'Edit Assignment' : 'Add Assignment',
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                        )),
                  )
                ],
              ),
      ),
    );
  }

  String getAssignmentType() {
    if (selectedAssignmentType == AssignmentType.assignment) {
      return 'assignment';
    } else if (selectedAssignmentType == AssignmentType.journal) {
      return 'journal';
    } else if (selectedAssignmentType == AssignmentType.homeWork) {
      return 'homeWork';
    } else {
      return '';
    }
  }

  AssignmentType getAssignmentTypeEnum({
    required String assignmentType,
  }) {
    if (assignmentType.toLowerCase() == 'assignment') {
      return AssignmentType.assignment;
    } else if (assignmentType.toLowerCase() == 'journal') {
      return AssignmentType.journal;
    } else if (assignmentType.toLowerCase() == 'homeWork') {
      return AssignmentType.homeWork;
    }
    return AssignmentType.assignment;
  }
}
