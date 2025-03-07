import 'package:flutter/material.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/dimens/dimens.dart';
import 'package:present_unit/main.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.only(
        bottom: isIOS ? Dimens.height18 : 0,
        top: Dimens.height18,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(
              (255 * 0.2).toInt(),
            ),
            blurStyle: BlurStyle.outer,
            spreadRadius: 1,
            blurRadius: 12,
          ),
        ],
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.sizeOf(context).height * 0.08,
        maxHeight: MediaQuery.sizeOf(context).height * 0.11 + (isIOS ? MediaQuery.sizeOf(context).height * 0.02 : 0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.children,
        // children: [
        //   GestureDetector(
        //     behavior: HitTestBehavior.translucent,
        //     onTap: () {
        //       setState(() {
        //         selectTab = AdminBottomNavigationBarEnums.home;
        //       });
        //     },
        //     child: iconAndTitleHelper(
        //       bottomNavigationBarEnums: AdminBottomNavigationBarEnums.home,
        //     ),
        //   ),
        //   GestureDetector(
        //     behavior: HitTestBehavior.translucent,
        //     onTap: () {
        //       setState(() {
        //         selectTab = AdminBottomNavigationBarEnums.course;
        //       });
        //     },
        //     child: iconAndTitleHelper(
        //       bottomNavigationBarEnums: AdminBottomNavigationBarEnums.course,
        //     ),
        //   ),
        //   GestureDetector(
        //     behavior: HitTestBehavior.translucent,
        //     onTap: () {
        //       setState(() {
        //         selectTab = AdminBottomNavigationBarEnums.faculty;
        //       });
        //     },
        //     child: iconAndTitleHelper(
        //       bottomNavigationBarEnums: AdminBottomNavigationBarEnums.faculty,
        //     ),
        //   ),
        // ],
      ),
    );
  }
}
