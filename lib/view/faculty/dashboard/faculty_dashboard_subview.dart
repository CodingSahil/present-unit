import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/view/splash_view.dart';

class FacultyDashboardSubview extends StatefulWidget {
  const FacultyDashboardSubview({super.key});

  @override
  State<FacultyDashboardSubview> createState() => _FacultyDashboardSubviewState();
}

class _FacultyDashboardSubviewState extends State<FacultyDashboardSubview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: AppTextTheme.textSize16(
          label: 'Welcome, ${userDetails?.faculty?.name}',
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
      body: Center(
        child: AppTextTheme.textSize25(
          label: 'Home',
          color: AppColors.black,
        ),
      ),
    );
  }
}
