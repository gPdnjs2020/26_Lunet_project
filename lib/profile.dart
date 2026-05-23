import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const Center(
                child: Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6480),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundImage: AssetImage(
                        'assets/images/user_avatar_placeholder.png',
                      ),
                      backgroundColor: Colors.white,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF4A6480), // 카메라 버튼 배경
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white, // 아이콘 색상
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// [ 3. 'Edit Profile' 버튼 영역 (로그인 버튼 스타일과 동일) ]
              Container(
                width: double.infinity,
                height: 40, // 동일한 높이
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), // 동일한 라운딩
                  gradient: const LinearGradient(
                    // 동일한 그라디언트
                    colors: [Color(0xFF486A8A), Color(0xFFA9C7F2)],
                  ),
                  boxShadow: [
                    // 동일한 그림자
                    BoxShadow(
                      color: const Color(0xFF486A8A).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // 투명하게 설정하여 그라디언트 유지
                    shadowColor: Colors.transparent, // 그림자 중복 방지
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // TODO: 프로필 편집 화면으로 이동 로직
                    Navigator.pop(context); // 임시로 뒤로가기
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // 버튼 텍스트 색상
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// [ 4. 계정 정보 섹션 ]
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'ACCOUNT INFORMATION',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6480), // 섹션 헤더 주 색상
                  ),
                ),
              ),

              // 계정 정보 상세 목록 컨테이너 (텍스트 필드와 유사한 둥근 코너)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15), // 동일한 라운딩
                ),
                child: Column(
                  children: [
                    _buildDetailItem('Username', value: 'John Doe'),
                    _buildDetailItem('Email', value: 'john.doe@email.com'),
                    _buildDetailItem(
                      'Password',
                      value: '••••••••••••',
                      hasMoreArrow: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// [ 5. 설정 및 환경설정 섹션 ]
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'SETTINGS & PREFERENCES',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6480), // 섹션 헤더 주 색상
                  ),
                ),
              ),

              // 설정 상세 목록 컨테이너
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15), // 동일한 라운딩
                ),
                child: Column(
                  children: [
                    _buildDetailItem(
                      'Notifications',
                      trailing: Switch(
                        value: true,
                        onChanged: (val) {},
                        activeColor: const Color(0xFF4A6480),
                      ),
                    ),
                    _buildDetailItem(
                      'Dark Mode',
                      trailing: Switch(
                        value: false,
                        onChanged: (val) {},
                        activeColor: const Color(0xFF4A6480),
                      ),
                    ),
                    _buildDetailItem(
                      'Language',
                      value: 'English',
                      hasMoreArrow: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// [ 6. 기타 섹션 ]
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'OTHER',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6480), // 섹션 헤더 주 색상
                  ),
                ),
              ),

              // 기타 상세 목록 컨테이너
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15), // 동일한 라운딩
                ),
                child: Column(
                  children: [
                    _buildDetailItem('Help Center', hasMoreArrow: true),
                    _buildDetailItem('Terms of Service', hasMoreArrow: true),
                    _buildDetailItem('Privacy Policy', hasMoreArrow: true),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// [ 7. 로그아웃 버튼 (좌측 정렬 텍스트 스타일) ]
              TextButton(
                onPressed: () {
                  // TODO: 로그아웃 로직 및 로그인 화면으로 이동
                  Navigator.pushReplacementNamed(context, '/'); // 임시로 로그인 화면 이동
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // 기본 여백 제거
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red, // 텍스트 색상 빨강
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------- //
  // [ 커스텀 기능 함수 모음 ]
  // ---------------------------------------------------------------------- //

  /// [ 기능 1: 프로필 상세 정보 항목 공통 함수 ]
  /// 로그인 화면의 텍스트 필드 디자인 아이덴티티(간격, 코너 반경, 폰트 스타일)를 따르는 항목을 그립니다.
  Widget _buildDetailItem(
    String title, {
    String? value,
    bool hasMoreArrow = false,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: const BoxDecoration(
          // 항목 간 구분선은 Container 자체 테두리로 구현
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양끝 정렬
          children: [
            // 왼쪽: 제목
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black87, // 일반 텍스트 색상
              ),
            ),

            // 오른쪽: 정보 값, 화살표 또는 트레일링 위젯
            Row(
              children: [
                if (value != null) ...[
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          Colors.grey.shade600, // 정보 값 텍스트 색상 (로그인 힌트 텍스트와 유사)
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (trailing != null) trailing, // 스위치 등
                if (hasMoreArrow && trailing == null) ...[
                  // 화살표가 필요하고 트레일링 위젯이 없을 때
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade600, // 화살표 아이콘 색상
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
