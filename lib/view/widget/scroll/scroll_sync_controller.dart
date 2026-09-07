import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nested_home_page/extension/go_route_data_extension.dart';
import 'package:nested_home_page/view/widget/scroll/subordinate_scroll_controller.dart';

/// Consists of the [StatefulNavigationShell]'s branch index and the route (route.locationWithoutQuery + widget.key)
typedef ScrollKey = (int branch, String? route);

/// Used to save the scroll states of [ScrollController]s
class NestedScrollState {
  final double outerOffset;
  final double? innerOffset;

  const NestedScrollState({required this.outerOffset, required this.innerOffset});
}

class ScrollSyncController extends ChangeNotifier {
  ScrollSyncController({this.activeBranch = 0, this.useResetAnimation = true}) : outer = ScrollController();

  /// NestedScrollView's own controller
  final ScrollController outer;

  /// NestedScrollView's own coordinator controller
  late ScrollController _inner;

  ScrollController get innerActive => _pageSpecificController[activeKey] ?? _inner;

  // Keys
  int activeBranch;
  final Map<int, String?> _activeRoutes = {}; // by branch
  ScrollKey get activeKey => (activeBranch, _activeRoutes[activeBranch]);
  String? get activeRoute => _activeRoutes[activeBranch];

  /// Saves the [route] into [_activeRoutes] storage
  void _setRouteActive(GoRouteData route, {required Key? widgetKey}) =>
      _activeRoutes[activeBranch] = route.toKey(widgetKey);

  final Map<ScrollKey, NestedScrollState> scrollStates = {};
  final Map<ScrollKey, SubordinateScrollController?> _pageSpecificController = {};

  /// Is calculated by the height of the inner scrollview
  //! init to true seems to be required to make the initial scroll deactivation work correctly
  bool scrollEnabled = true;

  /// Disables Scrolling when the inner content is to short, thus disabling scrolling for the outer sliverHeader
  ScrollPhysics? get physics => scrollEnabled ? null : const NeverScrollableScrollPhysics();

  /// Defines whether the SliverHeader should jump or animate into view
  final bool useResetAnimation;

  /// Captured once, from WrapperPage's Builder — the one true inner controller.
  void attachSharedInner(ScrollController controller) => _inner = controller;

  /// Delivers a (saved) [ScrollController] which syncs to the [_inner]
  SubordinateScrollController getScrollController(GoRouteData route, {required Key? widgetKey}) {
    final controller = _pageSpecificController[(activeBranch, route.toKey(widgetKey))] ??= SubordinateScrollController(
      parent: _inner,
      debugLabel: route.runtimeType.toString(),
    );
    debugPrint('getScrollController ($activeBranch, $route); $controller');
    return controller;
  }

  /// Removes no longer needed [ScrollController]s
  void disposeScrollController(GoRouteData route, {required Key? widgetKey}) {
    debugPrint('disposeScrollController $activeBranch, $route');
    final key = (activeBranch, route.toKey(widgetKey));

    _activeRoutes.removeWhere((_, value) => value == route.toKey(widgetKey));
    scrollStates.remove(key);
    _pageSpecificController[key]?.dispose();
    _pageSpecificController.remove(key);
  }

  /// Calculate if the inner content is high enough to allow scrolling
  void calculateScrollEnabled() {
    final inner = _pageSpecificController[activeKey];

    if (!outer.hasClients || !(inner?.hasClients ?? false)) {
      _setScroll(false);
      return;
    }

    final headerHeight = outer.position.maxScrollExtent;
    final innerWithHeader = (inner?.position.extentInside ?? 0) + headerHeight;
    final bool headerScrolled = outer.position.extentInside < innerWithHeader;
    final bool overflows = headerScrolled || (inner?.position.maxScrollExtent ?? 0) > 0;
    _setScroll(overflows);
  }

  void _setScroll(bool value) {
    if (value == scrollEnabled) return;
    scrollEnabled = value;
    notifyListeners();
    debugPrint('_setScroll: $value');
  }

  /// When the [StatefulNavigationShell.currentIndex] changes this method is called to adjust to the right controller
  void setActiveBranch(int? index) {
    debugPrint('setActiveBranch $index');
    if (index == activeBranch || index == null) return;
    final route = _activeRoutes[index];

    final oldKey = activeKey;
    final newKey = (index, route);

    debugPrint('setActiveBranch $index');

    _disableInnerController(oldKey);
    // an unknown route controller should not be activated/ will be activated by [setActiveRoute] anyway
    if (route != null) {
      _enableInnerController(newKey);
    }

    activeBranch = index;
    calculateScrollEnabled();
  }

  /// Triggers once a new Route is pushed or popped to and adjusts the right controller
  void setActiveRoute(GoRouteData route, {required Key? widgetKey}) {
    final newRouteKey = route.toKey(widgetKey);
    if (activeRoute == newRouteKey) return;

    final oldKey = activeKey;
    final newKey = (activeBranch, newRouteKey);

    debugPrint('setActiveRoute $route');

    // Deactivate whatever was active before ourselves, rather than relying on
    // RouteObserver's didPushNext firing — it doesn't fire reliably when
    // GoRouter builds several pages of the same branch's Navigator in a single
    // frame (cold start / deep link straight into a nested route). Without
    // this, the previous route's SubordinateScrollController stays attached to
    // the shared inner controller at the same time as the new route's one.
    if (oldKey.$2 != null && oldKey != newKey) {
      _disableInnerController(oldKey);
    }

    _enableInnerController(newKey);

    _setRouteActive(route, widgetKey: widgetKey);
  }

  /// Deactivates the route & controller once the route is popped or another pushed
  void setInactiveRoute(GoRouteData route, {required Key? widgetKey}) {
    final oldKey = activeKey;
    debugPrint('setInactiveRoute $route');
    _disableInnerController(oldKey);
  }

  /// Disables controller and saves scroll positions
  void _disableInnerController(ScrollKey key) {
    debugPrint('disableInnerController $key');
    final inner = _pageSpecificController[key];
    // safe inner & outer position
    if (outer.hasClients && (inner?.hasClients ?? false)) {
      scrollStates[key] = NestedScrollState(outerOffset: outer.offset, innerOffset: inner?.offset);
    }
    inner?.isActive = false;
  }

  /// Actives controller and restores scroll positions
  void _enableInnerController(ScrollKey key) {
    debugPrint('enableInnerController $key');
    final inner = _pageSpecificController[key];
    final lastScrollState = scrollStates[key];

    // Jump to last saved position
    final (outerOffset, innerOffset) = (lastScrollState?.outerOffset, lastScrollState?.innerOffset);

    // we need to await the inner to have clients
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('enableInnerController $key callback');

      // A newer route/branch may have become active before this callback ran
      // (e.g. GoRouter building /dashboard and /dashboard/item in the same
      // frame on cold start). Bail out so we don't touch the shared `outer`
      // controller on behalf of a page that's no longer current.
      if (key != activeKey) {
        debugPrint('enableInnerController $key skipped, no longer active $activeKey');
        return;
      }

      if (!(outer.hasClients &&
          outer.position.hasContentDimensions &&
          (inner?.hasClients ?? false) &&
          (inner?.position.hasContentDimensions ?? false))) {
        debugPrint('enableInnerController $key skipped, scroll not setup $activeKey');
        return;
      }

      if (useResetAnimation) {
        // inner?.animateTo(innerOffset ?? 0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        outer.animateTo(outerOffset ?? 0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        // Even if we have no scrollState we still want to reset the page to the top, so the header is visible
        outer.jumpTo(outerOffset ?? 0);
      }
      // We only trigger this last, as this creates a subscription to the outer scroll, which we want to scroll independent
      inner?.isActive = true;
    });
  }

  @override
  void dispose() {
    outer.dispose();
    super.dispose();
  }
}

class ScrollSyncScope extends InheritedNotifier<ScrollSyncController> {
  const ScrollSyncScope({super.key, required ScrollSyncController controller, required super.child})
    : super(notifier: controller);

  static ScrollSyncController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScrollSyncScope>()!.notifier!;
}
