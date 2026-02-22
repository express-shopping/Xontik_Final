import 'package:flutter/material.dart';

class XontikProvider extends ChangeNotifier {
  // 1. المتغيرات (Variables) - نضعها في البداية
  int _totalLikes = 1500000;
  bool _isFollowing = false;

  // 2. دوال الجلب (Getters) - نضعها هنا
  int get totalLikes => _totalLikes;
  bool get isFollowing => _isFollowing;

  // 3. دالة تنسيق الأرقام التي سألت عنها (Formatted Likes)
  String get formattedLikes {
    if (_totalLikes >= 1000000) {
      return '${(_totalLikes / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M';
    } else if (_totalLikes >= 1000) {
      return '${(_totalLikes / 1000).toStringAsFixed(1).replaceAll('.0', '')}K';
    }
    return _totalLikes.toString();
  }

  // 4. الدوال التي تغير الحالة (Functions)
  void addLike() {
    _totalLikes++;
    notifyListeners(); // لتحديث الواجهة فوراً
  }

  void toggleFollow() {
    _isFollowing = !_isFollowing;
    notifyListeners();
  }
}

