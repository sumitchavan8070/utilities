import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:utilities/constants/logger.dart';

Future<String?> getDeviceId() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  String? id;
  logger.f("----------  Function deviceInfo ----------");

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    id = androidInfo.id;

    logger.f("----------  Function deviceInfo id and --> : $id ----------");

    // Unique device ID for Android
    return androidInfo.id;
  }
  if (Platform.isIOS) {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    id = iosInfo.identifierForVendor;
    logger.f("----------  Function deviceInfo id ios  --> : $id ----------");
    // Unique device ID for iOS
    return id;
  }
  id = "Error while retrieving the device ID App Error";
  logger.f("----------  Function deviceInfo id override  --> : $id ----------");

  return id.toString();
}
