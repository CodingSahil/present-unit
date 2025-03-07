import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:present_unit/helpers/extension/string_print.dart';

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
  convertListOfObject.length.toString().logOnString(
        'Length from get method $collection',
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
