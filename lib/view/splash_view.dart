import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:present_unit/helper-widgets/loader/loader.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/database/storage_keys.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/routes/routes.dart';

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
        log(
          '$adminDetails',
          name: 'adminDetails',
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
                      child: Loader(
                        color: AppColors.black,
                      ),
                    )
                  : SizedBox(width: Dimens.width24,
                height: Dimens.height24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
