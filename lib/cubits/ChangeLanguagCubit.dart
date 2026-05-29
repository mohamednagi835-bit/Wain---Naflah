import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Changelanguagcubit extends Cubit<Locale> {
  Changelanguagcubit() : super(Locale('en')) {
    loadsavedlocale();
  }

  Future<void> chanlang(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', languageCode);
    emit(Locale(languageCode));

    // toggling:
    // if(state.languageCode == 'en')
    // emit(Locale('ar'));
    // else
    // emit(Locale('en'));
  }

  void togglelanguage() {
    if (state.languageCode == 'en') {
      emit(Locale('ar'));
    } else {
      emit(Locale('en'));
    }
  }

  Future<void> loadsavedlocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langcode = prefs.getString('lang');
    if (langcode != null) {
      emit(Locale(langcode));
    }
  }
}
