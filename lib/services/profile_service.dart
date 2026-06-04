import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Future<void> saveNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', nickname);
  }

  static Future<String> loadNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nickname') ?? '루넷 사용자';
  }

  static Future<void> saveProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage', path);
  }

  static Future<String?> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileImage');
  }
}