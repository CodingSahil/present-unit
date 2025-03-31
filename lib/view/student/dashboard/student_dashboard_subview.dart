import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:present_unit/controller/faculty/assignment_controller.dart';
import 'package:present_unit/controller/faculty/classes_with_attendance_controller.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/date-time-convert/date_time_conversion.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/class_list_for_attendance/class_list_for_attendance.dart';
import 'package:present_unit/models/navigation_models/common_models/list_view_navigation_models.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/faculty/dashboard/faculty_dashboard_subview.dart';
import 'package:present_unit/view/splash_view.dart';

class StudentDashboardSubview extends StatefulWidget {
  const StudentDashboardSubview({super.key});

  @override
  State<StudentDashboardSubview> createState() => _StudentDashboardSubviewState();
}

class _StudentDashboardSubviewState extends State<StudentDashboardSubview> {
  late final ClassesWithAttendanceController classesWithAttendanceController;
  late final AssignmentController assignmentController;
  List<ClassesForAttendanceModel> todaysLecture = [];

  @override
  void initState() {
    classesWithAttendanceController = Get.find<ClassesWithAttendanceController>();
    assignmentController = Get.find<AssignmentController>();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await classesWithAttendanceController.getClassesListStudent();
        await assignmentController.getAssignmentListStudent();
        if (classesWithAttendanceController.classesForAttendanceModel.isNotEmpty) {
          String todayDateString = DateTimeConversion.convertDateIntoString(DateTime.now());
          todaysLecture = classesWithAttendanceController.classesForAttendanceModel.where(
            (element) {
              return element.lectureDate == todayDateString;
            },
          ).toList();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: AppTextTheme.textSize16(
          label: 'Welcome, ${userDetails?.student?.name}',
          color: AppColors.white,
        ),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.width22,
              ),
              child: SvgPicture.asset(
                AssetsPaths.drawerSVG,
                colorFilter: ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
                height: Dimens.height40,
                width: Dimens.width40,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => classesWithAttendanceController.loader.value || assignmentController.loader.value
            ? Center(
                child: Loader(
                  color: AppColors.primaryColor,
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.height12,
                  horizontal: Dimens.width40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// today's lecture
                    SizedBox(height: Dimens.height20),
                    AppTextTheme.textSize25(
                      label: 'Today\'s Lecture',
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: Dimens.height20),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          Dimens.radius18,
                        ),
                        border: Border.all(
                          color: AppColors.black.withAlpha(
                            (255 * 0.15).toInt(),
                          ),
                          width: 1,
                        ),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.height12,
                          horizontal: Dimens.width8,
                        ),
                        itemCount: classesWithAttendanceController.globalClassesForAttendanceModel.length,
                        itemBuilder: (context, index) {
                          ClassesForAttendanceModel classForAttendanceModel = classesWithAttendanceController.globalClassesForAttendanceModel[index];
                          return LectureDetailsOnHomePage(
                            index: index,
                            className: classForAttendanceModel.classDetails.name,
                            isLast: index == (classesWithAttendanceController.globalClassesForAttendanceModel.length - 1),
                            startTime: classForAttendanceModel.startingTime,
                            endTime: classForAttendanceModel.endingTime,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: Dimens.height68),
                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: Dimens.height32),
                    //   child: Divider(
                    //     height: 1,
                    //     thickness: 0.5,
                    //     color: AppColors.black.withAlpha(
                    //       (255 * 0.5).toInt(),
                    //     ),
                    //   ),
                    // ),

                    /// Previous Lectures
                    InformationCard(
                      label: 'Previous Lectures',
                      count: classesWithAttendanceController.classesForAttendanceModel.length.toString(),
                      onTap: () {
                        Get.toNamed(
                          Routes.lectureCommonListView,
                          arguments: CommonLectureListModel(
                            label: 'Previous Lectures',
                            lectureList: classesWithAttendanceController.classesForAttendanceModel,
                          ),
                        );
                      },
                    ),
                    InformationCard(
                      label: 'Future Lectures',
                      count: classesWithAttendanceController.classesForAttendanceModel.length.toString(),
                      onTap: () {
                        Get.toNamed(
                          Routes.lectureCommonListView,
                          arguments: CommonLectureListModel(
                            label: 'Future Lectures',
                            lectureList: classesWithAttendanceController.classesForAttendanceModel,
                          ),
                        );
                      },
                    ),
                    InformationCard(
                      label: 'Previous Assignment',
                      count: assignmentController.assignmentList.length.toString(),
                      onTap: () {
                        Get.toNamed(
                          Routes.assignmentCommonListView,
                          arguments: CommonAssignmentListModel(
                            label: 'Previous Assignment',
                            assignmentList: assignmentController.assignmentList,
                          ),
                        );
                      },
                    ),
                    InformationCard(
                      label: 'Future Assignment',
                      count: assignmentController.assignmentList.length.toString(),
                      onTap: () {
                        Get.toNamed(
                          Routes.assignmentCommonListView,
                          arguments: CommonAssignmentListModel(
                            label: 'Future Assignment',
                            assignmentList: assignmentController.assignmentList,
                          ),
                        );
                      },
                    ),
                    // AppTextTheme.textSize25(
                    //   label: 'Home',
                    //   color: AppColors.black,
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}
