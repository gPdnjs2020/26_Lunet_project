import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart'; // ⭐ [GPS 추가] 기기 GPS 수집을 위한 패키지 임포트

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
  String _weatherTemp = '--°C';
  String _weatherIconUrl = '';
  bool _isLoadingWeather = true;
  String _currentAreaName = '';

  @override
  void initState() {
    super.initState();
    _initGPSAndWeather();
  }

  Future<void> _initGPSAndWeather() async {
    try {
      // 1. 스마트폰 자체의 GPS 기능(위치 서비스)이 활성화되어 있는지 검사
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw '스마트폰의 GPS 기능이 꺼져 있습니다.';
      }

      // 2. 앱에 위치 권한이 허용되어 있는지 체크
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // 권한이 없다면 유저에게 허용해달라는 팝업 시스템 창을 띄움
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw '위치 권한이 거부되었습니다.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw '위치 권한이 설정에서 영구 거부되었습니다.';
      }

      // 3. 기기 센서로부터 위도(latitude)와 경도(longitude) GPS 신호 획득
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ); // low 설정 시 배터리 소모 최적화 및 로딩 속도 향상

      // 4. 획득한 실시간 위도, 경도 좌표 값을 들고 아래의 날씨 수집 함수로 전달
      await _fetchWeatherByGPS(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("GPS 연동 에러: $e");
      setState(() {
        _weatherTemp = '오류';
        _isLoadingWeather = false;
      });
    }
  }

  /// 🌍 ⭐ [GPS 추가] 실시간 위도/경도 좌표를 사용하여 OpenWeatherMap 서버에 날씨 요청
  Future<void> _fetchWeatherByGPS(double lat, double lon) async {
    try {
      final String apiKey = "75af31a92acaa7c17e9e76ce3bcb0c8e";

      final String url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final double temp = data['main']['temp'];
        final String iconCode = data['weather'][0]['icon'];
        final String areaName = data['name'];

        setState(() {
          _weatherTemp = '${temp.toStringAsFixed(1)}°C';
          _weatherIconUrl =
              'https://openweathermap.org/img/wn/$iconCode@2x.png';
          _currentAreaName = areaName;
          _isLoadingWeather = false;
        });
      } else {
        setState(() {
          _isLoadingWeather = false;
        });
      }
    } catch (e) {
      debugPrint("날씨 API 로딩 오류: $e");
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
                              color: Color(0xFF4A6480),
                            ),
                          ),

                          /// ⭐ [GPS 추가] 기온 아래에 현재 잡힌 실제 영문 동네 이름을 작게 표시해 가독성 극대화
                          if (_currentAreaName.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Text(
                                _currentAreaName,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
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
