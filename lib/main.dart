import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

/*
Platform documentation: https://docs.flutter.io/flutter/dart-io/Platform-class.html
kIsWeb documentation: https://api.flutter.dev/flutter/foundation/kIsWeb-constant.html
*/

String url;

Future<TranslationResponse> createTranslationResponse(String text) async {
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
      'sourceLanguage': "en",
      'targetLanguage': "fr",
    }),
  );

  print("");
  print(json.decode(response.body));
  print("");

  if (response.statusCode == 200) {
    return TranslationResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create TranslationResponse.');
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
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  Future<TranslationResponse> _futureTranslationResponse;

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
          child: (_futureTranslationResponse == null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: 'Enter Text'),
                    ),
                    RaisedButton(
                      child: Text('Translate Text'),
                      onPressed: () {
                        setState(() {
                          _futureTranslationResponse =
                              createTranslationResponse(_controller.text);
                        });
                      },
                    ),
                  ],
                )
              : FutureBuilder<TranslationResponse>(
                  future: _futureTranslationResponse,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.translatedText);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return CircularProgressIndicator();
                  },
                ),
        ),
      ),
    );
  }
}
