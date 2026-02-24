import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

// --- البروفايدر المسؤول عن إدارة الحالة (تمت إضافته لإصلاح الخطأ) ---
class XontikProvider with ChangeNotifier {
  int _likes = 1500000;
  String get formattedLikes => "${(_likes / 1000000).toStringAsFixed(1)}M";

  void addLike() {
    _likes++;
    notifyListeners();
  }

  void simulateIncomingMessage(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      showXontikNotification(context, "أحمد المصراتي", "تصميم رائع جداً! 🔥");
    });
  }
}

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
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeInOutQuart;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: FadeTransition(opacity: animation, child: child));
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
            _socialBtn(Icons.g_mobiledata, "المتابعة باستخدام Google"),
            _socialBtn(Icons.apple, "المتابعة باستخدام Apple"),
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
    child: Row(children: [Icon(icon, color: color, size: 26), Expanded(child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500)))]),
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
    const SizedBox(), // Placeholder for plus button
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

  void _onItemTapped(int index) {
    if (index == 2) {
      _showUploadOptions(context);
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
        height: 280, padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 30),
            const Text("إنشاء منشور جديد", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
            const Spacer(),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء", style: TextStyle(color: Colors.white60, fontSize: 16)))
          ],
        ),
      ),
    );
  }

  Widget _uploadBtn(IconData icon, String label, Color color, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Column(children: [CircleAvatar(radius: 30, backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color, size: 30)), const SizedBox(height: 10), Text(label, style: const TextStyle(color: Colors.white, fontSize: 13))]),
  );
}

// --- 3. الملف الشخصي ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, title: const Text("Xontik_Creator"), centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsScreen())))]
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 15),
          const Text("@xontik_official", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              _stat("150", "أتابع"), 
              _stat("1.5M", "متابعين"), 
              Consumer<XontikProvider>(builder: (context, provider, child) => _stat(provider.formattedLikes, "إعجاب")),
            ]
          ),
          const SizedBox(height: 25),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _profileActionBtn("تعديل الملف", const Color(0xFFeb3349), () => Navigator.push(context, MaterialPageRoute(builder: (c) => const EditProfileScreen()))),
            const SizedBox(width: 10),
            _profileActionBtn("مشاركة الملف", Colors.white10, () => _showShareMenu(context)),
          ]),
          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          Expanded(child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1, mainAxisSpacing: 1), itemCount: 12, itemBuilder: (c, i) => Container(color: Colors.white10, child: const Icon(Icons.play_arrow, color: Colors.white24)))),
        ],
      ),
    );
  }
  Widget _stat(String v, String l) => Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [Text(v, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text(l, style: const TextStyle(color: Colors.grey))]));
  Widget _profileActionBtn(String t, Color c, VoidCallback o) => GestureDetector(onTap: o, child: Container(padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(25)), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))));
  void _showShareMenu(BuildContext context) {
    showModalBottomSheet(context: context, backgroundColor: Colors.grey[900], builder: (c) => Container(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: const [Text("مشاركة الملف الشخصي", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height: 20), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Icon(Icons.link, size: 40), Icon(Icons.facebook, size: 40), Icon(Icons.send, size: 40)])])));
  }
}

// --- 4. محرك الفيديوهات ---
class TikTokFeedView extends StatelessWidget {
  const TikTokFeedView({super.key});
  final List<String> videoUrls = const [
    "https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-lighting-in-the-city-21002-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-34659-large.mp4",
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
  bool _isFollowed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if(mounted) setState(() { _isInitialized = true; _controller.setLooping(true); _controller.play(); });
      });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        if (info.visibleFraction < 0.5) { if (_isInitialized) _controller.pause(); } 
        else { if (_isInitialized) _controller.play(); }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          _isInitialized 
              ? GestureDetector(onTap: () => setState(() => _controller.value.isPlaying ? _controller.pause() : _controller.play()), child: VideoPlayer(_controller)) 
              : const Center(child: CircularProgressIndicator()),
          Positioned(right: 10, bottom: 100, child: _buildSideActions()),
        ],
      ),
    );
  }

  Widget _buildSideActions() => Column(children: [
    _sideProfile(), const SizedBox(height: 15),
    GestureDetector(onTap: () => Provider.of<XontikProvider>(context, listen: false).addLike(), child: _sideAction(Icons.favorite, "Like", Colors.red)),
    const SizedBox(height: 15),
    GestureDetector(onTap: () => _showComments(context), child: _sideAction(Icons.chat_bubble, "1.2K", Colors.white)),
    const SizedBox(height: 15),
    _sideAction(Icons.share, "Share", Colors.white),
    const SizedBox(height: 15),
    _musicRotationIcon(),
  ]);

  Widget _sideProfile() => Stack(clipBehavior: Clip.none, children: [
    const CircleAvatar(radius: 25, backgroundColor: Colors.white, child: CircleAvatar(radius: 23, child: Icon(Icons.person))),
    Positioned(bottom: -8, left: 15, child: GestureDetector(onTap: () => setState(() => _isFollowed = !_isFollowed), child: Container(decoration: BoxDecoration(color: _isFollowed ? Colors.green : Colors.red, shape: BoxShape.circle), child: Icon(_isFollowed ? Icons.check : Icons.add, size: 18, color: Colors.white))))
  ]);

  Widget _sideAction(IconData i, String l, Color c) => Column(children: [Icon(i, size: 30, color: c), const SizedBox(height: 4), Text(l, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]);
  Widget _musicRotationIcon() => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(shape: BoxShape.circle, gradient: SweepGradient(colors: [Colors.black, Colors.grey[800]!, Colors.black])), child: const Icon(Icons.music_note, size: 18, color: Colors.white));
  
  void _showComments(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => Container(height: MediaQuery.of(context).size.height * 0.75, decoration: BoxDecoration(color: const Color(0xFF161616).withOpacity(0.95), borderRadius: const BorderRadius.vertical(top: Radius.circular(25))), child: const Center(child: Text("قسم التعليقات"))));
  }
}

// --- 5. تعديل الملف الشخصي ---
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(text: "Xontik_Official");
  final TextEditingController _usernameController = TextEditingController(text: "xontik_pro");
  final TextEditingController _bioController = TextEditingController(text: "مبدع في عالم XONTIK 🔥");
  String _storyPrivacy = "عام";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("تعديل الملف الشخصي"), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("حفظ", style: TextStyle(color: Color(0xFFeb3349))))]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(child: Stack(children: const [CircleAvatar(radius: 50, backgroundColor: Colors.white10, child: Icon(Icons.person, size: 50)), Positioned(bottom: 0, right: 0, child: CircleAvatar(radius: 15, backgroundColor: Colors.blue, child: Icon(Icons.camera_alt, size: 15)))])) ,
            _buildEditItem("الاسم", _nameController, "تغيير الاسم متاح كل 30 يوم."),
            _buildEditItem("اسم المستخدم", _usernameController, "xontik.com/@${_usernameController.text}"),
            _buildEditItem("السيرة الذاتية", _bioController, "أخبرنا عنك...", isBio: true),
            const Divider(color: Colors.white12, height: 40),
            ListTile(title: const Text("من يمكنه رؤية قصتي؟"), trailing: DropdownButton<String>(value: _storyPrivacy, dropdownColor: Colors.grey[900], items: ["عام", "أصدقاء", "أنا فقط"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => _storyPrivacy = v!))),
          ],
        ),
      ),
    );
  }
  Widget _buildEditItem(String label, TextEditingController controller, String hint, {bool isBio = false}) => Padding(padding: const EdgeInsets.all(15), child: Row(children: [SizedBox(width: 100, child: Text(label)), Expanded(child: TextField(controller: controller, maxLines: isBio ? 3 : 1, decoration: InputDecoration(hintText: hint, enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)))))]));
}

// --- 6. الإعدادات والخصوصية ---
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("الإعدادات والخصوصية")),
      body: ListView(
        children: [
          _tile(Icons.person_outline, "إدارة الحساب"),
          _tile(Icons.lock_outline, "الخصوصية"),
          _tile(Icons.account_balance_wallet_outlined, "المحفظة", onTap: () => _showWallet(context)),
          _tile(Icons.live_tv, "بث مباشر (LIVE)", color: Colors.redAccent, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const LiveStreamScreen()))),
          const SizedBox(height: 30),
          Center(child: TextButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text("تسجيل الخروج", style: TextStyle(color: Color(0xFFeb3349))))),
        ],
      ),
    );
  }
  Widget _tile(IconData i, String t, {Color color = Colors.white, VoidCallback? onTap}) => ListTile(leading: Icon(i, color: color), title: Text(t), trailing: const Icon(Icons.arrow_forward_ios, size: 14), onTap: onTap);
  void _showWallet(BuildContext context) {
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF121212), builder: (c) => Container(padding: const EdgeInsets.all(25), child: Column(mainAxisSize: MainAxisSize.min, children: const [Text("المحفظة الإلكترونية", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), SizedBox(height: 25), ListTile(leading: Icon(Icons.paypal, color: Colors.blue), title: Text("PayPal"), trailing: Text("ربط"))])));
  }
}

// --- 7. واجهة البث المباشر ---
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
      body: Stack(children: [
        Container(color: Colors.black87), ..._hearts,
        SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.all(15), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildProBadge(), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))])),
          const Spacer(),
          _buildBottomUI()
        ]))
      ]),
    );
  }
  Widget _buildProBadge() => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.redAccent, Color(0xFFeb3349)]), borderRadius: BorderRadius.circular(5)), child: const Row(children: [Icon(Icons.sensors, size: 14), SizedBox(width: 4), Text("LIVE")]));
  Widget _buildBottomUI() => Container(padding: const EdgeInsets.all(15), child: Row(children: [
    const Expanded(child: Text("مبدع يا فنان! 🔥")),
    IconButton(icon: const Icon(Icons.touch_app, color: Colors.pinkAccent), onPressed: () {
      setState(() { _hearts.add(FloatingHeart(leftPosition: 50.0 + (DateTime.now().millisecond % 150))); });
    }),
  ]));
}

// --- 8. صندوق الوارد ---
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("الرسائل")),
      body: ListView.builder(itemCount: xontikUsers.length, itemBuilder: (c, i) => ListTile(
        onTap: () => Navigator.push(context, createXontikRoute(const ChatDetailScreen())),
        leading: CircleAvatar(backgroundImage: NetworkImage(xontikUsers[i].image)),
        title: Text(xontikUsers[i].name), subtitle: Text(xontikUsers[i].lastMsg),
      )),
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
  final TextEditingController _ctrl = TextEditingController();
  final List<Map<String, dynamic>> _msgs = [{"text": "مرحباً بك في XONTIK!", "isMe": false}];
  void _send() {
    if (_ctrl.text.isEmpty) return;
    setState(() { _msgs.add({"text": _ctrl.text, "isMe": true}); });
    _ctrl.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey[900], title: const Text("أحمد المصراتي")),
      body: Column(children: [
        Expanded(child: ListView.builder(itemCount: _msgs.length, itemBuilder: (c, i) => _bubble(_msgs[i]["text"], _msgs[i]["isMe"]))),
        Container(padding: const EdgeInsets.all(10), child: Row(children: [Expanded(child: TextField(controller: _ctrl)), IconButton(icon: const Icon(Icons.send), onPressed: _send)]))
      ]),
    );
  }
  Widget _bubble(String t, bool m) => Align(alignment: m ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: m ? const Color(0xFFeb3349) : Colors.white12, borderRadius: BorderRadius.circular(15)), child: Text(t)));
}

// --- 10. القلوب المتطايرة ---
class FloatingHeart extends StatefulWidget {
  final double leftPosition;
  const FloatingHeart({super.key, required this.leftPosition});
  @override
  State<FloatingHeart> createState() => _FloatingHeartState();
}

class _FloatingHeartState extends State<FloatingHeart> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() { super.initState(); _c = AnimationController(duration: const Duration(seconds: 2), vsync: this)..forward(); }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _c, builder: (c, child) => Positioned(bottom: 100 + (_c.value * 300), left: widget.leftPosition, child: Opacity(opacity: 1 - _c.value, child: const Icon(Icons.favorite, color: Color(0xFFeb3349), size: 30))));
  }
}

// --- 11. واجهة اكتشف ---
class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: const TextField(decoration: InputDecoration(hintText: "بحث...", prefixIcon: Icon(Icons.search)))),
      body: ListView(children: [
        _buildBanner(),
        _section("#برمجة_فلاتر"), _list(),
        _section("#Xontik_Masterpiece"), _list(),
      ]),
    );
  }
  Widget _buildBanner() => Container(
    margin: const EdgeInsets.all(15), height: 160,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
    child: ClipRRect(borderRadius: BorderRadius.circular(15), child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: const Center(child: Text("تحدي XONTIK الجديد", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))))),
  );
  Widget _section(String t) => Padding(padding: const EdgeInsets.all(15), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)));
  Widget _list() => SizedBox(height: 150, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: 5, itemBuilder: (c, i) => Container(width: 100, margin: const EdgeInsets.all(5), color: Colors.white10, child: const Icon(Icons.play_arrow))));
}

// --- 12. واجهة الكاميرا ---
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _c;
  bool _init = false;
  @override
  void initState() { super.initState(); _setup(); }
  Future<void> _setup() async {
    final cams = await availableCameras();
    if (cams.isNotEmpty) { _c = CameraController(cams[0], ResolutionPreset.high); await _c!.initialize(); if(mounted) setState(() => _init = true); }
  }
  @override
  void dispose() { _c?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        if (_init) CameraPreview(_c!) else const Center(child: CircularProgressIndicator()),
        Positioned(top: 40, left: 10, child: IconButton(icon: const Icon(Icons.close, size: 30), onPressed: () => Navigator.pop(context))),
        Positioned(bottom: 50, left: 0, right: 0, child: Center(child: Container(width: 70, height: 70, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), color: const Color(0xFFeb3349))))),
      ]),
    );
  }
}
