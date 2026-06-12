import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ⭐ [추가] 회원가입 시 한 번에 모든 정보를 서버에 저장하는 전용 함수
  static Future<void> saveUserProfile({
    required String nickname,
    required String birthdate,
    required String gender,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'nickname': nickname,
      'birthdate': birthdate,
      'gender': gender,
    }, SetOptions(merge: true));
  }

  /// ----------------------------------------------------
  /// 기존 함수들 (다른 파일에서 에러 안 나도록 호환성 유지 + Firebase 적용)
  /// ----------------------------------------------------

  static Future<void> saveNickname(String nickname) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).set({
      'nickname': nickname,
    }, SetOptions(merge: true));
  }

  static Future<String> loadNickname() async {
    final user = _auth.currentUser;
    if (user == null) return '루넷 사용자';
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data()?['nickname'] ?? '루넷 사용자';
  }

  static Future<void> saveProfileImage(String path) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).set({
      'profileImage': path,
    }, SetOptions(merge: true));
  }

  static Future<String?> loadProfileImage() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data()?['profileImage'];
  }

  static Future<void> savePersonality(String personality) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).set({
      'personality': personality,
    }, SetOptions(merge: true));
  }

  static Future<String> loadPersonality() async {
    final user = _auth.currentUser;
    if (user == null) return '공감형';
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data()?['personality'] ?? '공감형';
  }

  static Future<void> saveBirthdate(String birthdate) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).set({
      'birthdate': birthdate,
    }, SetOptions(merge: true));
  }

  static Future<String?> getBirthdate() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data()?['birthdate'];
  }

  static Future<void> saveGender(String gender) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).set({
      'gender': gender,
    }, SetOptions(merge: true));
  }

  static Future<String?> getGender() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data()?['gender'];
  }
}
