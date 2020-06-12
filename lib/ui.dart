import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import './types.dart';
import './net.dart';

var translationDisplay = TranslationDisplay("", "", "", "", "", "initial");

var myApp = PageWidget();

var textValue = "";

class PageWidget extends StatelessWidget {
  final BehaviorSubject<String> translationTask = BehaviorSubject.seeded("");

  void initChain() {
    print("before restart ####");
    print(translator.toJson());
    print("####");

    translator.targetLanguage = "";

    translationDisplay.status = "restart";
    translationDisplay.sourceLanguage = "en";
//    translationDisplay.sourceText = textValue;
    translationDisplay.targetLanguage = "";
    translationDisplay.targetText = "";

    translator.text = translationDisplay.sourceText;
    translator.sourceLanguage = "en";
    translationTask.value = translationDisplay.sourceText;

    print("after restart ####");
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
    if (translationDisplay.status == "initial") {
      print("TRANSLATE INITIAL");
      if (text.isEmpty) {
        if (textValue.isEmpty){
          initChain();
          return;
        }
        text = textValue;
      }
//      translator.text = translationDisplay.sourceText;
      translator.text = text;
    }

    if (translationDisplay.status == "error") {
      initChain();
      return;
    }

    if (sourceLanguageCode == targetLanguageCode) {
      print(sourceLanguageCode + " == " + targetLanguageCode);
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
        translationDisplay.status = "error";
        translator.text = translationDisplay.sourceText;
        translationTask.add(value?.translatedText ?? "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chain of Translations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chain of Translations'),
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
                      decoration: InputDecoration(
                        hintText: 'start with an English text...',
                      ),
                      onChanged: (text) {
                        textValue = text;
                      },
                      onSubmitted: (text) {
                        print("SUBMITTED: " + text);
                        initChain();
                      },
                    ),
                    width: 350,
                  ),
//                  RaisedButton(
//                    child: Text("(Re)Init"),
//                    onPressed: () {
//                      initChain();
//                    },
//                  ),
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
                ],
              ),
              Row(
                children: [
                  RaisedButton(
                    child: Text("Spanish"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "es");
                    },
                  ),
                  RaisedButton(
                    child: Text("Italian"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "it");
                    },
                  ),
                  RaisedButton(
                    child: Text("Portuguese"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "pt");
                    },
                  ),
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
                ],
              ),
              Row(
                children: [
                  RaisedButton(
                    child: Text("Thai"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "th");
                    },
                  ),
                  RaisedButton(
                    child: Text("Hindi"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "hi");
                    },
                  ),
                  RaisedButton(
                    child: Text("Indonesian"),
                    onPressed: () {
                      translate(
                          translator.text, translator.sourceLanguage, "id");
                    },
                  ),
                ],
              ),
              StreamBuilder<String>(
                  stream: translationTask.asBroadcastStream(),
                  initialData: translationTask.value,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
//                    var txt = SelectableText("");
                    if (snapshot.hasError) {
                      var txt = SelectableText(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.left,
                        showCursor: true,
//                        enableInteractiveSelection: true,
                        toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false),
                      );
                      return txt;
//                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      switch (translationDisplay.status) {
                        case "initial":
                          text = "";
                          break;
                        case "restart":
                          print("CASE: RESTART");
                          text = "en: \"" + textValue + "\"";
                          translator.targetLanguage = "en";
                          translator.text = textValue;
                          break;
                        case "error":
                          print("CASE: ERROR");
                          text = "error: \"" + snapshot?.data ?? "" + "\"";
//                          print(translator.toJson());
//                          translator.text = translationDisplay.sourceText;
//                          translationDisplay.sourceLanguage = translationDisplay.targetLanguage;
//                          print(translator.toJson());
                          break;
                        default:
                          print("CASE: DEFAULT");
                          translationDisplay.targetText = snapshot?.data ?? "";
                          text = translationDisplay.taskId +
                              "\n" +
                              translationDisplay.sourceLanguage +
                              ": \"" +
                              translationDisplay.sourceText +
                              "\"\n" +
                              translationDisplay.targetLanguage +
                              ": \"" +
                              translationDisplay.targetText +
                              "\"";
                          translator.text = translationDisplay.targetText;
                          translator.sourceLanguage =
                              translationDisplay.targetLanguage;
                      }

                      print("!!!");
                      print(translator.toJson());
                      print("!!!");

//                  if (snapshot.data.length == 0) {
//                    return Text("");
//                  }
                      var txt = SelectableText(
                        "$text",
                        textAlign: TextAlign.left,
//                    textScaleFactor: 0.95,
                        showCursor: true,
//                        enableInteractiveSelection: true,
                        toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false),
                      );
                      return txt;
                    }
                    return SizedBox(
                      child: const CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    );
                  }),
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
