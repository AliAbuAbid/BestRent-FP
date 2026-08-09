// ignore_for_file: unused_import

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/ChattingApp/chat_page.dart';
import 'package:derot/DataBase/firebase_options.dart';
import 'package:derot/HouseRent/HouseEditor/ShowInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
}

class PushNotificationService {
  PushNotificationService._();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'bestrent_default_channel',
    'BestRent Notifications',
    description: 'App notifications and chat messages',
    importance: Importance.high,
  );

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[Push] permission status: ${settings.authorizationStatus}');

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) _handleTap(initialMessage);

    FirebaseMessaging.instance.onTokenRefresh.listen(_saveToken);

    FirebaseAuth.instance.authStateChanges().listen((user) {
      debugPrint('[Push] authStateChanges: uid=${user?.uid}');
      if (user != null) _saveTokenForCurrentUser();
    });
    if (FirebaseAuth.instance.currentUser != null) {
      await _saveTokenForCurrentUser();
    }
  }

  static Future<void> _saveTokenForCurrentUser() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint('[Push] got FCM token: $token');
      if (token != null) await _saveToken(token);
    } catch (e, st) {
      debugPrint('[Push] _saveTokenForCurrentUser error: $e\n$st');
    }
  }

  static Future<DocumentReference?> _currentUserDocRef() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      debugPrint('[Push] no signed-in user, skipping token save');
      return null;
    }
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    if (query.docs.isEmpty) {
      debugPrint('[Push] no users doc found for uid=$uid');
      return null;
    }
    return query.docs.first.reference;
  }

  static Future<void> _saveToken(String token) async {
    try {
      final ref = await _currentUserDocRef();
      if (ref == null) return;
      await ref.update({
        'fcmTokens': FieldValue.arrayUnion([token]),
      });
      debugPrint('[Push] saved token to ${ref.path}');
    } catch (e, st) {
      debugPrint('[Push] _saveToken error: $e\n$st');
    }
  }

  /// Call on logout so this device stops receiving pushes for the signed-out account.
  static Future<void> clearTokenForCurrentUser() async {
    final ref = await _currentUserDocRef();
    if (ref == null) return;
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    await ref.update({
      'fcmTokens': FieldValue.arrayRemove([token]),
    });
  }

  static void _onForegroundMessage(RemoteMessage message) {
    debugPrint('[Push] onMessage: ${message.notification?.title} / ${message.notification?.body} data=${message.data}');
    final notification = message.notification;
    if (notification == null) return;
    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  static void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      _navigateForData(jsonDecode(payload) as Map<String, dynamic>);
    } catch (_) {}
  }

  static void _handleTap(RemoteMessage message) {
    _navigateForData(message.data);
  }

  static Future<void> _navigateForData(Map<String, dynamic> data) async {
    final type = data['type'];
    if (type == 'chat') {
      final senderId = data['senderId'];
      if (senderId == null) return;
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: senderId)
          .limit(1)
          .get();
      if (query.docs.isEmpty) return;
      final userData = query.docs.first.data();
      Get.to(() => ChatPage(
            receiverUserEmail: userData['email'],
            receiverUserID: senderId,
            receiverUsername: userData['username'],
          ));
    } else if (type == 'apartment' && data['apartmentId'] != null) {
      contentId = data['apartmentId'];
      Get.to(() => ShowInfo());
    }
  }
}
