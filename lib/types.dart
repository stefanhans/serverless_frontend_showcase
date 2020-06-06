import './ui.dart';

class Translation {
  String taskId;
  String sourceText;
  String sourceLanguage;
  String targetText;
  String targetLanguage;

  Translation(String taskId, String sourceText, String sourceLanguage,
      String targetText, String targetLanguage) {
    this.sourceText = sourceText;
    this.sourceLanguage = sourceLanguage;
    this.targetText = targetText;
    this.targetLanguage = targetLanguage;
  }

  String toJson() {
    return ('{ \n"sourceText": ${this.sourceText}, '
        '\n"sourceLanguage": ${this.sourceLanguage}, '
        '\n"targetText": ${this.targetText}, '
        '\n"targetLanguage": ${this.targetLanguage} '
        '\n}');
  }
}

class Translator {
  String clientVersion;
  String clientId;
  String text;
  String sourceLanguage;
  String targetLanguage;
  List<Translation> translations;

  Translator(String clientVersion, String clientId, String text,
      String sourceLanguage, String targetLanguage) {
    this.clientVersion = clientVersion;
    this.clientId = clientId;
    this.text = text;
    this.sourceLanguage = sourceLanguage;
    this.targetLanguage = targetLanguage;
    this.translations = new List<Translation>();
  }

  String toJson() {
    String translationStr;
    for (var translation in this.translations) {
      translationStr = translation.toJson();
    }
    return ('{ \n"clientVersion": ${this.clientVersion}, '
        '\n"clientId": ${this.clientId}, '
        '\n"text": ${this.text}, '
        '\n"sourceLanguage": ${this.sourceLanguage}, '
        '\n"targetLanguage": ${this.targetLanguage}, '
        '\n"translations": [\n $translationStr'
        '] \n}');
//    return jsonEncode(this);
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

    translator.translations.add(Translation(
        json['taskId'],
        translator.text,
        translator.sourceLanguage,
        json['translatedText'],
        translator.targetLanguage));

    print("####");
    print(translator.toJson());
    print("####");

    translator.text = json['translatedText'];
    translator.sourceLanguage = translator.targetLanguage;

    print("!!!");
    print(translator.toJson());
    print("!!!");


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

