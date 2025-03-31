import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/common_enums.dart';
import 'package:present_unit/helpers/enum/faculty_enum.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/models/class_list/class_list_models.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/faculty/assignment/assignment_list_view.dart';
import 'package:present_unit/view/faculty/classes/lecture_list_view.dart';
import 'package:present_unit/view/splash_view.dart';
import 'package:present_unit/view/student/dashboard/student_dashboard_subview.dart';

class StudentDashboardView extends StatefulWidget {
  const StudentDashboardView({super.key});

  @override
  State<StudentDashboardView> createState() => _StudentDashboardViewState();
}

class _StudentDashboardViewState extends State<StudentDashboardView> {
  int selectedIndex = 0;
  RxBool logoutLoader = false.obs;
  bool isStudentDetailsFilled = false;
  Student? student;
  FacultyUserModules selectTab = FacultyUserModules.home;

  @override
  void initState() {
    if (userDetails != null && userDetails!.student != null) {
      student = userDetails!.student!;
    }
    isStudentDetailsFilled = student != null;
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
            top: MediaQuery
                .sizeOf(context)
                .height * 0.04 + (isIOS ? MediaQuery
                .sizeOf(context)
                .height * 0.035 : 0),
            bottom: MediaQuery
                .sizeOf(context)
                .height * 0.02 + (isIOS ? MediaQuery
                .sizeOf(context)
                .height * 0.01 : 0),
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
                  if (isStudentDetailsFilled)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextTheme.textSize20(
                              label: student!.name,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                            AppTextTheme.textSize12(
                              label: student!.email,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black.withAlpha(
                                (255 * 0.4).toInt(),
                              ),
                            ),
                            AppTextTheme.textSize12(
                              label: student!.mobileNumber,
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
                          height: MediaQuery
                              .sizeOf(context)
                              .height * 0.06,
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
                              arguments: UserType.student,
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
                      width: MediaQuery
                          .sizeOf(context)
                          .width * 0.65,
                      height: MediaQuery
                          .sizeOf(context)
                          .height * 0.05,
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimens.width24,
                      ),
                      padding: EdgeInsets.zero,
                      child: Obx(
                            () =>
                        logoutLoader.value
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: AppColors.black.withAlpha(
              (255 * 0.25).toInt(),
            ),
          ),
          NavigationBar(
            backgroundColor: AppColors.bottomNavigationBarColor,
            indicatorColor: AppColors.primaryColor,
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) =>
                setState(() {
                  selectedIndex = value;
                  if (value == 0) {
                    selectTab = FacultyUserModules.home;
                  }
                  if (value == 1) {
                    selectTab = FacultyUserModules.classes;
                  }
                  if (value == 2) {
                    selectTab = FacultyUserModules.assignment;
                  }
                }),
            destinations: [
              NavigationDestination(
                icon: SvgPicture.asset(
                  AssetsPaths.homeSVG,
                  height: Dimens.height40,
                  width: Dimens.width40,
                  colorFilter: ColorFilter.mode(
                    AppColors.unselectedColor,
                    BlendMode.srcIn,
                  ),
                ),
                selectedIcon: SvgPicture.asset(
                  AssetsPaths.homeSVG,
                  height: Dimens.height40,
                  width: Dimens.width40,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  AssetsPaths.classesSVG,
                  height: Dimens.height40,
                  width: Dimens.width40,
                  colorFilter: ColorFilter.mode(
                    AppColors.unselectedColor,
                    BlendMode.srcIn,
                  ),
                ),
                selectedIcon: SvgPicture.asset(
                  AssetsPaths.classesSVG,
                  height: Dimens.height40,
                  width: Dimens.width40,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Lecture',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  AssetsPaths.assignmentSVG,
                  height: Dimens.height40,
                  width: Dimens.width40,
                  colorFilter: ColorFilter.mode(
                    AppColors.unselectedColor,
                    BlendMode.srcIn,
                  ),
                ),
                selectedIcon: SvgPicture.asset(
                  AssetsPaths.assignmentSVG,
                  height: Dimens.height40,
                  width: Dimens.width40,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Assignment',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget viewForSelectedTab({
    required FacultyUserModules bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case FacultyUserModules.home:
        return const StudentDashboardSubview();

      case FacultyUserModules.classes:
        return const ClassListForAttendanceView();

      case FacultyUserModules.assignment:
        return const AssignmentListView();
    }
  }
}
