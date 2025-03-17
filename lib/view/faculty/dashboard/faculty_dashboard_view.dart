import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/helper-widgets/bottom_nav_bar.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/common_enums.dart';
import 'package:present_unit/helpers/enum/faculty_enum.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/faculty/assignment/assignment_list_view.dart';
import 'package:present_unit/view/faculty/classes/lecture_list_view.dart';
import 'package:present_unit/view/faculty/dashboard/faculty_dashboard_subview.dart';
import 'package:present_unit/view/splash_view.dart';

class FacultyDashboardView extends StatefulWidget {
  const FacultyDashboardView({super.key});

  @override
  State<FacultyDashboardView> createState() => _FacultyDashboardViewState();
}

class _FacultyDashboardViewState extends State<FacultyDashboardView> {
  /// bottom navigation

  RxBool logoutLoader = false.obs;
  int selectedIndex = 0;
  FacultyUserModules selectTab = FacultyUserModules.home;
  bool isFacultyDetailsFilled = userDetails != null && userDetails!.faculty != null;
  Faculty? faculty;

  @override
  void initState() {
    if (isFacultyDetailsFilled) {
      faculty = userDetails!.faculty!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: viewForSelectedTab(
        bottomNavigationBarEnums: selectTab,
      ),
      drawer: Drawer(
        backgroundColor: AppColors.white,
        child: Padding(
          padding: EdgeInsets.only(
            left: Dimens.width30,
            right: Dimens.width30,
            top: MediaQuery.sizeOf(context).height * 0.04 + (isIOS ? MediaQuery.sizeOf(context).height * 0.035 : 0),
            bottom: MediaQuery.sizeOf(context).height * 0.02 + (isIOS ? MediaQuery.sizeOf(context).height * 0.01 : 0),
          ),
          child: StatefulBuilder(
            builder: (context, setDrawerState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppTextTheme.textSize32(
                        label: 'Present',
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      AppTextTheme.textSize32(
                        label: 'Unit',
                        color: Color(0xfffcb103),
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.height18),
                  if (isFacultyDetailsFilled)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextTheme.textSize20(
                              label: faculty!.name,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                            AppTextTheme.textSize12(
                              label: faculty!.email,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black.withAlpha(
                                (255 * 0.4).toInt(),
                              ),
                            ),
                            AppTextTheme.textSize12(
                              label: faculty!.mobileNumber,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black.withAlpha(
                                (255 * 0.4).toInt(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.height18),
                        Divider(
                          color: AppColors.black.withAlpha(
                            (255 * 0.4).toInt(),
                          ),
                          height: 1,
                          thickness: 0.5,
                        ),
                        SizedBox(height: Dimens.height18),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.06,
                        ),
                      ],
                    ),
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.pop(context);
                            Get.toNamed(
                              Routes.classesForAttendance,
                              arguments: true,
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AssetsPaths.classesSVG,
                                height: Dimens.height34,
                                width: Dimens.width34,
                                colorFilter: ColorFilter.mode(
                                  AppColors.black.withAlpha((255 * 0.4).toInt()),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: Dimens.width24),
                              AppTextTheme.textSize16(
                                label: 'Lecture',
                                color: AppColors.black.withAlpha(
                                  (255 * 0.4).toInt(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimens.height28),
                        Divider(
                          color: AppColors.black.withAlpha(
                            (255 * 0.4).toInt(),
                          ),
                          height: 1,
                          thickness: 0.5,
                        ),
                        SizedBox(height: Dimens.height28),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.pop(context);
                            Get.toNamed(
                              Routes.assignmentForAttendance,
                              arguments: true,
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AssetsPaths.assignmentSVG,
                                height: Dimens.height34,
                                width: Dimens.width34,
                                colorFilter: ColorFilter.mode(
                                  AppColors.black.withAlpha((255 * 0.4).toInt()),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: Dimens.width24),
                              AppTextTheme.textSize16(
                                label: 'Assignment',
                                color: AppColors.black.withAlpha((255 * 0.4).toInt()),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimens.height28),
                        Divider(
                          color: AppColors.black.withAlpha(
                            (255 * 0.4).toInt(),
                          ),
                          height: 1,
                          thickness: 0.5,
                        ),
                        SizedBox(height: Dimens.height28),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            Navigator.pop(context);
                            Get.toNamed(
                              Routes.changePasswordView,
                              arguments: UserType.faculty,
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AssetsPaths.changePasswordSVG,
                                height: Dimens.height34,
                                width: Dimens.width34,
                                colorFilter: ColorFilter.mode(
                                  AppColors.black.withAlpha((255 * 0.4).toInt()),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: Dimens.width24),
                              AppTextTheme.textSize16(
                                label: 'Change Password',
                                color: AppColors.black.withAlpha((255 * 0.4).toInt()),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      logoutLoader(true);
                      GetStorage().erase();
                      await Future.delayed(
                        const Duration(
                          seconds: 1,
                        ),
                      );
                      logoutLoader(false);
                      Get.offAllNamed(Routes.login);
                    },
                    child: SubmitButtonHelper(
                      width: MediaQuery.sizeOf(context).width * 0.65,
                      height: MediaQuery.sizeOf(context).height * 0.05,
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimens.width24,
                      ),
                      padding: EdgeInsets.zero,
                      child: Obx(
                        () => logoutLoader.value
                            ? const ButtonLoader()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppTextTheme.textSize16(
                                    label: 'Log Out',
                                    color: AppColors.white,
                                  ),
                                  SizedBox(width: Dimens.width16),
                                  Icon(
                                    Icons.logout,
                                    color: AppColors.white,
                                    size: Dimens.height40,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        children: [
          iconAndTitleHelper(bottomNavigationBarEnums: FacultyUserModules.home, numberOfTab: 3),
          iconAndTitleHelper(bottomNavigationBarEnums: FacultyUserModules.classes, numberOfTab: 3),
          iconAndTitleHelper(bottomNavigationBarEnums: FacultyUserModules.assignment, numberOfTab: 3),
        ],
      ),
    );
  }

  Widget viewForSelectedTab({
    required FacultyUserModules bottomNavigationBarEnums,
  }) {
    // List<int> studentList = classListController.classList
    //     .map(
    //       (e) => e.studentList?.length ?? 0,
    // )
    //     .toList();
    // num totalStudents = studentList.isNotEmpty
    //     ? num.parse(
    //   studentList
    //       .reduce(
    //         (value, element) => value + element,
    //   )
    //       .toString(),
    // )
    //     : 0;
    // num totalCourses = courseController.courseList.length;
    // num totalFaculty = facultyController.facultyList.length;
    // num totalSubject = subjectController.subjectList.length;
    // num totalClass = classListController.classList.length;

    switch (bottomNavigationBarEnums) {
      case FacultyUserModules.home:
        return const FacultyDashboardSubview();

      case FacultyUserModules.classes:
        return const ClassListForAttendanceView();

      case FacultyUserModules.assignment:
        return const AssignmentListView();
    }
  }

  Widget iconAndTitleHelper({
    required FacultyUserModules bottomNavigationBarEnums,
    required int numberOfTab,
  }) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / numberOfTab,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            selectTab = bottomNavigationBarEnums;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimens.height16,
            horizontal: Dimens.width24,
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                iconForBottomNavigationBarEnums(
                  bottomNavigationBarEnums: bottomNavigationBarEnums,
                ),
                height: Dimens.height40,
                width: Dimens.width40,
                colorFilter: ColorFilter.mode(
                  selectTab == bottomNavigationBarEnums ? AppColors.primaryColor : AppColors.unselectedColor,
                  BlendMode.srcIn,
                ),
              ),
              AppTextTheme.textSize14(
                label: titleForBottomNavigationBarEnums(
                  bottomNavigationBarEnums: bottomNavigationBarEnums,
                ),
                color: selectTab == bottomNavigationBarEnums ? AppColors.primaryColor : AppColors.unselectedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String iconForBottomNavigationBarEnums({
    required FacultyUserModules bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case FacultyUserModules.home:
        return AssetsPaths.homeSVG;
      case FacultyUserModules.classes:
        return AssetsPaths.classesSVG;
      case FacultyUserModules.assignment:
        return AssetsPaths.assignmentSVG;
    }
  }

  String titleForBottomNavigationBarEnums({
    required FacultyUserModules bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case FacultyUserModules.home:
        return 'Home';
      case FacultyUserModules.classes:
        return 'Class';
      case FacultyUserModules.assignment:
        return 'Assignment';
    }
  }
}
