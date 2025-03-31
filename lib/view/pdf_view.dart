import 'package:flutter/material.dart';
import 'package:present_unit/helper-widgets/app-bar/app_bar.dart';
import 'package:present_unit/helpers/colors/app_color.dart';
import 'package:present_unit/helpers/text-style/text_style.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  const PdfView({
    super.key,
    required this.arguments,
  });

  final dynamic arguments;

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  String? url;

  @override
  void initState() {
    if (widget.arguments != null && widget.arguments is String) {
      url = widget.arguments as String;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: commonAppBarPreferred(
        label: 'PDF Viewer',
      ),
      body: url != null && url!.isNotEmpty
          ? SfPdfViewer.network(
              url!,
            )
          : Center(
              child: AppTextTheme.textSize14(
                label: 'No Data',
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
