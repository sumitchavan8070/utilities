import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HiddenDrawerController extends GetxController {
  RxDouble xOffset = 0.0.obs;
  RxDouble yOffset = 0.0.obs;
  RxDouble scaleFactor = 1.0.obs;
  RxBool isDrawerOpen = false.obs;
  RxBool isSmtTapped = false.obs;
  RxBool isFilterTapped = false.obs;
  
  

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final filterScaffoldKey  = GlobalKey<ScaffoldState>(); 

  void toggleDrawer() {

    debugPrint("_hiddenDrawerController ::::: ${isDrawerOpen.value}");

    isDrawerOpen.value = !isDrawerOpen.value;
    if (isDrawerOpen.value) {
      xOffset.value = 230;
      yOffset.value = 130;
      scaleFactor.value = 0.7;

    } else {
      xOffset.value = 0;
      yOffset.value = 0;
      scaleFactor.value = 1;
    }
    debugPrint(isDrawerOpen.value.toString());
  }
}
