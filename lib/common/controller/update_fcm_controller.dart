import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utilities/constants/logger.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/api_request.dart';

class UpdateFcmController extends GetxController {
  updateFcm({required String? token, String? currentTime, String? deviceID}) async {
    const apiEndPoint = APIEndPoints.updateFcmToken;
    debugPrint("---------- $apiEndPoint updateFcm Start ----------");

    final postData = {
      "fcm_token": token,
      "currentTime": currentTime,
      "deviceID": deviceID
    };

    try {
      final response = await postRequest(
        apiEndPoint: apiEndPoint,
        postData: postData ?? {"fcm_token": token},
      );

      debugPrint("UpdateFcmController => updateFcm > Success  $response");

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }
    } catch (error) {
      debugPrint("---------- $apiEndPoint updateFcm End With Error ----------");
      debugPrint("UpdateFcmController => updateFcm > Error $error ");
    } finally {
      debugPrint("---------- $apiEndPoint updateFcm End ----------");
    }
  }
}
