import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final Function(int)? onTap;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      /// 공통 헤더
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F2),
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 75,

        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(
                'assets/images/logo.png',
              ),
            ),

            const SizedBox(width: 10),

            const Text(
              'Lunet',
              style: TextStyle(
                color: Color(0xFF4A6480),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      /// 공통 body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        ),
      ),

      /// 공통 바텀바
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF7F5F2),

          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              blurRadius: 10,
            ),
          ],
        ),

        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,

          backgroundColor: const Color(0xFFF7F5F2),
          elevation: 0,

          selectedItemColor: const Color(0xFF4A6480),
          unselectedItemColor: Colors.grey,

          type: BottomNavigationBarType.fixed,

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome),
              label: 'Predict',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}