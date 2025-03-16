import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/extension/string_print.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';
import 'package:present_unit/models/navigation_models/common_models/authentication_classes.dart';
import 'package:present_unit/routes/routes.dart';

UserDetails? userDetails;

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late GetStorage getStorage;
  RxBool loader = false.obs;

  @override
  void initState() {
    super.initState();
    getStorage = GetStorage();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await Future.delayed(
          const Duration(
            milliseconds: 500,
          ),
        );
        loader(true);
        var adminDetails = await getStorage.read(
          StorageKeys.adminDetails,
        );
        var facultyDetails = await getStorage.read(
          StorageKeys.facultyDetails,
        );
        var userType = await getStorage.read(
          StorageKeys.userType,
        );

        adminDetails.toString().logOnString('adminDetails');
        '$userType && ${userType.runtimeType}'.logOnString('userType');
        if (adminDetails != null) {
          userDetails = UserDetails(
            admin: Admin.fromJson(
              jsonDecode(
                adminDetails,
              ),'',
            ),
            faculty: null,
            userType: fetchUserType(
              userTypeString: userType.toString(),
            ),
          );

          await Future.delayed(
            const Duration(
              milliseconds: 1500,
            ),
          );
          loader(false);

          if (adminDetails != null && adminDetails.isNotEmpty) {
            Get.offAllNamed(Routes.adminDashboard);
          } else {
            Get.offAllNamed(Routes.login);
          }
        } else if (facultyDetails != null) {
          userDetails = UserDetails(
            admin: null,
            faculty: Faculty.fromJson(
              jsonDecode(facultyDetails),
              '',
            ),
            userType: fetchUserType(
              userTypeString: userType.toString(),
            ),
          );

          await Future.delayed(
            const Duration(
              milliseconds: 1500,
            ),
          );
          loader(false);

          if (facultyDetails != null && facultyDetails.isNotEmpty && userDetails != null) {
            Get.offAllNamed(Routes.facultyDashboard);
          } else {
            Get.offAllNamed(Routes.login);
          }
        } else {
          loader(false);
          Get.offAllNamed(Routes.login);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextTheme.textSize28(
              label: 'PresentUnit',
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
            AppTextTheme.textSize12(
              label: 'The Mobile App for Class Operation',
              color: AppColors.black,
            ),
            SizedBox(
              width: Dimens.width20,
              height: Dimens.height20,
            ),
            Obx(
              () => loader.value
                  ? SizedBox(
                      width: Dimens.width24,
                      height: Dimens.height24,
                      child: Center(
                        child: Loader(
                          color: AppColors.black,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: Dimens.width24,
                      height: Dimens.height24,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
