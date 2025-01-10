import 'package:flutter/material.dart';

extension ConvertFromString on TextEditingController {
  num convertToNum() => num.parse(text);
}
