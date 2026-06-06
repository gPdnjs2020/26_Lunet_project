import 'package:flutter/material.dart';

class ResultSaveWidget extends StatelessWidget {
  final String situation;
  final int successPercent;
  final String profileTitle;
  final String profileStyle;
  final String advice;
  final String positive;
  final String warning;
  final String lunaMessage;

  const ResultSaveWidget({
    super.key,
    required this.situation,
    required this.successPercent,
    required this.profileTitle,
    required this.profileStyle,
    required this.advice,
    required this.positive,
    required this.warning,
    required this.lunaMessage,
  });

  Widget section(String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: const TextStyle(
              fontSize: 22,
              height: 1.7,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF7F5F2),

      child: SingleChildScrollView(
        child: Container(
          width: 1080,
          padding: const EdgeInsets.all(40),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Image.asset(
                'assets/images/character.png',
                width: 220,
              ),

              const SizedBox(height: 30),

              Text(
                '지금은 약 $successPercent%',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6480),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                '루넷의 분석 결과 🌙',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              section('당신의 고민', situation),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF486A8A),
                      Color(0xFFA9C7F2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Text(
                      profileTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      profileStyle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              section('루넷의 분석', advice),
              section('긍정 요소', positive),
              section('주의 요소', warning),
              section('루나의 조언', lunaMessage),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 20),

              const Text(
                'LUNET 🌙',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6480),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}