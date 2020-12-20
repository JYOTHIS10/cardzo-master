import 'dart:async';
import 'package:translator/translator.dart';

// Translation from english to malayalam
Future<String> englishToMalayalam(String englishString) async {
  GoogleTranslator translator = new GoogleTranslator();

  String malayalamString = await translator
      .translate(englishString, from: 'en', to: 'ml')
      .then((value) => value.text);

  print('en to ml');
  return malayalamString;
}

// Translation from english to malayalam
Future<String> malayalamToEnglish(String malayalamString) async {
  GoogleTranslator translator = new GoogleTranslator();

  String englishString = await translator
      .translate(malayalamString, from: 'ml', to: 'en')
      .then((value) => value.text);

  print('ml to en');
  return englishString;
}
