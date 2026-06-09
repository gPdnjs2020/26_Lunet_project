import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart'; // ⭐ [GPS 추가] 기기 GPS 수집을 위한 패키지
import 'package:geocoding/geocoding.dart';

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
  String _currentAreaName = ''; // ⭐ [GPS 추가] 지역 명을 저장할 변수

  @override
  void initState() {
    super.initState();
    _initGPSAndWeather(); // 화면이 열릴 때 실시간 GPS로 날씨 가져오기 시작
  }

  /// 🛰️ [스마트폰 GPS 기능을 켜서 위도/경도를 추출하는 함수]
  Future<void> _initGPSAndWeather() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'GPS 기능이 꺼져 있습니다.';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw '위치 권한이 거부되었습니다.';
      }

      if (permission == LocationPermission.deniedForever) {
        throw '위치 권한이 영구 거부되었습니다.';
      }

      // 현재 GPS 좌표 획득
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      // 좌표로 날씨 호출
      await _fetchWeatherByGPS(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("GPS 연동 에러: $e");
      setState(() {
        _weatherTemp = '오류';
        _isLoadingWeather = false;
      });
    }
  }

  /// 🌍 [GPS 좌표를 사용해 OpenWeatherMap에서 날씨 데이터와 '시/군/구' 가져오기]
  Future<void> _fetchWeatherByGPS(double lat, double lon) async {
    try {
      final String apiKey = "75af31a92acaa7c17e9e76ce3bcb0c8e"; // 유저님의 API Key

      // 1. 날씨 정보 호출
      final String weatherUrl =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=kr';
      final weatherResponse = await http.get(Uri.parse(weatherUrl));

      // 2. ⭐ '시/군/구' 단위의 도시 이름을 가져오기 위한 지오코딩 API 호출
      // 이 API는 '흥해읍' 대신 상위 행정구역인 '포항시'를 반환해 줍니다.
      final String geoUrl =
          'http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=$apiKey';
      final geoResponse = await http.get(Uri.parse(geoUrl));

      if (weatherResponse.statusCode == 200) {
        final weatherData = jsonDecode(weatherResponse.body);
        final double temp = weatherData['main']['temp'];
        final String iconCode = weatherData['weather'][0]['icon'];

        String areaName = '알 수 없는 위치';

        // 3. 지오코딩 응답에서 한국어(ko) 도시 이름 추출
        if (geoResponse.statusCode == 200) {
          final List geoData = jsonDecode(geoResponse.body);
          if (geoData.isNotEmpty) {
            final localNames = geoData[0]['local_names'];
            if (localNames != null && localNames['ko'] != null) {
              areaName = localNames['ko']; // 결과: '포항시', '서울특별시' 등
            } else {
              areaName =
                  geoData[0]['name'] ?? weatherData['name'] ?? '알 수 없는 위치';
            }
          }
        }

        setState(() {
          _weatherTemp = '${temp.toStringAsFixed(1)}°C';
          _weatherIconUrl =
              'https://openweathermap.org/img/wn/$iconCode@2x.png';
          _currentAreaName = areaName; // ⭐ 화면에 '포항시' 출력
          _isLoadingWeather = false;
        });
      } else {
        setState(() {
          _isLoadingWeather = false;
        });
      }
    } catch (e) {
      debugPrint("날씨/위치 API 로딩 오류: $e");
      setState(() {
        _currentAreaName = '위치 확인 불가';
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
          /// 말풍선 (원래 디자인대로 왼쪽 정렬 및 가로폭 240 복구)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 240,
              padding: const EdgeInsets.all(18),
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

          const SizedBox(height: 25),

          /// 🌤️ [수정 포인트] 캐릭터 조금 윗 부분에 위치한 날씨 정보 칸
          _isLoadingWeather
              ? const SizedBox(
                  height: 55,
                  child: Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF4A6480),
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 내부 내용만큼만 크기 차지하도록 설정
                    children: [
                      // 날씨 아이콘
                      _weatherIconUrl.isNotEmpty
                          ? Image.network(
                              _weatherIconUrl,
                              width: 56,
                              height: 56,
                              errorBuilder: (c, e, s) => const Icon(
                                Icons.wb_sunny_rounded,
                                color: Colors.orange,
                                size: 60,
                              ),
                            )
                          : const Icon(
                              Icons.wb_sunny_rounded,
                              color: Colors.orange,
                              size: 40,
                            ),
                      const SizedBox(width: 10),
                      // 온도 및 지역 명 세로 정렬
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _weatherTemp, // 기온 표시
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2B2B2B),
                            ),
                          ),
                          if (_currentAreaName.isNotEmpty)
                            Text(
                              _currentAreaName, // 지역 명 표시
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

          const SizedBox(height: 20), // 날씨 정보칸과 캐릭터 사이 간격 조정
          /// 캐릭터
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
