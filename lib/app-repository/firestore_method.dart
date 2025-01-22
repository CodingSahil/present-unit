import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<T>> getListFromFirebase<T>({
  required String collection,
  required T Function(Map<String, dynamic> json) fromJson,
}) async {
  QuerySnapshot collectedObject =
      await FirebaseFirestore.instance.collection(collection).get();

  List<T> convertListOfObject = collectedObject.docs
      .map(
        (e) => fromJson(e.data() as Map<String, dynamic>),
      )
      .toList();

  log(
    convertListOfObject.length.toString(),
    name: 'Length from get method',
  );

  return convertListOfObject;
}

Future<void> writeCollegeObject({
  required String collection,
  required String newDocumentName,
  required Map<String, dynamic> newMap,
}) async {
  await FirebaseFirestore.instance
      .collection(collection)
      .doc(
        newDocumentName,
      )
      .set(
        newMap,
      );
}
