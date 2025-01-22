import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';

class LabeledTextFormField extends StatelessWidget {
  final String? labelText;
  final String? errorMessage;
  final String hintText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool enable;
  final bool isError;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction textInputAction;
  final VoidCallback? onEditingComplete;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  final bool isCurrencyBeforeText;
  final bool showBorder;
  final bool showRedTextColor;
  final bool isAmountField;
  final bool isOptionalFields;
  final bool isCancel;
  final bool isPasswordField;
  final void Function()? onClose;

  const LabeledTextFormField({
    super.key,
    this.labelText,
    required this.controller,
    required this.hintText,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    this.errorMessage,
    this.onEditingComplete,
    this.enable = true,
    this.isError = false,
    this.isCurrencyBeforeText = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.showBorder = true,
    this.textCapitalization = TextCapitalization.sentences,
    this.showRedTextColor = false,
    this.isAmountField = false,
    this.isOptionalFields = false,
    this.isCancel = false,
    this.isPasswordField = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    bool isEyeOpen = false;
    return StatefulBuilder(
      builder: (context, setPasswordState) {
        return TextFormField(
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          enabled: enable,
          controller: controller,
          cursorColor: AppColors.black,
          cursorWidth: 1,
          keyboardType: textInputType,
          maxLines: maxLines,
          obscureText: isPasswordField && !isEyeOpen,
          obscuringCharacter: '*',
          onEditingComplete: onEditingComplete,
          inputFormatters: isAmountField
              ? <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ]
              : textInputType == TextInputType.emailAddress
                  ? <TextInputFormatter>[
                      AllLowerCaseCaseTextFormatter(),
                    ]
                  : textInputType == TextInputType.phone
                      ? <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(10),
                        ]
                      : textInputType == TextInputType.url
                          ? <TextInputFormatter>[
                              NormalCaseTextFormatter(),
                            ]
                          : <TextInputFormatter>[
                              UpperCaseTextFormatter(),
                            ],
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.normal,
            fontSize: Dimens.textSize24,
            color: showRedTextColor ? AppColors.red : AppColors.black,
          ),
          decoration: InputDecoration(
            contentPadding: contentPadding,
            filled: !enable,
            labelText: labelText != null && labelText!.isNotEmpty
                ? '$labelText ${isOptionalFields ? '(Optional)' : ''}'
                : null,
            hintText: hintText,
            errorText: isError ? errorMessage ?? '$hintText is required' : null,
            errorStyle: GoogleFonts.oswald(
              fontWeight: FontWeight.normal,
              fontSize: Dimens.textSize24,
              color: AppColors.red,
            ),
            prefixText: isCurrencyBeforeText ? '₹ ' : null,
            prefixStyle: TextStyle(
              color: showRedTextColor
                  ? AppColors.red
                  : AppColors.lightTextColor.withAlpha((255 * 0.5).toInt()),
            ),
            labelStyle: GoogleFonts.oswald(
              fontWeight: FontWeight.normal,
              fontSize: Dimens.textSize24,
              color: AppColors.black,
            ),
            hintStyle: GoogleFonts.oswald(
              fontWeight: FontWeight.normal,
              fontSize: Dimens.textSize24,
              color: AppColors.black,
            ),
            suffixIcon: isCancel
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onClose,
                    child: Icon(
                      Icons.cancel,
                      color: AppColors.red,
                      size: Dimens.height28,
                    ),
                  )
                : isPasswordField
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.height28,
                          horizontal: Dimens.width36,
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setPasswordState(() => isEyeOpen = !isEyeOpen);
                          },
                          child: isEyeOpen
                              ? SvgPicture.asset(
                                  AssetsPaths.eyeOpenSVG,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.black.withAlpha(
                                      (255 * 0.75).toInt(),
                                    ),
                                    BlendMode.srcIn,
                                  ),
                                )
                              : SvgPicture.asset(
                                  AssetsPaths.eyeCloseSVG,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.black.withAlpha(
                                      (255 * 0.75).toInt(),
                                    ),
                                    BlendMode.srcIn,
                                  ),
                                ),
                        ),
                      )
                    : null,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Dimens.radius20,
              ),
              borderSide: BorderSide(
                color:
                    showBorder ? AppColors.primaryColor : AppColors.transparent,
                width: showBorder ? Dimens.width2 : 0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Dimens.radius20,
              ),
              borderSide: BorderSide(
                color: showBorder
                    ? isError
                        ? AppColors.red
                        : AppColors.lightTextColor
                            .withAlpha((255 * 0.5).toInt())
                    : AppColors.transparent,
                width: showBorder ? Dimens.width2 : 0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Dimens.radius20,
              ),
              borderSide: BorderSide(
                color: AppColors.lightTextColor.withAlpha((255 * 0.5).toInt()),
                width: Dimens.width2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Dimens.radius20,
              ),
              borderSide: BorderSide(
                color: AppColors.red,
                width: Dimens.width2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Dimens.radius20,
              ),
              borderSide: BorderSide(
                color: AppColors.red,
                width: Dimens.width2,
              ),
            ),
          ),
        );
      },
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

class NormalCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text,
      selection: newValue.selection,
    );
  }
}

class AllUpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class AllLowerCaseCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  // if (value.trim().isEmpty) return "";
  // return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  List<String> words = value.split(' ');
  List<String> capitalizedWords = words.map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1);
    } else {
      return word;
    }
  }).toList();
  return capitalizedWords.join(' ');
}
