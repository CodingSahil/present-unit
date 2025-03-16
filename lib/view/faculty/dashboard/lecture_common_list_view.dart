import 'package:flutter/material.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/date-time-convert/date_time_conversion.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:present_unit/models/navigation_models/common_models/list_view_navigation_models.dart';
import 'package:present_unit/view/faculty/assignment/assignment_list_view.dart';
import 'package:present_unit/view/faculty/classes/lecture_list_view.dart';

class LectureCommonListView extends StatefulWidget {
  const LectureCommonListView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<LectureCommonListView> createState() => _LectureCommonListViewState();
}

class _LectureCommonListViewState extends State<LectureCommonListView> {
  CommonLectureListModel? commonLectureListModel;

  @override
  void initState() {
    if (widget.arguments != null && widget.arguments is CommonLectureListModel) {
      commonLectureListModel = widget.arguments as CommonLectureListModel;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: commonLectureListModel?.label ?? '',
      ),
      body: commonLectureListModel != null && commonLectureListModel!.lectureList.isNotEmpty
          ? ListView(
              padding: EdgeInsets.symmetric(
                vertical: Dimens.height24,
                horizontal: Dimens.width30,
              ),
              children: commonLectureListModel?.lectureList.map(
                    (e) {
                      DateTime startTime = DateTimeConversion.convertStringToDateTime(e.startingTime);
                      late DateTime endTime = DateTimeConversion.convertStringToDateTime(e.endingTime);
                      String differenceInMinutes = endTime.difference(startTime).inMinutes.toString();

                      return ClassesWithAttendanceReadView(
                        classesForAttendanceModel: e,
                        differenceInMinutes: differenceInMinutes,
                      );
                    },
                  ).toList() ??
                  [],
            )
          : Center(
              child: AppTextTheme.textSize18(
                label: 'No Data',
                color: AppColors.black,
              ),
            ),
    );
  }
}

class AssignmentCommonListView extends StatefulWidget {
  const AssignmentCommonListView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<AssignmentCommonListView> createState() => _AssignmentCommonListViewState();
}

class _AssignmentCommonListViewState extends State<AssignmentCommonListView> {
  CommonAssignmentListModel? commonAssignmentListModel;

  @override
  void initState() {
    if (widget.arguments != null && widget.arguments is CommonAssignmentListModel) {
      commonAssignmentListModel = widget.arguments as CommonAssignmentListModel;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: commonAssignmentListModel?.label ?? '',
      ),
      body: commonAssignmentListModel != null && commonAssignmentListModel!.assignmentList.isNotEmpty
          ? ListView(
              padding: EdgeInsets.symmetric(
                vertical: Dimens.height24,
                horizontal: Dimens.width30,
              ),
              children: commonAssignmentListModel!.assignmentList
                  .map(
                    (e) => AssignmentDetailsReadOnlyCard(
                      assignmentModel: e,
                    ),
                  )
                  .toList(),
            )
          : Center(
              child: AppTextTheme.textSize18(
                label: 'No Data',
                color: AppColors.black,
              ),
            ),
    );
  }
}
