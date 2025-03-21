library utilities;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:utilities/services/crashlytics_service.dart';
import 'package:utilities/services/get_package_info.dart';


late final GlobalKey<ScaffoldMessengerState> globalScaffoldMessengerKey;
late final GoRouter globalGoConfig;

Future<void> initGlobalKeys(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    GoRouter globalRouter) async {
  globalScaffoldMessengerKey = scaffoldMessengerKey;
  globalGoConfig = globalRouter;

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize GetStorage
  final getStatus = await GetStorage.init();
  debugPrint("-------- initGetStorage ------ => $getStatus");

  CrashlyticsService().init();
  await getPackageInfo();
  // Global Flutter error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };
}




