import 'package:flutter/material.dart';
import 'package:present_unit/helper-widgets/text-field/labled_textform_field.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';

class AppTextFormFieldsWithLabel extends StatefulWidget {
  const AppTextFormFieldsWithLabel({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.isError,
    required this.onChanged,
    required this.onFieldSubmitted,
    this.isPasswordField = false,
    this.errorMessage,
  });

  final TextEditingController textEditingController;
  final String hintText;
  final String? errorMessage;
  final bool isError;
  final bool isPasswordField;
  final void Function(String value) onChanged;
  final void Function(String value) onFieldSubmitted;

  @override
  State<AppTextFormFieldsWithLabel> createState() => _AppTextFormFieldsWithLabelState();
}

class _AppTextFormFieldsWithLabelState extends State<AppTextFormFieldsWithLabel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: Dimens.width6),
          child: AppTextTheme.textSize14(
            label: widget.hintText,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: Dimens.height12),
        LabeledTextFormField(
          controller: widget.textEditingController,
          hintText: widget.hintText.toLowerCase().contains('enter') ? widget.hintText : 'Enter ${widget.hintText}',
          isError: widget.isError,
          errorMessage: widget.errorMessage != null && widget.errorMessage!.isNotEmpty ? widget.errorMessage : null,
          isPasswordField: widget.isPasswordField,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
        ),
      ],
    );
  }
}
