import 'dart:developer';

import 'package:present_unit/main.dart';

extension StringPrint on String {
  logOnString(String name) {
    if (isDebugMode) {
      log(
        this,
        name: name,
      );
    }
  }
}
