import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';

void showSuccessSnackBar({
  required BuildContext context,
  required String title,
  int? durationInMilliseconds,
}) {
  ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(
        milliseconds: durationInMilliseconds ?? 2000,
      ),
      backgroundColor: AppColors.green,
      content: AppTextTheme.textSize16(
        label: title,
        color: AppColors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

void showErrorSnackBar({
  required BuildContext context,
  required String title,
  int? durationInMilliseconds,
}) {
  ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(
        milliseconds: durationInMilliseconds ?? 2000,
      ),
      backgroundColor: AppColors.red,
      content: AppTextTheme.textSize14(
        label: title,
        color: AppColors.white,
        fontWeight: FontWeight.w500,
        maxLines: 2,
      ),
    ),
  );
}
