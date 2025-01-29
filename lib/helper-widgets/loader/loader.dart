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
    return CircularProgressIndicator(
      color: color ?? AppColors.primaryColor,
      strokeWidth: 1,
    );
  }
}

class ButtonLoader extends StatelessWidget {
  const ButtonLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.height24,
      width: Dimens.width24,
      child: Center(
        child: Loader(
          color: AppColors.white,
        ),
      ),
    );
  }
}
