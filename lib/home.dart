import 'package:flutter/material.dart';

class LumiereHomePage extends StatelessWidget {
  const LumiereHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF7F5F2),
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
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

      body: SafeArea(
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
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Lumiere',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6480),
                        ),
                      ),
                    ],
                  ),

                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
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
                    '안녕! 나는 루미에르야.\n함께 최고의 선택을 찾아볼까? ✨',
                    style: TextStyle(
                      fontSize: 16,
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
                  child: Image.asset('assets/images/character.png', width: 120),
                ),
              ),

              const SizedBox(height: 40),

              /// 메인 텍스트
              const Text(
                '지금 고민하고 있는 선택,\n같이 생각해볼까?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                  color: Color(0xFF2B2B2B),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '루미에르는 당신의 마음과 상황을 깊이 이해하고,\n가장 행복한 결정을 내릴 수 있도록 돕는 친구예요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.7,
                ),
              ),

              const Spacer(),

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

                  onPressed: () {},

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
