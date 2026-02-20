import 'package:flutter/material.dart';

void main() => runApp(XontikApp());

class XontikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XONTIK',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: TikTokScreen(),
    );
  }
}

class TikTokScreen extends StatelessWidget {
  final List<Color> colors = [Colors.black, Colors.blueGrey, Colors.black87, Colors.grey[900]!];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // محاكي الفيديو
              Container(color: colors[index]),
              const Center(child: Icon(Icons.play_arrow, size: 80, color: Colors.white24)),
              
              // الأزرار الجانبية (التفاعل)
              Positioned(
                right: 15,
                bottom: 120,
                child: Column(
                  children: [
                    _buildActionButton(Icons.favorite, "1.2k"),
                    _buildActionButton(Icons.comment, "450"),
                    _buildActionButton(Icons.share, "Share"),
                  ],
                ),
              ),
              
              // وصف الفيديو
              Positioned(
                left: 15,
                bottom: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("@Xontik_User", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                    SizedBox(height: 10),
                    Text("The best TikTok experience starts here! #Xontik", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 35), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Icon(icon, size: 35, color: Colors.white),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

