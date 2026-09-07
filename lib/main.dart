import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nested_home_page/router/routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: globalNavigatorKey,
    initialLocation: '/',
    routes: $appRoutes,
    observers: [routeObserver],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
