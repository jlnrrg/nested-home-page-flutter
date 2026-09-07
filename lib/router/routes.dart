import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:nested_home_page/view/pages/order_details_page.dart';
import 'package:nested_home_page/view/pages/order_overview.dart';
import 'package:nested_home_page/view/pages/settings_page.dart';
import 'package:nested_home_page/view/pages/user_details_page.dart';
import 'package:nested_home_page/view/pages/user_overview_page.dart';
import 'package:nested_home_page/view/widget/scroll/inner_scroll_widget.dart';
import 'package:nested_home_page/view/widget/scroll/root_shell_wrapper.dart';

part 'routes.g.dart';

final routeObserver = RouteObserver<ModalRoute<void>>();

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'globalNavigatorKey');

@TypedGoRoute<HomeRoute>(path: '/', name: 'Home')
class HomeRoute extends GoRouteData with $HomeRoute {
  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return OrderOverviewStatefulRoute().location;
  }
}

@TypedStatefulShellRoute<AppStatefulShell>(
  branches: [
    TypedStatefulShellBranch<OrderTab>(
      routes: [
        TypedGoRoute<OrderOverviewStatefulRoute>(
          path: '/stateful/order',
          name: 'Order Overview (state)',

          routes: [TypedGoRoute<OrderDetailsStatefulRoute>(path: 'detail', name: 'Order Detail (state)')],
        ),
      ],
    ),
    TypedStatefulShellBranch<UserTab>(
      routes: [
        TypedGoRoute<UserOverviewStatefulRoute>(
          path: '/stateful/user',
          name: 'User Overview (state)',
          routes: [TypedGoRoute<UserDetailsStatefulRoute>(path: 'detail', name: 'User Details (state)')],
        ),
      ],
    ),
  ],
)
class AppStatefulShell extends StatefulShellRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = globalNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
    return RootShellWrapper(child: navigationShell);
  }
}

class OrderTab extends StatefulShellBranchData {}

class UserTab extends StatefulShellBranchData {}

@TypedShellRoute<AppShell>(
  routes: [
    TypedGoRoute<OrderOverviewRoute>(
      path: '/stateless/order',
      name: 'Order Overview',
      routes: [TypedGoRoute<OrderDetailsRoute>(path: 'detail', name: 'Order Detail')],
    ),
    TypedGoRoute<UserOverviewRoute>(
      path: '/stateless/user',
      name: 'User Overview',
      routes: [TypedGoRoute<UserDetailsRoute>(path: 'detail', name: 'User Detail')],
    ),
  ],
)
class AppShell extends ShellRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = globalNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return RootShellWrapper(child: navigator);
  }
}

// Outside Routes

@TypedGoRoute<SettingsRoute>(path: '/settings', name: 'Settings')
/// The [SettingsPage] is an example of a page living above the [RootShellWrapper]
class SettingsRoute extends GoRouteData with $SettingsRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) => SettingsPage();
}

// Stateful Shell Routes

class OrderOverviewStatefulRoute extends CustomRouteData with $OrderOverviewStatefulRoute {
  @override
  Widget buildContent(BuildContext context) => OrderOverviewPage(key: ValueKey('OrderOverviewStatefulRoute'));
}

class OrderDetailsStatefulRoute extends CustomRouteData with $OrderDetailsStatefulRoute {
  OrderDetailsStatefulRoute({@TypedQueryParameter(name: 'id') this.orderID});

  final int? orderID;
  @override
  Widget buildContent(BuildContext context) => OrderDetailsPage(key: ValueKey(orderID), orderID: orderID);
}

class UserOverviewStatefulRoute extends CustomRouteData with $UserOverviewStatefulRoute {
  @override
  Widget buildContent(BuildContext context) => UserOverviewPage(key: ValueKey('UserOverviewStatefulRoute'));
}

class UserDetailsStatefulRoute extends CustomRouteData with $UserDetailsStatefulRoute {
  UserDetailsStatefulRoute({@TypedQueryParameter(name: 'id') this.userID});

  final int? userID;

  @override
  Widget buildContent(BuildContext context) => UserDetailsPage(key: ValueKey(userID), userID: userID);
}

// Stateless Shell Routes

class OrderOverviewRoute extends CustomRouteData with $OrderOverviewRoute {
  @override
  Widget buildContent(BuildContext context) => OrderOverviewPage();
}

class OrderDetailsRoute extends CustomRouteData with $OrderDetailsRoute {
  OrderDetailsRoute({@TypedQueryParameter(name: 'id') this.orderID});

  final int? orderID;
  @override
  Widget buildContent(BuildContext context) => OrderDetailsPage(key: ValueKey(orderID), orderID: orderID);
}

class UserOverviewRoute extends CustomRouteData with $UserOverviewRoute {
  @override
  Widget buildContent(BuildContext context) => UserOverviewPage();
}

class UserDetailsRoute extends CustomRouteData with $UserDetailsRoute {
  UserDetailsRoute({@TypedQueryParameter(name: 'id') this.userID});

  final int? userID;

  @override
  Widget buildContent(BuildContext context) => UserDetailsPage(key: ValueKey(userID), userID: userID);
}

// Base

class CustomRouteData extends GoRouteData {
  @mustBeOverridden
  Widget buildContent(BuildContext context) {
    throw UnimplementedError('One of `build` or `buildContent` must be implemented.');
  }

  Widget pageWrapper(BuildContext context, GoRouterState state, Widget child) {
    return InnerScrollWidget(key: child.key, routeData: this, sliver: child);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final Widget content = pageWrapper(context, state, buildContent(context));

    return CustomWebPage(
      key: state.pageKey,
      name: state.uri.toString(),
      // canPop: GoRouter.of(context).routerDelegate.currentConfiguration.routes.whereType<GoRoute>().length > 1,
      child: content,
    );
  }
}

class CustomWebPage<T> extends CustomTransitionPage<T> {
  const CustomWebPage({super.key, super.name, required super.child})
    : super(transitionsBuilder: _defaultTransitionsBuilder);

  static Widget _defaultTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fadeOutTween = Tween<double>(begin: 1, end: 0);
    final fadeInTween = Tween<double>(begin: 0, end: 1);
    final slideOutTween = Tween<Offset>(begin: Offset.zero, end: const Offset(-1, 0));
    final slideInTween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);

    return FadeTransition(
      opacity: secondaryAnimation.drive(fadeOutTween),
      child: SlideTransition(
        position: secondaryAnimation.drive(slideOutTween),
        child: FadeTransition(
          opacity: animation.drive(fadeInTween),
          child: SlideTransition(position: animation.drive(slideInTween), child: child),
        ),
      ),
    );
  }
}
