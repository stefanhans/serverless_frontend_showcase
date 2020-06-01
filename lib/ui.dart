import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

/*
Platform documentation: https://docs.flutter.io/flutter/dart-io/Platform-class.html
kIsWeb documentation: https://api.flutter.dev/flutter/foundation/kIsWeb-constant.html
*/
String url;

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

class TranslationResponse {
  final String taskId;
  final String translatedText;
  final List<String> loadCommands;

  TranslationResponse({this.taskId, this.translatedText, this.loadCommands});

  factory TranslationResponse.fromJson(Map<String, dynamic> json) {
    print("factory TranslationResponse");
    print(json.toString());
    return TranslationResponse(
      taskId: json['taskId'],
      translatedText: json['translatedText'],
      loadCommands: json['loadCommands'].cast<String>(),
    );
  }
  factory TranslationResponse.error(String description) {
    print("factory TranslationResponse error");
    print(description);
    return TranslationResponse(
      taskId: "error",
      translatedText: description,
      loadCommands: null,
    );
  }
}

class PageWidget extends StatelessWidget {
  var textValue;
  final BehaviorSubject<String> translationTask =
      BehaviorSubject.seeded("nothing yet");

  void translate(String languageCode) {
    createTranslationResponse(text: textValue, targetLanguage: languageCode)
        .then((value) {
      if (value.taskId != 'error') {
        translationTask.add(value?.translatedText ?? "");
      } else {
        translationTask.add(value?.translatedText ?? "");
      }
    });
  }

//  _translate() = createTranslationResponse(
//  text: textValue, targetLanguage: "zh")
//      .then((value) {
//  if (value.taskId != 'error') {
//  translationTask.add(value?.translatedText ?? "");
//  } else {
//  translationTask.add(value?.translatedText ?? "");
//  }
//  });

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
              RaisedButton(
                child: Text("Translate to French"),
                onPressed: () {
                  translate("fr");
                },
              ),
              RaisedButton(
                child: Text("Translate to Russian"),
                onPressed: () {
                  translate("ru");
                },
              ),
              RaisedButton(
                child: Text("Translate to Spanish"),
                onPressed: () {
                  translate("es");
                },
              ),
              RaisedButton(
                child: Text("Translate to Italian"),
                onPressed: () {
                  translate("it");
                },
              ),
              RaisedButton(
                child: Text("Translate to Dutch"),
                onPressed: () {
                  translate("nl");
                },
              ),
              RaisedButton(
                child: Text("Translate to Thai"),
                onPressed: () {
                  translate("th");
                },
              ),
              RaisedButton(
                child: Text("Translate to Chinese"),
                onPressed: () {
                  translate("zh");
                },
              ),
              RaisedButton(
                child: Text("Translate to Arabic"),
                onPressed: () {
                  translate("ar");
                },
              ),
              StreamBuilder<String>(
                stream: translationTask.asBroadcastStream(),
                initialData: translationTask.value,
                builder: (context, snapshot) {
                  final text = snapshot.data;
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
