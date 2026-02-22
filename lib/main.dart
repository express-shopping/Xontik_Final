import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'app_state.dart'; 

class XontikUser {
  final String name;
  final String handle;
  final String image;
  final String lastMsg;

  XontikUser({required this.name, required this.handle, required this.image, this.lastMsg = ""});
}

// قائمة المستخدمين المركزية
final List<XontikUser> xontikUsers = [
  XontikUser(name: "أحمد المصراتي", handle: "@ahmed_99", image: "https://i.pravatar.cc/150?u=1", lastMsg: "تصميم رائع!"),
  XontikUser(name: "سارة المبروك", handle: "@sara_designer", image: "https://i.pravatar.cc/150?u=2", lastMsg: "شكراً على الدعم"),
  XontikUser(name: "محمد علي", handle: "@m_ali", image: "https://i.pravatar.cc/150?u=3", lastMsg: "متى البث القادم؟"),
];

Route createXontikRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0); // يبدأ من اليمين
      var end = Offset.zero;
      var curve = Curves.easeInOutQuart; // حركة ناعمة جداً
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      
      return SlideTransition(
        position: animation.drive(tween),
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

// --- 2. الهيكل الرئيسي مع زر النشر المطور ---
class MainTikTokScaffold extends StatefulWidget {
  const MainTikTokScaffold({super.key});
  @override
  State<MainTikTokScaffold> createState() => _MainTikTokScaffoldState();
}

class _MainTikTokScaffoldState extends State<MainTikTokScaffold> {
  int _selectedIndex = 0;

  // هنا قمنا بوضع الواجهات الحقيقية بدلاً من كلمة "Center" القديمة
  final List<Widget> _pages = [
    const TikTokFeedView(),   // صفحة الفيديوهات
    const DiscoverView(),     // صفحة اكتشف الجديدة والمميزة
    Container(),              // مكان فارغ لزر الـ (+)
    const InboxScreen(),      // صفحة صندوق الوارد
    const ProfileScreen(),    // صفحة الملف الشخصي
  ];

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
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (context) => Container(
        height: 250,
        color: Colors.black87,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, 
              children: [
                _uploadBtn(Icons.videocam, "كاميرا", Colors.purple), // السطر 178 المعدل
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _uploadBtn(IconData i, String t, Color c) => Column(children: [CircleAvatar(radius: 30, backgroundColor: c.withOpacity(0.2), child: Icon(i, color: c, size: 30)), const SizedBox(height: 10), Text(t)]);
}


// --- 3. الملف الشخصي (أزرار دائرية ووردية) ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, 
        title: const Text("Xontik_Creator"), 
        centerTitle: true, 
        // تفعيل الزر هنا
        actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsScreen()));
        })]
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
    // هنا نستخدم Consumer لسحب الرقم الحقيقي من Provider
    Consumer<XontikProvider>(
      builder: (context, provider, child) {
        return _stat(provider.formattedLikes, "إعجاب");
      },
    ),
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
    showModalBottomSheet(context: context, backgroundColor: Colors.grey[900], builder: (c) => Container(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [const Text("مشاركة الملف الشخصي", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 20), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [Icon(Icons.link, size: 40), Icon(Icons.facebook, size: 40), Icon(Icons.send, size: 40)])])));
  }
}

// --- 4. محرك الفيديوهات الحقيقي (XONTIK VIDEO PLAYER) ---
class TikTokFeedView extends StatelessWidget {
  const TikTokFeedView({super.key});

  // روابط فيديوهات حقيقية للتجربة
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

// --- 4. محرك الفيديوهات المصحح بالكامل ---
class VideoItem extends StatefulWidget {
  final String videoUrl;
  const VideoItem({super.key, required this.videoUrl});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

// استبدل كلاس _VideoItemState بهذا لضمان عدم وجود تكرار
class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isFollowed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: const Color(0xFF161616).withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: const Center(child: Text("قسم التعليقات")),
      ),
    );
  }

  Widget _buildSideActions() {
    return Column(
      children: [
        _sideProfile(),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () => Provider.of<XontikProvider>(context, listen: false).addLike(),
          child: _sideAction(Icons.favorite, "Like", Colors.red),
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () => _showComments(context), 
          child: _sideAction(Icons.chat_bubble, "1.2K", Colors.white)
        ),
        const SizedBox(height: 15),
        _sideAction(Icons.share, "Share", Colors.white),
        const SizedBox(height: 15),
        _musicRotationIcon(),
      ],
    );
  }

  Widget _sideProfile() => Stack(clipBehavior: Clip.none, children: [
    const CircleAvatar(radius: 25, backgroundColor: Colors.white, child: CircleAvatar(radius: 23, child: Icon(Icons.person))),
    Positioned(
      bottom: -8, left: 15, 
      child: GestureDetector(
        onTap: () => setState(() => _isFollowed = !_isFollowed),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(color: _isFollowed ? Colors.green : Colors.red, shape: BoxShape.circle),
          child: Icon(_isFollowed ? Icons.check : Icons.add, size: 18, color: Colors.white),
        ),
      ),
    )
  ]);

  Widget _sideAction(IconData i, String l, Color c) => Column(
    children: [
      Icon(i, size: 30, color: c),
      const SizedBox(height: 4),
      Text(l, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
    ],
  );

  Widget _musicRotationIcon() => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(shape: BoxShape.circle, gradient: SweepGradient(colors: [Colors.black, Colors.grey[800]!, Colors.black])),
    child: const Icon(Icons.music_note, size: 18, color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        if (info.visibleFraction < 0.5) {
          if (_isInitialized) _controller.pause();
        } else {
          if (_isInitialized) _controller.play();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          _isInitialized 
              ? GestureDetector(
                  onTap: () => setState(() => _controller.value.isPlaying ? _controller.pause() : _controller.play()), 
                  child: VideoPlayer(_controller)
                ) 
              : const Center(child: CircularProgressIndicator()),
          Positioned(right: 10, bottom: 100, child: _buildSideActions()), // تم نقل الأزرار لليمين كما في تيك توك
        ],
      ),
    );
  }
}



  // الدوال المساعدة الأصلية للفيديو

  Widget _sideAction(IconData i, String l, Color c) => Column(
    children: [
      Icon(i, size: 30, color: c),
      const SizedBox(height: 4),
      Text(l, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
    ],
  );

  Widget _musicRotationIcon() => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(shape: BoxShape.circle, gradient: SweepGradient(colors: [Colors.black, Colors.grey[800]!, Colors.black])),
    child: const Icon(Icons.music_note, size: 18, color: Colors.white),
  );

// --- واجهة تعديل الملف الاحترافية (XONTIK) ---
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // تعريف وحدات التحكم للنصوص
  final TextEditingController _nameController = TextEditingController(text: "Xontik_Official");
  final TextEditingController _usernameController = TextEditingController(text: "xontik_pro");
  final TextEditingController _bioController = TextEditingController(text: "مبدع في عالم XONTIK 🔥");
  
  String _storyPrivacy = "عام"; // القيمة الافتراضية للقصة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("تعديل الملف الشخصي", style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("حفظ", style: TextStyle(color: Color(0xFFeb3349), fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // قسم تغيير الصورة
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(radius: 50, backgroundColor: Colors.white10, child: Icon(Icons.person, size: 50, color: Colors.white24)),
                  Positioned(bottom: 0, right: 0, child: CircleAvatar(radius: 15, backgroundColor: Colors.blue, child: Icon(Icons.camera_alt, size: 15, color: Colors.white))),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // الحقول المطلوبة
            _buildEditItem("الاسم", _nameController, "يمكنك تغيير اسمك مرة واحدة كل 30 يوم."),
            _buildEditItem("اسم المستخدم", _usernameController, "xontik.com/@${_usernameController.text}"),
            _buildEditItem("السيرة الذاتية", _bioController, "أخبرنا عنك...", isBio: true),
            
            const Divider(color: Colors.white12, height: 40),
            
            // ميزة القصة والخصوصية (طلبك الخاص)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("إعدادات القصة (Story)", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("من يمكنه رؤية قصتي؟"),
                    trailing: DropdownButton<String>(
                      value: _storyPrivacy,
                      dropdownColor: Colors.grey[900],
                      underline: const SizedBox(),
                      items: ["عام", "أصدقاء", "أنا فقط"].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(color: Colors.white)));
                      }).toList(),
                      onChanged: (val) => setState(() => _storyPrivacy = val!),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // أداة بناء حقول الإدخال بتصميم راقي
  Widget _buildEditItem(String label, TextEditingController controller, String hint, {bool isBio = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 15))),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  maxLines: isBio ? 3 : 1,
                  maxLength: isBio ? 80 : 30, // السيرة لا تتجاوز 80 حرف
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 5),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFeb3349))),
                  ),
                ),
                const SizedBox(height: 5),
                Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- صفحة الإعدادات والخصوصية الشاملة ---
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("الإعدادات والخصوصية", style: TextStyle(fontSize: 16)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        children: [
          _sectionTitle("الحساب"),
          _settingsTile(Icons.person_outline, "إدارة الحساب"),
          _settingsTile(Icons.lock_outline, "الخصوصية"),
          _settingsTile(Icons.security, "الأمان"),
          
          _sectionTitle("المحتوى والعمليات"),
          _settingsTile(Icons.account_balance_wallet_outlined, "المحفظة", subtitle: "PayPal, بنك, محافظ إلكترونية", onTap: () => _showWallet(context)),
          _settingsTile(
  Icons.live_tv, 
  "بث مباشر (LIVE)", 
  color: Colors.redAccent, 
  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const LiveStreamScreen())),
),
          _settingsTile(Icons.language, "اللغة", subtitle: "العربية"),
          
          _sectionTitle("الدعم"),
          _settingsTile(Icons.help_outline, "مركز المساعدة"),
          _settingsTile(Icons.flag_outlined, "إبلاغ عن مشكلة"),
          
          const SizedBox(height: 30),
          Center(
            child: TextButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text("تسجيل الخروج", style: TextStyle(color: Color(0xFFeb3349), fontWeight: FontWeight.bold)),
            ),
          ),
          const Center(child: Text("Version 1.0.0 Xontik", style: TextStyle(color: Colors.white24, fontSize: 10))),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 8),
    child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
  );

  Widget _settingsTile(IconData icon, String title, {String? subtitle, Color color = Colors.white, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap ?? () {},
      leading: Icon(icon, color: color, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitle != null) Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white24),
        ],
      ),
    );
  }

  // نافذة المحفظة الاحترافية
  void _showWallet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("المحفظة الإلكترونية", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            _walletOption(Icons.paypal, "PayPal", Colors.blue),
            _walletOption(Icons.account_balance, "حساب بنكي مباشر", Colors.green),
            _walletOption(Icons.wallet, "محفظة إلكترونية", Colors.orange),
            const SizedBox(height: 15),
            const Text("سيتم تحويل الأرباح خلال 24 ساعة", style: TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _walletOption(IconData i, String t, Color c) => ListTile(
    leading: Icon(i, color: c),
    title: Text(t),
    trailing: const Text("ربط", style: TextStyle(color: Color(0xFFeb3349))),
    onTap: () {},
  );
}


// --- 7. واجهة البث المباشر الاحترافية (XONTIK LIVE) ---
class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key});
  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

// --- الجزء المعدل من واجهة البث المباشر ---
class _LiveStreamScreenState extends State<LiveStreamScreen> {
  final List<String> _comments = ["مبدع يا فنان! 🔥", "تحية من ليبيا 🇱🇾", "أجمل بث اليوم 😍", "كيف حالك يا بطل؟"];
  int _likes = 12500;
  
  // 1. أضف قائمة القلوب هنا كمتغير
  List<Widget> _hearts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // خلفية البث
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(child: Icon(Icons.videocam_off, color: Colors.white24, size: 80)),
          ),

          // الطبقة العلوية (معلومات المضيف)
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 20)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Xontik_Creator", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text("${_likes.toString()} إعجاب", style: const TextStyle(fontSize: 10, color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFeb3349), borderRadius: BorderRadius.circular(20)),
                        child: const Text("متابعة", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                _liveStat(Icons.visibility, "1.2K"),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // منطقة التعليقات
          Positioned(
            bottom: 100,
            left: 15,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 200,
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, i) => _buildComment(_comments[i]),
              ),
            ),
          ),

          // 2. عرض القلوب المتطايرة فوق العناصر (استخدام ميزة الـ Spread Operator ...)
          ..._hearts,

          // الأزرار السفلية
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 45,
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(25)),
                    child: const TextField(
                      decoration: InputDecoration(hintText: "أرسل تعليقاً...", border: InputBorder.none, hintStyle: TextStyle(color: Colors.white54, fontSize: 14)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _bottomAction(Icons.card_giftcard, Colors.orange, () => _showGifts(context)),
                const SizedBox(width: 10),
                
                // 3. كود الزر المطور الذي وضعته أنت (ولكن داخل مكان الـ build)
                _bottomAction(Icons.touch_app, Colors.pinkAccent, () {
  setState(() {
    _likes += 100; // زيادة العداد
    
    // إنشاء مفتاح فريد لكل قلب ليتم حذفه لاحقاً
    UniqueKey heartKey = UniqueKey();
    
    // إضافة قلب جديد للقائمة بموقع عشوائي بسيط
    _hearts.add(FloatingHeart(
      key: heartKey,
      leftPosition: 50.0 + (DateTime.now().millisecond % 150), 
    ));

    // كود الحذف التلقائي من الذاكرة بعد ثانيتين
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _hearts.removeWhere((heart) => heart.key == heartKey);
        });
      }
    });
  });
}),

                const SizedBox(width: 10),
                _bottomAction(Icons.share, Colors.blue, () {}),
              ],
            ),
          ),
          
          const Positioned(top: 100, right: 15, child: Text("LIVE", style: TextStyle(color: Color(0xFFeb3349), fontWeight: FontWeight.bold, letterSpacing: 2))),
        ],
      ),
    );
  }

  // الدوال المساعدة تبقى كما هي...
  Widget _liveStat(IconData i, String v) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(15)),
    child: Row(children: [Icon(i, size: 14, color: Colors.white), const SizedBox(width: 4), Text(v, style: const TextStyle(fontSize: 12))]),
  );

  Widget _buildComment(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(text: "User_Name: ", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
            TextSpan(text: text, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    ),
  );

  Widget _bottomAction(IconData i, Color c, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: CircleAvatar(radius: 22, backgroundColor: Colors.black45, child: Icon(i, color: c, size: 24)),
  );

  void _showGifts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.9),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (c) => Container(
        padding: const EdgeInsets.all(20),
        height: 350,
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("أرسل هدية لدعم المبدع", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  _giftItem("🌹", "وردة", "1"),
                  _giftItem("💎", "ألماس", "100"),
                  _giftItem("🦁", "أسد", "3000"),
                  _giftItem("🚀", "صاروخ", "5000"),
                  _giftItem("👑", "تاج", "500"),
                  _giftItem("🎸", "جيتار", "50"),
                  _giftItem("🚗", "سيارة", "1000"),
                  _giftItem("🔥", "نار", "10"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _giftItem(String icon, String name, String price) => Column(
    children: [
      Text(icon, style: const TextStyle(fontSize: 30)),
      Text(name, style: const TextStyle(fontSize: 10, color: Colors.white70)),
      Text("🪙 $price", style: const TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.bold)),
    ],
  );
}
// أضف هذا الـ Widget في مكان كلمة "LIVE" القديمة
Widget _buildProLiveBadge() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.redAccent.withOpacity(0.8), Color(0xFFeb3349)],
      ),
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 10, spreadRadius: 1)
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.sensors, size: 14, color: Colors.white),
        const SizedBox(width: 4),
        Text("LIVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
      ],
    ),
  );
}

// --- 8. واجهة صندوق الوارد (Inbox) ---
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("الرسائل", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.add_comment_outlined), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // قسم الأصدقاء النشطين (Stories style)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, i) => _buildActiveUser(),
            ),
          ),
          const Divider(color: Colors.white12),
          // قائمة المحادثات
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, i) => _buildChatTile(context, i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveUser() => Padding(
    padding: const EdgeInsets.all(10),
    child: Stack(
      children: [
        const CircleAvatar(radius: 30, backgroundColor: Colors.white10, child: Icon(Icons.person, color: Colors.white54)),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(width: 15, height: 15, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2))),
        ),
      ],
    ),
  );

  Widget _buildChatTile(BuildContext context, int i) {
  final user = xontikUsers[i % xontikUsers.length]; // جلب مستخدم من القائمة
  return ListTile(
    onTap: () => Navigator.of(context).push(createXontikRoute(const ChatDetailScreen())),
    leading: CircleAvatar(
      backgroundImage: NetworkImage(user.image),
    ),
    title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(user.lastMsg, style: const TextStyle(color: Colors.white54)),
    trailing: const Text("١٢:٤٠ م", style: TextStyle(fontSize: 10, color: Colors.grey)),
  );
 }
}


// --- 9. واجهة المحادثة التفصيلية (The Professional Chat) ---
class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Row(
          children: [
            const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 20)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Xontik User", style: TextStyle(fontSize: 14)),
                Text("متصل الآن", style: TextStyle(fontSize: 10, color: Colors.green)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call_outlined, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_outlined, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: NetworkImage("https://www.transparenttextures.com/patterns/black-linen.png"), repeat: ImageRepeat.repeat),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  _chatBubble("مرحباً بك في عالم XONTIK! 🔥", true),
                  _chatBubble("أهلاً بك، كيف يمكنني مساعدتك؟", false),
                  _chatBubble("أريد تجربة واجهة الدردشة الجديدة", true),
                  _chatBubble("بالتأكيد! إنها واجهة ذكية وراقية جداً", false),
                ],
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _chatBubble(String text, bool isMe) => Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFFeb3349) : Colors.white12,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isMe ? 20 : 0),
          bottomRight: Radius.circular(isMe ? 0 : 20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 15)),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("10:00", style: TextStyle(fontSize: 9, color: Colors.white60)),
              if (isMe) const SizedBox(width: 4),
              if (isMe) const Icon(Icons.done_all, size: 12, color: Colors.blueAccent),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildMessageInput() => Container(
    padding: const EdgeInsets.all(10),
    color: Colors.black,
    child: Row(
      children: [
        IconButton(icon: const Icon(Icons.add_circle, color: Color(0xFFeb3349)), onPressed: () {}),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(25)),
            child: const TextField(
              decoration: InputDecoration(hintText: "اكتب رسالة...", border: InputBorder.none, hintStyle: TextStyle(fontSize: 14)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: const Color(0xFFeb3349),
          child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 18), onPressed: () {}),
        ),
      ],
    ),
  );
}


// --- 10. محرك القلوب المتطايرة (Xontik Heart Animation) ---
class FloatingHeart extends StatefulWidget {
  final double leftPosition;
  const FloatingHeart({super.key, required this.leftPosition});
  @override
  State<FloatingHeart> createState() => _FloatingHeartState();
}

class _FloatingHeartState extends State<FloatingHeart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _movement;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)));
    _movement = Tween<double>(begin: 0.0, end: -300.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward().then((_) => _controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          bottom: 100 - _movement.value,
          left: widget.leftPosition,
          child: Opacity(
            opacity: _opacity.value,
            child: const Icon(Icons.favorite, color: Color(0xFFeb3349), size: 35),
          ),
        );
      },
    );
  }
}


// --- 11. واجهة اكتشف الاحترافية (Discover View) ---
class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: "بحث عن مبدعين أو هاشتاقات...",
              hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.white70),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        children: [
          // 1. شريط الإعلانات أو التريندات الكبرى (Banner)
          _buildTrendingBanner(),

          // 2. قسم الهاشتاقات المتصدرة
          _buildTrendingSection("برمجة_فلاتر", "1.5M"),
          _buildHorizontalVideoList(),

          _buildTrendingSection("Xontik_Masterpiece", "850K"),
          _buildHorizontalVideoList(),

          _buildTrendingSection("إبداع_ليبي", "500K"),
          _buildHorizontalVideoList(),

          const SizedBox(height: 20),
          
          // 3. قسم المستخدمين المقترحين
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text("مبدعون قد تعجب بهم", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSuggestedUsers(),
        ],
      ),
    );
  }

  Widget _buildTrendingBanner() {
    return Container(
      margin: const EdgeInsets.all(15),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFFeb3349), Color(0xFF2af1f7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 20, top: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("تحدي XONTIK الجديد", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("شارك إبداعك واربح جوائز قيمة", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Positioned(
            right: -10, bottom: -10,
            child: Icon(Icons.rocket_launch, size: 120, color: Colors.white.withOpacity(0.2)),
          )
        ],
      ),
    );
  }

  Widget _buildTrendingSection(String tag, String views) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
            child: const Text("#", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tag, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("أكثر من $views مشاهدة", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildHorizontalVideoList() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: 6,
        itemBuilder: (context, i) => Container(
          width: 110,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: NetworkImage("https://picsum.photos/200/300?random"), // صور عشوائية للتجربة
              fit: BoxFit.cover,
            ),
          ),
          child: const Stack(
            children: [
              Positioned(bottom: 5, left: 5, child: Row(children: [Icon(Icons.play_arrow, size: 14), Text("12K", style: TextStyle(fontSize: 10))])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedUsers() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: 5,
        itemBuilder: (context, i) => Container(
          width: 100,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              const CircleAvatar(radius: 35, backgroundColor: Colors.white10, child: Icon(Icons.person, size: 30)),
              const SizedBox(height: 8),
              Text("User_${i+1}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              const Text("مبدع رقمي", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}


// --- واجهة تصوير الفيديو الحقيقية (XONTIK Real Camera) ---

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with SingleTickerProviderStateMixin {
  // متغيرات الكاميرا
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isInitialized = false;
  bool _isRecording = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // تشغيل الكاميرا فور الدخول
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  // دالة تشغيل عدسة الكاميرا
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      // اختيار الكاميرا الخلفية [0] بدقة عالية
      _controller = CameraController(cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // إغلاق الكاميرا لتوفير البطارية
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. عرض بث الكاميرا الحقيقي
          if (_isInitialized && _controller != null)
            CameraPreview(_controller!)
          else
            const Center(child: CircularProgressIndicator(color: Color(0xFFeb3349))),

          // 2. واجهة الأزرار (Overlay)
          _buildCameraUI(),
        ],
      ),
    );
  }

  // دالة بناء الواجهة فوق الكاميرا
  Widget _buildCameraUI() {
    return Column(
      children: [
        // الجزء العلوي: إغلاق وموسيقى
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.close, size: 30, color: Colors.white), onPressed: () => Navigator.pop(context)),
              _buildMusicBadge(),
              IconButton(icon: const Icon(Icons.flash_off, color: Colors.white), onPressed: () {}),
            ],
          ),
        ),
        const Spacer(),
        // الجزء السفلي: زر التسجيل
        _buildBottomControls(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMusicBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
    child: const Row(
      children: [
        Icon(Icons.music_note, size: 18, color: Color(0xFF2af1f7)),
        SizedBox(width: 8),
        Text("إضافة موسيقى", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  Widget _buildBottomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildToolIcon(Icons.image, "المعرض"),
        // زر التسجيل النابض
        GestureDetector(
          onTap: () => setState(() => _isRecording = !_isRecording),
          child: ScaleTransition(
            scale: _isRecording ? _pulseController : const AlwaysStoppedAnimation(1.0),
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFeb3349),
                  borderRadius: BorderRadius.circular(_isRecording ? 10 : 50),
                ),
              ),
            ),
          ),
        ),
        _buildToolIcon(Icons.face, "المؤثرات"),
      ],
    );
  }

  Widget _buildToolIcon(IconData icon, String label) => Column(
    children: [
      Icon(icon, color: Colors.white, size: 30),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
    ],
  );
}

// Build Trigger
// Force Build Sun Feb 22 18:07:00 UTC 2026
