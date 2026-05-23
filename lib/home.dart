import 'package:flutter/material.dart';
import 'setting.dart';
import 'profile.dart';
import 'selection.dart';

class LumiereHomePage extends StatefulWidget {
  const LumiereHomePage({super.key});

  @override
  State<LumiereHomePage> createState() => _LumiereHomePageState();
}

class _LumiereHomePageState extends State<LumiereHomePage> {
  int _selectedIndex = 0; // ✨ 현재 선택된 탭 인덱스 (기본값 0: Predict)

  // ✨ 하단 바의 각 탭에 해당하는 화면들을 리스트로 모아둡니다.
  final List<Widget> _pages = [
    const _HomeContent(), // 0번 탭: 원래 있던 메인 홈 화면
    const Center(child: Text('History 화면 (준비중)')), // 1번 탭: 히스토리 화면 (임시)
    const ProfilePage(), // 2번 탭: 프로필 화면
  ];

  // ✨ 바텀 네비게이션 바 탭을 누를 때마다 실행되는 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 누른 버튼의 번호로 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      // ✨ 선택된 탭 번호에 따라 화면(body)이 샥샥 교체됩니다!
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF7F5F2),
        selectedItemColor: const Color(0xFF4A6480),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Predict',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// 상단 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Lunet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6480),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.menu),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 말풍선
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  width: 240,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9D8FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    '안녕! 나는 루나야.\n함께 최고의 선택을 찾아볼까? ✨',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// 캐릭터 이미지
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset('assets/images/character.png', width: 170),
                ),
              ),

              const SizedBox(height: 40),

              /// 메인 텍스트
              const Text(
                '지금 고민하고 있는 선택,\n내가 도와줄게!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                  color: Color(0xFF2B2B2B),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '루나는 당신의 마음과 상황을 깊이 이해하고,\n가장 행복한 결정을 내릴 수 있도록 돕는 친구예요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 60),

              /// 버튼
              Container(
                width: double.infinity,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF486A8A), Color(0xFFA9C7F2)],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SelectionPage()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '같이 고민하기',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
