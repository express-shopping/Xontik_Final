import 'package:flutter/material.dart';

void main() => runApp(XontikApp());

class XontikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // هذه الميزة تجعل التطبيق يتبع لغة الهاتف تلقائياً
      locale: Locale(WidgetsBinding.instance.platformDispatcher.locale.languageCode),
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: TikTokScreen(),
    );
  }
}

class TikTokScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // التحقق هل لغة الهاتف عربية أم لا لتغيير النصوص
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: Stack(
        children: [
          // خلفية الفيديو السوداء
          Container(color: Colors.black, child: const Center(child: Icon(Icons.play_arrow, size: 80, color: Colors.white24))),
          
          // --- أزرار التفاعل (الآن في الجهة اليسرى كما طلبت) ---
          Positioned(
            left: 15,
            bottom: 120,
            child: Column(
              children: [
                // صورة الحساب مع علامة + الحمراء
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const CircleAvatar(radius: 25, backgroundColor: Colors.grey, icon: Icon(Icons.person, color: Colors.white)),
                    ),
                    Transform.translate(
                      offset: const Offset(0, 10),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: const Icon(Icons.add, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                _buildAction(Icons.favorite, "1.2M"),
                _buildAction(Icons.comment, "45K"),
                _buildAction(Icons.share, "10K"),
              ],
            ),
          ),

          // نصوص الوصف (تتغير حسب لغة الجهاز)
          Positioned(
            bottom: 100,
            right: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("@User_Xontik", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                Text(isArabic ? "وصف الفيديو يظهر هنا..." : "Video description goes here..."),
              ],
            ),
          ),
        ],
      ),
      
      // شريط التنقل السفلي (مترجم تلقائياً)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: isArabic ? 'الرئيسية' : 'Home'),
          BottomNavigationBarItem(icon: const Icon(Icons.search), label: isArabic ? 'اكتشف' : 'Discover'),
          BottomNavigationBarItem(icon: _buildAddIcon(), label: ''),
          BottomNavigationBarItem(icon: const Icon(Icons.message), label: isArabic ? 'الرسائل' : 'Inbox'),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: isArabic ? 'الملف الشخصي' : 'Profile'),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Icon(icon, size: 38, color: Colors.white),
          Text(count, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAddIcon() {
    return Container(
      width: 45,
      height: 30,
      child: Stack(
        children: [
          Container(margin: const EdgeInsets.only(left: 10), decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.circular(10))),
          Container(margin: const EdgeInsets.only(right: 10), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10))),
          Center(child: Container(height: double.infinity, width: 30, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.add, color: Colors.black, size: 20))),
        ],
      ),
    );
  }
}

