import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationButtonsFAB extends StatefulWidget {
  const NavigationButtonsFAB({super.key});

  @override
  State<NavigationButtonsFAB> createState() => _NavigationButtonsFABState();
}

class NavigationItem {
  NavigationItem({required this.name, required this.path});
  final String? name;
  final String path;
}

class _NavigationButtonsFABState extends State<NavigationButtonsFAB> {
  bool isExpanded = false;
  late List<NavigationItem> routes;

  List<NavigationItem> expandRoutes(List<RouteBase> routes) {
    List<NavigationItem> entries = [];

    for (final route in routes) {
      if (route is StatefulShellRoute) {
        final r = expandRoutes(route.routes);
        entries.addAll(r);
      } else if (route is ShellRoute) {
        final r = expandRoutes(route.routes);
        entries.addAll(r);
      } else if (route is GoRoute) {
        final r = expandRoutes(route.routes);

        entries.addAll([
          NavigationItem(name: route.name, path: route.path),
          ...r.map((e) => NavigationItem(name: e.name, path: [route.path, e.path].join('/'))),
        ]);
      }
    }
    return entries;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final router = GoRouter.of(context);
    routes = expandRoutes(router.configuration.routes);
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    final toggleButton = FloatingActionButton.extended(
      heroTag: 'NavigationToggleButton',
      icon: Icon(isExpanded ? Icons.close : Icons.open_in_browser),
      label: Text(isExpanded ? 'close' : 'open'),
      onPressed: () => setState(() {
        isExpanded = !isExpanded;
      }),
    );

    if (isExpanded) {
      return SingleChildScrollView(
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...routes.map(
              (e) => FloatingActionButton.extended(
                heroTag: e.path,
                onPressed: () => router.go(e.path),
                label: Text(e.name ?? 'Unknown'),
              ),
            ),
            toggleButton,
          ],
        ),
      );
    }

    return toggleButton;
  }
}
