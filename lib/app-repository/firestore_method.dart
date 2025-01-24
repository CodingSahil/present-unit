import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<T>> getListFromFirebase<T>({
  required String collection,
  required T Function(
    Map<String, dynamic> json,
    String documentID,
  ) fromJson,
}) async {
  QuerySnapshot collectedObject =
      await FirebaseFirestore.instance.collection(collection).get();

  List<T> convertListOfObject = collectedObject.docs
      .map(
        (e) => fromJson(
          e.data() as Map<String, dynamic>,
          e.id,
        ),
      )
      .toList();

  log(
    convertListOfObject.length.toString(),
    name: 'Length from get method',
  );

  return convertListOfObject;
}

Future<void> writeAnObject({
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

Future<void> updateAnObject({
  required String collection,
  required String documentName,
  required Map<String, dynamic> newMap,
}) async {
  await FirebaseFirestore.instance
      .collection(collection)
      .doc(
        documentName,
      )
      .update(
        newMap,
      );
}

Future<void> deleteAnObject({
  required String collection,
  required String documentName,
}) async {
  await FirebaseFirestore.instance
      .collection(collection)
      .doc(
        documentName,
      )
      .delete();
}
