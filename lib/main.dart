import 'package:flutter/material.dart';

void main() => runApp(XontikApp());

class XontikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xontik Premium',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        primaryColor: const Color(0xFFD4AF37),
      ),
      home: WelcomePage(),
    );
  }
}

// --- الصفحة الأولى: صفحة الترحيب ---
class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [Color(0xFF1A1A1A), Color(0xFF000000)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'XONTIK',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37), letterSpacing: 5),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                // الانتقال إلى الصفحة الثانية
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu()));
              },
              child: const Text('ابدأ الآن', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- الصفحة الثانية: القائمة الرئيسية (الجديدة) ---
class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XONTIK MENU', style: TextStyle(color: Color(0xFFD4AF37), letterSpacing: 2)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2, // زرين في كل صف
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildMenuCard(Icons.shopping_cart, "المتجر"),
            _buildMenuCard(Icons.person, "الملف الشخصي"),
            _buildMenuCard(Icons.settings, "الإعدادات"),
            _buildMenuCard(Icons.info, "عن التطبيق"),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4AF37), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color(0xFFD4AF37)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}

