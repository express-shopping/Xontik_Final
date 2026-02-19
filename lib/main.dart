import 'package:flutter/material.dart';

void main() => runApp(XontikApp());

class XontikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(WidgetsBinding.instance.platformDispatcher.locale.languageCode),
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: TikTokHome(),
    );
  }
}

class TikTokHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.black, child: const Center(child: Icon(Icons.play_arrow, size: 80, color: Colors.white24))),
          Positioned(
            left: 15, bottom: 120,
            child: Column(
              children: [
                _buildProfile(),
                const SizedBox(height: 20),
                _icon(Icons.favorite, "1.2M"),
                _icon(Icons.comment, "45K"),
                _icon(Icons.share, "10K"),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: isAr ? 'الرئيسية' : 'Home'),
          BottomNavigationBarItem(icon: const Icon(Icons.add_box, size: 40), label: ''),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: isAr ? 'الملف الشخصي' : 'Profile'),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Stack(alignment: Alignment.bottomCenter, children: [
      const CircleAvatar(radius: 25, backgroundColor: Colors.white, child: CircleAvatar(radius: 23, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white))),
      Transform.translate(offset: const Offset(0, 8), child: Container(decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: const Icon(Icons.add, size: 18, color: Colors.white))),
    ]);
  }

  Widget _icon(IconData i, String t) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Column(children: [Icon(i, size: 35), Text(t, style: const TextStyle(fontSize: 12))]));
}

