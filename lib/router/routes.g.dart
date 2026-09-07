// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $homeRoute,
  $appStatefulShell,
  $appShell,
  $settingsRoute,
];

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/',
  name: 'Home',
  hasOverriddenOnExit: false,
  factory: $HomeRoute._fromState,
);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $appStatefulShell => StatefulShellRouteData.$route(
  parentNavigatorKey: AppStatefulShell.$parentNavigatorKey,
  factory: $AppStatefulShellExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/stateful/order',
          name: 'Order Overview (state)',
          hasOverriddenOnExit: false,
          factory: $OrderOverviewStatefulRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'detail',
              name: 'Order Detail (state)',
              hasOverriddenOnExit: false,
              factory: $OrderDetailsStatefulRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/stateful/user',
          name: 'User Overview (state)',
          hasOverriddenOnExit: false,
          factory: $UserOverviewStatefulRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'detail',
              name: 'User Details (state)',
              hasOverriddenOnExit: false,
              factory: $UserDetailsStatefulRoute._fromState,
            ),
          ],
        ),
      ],
    ),
  ],
);

extension $AppStatefulShellExtension on AppStatefulShell {
  static AppStatefulShell _fromState(GoRouterState state) => AppStatefulShell();
}

mixin $OrderOverviewStatefulRoute on GoRouteData {
  static OrderOverviewStatefulRoute _fromState(GoRouterState state) =>
      OrderOverviewStatefulRoute();

  @override
  String get location => GoRouteData.$location('/stateful/order');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OrderDetailsStatefulRoute on GoRouteData {
  static OrderDetailsStatefulRoute _fromState(GoRouterState state) =>
      OrderDetailsStatefulRoute(
        orderID: _$convertMapValue(
          'id',
          state.uri.queryParameters,
          int.tryParse,
        ),
      );

  OrderDetailsStatefulRoute get _self => this as OrderDetailsStatefulRoute;

  @override
  String get location => GoRouteData.$location(
    '/stateful/order/detail',
    queryParams: {if (_self.orderID != null) 'id': _self.orderID!.toString()},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $UserOverviewStatefulRoute on GoRouteData {
  static UserOverviewStatefulRoute _fromState(GoRouterState state) =>
      UserOverviewStatefulRoute();

  @override
  String get location => GoRouteData.$location('/stateful/user');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $UserDetailsStatefulRoute on GoRouteData {
  static UserDetailsStatefulRoute _fromState(GoRouterState state) =>
      UserDetailsStatefulRoute(
        userID: _$convertMapValue(
          'id',
          state.uri.queryParameters,
          int.tryParse,
        ),
      );

  UserDetailsStatefulRoute get _self => this as UserDetailsStatefulRoute;

  @override
  String get location => GoRouteData.$location(
    '/stateful/user/detail',
    queryParams: {if (_self.userID != null) 'id': _self.userID!.toString()},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

RouteBase get $appShell => ShellRouteData.$route(
  parentNavigatorKey: AppShell.$parentNavigatorKey,
  factory: $AppShellExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/stateless/order',
      name: 'Order Overview',
      hasOverriddenOnExit: false,
      factory: $OrderOverviewRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'detail',
          name: 'Order Detail',
          hasOverriddenOnExit: false,
          factory: $OrderDetailsRoute._fromState,
        ),
      ],
    ),
    GoRouteData.$route(
      path: '/stateless/user',
      name: 'User Overview',
      hasOverriddenOnExit: false,
      factory: $UserOverviewRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'detail',
          name: 'User Detail',
          hasOverriddenOnExit: false,
          factory: $UserDetailsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $AppShellExtension on AppShell {
  static AppShell _fromState(GoRouterState state) => AppShell();
}

mixin $OrderOverviewRoute on GoRouteData {
  static OrderOverviewRoute _fromState(GoRouterState state) =>
      OrderOverviewRoute();

  @override
  String get location => GoRouteData.$location('/stateless/order');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OrderDetailsRoute on GoRouteData {
  static OrderDetailsRoute _fromState(GoRouterState state) => OrderDetailsRoute(
    orderID: _$convertMapValue('id', state.uri.queryParameters, int.tryParse),
  );

  OrderDetailsRoute get _self => this as OrderDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/stateless/order/detail',
    queryParams: {if (_self.orderID != null) 'id': _self.orderID!.toString()},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $UserOverviewRoute on GoRouteData {
  static UserOverviewRoute _fromState(GoRouterState state) =>
      UserOverviewRoute();

  @override
  String get location => GoRouteData.$location('/stateless/user');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $UserDetailsRoute on GoRouteData {
  static UserDetailsRoute _fromState(GoRouterState state) => UserDetailsRoute(
    userID: _$convertMapValue('id', state.uri.queryParameters, int.tryParse),
  );

  UserDetailsRoute get _self => this as UserDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/stateless/user/detail',
    queryParams: {if (_self.userID != null) 'id': _self.userID!.toString()},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $settingsRoute => GoRouteData.$route(
  path: '/settings',
  name: 'Settings',
  hasOverriddenOnExit: false,
  factory: $SettingsRoute._fromState,
);

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
