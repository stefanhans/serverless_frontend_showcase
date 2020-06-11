import './ui.dart';
import './net.dart';

class TranslationDisplay {
  String taskId;
  String sourceText;
  String sourceLanguage;
  String targetText;
  String targetLanguage;
  String status;

  TranslationDisplay(String taskId, String sourceText, String sourceLanguage,
      String targetText, String targetLanguage, String status) {
    this.sourceText = sourceText;
    this.sourceLanguage = sourceLanguage;
    this.targetText = targetText;
    this.targetLanguage = targetLanguage;
    this.status = status;
  }
}


class Translator {
  String clientVersion;
  String clientId;
  String text;
  String sourceLanguage;
  String targetLanguage;

  Translator(String clientVersion, String clientId, String text,
      String sourceLanguage, String targetLanguage) {
    this.clientVersion = clientVersion;
    this.clientId = clientId;
    this.text = text;
    this.sourceLanguage = sourceLanguage;
    this.targetLanguage = targetLanguage;
  }

  String toJson() {
    return ('{ \n"clientVersion": ${this.clientVersion}, '
        '\n"clientId": ${this.clientId}, '
        '\n"text": ${this.text}, '
        '\n"sourceLanguage": ${this.sourceLanguage}, '
        '\n"targetLanguage": ${this.targetLanguage}, '
        '\n}');
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

    print("####");
    print(translator.toJson());
    print("####");

    translationDisplay.taskId = json['taskId'];
    translationDisplay.sourceLanguage = translator.sourceLanguage;
    translationDisplay.sourceText = translator.text;
    translationDisplay.targetLanguage = translator.targetLanguage;
    translationDisplay.targetText = json['translatedText'];

    translator.sourceLanguage = translator.targetLanguage;

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
