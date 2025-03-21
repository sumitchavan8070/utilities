import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utilities/common/controller/update_fcm_controller.dart';
import 'package:utilities/common_assets_path.dart';
import 'package:utilities/constants/logger.dart';
import 'package:utilities/services/get_device_id.dart';
import 'package:utilities/utilities.dart';

final _updateFcmController = Get.put(UpdateFcmController());

class FCMNotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final prefs = GetStorage();
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Future<String?> getDeviceId() async {
  //   final deviceInfoPlugin = DeviceInfoPlugin();
  //   String? id;
  //   logger.f("----------  Function deviceInfo ----------");
  //
  //
  //   if (Platform.isAndroid) {
  //     final androidInfo = await deviceInfoPlugin.androidInfo;
  //     id = androidInfo.id;
  //
  //
  //     logger.f("----------  Function deviceInfo id and --> : $id ----------");
  //
  //     return androidInfo.id; // Unique device ID for Android
  //   }
  //   if (Platform.isIOS) {
  //     final iosInfo = await deviceInfoPlugin.iosInfo;
  //     id = iosInfo.identifierForVendor;
  //     logger.f("----------  Function deviceInfo id ios  --> : $id ----------");
  //
  //     return id; // Unique device ID for iOS
  //   }
  //   id = "Error while retrieving the device ID App Error";
  //   logger.f("----------  Function deviceInfo id override  --> : $id ----------");
  //
  //   return id.toString();
  // }

  Future<void> updateFCMToken() async {
    _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    final deviceId = await getDeviceId();
    final currentTime = DateTime.now();
    logger.f("---------- FCM TOKEN -->  $fcmToken ----------");

    if (fcmToken == null) {
      logger.f("----------  updateFCMTokenAPI Stopped FCM Token in null ----------");
      logger.f("----------  updateFCMTokenAPI deviceInfo $deviceId  ----------");
    }

    if (prefs.read('fcm') == null) {
      prefs.write('fcm', fcmToken);

      _updateFcmController.updateFcm(
          token: fcmToken, currentTime: currentTime.toString(), deviceID: deviceId);
      logger.f("----------  updateFCMTokenAPI  $fcmToken----------");
      print("----------  updateFCMTokenAPI  $fcmToken----------");

      return;
    } else {
      if (prefs.read('fcm') == fcmToken) {
        debugPrint("----------  updateFCMTokenAPI Stopped Same FCM Token  $fcmToken----------");
        _updateFcmController.updateFcm(
            token: fcmToken, currentTime: currentTime.toString(), deviceID: deviceId);
        return;
      }
    }

    debugPrint("FCM TOKEN $fcmToken ");

    if (fcmToken != null) {
      _updateFcmController.updateFcm(
          token: fcmToken, currentTime: currentTime.toString(), deviceID: deviceId);
    }
  }

  Future<void> clearFCMToken() async {
    _firebaseMessaging.deleteToken();
    _updateFcmController.updateFcm(token: null);
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    const initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_notification');
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // ------- Android notification click handler
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        try {
          final Map payload = json.decode(details.payload ?? "");
          onNotificationClicked(payload: payload);
        } catch (e) {
          debugPrint("onDidReceiveNotificationResponse error $e");
        }
      },
    );
  }

  onNotificationClicked({required Map payload}) async {
    debugPrint("---------payload::$payload");

    // Notification tap should open an external URL -->
    final redirectUrl = payload["redirect_url"];
    if (redirectUrl != "") {
      if (await launchUrl(redirectUrl, mode: LaunchMode.externalApplication)) {
        await canLaunchUrl(
          redirectUrl,
        );
      }
    }

    // For app routing, navigate the client to any screen within the app.
    try {
      if (payload.containsKey('path') && payload.containsKey('arguments')) {
        final arguments = json.decode(payload['arguments']);
        if (arguments == null) {
          return;
        }
        globalGoConfig.pushNamed(payload['path'], extra: arguments);
        debugPrint("---------payload false::$payload");
      } else if (payload.containsKey('path') == true) {
        globalGoConfig.pushNamed(payload['path']);
        debugPrint("---------payload true ::${payload['path']}");
      }
    } catch (e) {
      debugPrint("onNotificationClicked error $e");
    }
  }

  fcmListener({Function()? onTap}) {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        logger.t(
            "Notification Recieved =>  payload --> ${message.data} titile ${message.notification?.title} || body --> ${message.notification?.body}    ");
        createNotification(message);
      },
    );
  }

  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    try {
      final Map? payLoadMap = json.decode(payload ?? "");

      if (payLoadMap == null) {
        throw "error";
      }
      onNotificationClicked(payload: payLoadMap);
    } catch (e) {
      debugPrint("onDidReceiveNotificationResponse error $e");
    }
  }

  //----------------------------------------------------------

  static void createNotification(RemoteMessage message) async {
    try {
      final title = message.notification?.title ?? "";
      final body = message.notification?.body ?? "";
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const androidNotificationDetails = AndroidNotificationDetails(
        'pushnotification',
        'pushnotification',
        importance: Importance.max,
        priority: Priority.high,
        // sound: RawResourceAndroidNotificationSound(CommonAssetPath.smsTone),
        enableVibration: true ,
        // styleInformation: BigPictureStyleInformation(DrawableResourceAndroidBitmap('ic_notification'), largeIcon:  DrawableResourceAndroidBitmap('ic_notification')),
        largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
      );

      const iosNotificationDetail = DarwinNotificationDetails();

      const notificationDetails = NotificationDetails(
        iOS: iosNotificationDetail,
        android: androidNotificationDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: json.encode(message.data),
      );
    } catch (error) {
      debugPrint("Notification Create Error $error");
    }
  }
}
