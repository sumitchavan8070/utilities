import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:utilities/constants/under_maintenance_view.dart';
import 'package:utilities/navigation/route_path.dart';

List<RouteBase> utilitiesRoutes({
  required GlobalKey<NavigatorState>? shellNavigatorKey,
  required GlobalKey<NavigatorState>? rootNavigatorKey,
}) {
  return [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: UtilitiesPaths.isServerMaintenance,
      name: UtilitiesPaths.isServerMaintenance,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final message = extras["message"];
        final title = extras["title"];
        return UnderMaintenanceScreen(message: message, title: title);
      },
    ),

  ];
}
