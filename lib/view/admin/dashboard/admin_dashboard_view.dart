import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/controller/admin/course_controller.dart';
import 'package:present_unit/helper-widgets/buttons/submit_button.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/admin_enum.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/routes/routes.dart';
import 'package:present_unit/view/admin/dashboard/admin_dashboard_helper_view.dart';
import 'package:present_unit/view/admin/dashboard/course_helper_view.dart';

import 'faculty_helper_view.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  late CourseController courseController;
  late GetStorage getStorage;
  AdminBottomNavigationBarEnums selectTab = AdminBottomNavigationBarEnums.home;
  RxBool loader = false.obs;
  RxBool logoutLoader = false.obs;
  bool isAdminDetailsFilled = false;

  Admin? admin;

  @override
  void initState() {
    super.initState();

    courseController = Get.find<CourseController>();
    getStorage = GetStorage();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        loader(true);
        await courseController.getListOfCourse(
          context: context,
        );
        var adminDetails = getStorage.read(StorageKeys.adminDetails);
        admin = Admin.fromJson(
          jsonDecode(
            adminDetails,
          ),
        );
        isAdminDetailsFilled = adminDetails != null;
        loader(false);
      },
    );
  }

  String titleForBottomNavigationBarEnums({
    required AdminBottomNavigationBarEnums bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case AdminBottomNavigationBarEnums.home:
        return LabelStrings.home;
      case AdminBottomNavigationBarEnums.course:
        return LabelStrings.course;
      case AdminBottomNavigationBarEnums.classList:
        return LabelStrings.classList;
      case AdminBottomNavigationBarEnums.faculty:
        return LabelStrings.faculty;
      case AdminBottomNavigationBarEnums.subject:
        return LabelStrings.subject;
    }
  }

  String iconForBottomNavigationBarEnums({
    required AdminBottomNavigationBarEnums bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case AdminBottomNavigationBarEnums.home:
        return AssetsPaths.homeSVG;
      case AdminBottomNavigationBarEnums.course:
        return AssetsPaths.courseSVG;
      case AdminBottomNavigationBarEnums.classList:
        return AssetsPaths.homeSVG;
      case AdminBottomNavigationBarEnums.faculty:
        return AssetsPaths.facultySVG;
      case AdminBottomNavigationBarEnums.subject:
        return AssetsPaths.homeSVG;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: viewForSelectedTab(
        bottomNavigationBarEnums: selectTab,
      ),
      drawer: Drawer(
        backgroundColor: AppColors.white,
        child: Padding(
          padding: EdgeInsets.only(
            left: Dimens.width30,
            right: Dimens.width30,
            top: MediaQuery.sizeOf(context).height * 0.04 +
                (isIOS ? MediaQuery.sizeOf(context).height * 0.035 : 0),
            bottom: MediaQuery.sizeOf(context).height * 0.02 +
                (isIOS ? MediaQuery.sizeOf(context).height * 0.01 : 0),
          ),
          child: StatefulBuilder(
            builder: (context, setDrawerState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isAdminDetailsFilled)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextTheme.textSize20(
                              label: admin!.name,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                            AppTextTheme.textSize12(
                              label: admin!.email,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black.withAlpha(
                                (255 * 0.4).toInt(),
                              ),
                            ),
                            AppTextTheme.textSize12(
                              label: admin!.mobileNumber,
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
                            Get.toNamed(
                              Routes.courseView,
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AssetsPaths.courseSVG,
                                height: Dimens.height34,
                                width: Dimens.width34,
                                colorFilter: ColorFilter.mode(
                                  AppColors.black.withAlpha((255 * 0.4).toInt()),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: Dimens.width24),
                              AppTextTheme.textSize16(
                                label: LabelStrings.course,
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
                        Row(
                          children: [
                            SvgPicture.asset(
                              AssetsPaths.facultySVG,
                              height: Dimens.height34,
                              width: Dimens.width34,
                              colorFilter: ColorFilter.mode(
                                AppColors.black.withAlpha((255 * 0.4).toInt()),
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: Dimens.width24),
                            AppTextTheme.textSize16(
                              label: LabelStrings.faculty,
                              color:
                                  AppColors.black.withAlpha((255 * 0.4).toInt()),
                            ),
                          ],
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
                        Row(
                          children: [
                            SvgPicture.asset(
                              AssetsPaths.classSVG,
                              height: Dimens.height34,
                              width: Dimens.width34,
                              colorFilter: ColorFilter.mode(
                                AppColors.black.withAlpha((255 * 0.4).toInt()),
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: Dimens.width24),
                            AppTextTheme.textSize16(
                              label: LabelStrings.classList,
                              color:
                                  AppColors.black.withAlpha((255 * 0.4).toInt()),
                            ),
                          ],
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
                            Get.toNamed(
                              Routes.subjectView,
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AssetsPaths.subjectSVG,
                                height: Dimens.height34,
                                width: Dimens.width34,
                                colorFilter: ColorFilter.mode(
                                  AppColors.black.withAlpha((255 * 0.4).toInt()),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: Dimens.width24),
                              AppTextTheme.textSize16(
                                label: LabelStrings.subject,
                                color: AppColors.black
                                    .withAlpha((255 * 0.4).toInt()),
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
                      getStorage.erase();
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
      bottomNavigationBar: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.only(
          bottom: isIOS ? Dimens.height50 : 0,
        ),
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height * 0.08,
          maxHeight: MediaQuery.sizeOf(context).height * 0.1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            iconAndTitleHelper(
              bottomNavigationBarEnums: AdminBottomNavigationBarEnums.home,
            ),
            iconAndTitleHelper(
              bottomNavigationBarEnums: AdminBottomNavigationBarEnums.course,
            ),
            iconAndTitleHelper(
              bottomNavigationBarEnums: AdminBottomNavigationBarEnums.faculty,
            ),
          ],
        ),
      ),
    );
  }

  Widget iconAndTitleHelper({
    required AdminBottomNavigationBarEnums bottomNavigationBarEnums,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          selectTab = bottomNavigationBarEnums;
        });
      },
      child: Column(
        children: [
          SvgPicture.asset(
            iconForBottomNavigationBarEnums(
              bottomNavigationBarEnums: bottomNavigationBarEnums,
            ),
            height: Dimens.height40,
            width: Dimens.width40,
            colorFilter: ColorFilter.mode(
              selectTab == bottomNavigationBarEnums
                  ? AppColors.primaryColor
                  : AppColors.unselectedColor,
              BlendMode.srcIn,
            ),
          ),
          AppTextTheme.textSize14(
            label: titleForBottomNavigationBarEnums(
              bottomNavigationBarEnums: bottomNavigationBarEnums,
            ),
            color: selectTab == bottomNavigationBarEnums
                ? AppColors.primaryColor
                : AppColors.unselectedColor,
          ),
        ],
      ),
    );
  }

  Widget viewForSelectedTab({
    required AdminBottomNavigationBarEnums bottomNavigationBarEnums,
  }) {
    switch (bottomNavigationBarEnums) {
      case AdminBottomNavigationBarEnums.home:
        return Obx(
          () => loader.value
              ? Loader(
                  color: AppColors.primaryColor,
                )
              : AdminDashboardHelperView(
                  selectTab: bottomNavigationBarEnums,
                  admin: admin,
                ),
        );

      case AdminBottomNavigationBarEnums.course:
        return CourseHelperView(
          courseController: courseController,
          isAppBarRequire: true,
          onRefresh: () async {
            await courseController.getListOfCourse(
              context: context,
            );
            setState(() {});
          },
        );

      case AdminBottomNavigationBarEnums.faculty:
        return FacultyHelperView(
          isAppBarRequire: true,
          onRefresh: () async {
            // await courseController.getListOfCourse(
            //   context: context,
            // );
            setState(() {});
          },
        );

      default:
        return AdminDashboardHelperView(
          selectTab: bottomNavigationBarEnums,
          admin: admin,
        );
    }
  }
}
