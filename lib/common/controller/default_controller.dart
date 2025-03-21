import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:utilities/common/model/default_model.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/api_request.dart';

class DefaultController extends GetxController with StateMixin<DefaultModel> {
  RxBool isLoad = false.obs;
  final prefs = GetStorage();

  getDefaultData() async {
    var token = prefs.read('TOKEN');

    const apiEndPoint = APIEndPoints.defaultApi;
    isLoad.value = true;
    debugPrint("---------- $apiEndPoint getDefaultData Starst ----------");

    try {
      final response = await getRequest(
          apiEndPoint: apiEndPoint
      );

      debugPrint("DefaultController =>  getDefaultData > Success $response");


      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ';
      }

      final modal = DefaultModel.fromJson(response.data);
      change(modal, status: RxStatus.success());
    } catch (error) {
      isLoad.value = false;
      debugPrint("---------- $apiEndPoint  getDefaultData End With Error ----------");
      debugPrint(" DefaultController =>  getDefaultData > Error $error ");
      change(null, status: RxStatus.error(error.toString()));
    } finally {
      isLoad.value = false;

      debugPrint("---------- $apiEndPoint  getDefaultData End ----------");
    }
  }
}
