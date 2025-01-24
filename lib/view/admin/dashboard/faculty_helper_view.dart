import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/routes/routes.dart';

class FacultyHelperView extends StatefulWidget {
  const FacultyHelperView({
    super.key,
    required this.isAppBarRequire,
    required this.onRefresh,
  });

  final bool isAppBarRequire;
  final Future<void> Function() onRefresh;

  @override
  State<FacultyHelperView> createState() => _FacultyHelperViewState();
}

class _FacultyHelperViewState extends State<FacultyHelperView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.isAppBarRequire)
          CommonAppBar(
            label: LabelStrings.faculty,
            isBack: false,
            onTap: () async {
              var result = await Get.toNamed(Routes.addEditFaculty);
              if (result is bool && result) {
                await widget.onRefresh();
              }
            },
          ),
        Expanded(
          child: Center(
            child: AppTextTheme.textSize16(
              label: LabelStrings.noData,
            ),
          ),
        ),
      ],
    );
  }
}
