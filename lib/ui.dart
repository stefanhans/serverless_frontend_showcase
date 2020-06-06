import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
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
    String targetLanguage = 'fr'}) async {
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
    return TranslationResponse.fromJson(json.decode(response.body));
  } else {
    return TranslationResponse.error(response.body.toString());
  }
}

var translator = Translator("0.0.1", "beab10c6-deee-4843-9757-719566214526",
    "initial null", "en", "de");

class PageWidget extends StatelessWidget {
  var textValue;
  final BehaviorSubject<String> translationTask = BehaviorSubject.seeded("");

  void translate(String text, String sourceLanguageCode, String targetLanguageCode) {
    print("translate("+text+", "+sourceLanguageCode+", "+targetLanguageCode+")");
    print(translator.toJson());
    if (translator.translations.isEmpty) {
      print("INITIAL");
      translator.text = textValue;
    }

    createTranslationResponse(text: translator.text, sourceLanguage: sourceLanguageCode, targetLanguage: targetLanguageCode)
        .then((value) {
      if (value.taskId != 'error') {
        translationTask.add(value?.translatedText ?? "");
      } else {
        translator.text = textValue;
        translationTask.add(value?.translatedText ?? "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translate Text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Translate Text'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: TextField(
                      onChanged: (text) => textValue = text,
                    ),
                    width: 500,
                  ),
                ],
              ),
              Row(
                children: [
                  RaisedButton(
                    child: Text("English"),
                    onPressed: () {
                      translate(translator.text, translator.sourceLanguage, "en");
                    },
                  ),
                  RaisedButton(
                    child: Text("German"),
                    onPressed: () {
                      translate(translator.text, translator.sourceLanguage, "de");
                    },
                  ),
                  RaisedButton(
                    child: Text("French"),
                    onPressed: () {
                      translate(translator.text, translator.sourceLanguage, "fr");
                    },
                  ),
                  RaisedButton(
                    child: Text("Spanish"),
                    onPressed: () {
                      translate(translator.text, translator.sourceLanguage, "es");
                    },
                  ),
                  RaisedButton(
                    child: Text("Italian"),
                    onPressed: () {
                      translate(translator.text, translator.sourceLanguage, "it");
                    },
                  ),
                ],
              ),
//              Row(
//                children: [
//                  RaisedButton(
//                    child: Text("Russian"),
//                    onPressed: () {
//                      translate("ru");
//                    },
//                  ),
//                  RaisedButton(
//                    child: Text("Chinese"),
//                    onPressed: () {
//                      translate("zh");
//                    },
//                  ),
//                  RaisedButton(
//                    child: Text("Arabic"),
//                    onPressed: () {
//                      translate("ar");
//                    },
//                  ),
//                  RaisedButton(
//                    child: Text("Thai"),
//                    onPressed: () {
//                      translate("th");
//                    },
//                  ),
//                  RaisedButton(
//                    child: Text("Hindi"),
//                    onPressed: () {
//                      translate("hi");
//                    },
//                  ),
//                ],
//              ),

              StreamBuilder<String>(
                stream: translationTask.asBroadcastStream(),
                initialData: translationTask.value,
                builder: (context, snapshot) {
                  text = text + "\n" + snapshot.data;
                  return Text("$text");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
ar-SA Arabic Saudi Arabia
cs-CZ Czech Czech Republic
da-DK Danish Denmark
de-DE German Germany
el-GR Modern Greek Greece
en-GB English United Kingdom
es-ES Spanish Spain
fi-FI Finnish Finland
fr-FR French France
he-IL Hebrew Israel
hi-IN Hindi India
hu-HU Hungarian Hungary
id-ID Indonesian Indonesia
it-IT Italian Italy
ja-JP Japanese Japan
ko-KR Korean Republic of Korea
nl-NL Dutch Netherlands
no-NO Norwegian Norway
pl-PL Polish Poland
pt-PT Portuguese Portugal
ro-RO Romanian Romania
ru-RU Russian Russian Federation
sk-SK Slovak Slovakia
sv-SE Swedish Sweden
th-TH Thai Thailand
tr-TR Turkish Turkey
zh-CN Chinese China
 */
