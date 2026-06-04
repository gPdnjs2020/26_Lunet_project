import 'package:flutter/material.dart';
import '../profile/profile_edit.dart';

/// [ 설정창 화면 클래스 ]
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _mindfulnessAlarm = true;
  bool _weeklyInsight = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        iconTheme: const IconThemeData(color: Color(0xFF4A6480)),

        title: const Text(
          '설정',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A6480),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// 계정 설정
              _buildSectionTitle('계정 설정'),

              const SizedBox(height: 12),

              _buildMenuTile(
                Icons.person_outline,
                '개인 프로필',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileEditPage()),
                  );
                },
              ),

              const SizedBox(height: 10),

              _buildMenuTile(
                Icons.lock_outline,
                '보안 및 개인정보',

                onTap: () {
                  Navigator.pushNamed(context, '/security');
                },
              ),

              const SizedBox(height: 10),

              _buildMenuTile(
                Icons.logout_outlined,
                '로그아웃',

                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 36),

              /// AI 성격 설정
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  _buildSectionTitle('AI 성격 설정'),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF0F2),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: const Text(
                      'PREMIUM',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFFE08E9B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// 현재 성격
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFFE9D8FF),
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      '공감형',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A6480),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      '부드럽고 지지적이며 깊은 직관력을 가졌어요. 루미에르가 진심으로 귀를 기울입니다.',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      '사용 중 ✨',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// 다른 성격 카드
              Row(
                children: [
                  Expanded(
                    child: _buildPersonalityCard('철학형', '생각할 거리를 던져주는 깊은 대화.'),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _buildPersonalityCard('활기찬형', '동기부여를 해주는 맑은 에너지.'),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              /// 알림 설정
              _buildSectionTitle('알림 설정'),

              const SizedBox(height: 12),

              _buildSwitchTile(
                '마음챙김 알림',
                '매일의 목표를 위한 부드러운 알림.',
                _mindfulnessAlarm,
                (value) {
                  setState(() {
                    _mindfulnessAlarm = value;
                  });
                },
              ),

              const SizedBox(height: 10),

              _buildSwitchTile('주간 인사이트', '성장 여정을 요약해 드립니다.', _weeklyInsight, (
                value,
              ) {
                setState(() {
                  _weeklyInsight = value;
                });
              }),

              const SizedBox(height: 36),

              /// 고객 지원
              _buildSectionTitle('고객 지원'),

              const SizedBox(height: 12),

              _buildMenuTile(
                Icons.help_outline,
                '고객센터',

                hasArrow: false,

                trailing: const Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 10),

              _buildMenuTile(Icons.forum_outlined, '상담원 연결'),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  /// 섹션 제목
  Widget _buildSectionTitle(String title) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4A6480),
      ),
    );
  }

  /// 메뉴 타일
  Widget _buildMenuTile(
    IconData icon,
    String title, {
    bool hasArrow = true,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 60,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(15),

          onTap: onTap,

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF4A6480).withOpacity(0.7)),

                const SizedBox(width: 12),

                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),

                const Spacer(),

                if (hasArrow)
                  const Icon(Icons.chevron_right, size: 20, color: Colors.grey),

                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 성격 카드
  Widget _buildPersonalityCard(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            description,

            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  /// 스위치 카드
  Widget _buildSwitchTile(
    String title,
    String description,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),

                const SizedBox(height: 4),

                Text(
                  description,

                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,

            activeColor: const Color(0xFF4A6480),
            activeTrackColor: const Color(0xFF4A6480).withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
