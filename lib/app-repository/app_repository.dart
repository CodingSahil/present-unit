import 'dart:developer';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;

class BaseError {
  const BaseError({
    required this.statusCode,
    required this.message,
  });

  final num statusCode;
  final String message;
}

class AppRepository {
  Future<void> getLocations() async {
    var response = await http.post(
      Uri.parse(
        'https://places.googleapis.com/v1/places:Spicy',
      ),
      body: {
        "textQuery": "Spicy Vegetarian Food in Sydney, Australia",
      },
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask': '*'
      },
    );

    log('message => ${response.body}');
  }
}
