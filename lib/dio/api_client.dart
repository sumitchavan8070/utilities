import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:utilities/app_change.dart';
import 'package:utilities/constants/logger.dart';
import 'package:utilities/dio/api_end_points.dart';

class NewClient {
  Dio init() {
    final prefs = GetStorage();
    final osType = Platform.isAndroid ? "Android" : "IOS";
    final appName = AppConstants.appName;
    final buildNumber = prefs.read("appBuildNumber");
    final appVersion = prefs.read("appVersion");
    final packageName = prefs.read("packageName");

    var token = prefs.read('TOKEN');
    bool isLoggedIn = prefs.read("IS_LOGGED_IN") == true;

    Dio dio = Dio();
    dio.options.baseUrl = APIEndPoints.base;
    dio.options.headers["Authorization"] = 'Bearer ${token ?? ""}';
    dio.options.headers["AppName"] = appName;
    dio.options.headers["source"] = osType;
    dio.options.headers["appBuildNumber"] = buildNumber;
    dio.options.headers["appVersion"] = appVersion;
    dio.options.headers["packageName"] = packageName;

    logger.f("options.headers || ${dio.options.headers}");

    void updateCrashlytics(DioException e, RequestOptions options) {
      final baseUrl = options.baseUrl;
      final apiEndPoint = options.path;
      final requestMethod = options.method;
      final postData = options.queryParameters;

      if (!kDebugMode) {
        final crashlytics = FirebaseCrashlytics.instance;

        crashlytics.recordError("API EXCEPTION DIO: ${options.path}", e.stackTrace, fatal: true);
        crashlytics.setCustomKey("baseUrl", baseUrl);
        crashlytics.setCustomKey("api_end_point", apiEndPoint);
        crashlytics.setCustomKey("request_method", requestMethod);
        crashlytics.setCustomKey("AppName", appName);
        crashlytics.setCustomKey("token", token ?? "");
        crashlytics.setCustomKey("isLoggedInStatus", isLoggedIn);

        if (options.method == 'POST') {
          crashlytics.setCustomKey("post_data", postData);
        }

        logger.f(
            " Crashlytics updated -->  || baseUrl $baseUrl || apiEndPoint $apiEndPoint || requestMethod $requestMethod ||  postData $postData");
      }
    }

    debugPrint("------------   AppName => $appName |||||||||||||||||  source => $osType");

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onError: (e, handler) {
          // For update the Crashlytics to the Firebase
          updateCrashlytics(e, e.requestOptions);

          return handler.next(e);
        },
      ),
    );
    return dio;
  }
}
