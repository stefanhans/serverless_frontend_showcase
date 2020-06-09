import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import './types.dart';
import './net.dart';


var textValue;

class PageWidget extends StatelessWidget {
  final BehaviorSubject<String> translationTask = BehaviorSubject.seeded("");

  void reset() {

    print("before reset ####");
    print(translator.toJson());
    print("####");

    translator.targetLanguage = "";


    translationDisplay.status = "reset";
    translationDisplay.sourceLanguage = "en";
    translationDisplay.sourceText = textValue;
    translationDisplay.targetLanguage = "";
    translationDisplay.targetText = "";

    translator.text = textValue;
    translator.sourceLanguage = "en";
    translationTask.value = textValue ?? "";

    print("after reset ####");
    print(translator.toJson());
    print("####");
  }

  void translate(
      String text, String sourceLanguageCode, String targetLanguageCode) {
    print("translate(" +
        text +
        ", " +
        sourceLanguageCode +
        ", " +
        targetLanguageCode +
        ")");
//    print(translator.toJson());
    if (translator.translations.isEmpty) {
      print("INITIAL");
      translator.text = textValue;
    }

    if (sourceLanguageCode == targetLanguageCode) {
      print("RETURN");
      return;
    }

    createTranslationResponse(
            text: translator.text,
            sourceLanguage: sourceLanguageCode,
            targetLanguage: targetLanguageCode)
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
                    width: 232,
                  ),
                  RaisedButton(
                    child: Text("Reset"),
                    onPressed: () {
                      reset();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  RaisedButton(
                    child: Text("English"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "en");
                    },
                  ),
                  RaisedButton(
                    child: Text("German"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "de");
                    },
                  ),
                  RaisedButton(
                    child: Text("French"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "fr");
                    },
                  ),
//                  RaisedButton(
//                    child: Text("Spanish"),
//                    onPressed: () {
//                      translate(
//                          translator.text, translator.sourceLanguage, "es");
//                    },
//                  ),
//                  RaisedButton(
//                    child: Text("Italian"),
//                    onPressed: () {
//                      translate(
//                          translator.text, translator.sourceLanguage, "it");
//                    },
//                  ),
                ],
              ),
              Row(
                children: [
                  RaisedButton(
                    child: Text("Russian"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "ru");
                    },
                  ),
                  RaisedButton(
                    child: Text("Chinese"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "zh-CN");
                    },
                  ),
                  RaisedButton(
                    child: Text("Arabic"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "ar");
                    },
                  ),
//                  RaisedButton(
//                    child: Text("Thai"),
//                    onPressed: () {
//                      translate(
//                          translator.text, translator.sourceLanguage, "th");
//                    },
//                  ),
//                  RaisedButton(
//                    child: Text("Hindi"),
//                    onPressed: () {
//                      translate(
//                          translator.text, translator.sourceLanguage, "hi");
//                    },
//                  ),
                ],
              ),
              StreamBuilder<String>(
                stream: translationTask.asBroadcastStream(),
                initialData: translationTask.value,
                builder: (context, snapshot) {
                  print("xxxxx");
                  switch (translationDisplay.status) {
                    case  "initial":
                      text = "";
                      break;
                    case  "reset":
                      text = "en: \"" + textValue + "\"";
                      translator.targetLanguage = "en";
                      translator.text = textValue;
                      break;
                    default:
                      translationDisplay.targetText = snapshot?.data ?? "";
                      text = translationDisplay.sourceLanguage +
                          ": \"" +
                          translationDisplay.sourceText +
                          "\"\n" +
                          translationDisplay.targetLanguage +
                          ": \"" +
                          translationDisplay.targetText +
                          "\"";
                      translator.text = translationDisplay.targetText;
                      translator.sourceLanguage = translationDisplay.targetLanguage;
                  }


//                  translationDisplay.targetText = snapshot.data;
//                  text = "TaskId: \t" + translationDisplay.taskId +
//                      "\n" +
//                      translationDisplay.sourceLanguage +
//                      ": \"" +
//                      translationDisplay.sourceText +
//                      "\"\n" +
//                      translationDisplay.targetLanguage +
//                      ": \"" +
//                      translationDisplay.targetText +
//                      "\"";



                  print("!!!");
                  print(translator.toJson());
                  print("!!!");

//                  if (snapshot.data.length == 0) {
//                    return Text("");
//                  }
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
