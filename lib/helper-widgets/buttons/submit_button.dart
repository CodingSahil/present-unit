import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';

class SubmitButtonHelper extends StatelessWidget {
  const SubmitButtonHelper({
    super.key,
    required this.width,
    this.height,
    this.padding,
    this.margin,
    required this.child,
  });

  final Widget child;
  final double width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      margin: margin,
      padding: padding != null
          ? EdgeInsets.symmetric(
              vertical: Dimens.height18,
            )
          : null,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(
          Dimens.radius15,
        ),
      ),
      /// preferred text size 16
      child: child,
    );
  }
}
