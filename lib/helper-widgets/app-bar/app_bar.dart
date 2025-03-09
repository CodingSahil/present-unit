import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';

PreferredSizeWidget commonAppBarPreferred({
  required String label,
  bool isBack = true,
  bool isAdd = true,
  void Function()? onTap,
PreferredSizeWidget? bottom,
}) {
  return AppBar(
    backgroundColor: AppColors.primaryColor,
    centerTitle: true,
    automaticallyImplyLeading: false,
    leading: isBack
        ? GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.back();
      },
      child: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.white,
        size: Dimens.width36,
      ),
    )
        : null,
    title: AppTextTheme.textSize16(
      label: label,
      color: AppColors.white,
    ),
    actions: [
      if (isAdd && onTap != null)
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Icon(
            Icons.add,
            color: AppColors.white,
            size: Dimens.width44,
          ),
        ),
      SizedBox(width: Dimens.width28),
    ],
    bottom: bottom,
  );
}

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({
    super.key,
    required this.label,
    this.isBack = true,
    this.isAdd = true,
    this.onTap,
  });

  final String label;
  final bool isBack;
  final bool isAdd;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: isBack
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
                size: Dimens.width36,
              ),
            )
          : null,
      title: AppTextTheme.textSize16(
        label: label,
        color: AppColors.white,
      ),
      actions: [
        if (isAdd && onTap != null)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: Icon(
              Icons.add,
              color: AppColors.white,
              size: Dimens.width44,
            ),
          ),
        SizedBox(width: Dimens.width28),
      ],
    );
  }
}
