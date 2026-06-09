import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String personalityKey = 'personality';

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

  static Future<void> savePersonality(String personality) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(personalityKey, personality);
  }

  static Future<String> loadPersonality() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(personalityKey) ?? '공감형';
  }

  /// ⭐ [추가] 생년월일 저장하기
  static Future<void> saveBirthdate(String birthdate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_birthdate', birthdate);
  }

  /// ⭐ [수정] 생년월일 불러오기 (UI 에러 방지를 위해 기본값 '정보 없음' 반환)
  static Future<String> loadBirthdate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_birthdate') ?? '정보 없음';
  }

  /// ⭐ [추가] 성별 저장하기
  static Future<void> saveGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_gender', gender);
  }

  /// ⭐ [추가] 성별 불러오기 (UI 에러 방지를 위해 기본값 '선택 안 함' 반환)
  static Future<String> loadGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_gender') ?? '선택 안 함';
  }
}
