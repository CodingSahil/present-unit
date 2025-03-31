import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.height28,
      width: Dimens.width28,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primaryColor,
        strokeWidth: 1.5,
      ),
    );
  }
}

class ButtonLoader extends StatelessWidget {
  const ButtonLoader({
    super.key,
    this.loaderColor,
    this.height,
    this.width,
  });

  final Color? loaderColor;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Dimens.height24,
      width: width ?? Dimens.width24,
      child: Center(
        child: Loader(
          color: loaderColor ?? AppColors.white,
        ),
      ),
    );
  }
}
