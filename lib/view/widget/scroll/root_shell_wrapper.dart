import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nested_home_page/view/widget/navigation_button_bar.dart';
import 'package:nested_home_page/view/widget/scroll/scroll_sync_controller.dart';

class RootShellWrapper extends StatefulWidget {
  const RootShellWrapper({super.key, this.floatingHeader = true, required this.child});

  final bool floatingHeader;
  final Widget child;

  @override
  State<RootShellWrapper> createState() => _RootShellWrapperState();
}

class _RootShellWrapperState extends State<RootShellWrapper> {
  late final ScrollSyncController _scrollSyncController;

  ScrollPhysics? physics;

  StatefulNavigationShell? get childAsStatefulShell {
    final child = widget.child;
    if (child is StatefulNavigationShell) {
      return child;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    debugPrint('$this initState');
    _scrollSyncController = ScrollSyncController(activeBranch: childAsStatefulShell?.currentIndex ?? 0);
    _scrollSyncController.addListener(_rebuildPhysics);
  }

  @override
  void didUpdateWidget(covariant RootShellWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    // TODO: Here trigger a notifier to rerender Header, etc.
    final oldChild = oldWidget.child;
    final newChild = widget.child;

    if (oldChild is StatefulNavigationShell && newChild is StatefulNavigationShell) {
      if (oldChild.currentIndex != newChild.currentIndex) {
        _scrollSyncController.setActiveBranch(newChild.currentIndex);
        // branchObserver.didChangeBranch(widget.child.currentIndex);
      }
    }
  }

  void _rebuildPhysics() => WidgetsBinding.instance.addPostFrameCallback((_) {
    debugPrint('$this _rebuildPhysics');
    final newPhysics = _scrollSyncController.physics;
    if (mounted && physics != newPhysics) {
      setState(() {
        physics = newPhysics;
      });
    }
  });

  @override
  void dispose() {
    _scrollSyncController.removeListener(_rebuildPhysics);
    _scrollSyncController.dispose();
    super.dispose();
  }

  // void _goBranch(int index) => widget.child.goBranch(index, initialLocation: index == widget.child.currentIndex);

  void _onDestinationSelected(GoRouter router, int index) {
    final shell = childAsStatefulShell;
    if (shell != null) {
      shell.goBranch(index, initialLocation: index == shell.currentIndex);
    } else {
      final routeStack = router.routerDelegate.currentConfiguration.routes;
      // get current shell routes
      final rootShellRoutes = routeStack.first.routes;
      // get intended index route
      final destination = (rootShellRoutes.elementAtOrNull(index) as GoRoute?)?.path;
      // navigate to route
      if (destination != null) {
        router.go(destination);
      }
    }
  }

  int? shellSelectedIndex(GoRouter router) {
    final shell = childAsStatefulShell;
    if (shell != null) return shell.currentIndex;

    final routeStack = router.routerDelegate.currentConfiguration.routes;
    final rootShellRoutes = routeStack.first.routes;

    try {
      return rootShellRoutes.indexOf(routeStack[1]);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('$this build');
    final router = GoRouter.of(context);
    final destinations = router.routerDelegate.currentConfiguration.routes.first.routes.whereType<GoRoute>();

    final selectedIndex = shellSelectedIndex(router);

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 90,
            child: NavigationRail(
              elevation: 5,
              labelType: NavigationRailLabelType.all,
              destinations: destinations
                  // TODO: Use Route Metadata for icons and label once it lands in the go_router_builder, https://github.com/flutter/flutter/issues/160738#issuecomment-5378956725
                  .map(
                    (e) => NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text(e.name ?? 'No Label', maxLines: 2),
                    ),
                  )
                  .toList(),
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => _onDestinationSelected(router, index),
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(physics: physics),
              child: NestedScrollView(
                controller: _scrollSyncController.outer,
                floatHeaderSlivers: widget.floatingHeader,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  //? prevents list's top items to partially render hidden behind the pinned/expanding header at certain scroll offsets by passing the height down the context
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: CustomSliverAppBar(
                      key: ValueKey(childAsStatefulShell?.shellRouteContext.routerState.fullPath ?? widget.key),
                      floating: widget.floatingHeader,
                      scrollEnabled: _scrollSyncController.scrollEnabled,
                      hasStatefulShell: widget.child is StatefulNavigationShell,
                    ),
                  ),
                ],
                body: Builder(
                  builder: (innerContext) {
                    _scrollSyncController.attachSharedInner(PrimaryScrollController.of(innerContext));
                    return ScrollSyncScope(controller: _scrollSyncController, child: widget.child);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 10,
        children: [
          FloatingActionButton.extended(
            heroTag: 'ScrollDown',
            icon: Icon(Icons.arrow_downward),
            label: Text('Scroll Down'),
            onPressed: () => _scrollSyncController.innerActive.animateTo(
              _scrollSyncController.innerActive.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
          FloatingActionButton.extended(
            heroTag: 'ScrollUp',
            icon: Icon(Icons.arrow_upward),
            label: Text('Scroll Up'),
            onPressed: () =>
                _scrollSyncController.outer.animateTo(-1, duration: Duration(milliseconds: 300), curve: Curves.easeIn),
          ),
          NavigationButtonsFAB(),
        ],
      ),
    );
  }
}

class CustomSliverAppBar extends StatefulWidget {
  const CustomSliverAppBar({
    super.key,
    required this.floating,
    required this.scrollEnabled,
    required this.hasStatefulShell,
  });

  final bool floating;
  final bool scrollEnabled;
  final bool hasStatefulShell;

  @override
  State<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  bool canPop = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routerCanPop = router.canPop();
      if (canPop != routerCanPop) {
        setState(() {
          canPop = routerCanPop;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final routeState = GoRouterState.of(context);

    return SliverAppBar(
      key: ValueKey(canPop),
      leading: canPop
          ? BackButton(
              onPressed: () => GoRouter.of(context).pop(),
              style: IconButton.styleFrom(foregroundColor: theme.canvasColor),
            )
          : null,
      backgroundColor: widget.hasStatefulShell ? theme.primaryColor : theme.colorScheme.tertiary,
      title: Text(routeState.topRoute?.name ?? 'Header', style: theme.primaryTextTheme.headlineLarge),
      pinned: false,
      floating: widget.floating,
      snap: false,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(35),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            widget.scrollEnabled ? 'can scroll' : "can't scroll",
            style: theme.primaryTextTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}
