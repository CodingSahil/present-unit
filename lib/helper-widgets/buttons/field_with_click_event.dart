import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';

class FieldWithClickEventHelper extends StatelessWidget {
  const FieldWithClickEventHelper({super.key, required this.label, required this.onTap, required this.isValueFilled, required this.isError, this.roundedIcon, this.errorMessage});

  final String label;
  final void Function() onTap;
  final bool isValueFilled;
  final IconData? roundedIcon;
  final bool isError;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Dimens.radius16,
              ),
              border: Border.all(
                color: AppColors.lightTextColor.withAlpha((255 * 0.5).toInt()),
                width: 0.5,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: Dimens.height24,
              horizontal: Dimens.width30,
            ),
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTextTheme.textSize14(
                  label: label,
                  color: isError
                      ? AppColors.red
                      : AppColors.black.withAlpha(
                          (255 * (isValueFilled ? 1 : 0.5)).toInt(),
                        ),
                ),
                Icon(
                  roundedIcon ?? Icons.keyboard_arrow_down_rounded,
                  color: AppColors.black,
                  size: Dimens.height36,
                ),
              ],
            ),
          ),
          if (isError && errorMessage != null && errorMessage!.isNotEmpty)
            AppTextTheme.textSize12(
              label: errorMessage!,
              color: AppColors.red,
            ),
        ],
      ),
    );
  }
}
