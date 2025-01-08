import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';

class SubmitButtonHelper extends StatelessWidget {
  const SubmitButtonHelper({
    super.key,
    required this.child,
    required this.width,
  });

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      padding: EdgeInsets.symmetric(
        vertical: Dimens.height18,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(
          Dimens.radius15,
        ),
      ),
      child: child,
    );
  }
}
