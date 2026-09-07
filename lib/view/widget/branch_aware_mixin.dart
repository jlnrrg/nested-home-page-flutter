import 'package:flutter/widgets.dart';
import 'package:nested_home_page/router/routes.dart';

/// An interface for objects that are aware of their current [Route], and
/// (as an addition on top of stock Flutter) aware of whether they currently
/// sit on the *visible* branch of an ancestor go_router
/// `StatefulNavigationShell` — e.g. the selected tab of a bottom navigation
/// bar built with `StatefulShellRoute.indexedStack`.
///
/// The four `didPush*`/`didPop*` callbacks are driven by [RouteObserver] and
/// fire on Navigator push/pop, exactly as before.
///
/// [didGetFocus] and [didLoseFocus] are driven by [TabFocusAwareStateMixin]
/// and fire when the branch this route lives in stops/starts being the
/// active tab. Switching tabs in an `IndexedStack`-based shell never pushes
/// or pops anything — the inactive branch's Navigator is simply hidden — so
/// [RouteObserver] alone can never see it. These two callbacks fill that gap.
abstract mixin class RouteBranchAware implements RouteAware {
  /// Called when the branch containing this route becomes the active
  /// (visible) tab of an ancestor `StatefulNavigationShell`.
  ///
  /// Also called when the [RouteAware.didPush].
  void didGetFocus() {}

  /// Called when the branch containing this route stops being the active
  /// tab of an ancestor `StatefulNavigationShell` (the user switched to a
  /// different tab).
  ///
  /// Also called when [RouteAware.didPop] fires.
  void didLoseFocus() {}
}

/// Mix this into any [State] whose widget lives inside a
/// `StatefulShellBranch` to get [RouteBranchAware.didGetFocus] /
/// [RouteBranchAware.didLoseFocus] calls whenever the user switches tabs, with no
/// manual wiring to the `WrapperPage`/`StatefulNavigationShell` required.
///
/// How it works: `StatefulShellRoute.indexedStack`'s default branch
/// container wraps every *inactive* branch in
/// `Offstage(child: TickerMode(enabled: false, child: branch))`. Since
/// [TickerMode] is a plain [InheritedWidget], every descendant of that
/// branch — no matter how deep in its own nested Navigator stack — is
/// automatically rebuilt/notified via [State.didChangeDependencies] the
/// instant the branch's tickers are enabled or disabled. This mixin just
/// listens for that and translates it into [RouteBranchAware.didGetFocus] /
/// [RouteBranchAware.didLoseFocus].
///
/// Usage:
/// ```dart
/// class _MyBranchRootState extends State<MyBranchRoot>
///     with TabFocusAwareStateMixin {
///   @override
///   void didGotFocus() => debugPrint('This tab became active');
///
///   @override
///   void didLostFocus() => debugPrint('This tab is no longer active');
/// }
/// ```
///
/// Combine with the ordinary [RouteObserver] subscription (in
/// [State.didChangeDependencies] / [State.dispose], same as always) if you
/// also want push/pop callbacks on the same widget.
mixin TabFocusAwareStateMixin<T extends StatefulWidget> on State<T> implements RouteBranchAware {
  bool? _hasTabFocus;

  /// Whether this widget's branch is currently the active tab. `true` until
  /// proven otherwise if the mixin hasn't run yet.
  bool get hasTabFocus => _hasTabFocus ?? true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) routeObserver.subscribe(this, route);

    _syncTabFocus();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _syncTabFocus() {
    // StatefulShellRoute.indexedStack's default container wraps every inactive branch in a TickerMode
    final bool active = TickerMode.of(context);
    final bool? previous = _hasTabFocus;
    _hasTabFocus = active;

    // Skip the very first read: that's the widget's initial state, not a
    // transition, so it shouldn't be reported as "just gained/lost focus".
    if (previous == null || previous == active) {
      return;
    }

    if (active) {
      didGetFocus();
    } else {
      didLoseFocus();
    }
  }

  @override
  void didGetFocus() {}

  @override
  void didLoseFocus() {}

  @override
  @mustCallSuper
  // A details page is supposed to trigger last compared to the overview page which just got into view
  void didPush() => WidgetsBinding.instance.addPostFrameCallback((_) {
    didGetFocus();
  });

  @override
  @mustCallSuper
  // This is "disabled" as it leads to double getFocus trigger on pop
  void didPopNext() {} // => didGetFocus();

  @override
  @mustCallSuper
  void didPop() => didLoseFocus();

  @override
  @mustCallSuper
  // this is handled via the didChangeDependencies sub to TickerMode already
  void didPushNext() {} // => didLoseFocus();
}
