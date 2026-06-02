import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/history_model.dart';

class HistoryService {
  static const String key = 'history_list';

  /// 저장
  static Future<void> saveHistory(HistoryModel history) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> histories = prefs.getStringList(key) ?? [];

    histories.insert(0, jsonEncode(history.toJson()));

    await prefs.setStringList(key, histories);
  }

  /// 삭제
  static Future<void> deleteHistoryByIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> histories = prefs.getStringList(key) ?? [];

    if (index < 0 || index >= histories.length) return;

    histories.removeAt(index);

    await prefs.setStringList(key, histories);
  }

  static Future<void> updateHistory(int index, HistoryModel history) async {
    final prefs = await SharedPreferences.getInstance();

    final histories = await loadHistories();

    if (index < 0 || index >= histories.length) return;

    histories[index] = history;

    final jsonList = histories.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(key, jsonList);
  }

  /// 불러오기
  static Future<List<HistoryModel>> loadHistories() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> histories = prefs.getStringList(key) ?? [];

    return histories.map((e) => HistoryModel.fromJson(jsonDecode(e))).toList();
  }
}
