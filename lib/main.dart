import 'dart:ui';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'app_state.dart'; // تأكد أن هذا الملف موجود في مجلد lib

// --- النماذج المركزية ---
class XontikUser {
  final String name;
  final String handle;
  final String image;
  final String lastMsg;
  XontikUser({required this.name, required this.handle, required this.image, this.lastMsg = ""});
}

final List<XontikUser> xontikUsers = [
  XontikUser(name: "أحمد المصراتي", handle: "@ahmed_99", image: "https://i.pravatar.cc/150?u=1", lastMsg: "تصميم رائع!"),
  XontikUser(name: "سارة المبروك", handle: "@sara_designer", image: "https://i.pravatar.cc/150?u=2", lastMsg: "شكراً على الدعم"),
  XontikUser(name: "محمد علي", handle: "@m_ali", image: "https://i.pravatar.cc/150?u=3", lastMsg: "متى البث القادم؟"),
];

// --- الدوال العامة ---
void showXontikNotification(BuildContext context, String user, String msg) {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50, left: 10, right: 10,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFeb3349), width: 1),
            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
          ),
          child: Row(
            children: [
              const CircleAvatar(backgroundColor: Color(0xFFeb3349), child: Icon(Icons.mail, color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(user, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(msg, style: const TextStyle(color: Colors.white70, fontSize: 13), maxLines: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  overlayState.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3), () => overlayEntry.remove());
}

Route createXontikRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOutQuart))),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => XontikProvider(),
      child: const XontikMasterpiece(),
    ),
  );
}

class XontikMasterpiece extends StatelessWidget {
  const XontikMasterpiece({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const AuthScreen(),
    );
  }
}

// --- 1. واجهة تسجيل الدخول ---
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          children: [
            const Spacer(),
            const Text("XONTIK", style: TextStyle(fontSize: 65, fontWeight: FontWeight.bold, letterSpacing: 6)),
            const SizedBox(height: 10),
            const Text("انضم إلى مجتمع المبدعين العالمي", style: TextStyle(color: Colors.white54, fontSize: 15)),
            const SizedBox(height: 60),
            _socialBtn(Icons.person_outline, "استخدام الهاتف / البريد الإلكتروني"),
            _socialBtn(Icons.facebook, "المتابعة باستخدام Facebook", color: Colors.blueAccent),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const MainTikTokScaffold())),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: RichText(text: const TextSpan(text: "ليس لديك حساب؟ ", style: TextStyle(color: Colors.white60), children: [
                  TextSpan(text: "إنشاء حساب", style: TextStyle(color: Color(0xFFeb3349), fontWeight: FontWeight.bold)),
                ])),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _socialBtn(IconData icon, String label, {Color color = Colors.white}) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.white12, width: 1)),
    child: Row(children: [Icon(icon, color: color, size: 26), Expanded(child: Text(label, textAlign: TextAlign.center))]),
  );
}

// --- 2. الهيكل الرئيسي ---
class MainTikTokScaffold extends StatefulWidget {
  const MainTikTokScaffold({super.key});
  @override
  State<MainTikTokScaffold> createState() => _MainTikTokScaffoldState();
}

class _MainTikTokScaffoldState extends State<MainTikTokScaffold> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const TikTokFeedView(),
    const DiscoverView(),
    Container(),
    const InboxScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<XontikProvider>(context, listen: false).simulateIncomingMessage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => i == 2 ? _showUploadOptions(context) : setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'الرئيسية'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'اكتشف'),
          BottomNavigationBarItem(icon: _buildPlusIcon(), label: ''),
          const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'صندوق الوارد'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'الملف'),
        ],
      ),
    );
  }

  Widget _buildPlusIcon() => SizedBox(width: 45, height: 28, child: Stack(children: [
    Container(margin: const EdgeInsets.only(left: 10), width: 38, decoration: BoxDecoration(color: const Color(0xFF2af1f7), borderRadius: BorderRadius.circular(7))),
    Container(margin: const EdgeInsets.only(right: 10), width: 38, decoration: BoxDecoration(color: const Color(0xFFeb3349), borderRadius: BorderRadius.circular(7))),
    Center(child: Container(width: 38, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)), child: const Icon(Icons.add, color: Colors.black, size: 20))),
  ]));

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.9),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        height: 280,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _uploadBtn(Icons.videocam, "كاميرا", Colors.purple, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const CameraScreen()));
                }),
                _uploadBtn(Icons.perm_media, "المعرض", Colors.blue, () => Navigator.pop(context)),
                _uploadBtn(Icons.auto_awesome, "مؤثرات", Colors.pinkAccent, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadBtn(IconData icon, String label, Color color, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Column(children: [CircleAvatar(radius: 30, backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color, size: 30)), const SizedBox(height: 10), Text(label)]),
  );
}

// --- 3. ملف التعريف ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("Xontik_Creator"), actions: [
        IconButton(icon: const Icon(Icons.menu), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsScreen())))
      ]),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _stat("150", "أتابع"),
            _stat("1.5M", "متابعين"),
            Consumer<XontikProvider>(builder: (context, p, _) => _stat(p.formattedLikes, "إعجاب")),
          ]),
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFeb3349), shape: StadiumBorder()),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const EditProfileScreen())),
            child: const Text("تعديل الملف"),
          ),
          const Divider(height: 40),
          Expanded(child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), itemCount: 12, itemBuilder: (c, i) => Container(color: Colors.white10, margin: const EdgeInsets.all(1), child: const Icon(Icons.play_arrow, color: Colors.white24)))),
        ],
      ),
    );
  }
  Widget _stat(String v, String l) => Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [Text(v, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text(l, style: const TextStyle(color: Colors.grey))]));
}

// --- 4. مشغل الفيديوهات ---
class TikTokFeedView extends StatelessWidget {
  const TikTokFeedView({super.key});
  final List<String> videoUrls = const [
    "https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-lighting-in-the-city-21002-large.mp4",
  ];
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videoUrls.length,
      itemBuilder: (context, index) => VideoItem(videoUrl: videoUrls[index]),
    );
  }
}

class VideoItem extends StatefulWidget {
  final String videoUrl;
  const VideoItem({super.key, required this.videoUrl});
  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))..initialize().then((_) {
      if (mounted) setState(() { _isInitialized = true; _controller.play(); _controller.setLooping(true); });
    });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        if (!mounted || !_isInitialized) return;
        info.visibleFraction < 0.5 ? _controller.pause() : _controller.play();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_isInitialized) GestureDetector(onTap: () => _controller.value.isPlaying ? _controller.pause() : _controller.play(), child: VideoPlayer(_controller)) else const Center(child: CircularProgressIndicator()),
          Positioned(right: 10, bottom: 100, child: Column(children: [
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(height: 20),
            IconButton(icon: const Icon(Icons.favorite, color: Colors.red, size: 35), onPressed: () => Provider.of<XontikProvider>(context, listen: false).addLike()),
            IconButton(icon: const Icon(Icons.comment, size: 35), onPressed: () {}),
            IconButton(icon: const Icon(Icons.share, size: 35), onPressed: () {}),
          ])),
        ],
      ),
    );
  }
}

// --- 5. واجهة اكتشف ---
class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("اكتشف إبداع XONTIK")),
      body: ListView(
        children: [
          _buildBanner(),
          const ListTile(title: Text("هاشتاقات متصدرة", style: TextStyle(fontWeight: FontWeight.bold))),
          _buildHorizontalList(),
        ],
      ),
    );
  }

  Widget _buildBanner() => Container(
    height: 150, margin: const EdgeInsets.all(15),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), gradient: const LinearGradient(colors: [Colors.purple, Colors.red])),
    child: const Center(child: Text("تحدي XONTIK الجديد 🚀", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
  );

  Widget _buildHorizontalList() => SizedBox(
    height: 160,
    child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: 5, itemBuilder: (c, i) => Container(width: 110, margin: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8), image: const DecorationImage(image: NetworkImage("https://picsum.photos/200/300"), fit: BoxFit.cover)))),
  );
}

// --- 6. الإعدادات ---
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الإعدادات"), backgroundColor: Colors.black),
      body: ListView(
        children: [
          ListTile(leading: const Icon(Icons.wallet), title: const Text("المحفظة"), onTap: () {}),
          ListTile(leading: const Icon(Icons.live_tv, color: Colors.red), title: const Text("بث مباشر"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const LiveStreamScreen()))),
        ],
      ),
    );
  }
}

// --- 7. البث المباشر ---
class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key});
  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  final List<Widget> _hearts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.black87, child: const Center(child: Text("بث مباشر XONTIK LIVE"))),
          ..._hearts,
          Positioned(top: 40, right: 20, child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))),
          Positioned(bottom: 20, right: 20, child: IconButton(icon: const Icon(Icons.favorite, color: Colors.pink, size: 40), onPressed: () {
            setState(() { _hearts.add(FloatingHeart(leftPosition: 50.0 + (DateTime.now().millisecond % 200))); });
          })),
        ],
      ),
    );
  }
}

// --- 8. صندوق الوارد ---
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الرسائل"), backgroundColor: Colors.black),
      body: ListView.builder(
        itemCount: xontikUsers.length,
        itemBuilder: (context, i) => ListTile(
          onTap: () => Navigator.push(context, createXontikRoute(const ChatDetailScreen())),
          leading: CircleAvatar(backgroundImage: NetworkImage(xontikUsers[i].image)),
          title: Text(xontikUsers[i].name),
          subtitle: Text(xontikUsers[i].lastMsg),
        ),
      ),
    );
  }
}

// --- 9. واجهة المحادثة ---
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final List<String> _msgs = ["مرحباً بك في XONTIK!"];
  final TextEditingController _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("المحادثة")),
      body: Column(
        children: [
          Expanded(child: ListView.builder(itemCount: _msgs.length, itemBuilder: (c, i) => ListTile(title: Text(_msgs[i])))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(child: TextField(controller: _ctrl, decoration: const InputDecoration(hintText: "اكتب هنا..."))),
              IconButton(icon: const Icon(Icons.send), onPressed: () { setState(() { _msgs.add(_ctrl.text); _ctrl.clear(); }); })
            ]),
          )
        ],
      ),
    );
  }
}

// --- 10. تعديل الملف الشخصي ---
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تعديل الملف")),
      body: const Center(child: Text("هنا يمكنك تعديل بياناتك")),
    );
  }
}

// --- 11. القلوب المتطايرة ---
class FloatingHeart extends StatefulWidget {
  final double leftPosition;
  const FloatingHeart({super.key, required this.leftPosition});
  @override
  State<FloatingHeart> createState() => _FloatingHeartState();
}

class _FloatingHeartState extends State<FloatingHeart> with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(seconds: 2))..forward().then((_) => dispose());
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ac,
      builder: (c, _) => Positioned(bottom: 100 + (_ac.value * 300), left: widget.leftPosition, child: Opacity(opacity: 1 - _ac.value, child: const Icon(Icons.favorite, color: Colors.red, size: 40))),
    );
  }
}

// --- 12. الكاميرا ---
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isInit = false;
  @override
  void initState() {
    super.initState();
    availableCameras().then((c) {
      if (c.isNotEmpty) {
        _controller = CameraController(c[0], ResolutionPreset.high);
        _controller!.initialize().then((_) { if (mounted) setState(() => _isInit = true); });
      }
    });
  }
  @override
  void dispose() { _controller?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isInit ? CameraPreview(_controller!) : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.red, onPressed: () => Navigator.pop(context), child: const Icon(Icons.close)),
    );
  }
}

