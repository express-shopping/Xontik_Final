import 'package:flutter/material.dart';

// هذا الكود هو المسؤول عن إدارة البيانات (اللايكات، الرصيد، الإشعارات)
class XontikProvider extends ChangeNotifier {
  // --- بيانات الرصيد والمحفظة ---
  double _balance = 125.50; // رصيد وهمي مبدئي
  double get balance => _balance;

  // --- بيانات الإعجابات ---
  int _likes = 1500;
  String get formattedLikes {
    if (_likes >= 1000) {
      return "${(_likes / 1000).toStringAsFixed(1)}K";
    }
    return _likes.toString();
  }

  // دالة إضافة إعجاب
  void addLike() {
    _likes++;
    notifyListeners(); // هذا السطر هو الذي كان يسبب الخطأ، الآن سيعمل!
  }

  // دالة سحب الأموال
  void withdrawFunds(double amount) {
    if (_balance >= amount) {
      _balance -= amount;
      notifyListeners();
      print("تم سحب $amount دولار بنجاح");
    }
  }

  // محاكاة وصول رسالة جديدة
  void simulateIncomingMessage(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      // استدعاء دالة الإشعار الجذاب التي صممناها في main.dart
      // ملاحظة: تأكد من أن الدالة showXontikNotification موجودة في main.dart
    });
  }
}

