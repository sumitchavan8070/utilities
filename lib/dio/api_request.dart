import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:utilities/constants/logger.dart';

import 'api_client.dart';

Future<Response> getRequest({required String apiEndPoint}) async {
  Dio client = NewClient().init();

  try {
    debugPrint("^^^^^^^^^^^^^^^^^^ $apiEndPoint getRequest Start ^^^^^^^^^^^^^^^^^^");

    final response = await client.get(apiEndPoint);

    debugPrint("^^^^^^^^^^^^^^^^^^ $apiEndPoint getRequest End ^^^^^^^^^^^^^^^^^^");

    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }

    return response;
  } catch (e) {
    logger.e("Error in getRequest => apiEndPoint : $apiEndPoint || Error: $e");

    rethrow;
  }
}

Future<Response> postRequest({
  required String apiEndPoint,
  required Map<String, dynamic> postData,
  FormData? formData,
}) async {
  Dio client = NewClient().init();
  try {
    debugPrint("~~~~~~~~~~~~~~~~~~~~ $apiEndPoint postRequest Start ~~~~~~~~~~~~~~~~~~~~ ");

    debugPrint(
        "~~~~~~~~~~~~~~~~~~~~ $apiEndPoint postRequest formData ${formData?.fields} ~~~~~~~~~~~~~~~~~~~~ ");
    debugPrint(
        "~~~~~~~~~~~~~~~~~~~~ $apiEndPoint postRequest postData $postData ~~~~~~~~~~~~~~~~~~~~ ");

    final response = await client.post(apiEndPoint, queryParameters: postData);

    debugPrint("~~~~~~~~~~~~~~~~~~~~ $apiEndPoint postRequest End ~~~~~~~~~~~~~~~~~~~~ ");

    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }

    return response;
  } catch (e) {
    logger.e("Error in postRequest => apiEndPoint : $apiEndPoint || Error: $e");

    rethrow;
  }
}
