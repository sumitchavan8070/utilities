import 'package:flutter/material.dart';
import 'package:utilities/packages/smooth_rectangular_border.dart';
import 'package:utilities/theme/app_colors.dart';

class CoreAppTheme {
  static ThemeData theme({
    Color? scaffoldBackgroundColor,
    Color? primaryColor,
    String? fontFamily,
    SwitchThemeData? switchTheme,
    PopupMenuThemeData? popupMenuTheme,
    BottomSheetThemeData? bottomSheetTheme,
    InputDecorationTheme? inputDecorationTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    PageTransitionsTheme? pageTransitionsTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
  }) {
    return ThemeData(
      scaffoldBackgroundColor: scaffoldBackgroundColor ?? AppColors.backgroundColor,
      primaryColor: primaryColor ?? AppColors.primaryColor,
      fontFamily: fontFamily ?? 'Poppins',
      useMaterial3: true,
      switchTheme: switchTheme ?? const SwitchThemeData(splashRadius: 0),
      popupMenuTheme: popupMenuTheme ?? const PopupMenuThemeData(color: Colors.white),
      bottomSheetTheme: bottomSheetTheme ??
          BottomSheetThemeData(
            backgroundColor: Colors.white,
            shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.vertical(
                top: SmoothRadius(cornerRadius: 16, cornerSmoothing: 1.0),
              ),
            ),
            showDragHandle: true,
            dragHandleSize: const Size(60, 4),
            clipBehavior: Clip.hardEdge,
          ),
      inputDecorationTheme: inputDecorationTheme ??
          InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 10),
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.alabaster,
            hintStyle: const TextStyle(color: AppColors.stormGrey),
          ),
      outlinedButtonTheme: outlinedButtonTheme ??
          OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(cornerRadius: 10),
              ),
            ),
          ),
      pageTransitionsTheme: pageTransitionsTheme ??
          const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
      elevatedButtonTheme: elevatedButtonTheme ??
          ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(letterSpacing: 0.15),
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: SmoothBorderRadius(cornerRadius: 10),
              ),
            ),
          ),
    );
  }
}
