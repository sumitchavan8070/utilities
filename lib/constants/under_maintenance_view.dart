import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:utilities/common_assets_path.dart';

class UnderMaintenanceScreen extends StatelessWidget {
  final String? message;
  final String? title;

  const UnderMaintenanceScreen({super.key, required this.message, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Lottie.asset(
                    CommonAssetPath.isServerMaintenance,
                    fit: BoxFit.cover,
                    animate: true,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              ErrorInfo(
                title: title ?? "Under Maintenance!",
                description: message ??
                    "We are currently performing scheduled maintenance. Please check back later. Thank you for your patience.",
                // button: you can pass your custom button,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
    this.button,
  });

  final String title;
  final String description;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style:
                  Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16 * 2.5),
          ],
        ),
      ),
    );
  }
}
