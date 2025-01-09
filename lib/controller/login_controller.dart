import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  Future<void> getData() async {
    QuerySnapshot temp =
        await FirebaseFirestore.instance.collection('college').get();
    log('temp => ${temp.docs.map(
          (e) => e.data(),
        ).toList()}');
  }
}
