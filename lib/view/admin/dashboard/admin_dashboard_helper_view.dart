import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/enum/admin_enum.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';

class AdminDashboardHelperView extends StatefulWidget {
  const AdminDashboardHelperView({
    super.key,
    required this.selectTab,
    required this.admin,
  });

  final AdminBottomNavigationBarEnums selectTab;
  final Admin? admin;

  @override
  State<AdminDashboardHelperView> createState() =>
      _AdminDashboardHelperViewState();
}

class _AdminDashboardHelperViewState extends State<AdminDashboardHelperView> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: AppTextTheme.textSize16(
            label: 'Welcome ${widget.admin?.name}',
            color: AppColors.white,
          ),
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.width22,),
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
        Center(
          child: AppTextTheme.textSize20(
            label: titleForBottomNavigationBarEnums(
              bottomNavigationBarEnums: widget.selectTab,
            ),
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
