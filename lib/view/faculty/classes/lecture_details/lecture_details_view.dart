import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/assets_path/assets_path.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/models/class_list_for_attendance/class_list_for_attendance.dart';

class LectureDetailsView extends StatefulWidget {
  const LectureDetailsView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<LectureDetailsView> createState() => _LectureDetailsViewState();
}

class _LectureDetailsViewState extends State<LectureDetailsView> with SingleTickerProviderStateMixin {
  late TabController tabController;
  ClassesForAttendanceModel? classesForAttendanceModel;

  @override
  void initState() {
    tabController = TabController(
      length: 3,
      vsync: this,
    );
    if (widget.arguments != null && widget.arguments is ClassesForAttendanceModel) {
      classesForAttendanceModel = widget.arguments as ClassesForAttendanceModel;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      animationDuration: const Duration(
        milliseconds: 250,
      ),
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgColor,
        appBar: commonAppBarPreferred(
          label: 'Lecture Details',
          bottom: TabBar(
            controller: tabController,
            dividerColor: AppColors.white,
            dividerHeight: Dimens.height4,
            tabs: [
              Tab(
                icon: SvgPicture.asset(
                  AssetsPaths.taskTodoSVG,
                  height: Dimens.height50,
                  width: Dimens.width50,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Tab(
                icon: SvgPicture.asset(
                  AssetsPaths.studentsSVG,
                  height: Dimens.height45,
                  width: Dimens.width45,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Tab(
                icon: SvgPicture.asset(
                  AssetsPaths.notesSVG,
                  height: Dimens.height50,
                  width: Dimens.width50,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskForLectureDetailsView(
              classesForAttendanceModel: classesForAttendanceModel != null ? classesForAttendanceModel! : ClassesForAttendanceModel.empty(),
            ),
            AttendanceForLectureDetailsView(
              classesForAttendanceModel: classesForAttendanceModel != null ? classesForAttendanceModel! : ClassesForAttendanceModel.empty(),
            ),
            NotesForLectureDetailsView(
              classesForAttendanceModel: classesForAttendanceModel != null ? classesForAttendanceModel! : ClassesForAttendanceModel.empty(),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskForLectureDetailsView extends StatefulWidget {
  const TaskForLectureDetailsView({
    super.key,
    required this.classesForAttendanceModel,
  });

  final ClassesForAttendanceModel classesForAttendanceModel;

  @override
  State<TaskForLectureDetailsView> createState() => _TaskForLectureDetailsViewState();
}

class _TaskForLectureDetailsViewState extends State<TaskForLectureDetailsView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AttendanceForLectureDetailsView extends StatefulWidget {
  const AttendanceForLectureDetailsView({
    super.key,
    required this.classesForAttendanceModel,
  });

  final ClassesForAttendanceModel classesForAttendanceModel;

  @override
  State<AttendanceForLectureDetailsView> createState() => _AttendanceForLectureDetailsViewState();
}

class _AttendanceForLectureDetailsViewState extends State<AttendanceForLectureDetailsView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class NotesForLectureDetailsView extends StatefulWidget {
  const NotesForLectureDetailsView({
    super.key,
    required this.classesForAttendanceModel,
  });

  final ClassesForAttendanceModel classesForAttendanceModel;

  @override
  State<NotesForLectureDetailsView> createState() => _NotesForLectureDetailsViewState();
}

class _NotesForLectureDetailsViewState extends State<NotesForLectureDetailsView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
