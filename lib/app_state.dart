import 'package:flutter/material.dart';
import 'main.dart'; // تأكد أن هذا المسار يؤدي لملف main الذي يحتوي على دالة التنبيه

class XontikProvider extends ChangeNotifier {
  // 1. المتغيرات
  int _totalLikes = 1500000;
  bool _isFollowing = false;

  // 2. الـ Getters
  int get totalLikes => _totalLikes;
  bool get isFollowing => _isFollowing;

  // 3. دالة تنسيق الأرقام الاحترافية (التي كتبتها أنت)
  String get formattedLikes {
    if (_totalLikes >= 1000000) {
      return '${(_totalLikes / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M';
    } else if (_totalLikes >= 1000) {
      return '${(_totalLikes / 1000).toStringAsFixed(1).replaceAll('.0', '')}K';
    }
    return _totalLikes.toString();
  }

  // 4. الدوال (Functions)
  void addLike() {
    _totalLikes++;
    notifyListeners(); 
  }

  void toggleFollow() {
    _isFollowing = !_isFollowing;
    notifyListeners();
  }

  // 5. ميزة محاكاة وصول رسالة (الإضافة الجديدة)
  void simulateIncomingMessage(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      // تستدعي الدالة الموجودة في main.dart
      showXontikNotification(
        context, 
        "أحمد المصراتي", 
        "أهلاً بك في تحدي XONTIK الجديد! 🚀"
      );
    });
  }
}

// أضف هذا داخل كلاس XontikProvider في ملف app_state.dart

double _balance = 0.0; // الرصيد الحالي بالدولار
int _diamonds = 0;    // عدد الألماسات (العملة الافتراضية)

double get balance => _balance;
int get diamonds => _diamonds;

// دالة لإضافة أرباح عند استلام هدية (مثلاً الأسد يعطي 50 دولار)
void receiveGift(int diamondValue, double cashValue) {
  _diamonds += diamondValue;
  _balance += cashValue;
  notifyListeners(); // لتحديث الواجهة فوراً
}

// دالة لسحب الأرباح إلى PayPal أو البنك
void withdrawFunds(double amount) {
  if (_balance >= amount) {
    _balance -= amount;
    notifyListeners();
  }
}

