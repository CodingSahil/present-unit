import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/labels/label_strings.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/main.dart';
import 'package:present_unit/models/navigation_models/common_models/bottomsheet_selection_model.dart';

Future<dynamic> showCommonBottomSheet({
  required BuildContext context,
  required String title,
  required List<BottomSheetSelectionModel> listOfItems,
  required BottomSheetSelectionModel? selectValue,
  required void Function(BottomSheetSelectionModel selectValue) onSubmit,
}) async {
  BottomSheetSelectionModel? selectValueLocal = selectValue;
  log('list => ${listOfItems.length}');
  await showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.white,
    scrollControlDisabledMaxHeightRatio: 0.8,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => listOfItems.isEmpty
            ? Center(
                child: AppTextTheme.textSize16(
                    label: LabelStrings.noData, color: AppColors.black),
              )
            : Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.height28,
                    ),
                    child: AppTextTheme.textSize16(
                      label: title,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Divider(
                    color: AppColors.black.withAlpha(
                      (255 * 0.5).toInt(),
                    ),
                    thickness: 0.5,
                    height: 1,
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.height28,
                        horizontal: Dimens.width20,
                      ),
                      children: listOfItems
                          .map(
                            (item) => Column(
                              children: [
                                RadioListTile<String>(
                                  value: item.name,
                                  groupValue: selectValueLocal?.name,
                                  activeColor: AppColors.primaryColor,
                                  title: AppTextTheme.textSize12(
                                    label: item.name,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  selected: selectValueLocal?.id == item.id,
                                  onChanged: (value) {
                                    setState(() {
                                      selectValueLocal = item;
                                    });
                                  },
                                ),
                                SizedBox(height: Dimens.height6),
                                // Divider(
                                //   height: 1,
                                //   thickness: 0.5,
                                //   color: AppColors.black.withAlpha(
                                //     (255 * 0.5).toInt(),
                                //   ),
                                // ),
                                // SizedBox(height: Dimens.height6),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  if (selectValueLocal != null)
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        onSubmit(selectValueLocal!);
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(
                            Dimens.radius15,
                          ),
                        ),
                        width: MediaQuery.sizeOf(context).width,
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimens.width50,
                          vertical: Dimens.height16,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.height16,
                        ),
                        child: AppTextTheme.textSize14(
                          label: 'Submit',
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (isIOS) SizedBox(height: Dimens.height24),
                ],
              ),
      );
    },
  );
  return await Future.value(
    selectValueLocal,
  );
}
