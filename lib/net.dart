import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

import './types.dart';

/*
Platform documentation: https://docs.flutter.io/flutter/dart-io/Platform-class.html
kIsWeb documentation: https://api.flutter.dev/flutter/foundation/kIsWeb-constant.html
*/
String url;
String text = "";

Future<TranslationResponse> createTranslationResponse(
    {String text,
      String sourceLanguage = 'en',
      String targetLanguage = 'en'}) async {
  if (kIsWeb) {
    url =
    'https://cors-anywhere.herokuapp.com/https://europe-west1-hybrid-cloud-22365.cloudfunctions.net/Translation';
  } else {
    url =
    'https://europe-west1-hybrid-cloud-22365.cloudfunctions.net/Translation';
  }

  print("text: " + text);
  print("sourceLanguage: " + sourceLanguage);
  print("targetLanguage: " + targetLanguage);

  translator.targetLanguage = targetLanguage;

  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'clientVersion': "0.0.1",
      'clientId': "beab10c6-deee-4843-9757-719566214526",
      'text': text,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
    }),
  );

  if (response.statusCode == 200) {
    translationDisplay.status = "translated";
    return TranslationResponse.fromJson(json.decode(response.body));
  } else {
    return TranslationResponse.error(response.body.toString());
  }
}
