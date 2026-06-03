import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../profile/profile.dart';
import 'selection.dart';
import '../history/history.dart';
import '../../widgets/main_layout.dart';

class LumiereHomePage extends StatefulWidget {
  const LumiereHomePage({super.key});

  @override
  State<LumiereHomePage> createState() => _LumiereHomePageState();
}

class _LumiereHomePageState extends State<LumiereHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 1:
        return const HistoryPage();
      case 2:
        return const ProfilePage();
      default:
        return const _HomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      child: _buildPage(),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  String _weatherTemp = '--°C'; // 기온을 저장할 변수
  String _weatherIconUrl = ''; // 날씨 아이콘 주소를 저장할 변수
  bool _isLoadingWeather = true; // 데이터를 불러오는 중인지 여부

  @override
  void initState() {
    super.initState();
    _fetchPohangWeather(); // 화면이 열릴 때 포항 날씨를 가져옴
  }

  /// 🌍 [포항시 날씨 API를 호출하는 비동기 함수]
  Future<void> _fetchPohangWeather() async {
    try {
      // ⚠️ 1단계에서 발급받은 본인의 실제 API Key를 여기에 꼭 넣어주세요!
      final String apiKey = "75af31a92acaa7c17e9e76ce3bcb0c8e";

      // 포항시 날씨를 섭씨온도(&units=metric)로 요청하는 주소
      final String url =
          'https://api.openweathermap.org/data/2.5/weather?q=Pohang&appid=$apiKey&units=metric';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // 성공적으로 데이터를 받았을 때 데이터 파싱
        final data = jsonDecode(response.body);
        final double temp = data['main']['temp'];
        final String iconCode = data['weather'][0]['icon'];

        setState(() {
          _weatherTemp =
              '${temp.toStringAsFixed(1)}°C'; // 소수점 한 자리까지 표현 (예: 23.4°C)
          _weatherIconUrl =
              'https://openweathermap.org/img/wn/$iconCode@2x.png'; // 아이콘 이미지 URL 생성
          _isLoadingWeather = false; // 로딩 종료
        });
      } else {
        // 서버 응답 에러 (키 미활성화 등)
        setState(() {
          _isLoadingWeather = false;
        });
      }
    } catch (e) {
      // 인터넷 연결 끊김 등의 에러 처리
      debugPrint("날씨 로딩 오류: $e");
      setState(() {
        _isLoadingWeather = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 10),

          /// 💬 [말풍선 & 날씨 가로 배치 레이아웃]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 왼쪽: 기존 루나 말풍선 (날씨 공간을 위해 가로폭 230 미세조정)
              Container(
                width: 230,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9D8FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  '안녕! 나는 루나야.\n함께 최고의 선택을 찾아볼까? ✨',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),

              /// 오른쪽: 날씨 표시 공간 (사진 속 질문하신 빈 공간)
              _isLoadingWeather
                  ? const SizedBox(
                      width: 60,
                      height: 60,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF4A6480),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 인터넷에서 날씨 아이콘을 받아와 표시 (실패 시 기본 해 아이콘)
                          _weatherIconUrl.isNotEmpty
                              ? Image.network(
                                  _weatherIconUrl,
                                  width: 32,
                                  height: 32,
                                  errorBuilder: (c, e, s) => const Icon(
                                    Icons.wb_sunny_rounded,
                                    color: Colors.orange,
                                    size: 24,
                                  ),
                                )
                              : const Icon(
                                  Icons.wb_sunny_rounded,
                                  color: Colors.orange,
                                  size: 24,
                                ),
                          const SizedBox(height: 2),
                          Text(
                            _weatherTemp,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A6480), // 기존 테마 포인트 컬러 사용
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),

          const SizedBox(height: 30),

          /// 캐릭터 (이하 UI 코드는 원본과 100% 동일)
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.7),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A6480).withOpacity(0.08),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Image.asset('assets/images/character.png', width: 165),
            ),
          ),

          const SizedBox(height: 40),

          /// 메인 텍스트
          const Text(
            '지금 고민하고 있는 선택,\n내가 도와줄게!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              height: 1.3,
              color: Color(0xFF2B2B2B),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            '루나는 당신의 마음과 상황을 깊이 이해하고,\n가장 행복한 결정을 내릴 수 있도록 돕는 친구예요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.7),
          ),

          const SizedBox(height: 50),

          /// 분석 카드
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Color(0xFF4A6480)),
                    SizedBox(width: 10),
                    Text(
                      '루나의 분석',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A6480),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  '✔ 당신의 감정 상태 분석\n'
                  '✔ 상황 기반 성공 가능성 예측\n'
                  '✔ 맞춤 전략 추천\n'
                  '✔ 실제 후기 기록 저장',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.9,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          /// 같이 고민하기 버튼
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
                  const SizedBox(width: 10),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            '루나는 언제나 당신의 선택을 응원해요 🌙',
            style: TextStyle(color: Colors.black45, fontSize: 13),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
