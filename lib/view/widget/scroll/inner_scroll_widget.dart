import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nested_home_page/extension/go_route_data_extension.dart';
import 'package:nested_home_page/router/routes.dart';
import 'package:nested_home_page/view/widget/branch_aware_mixin.dart';
import 'package:nested_home_page/view/widget/scroll/scroll_sync_controller.dart';
import 'package:nested_home_page/view/widget/sliver_footer.dart';

class InnerScrollWidget extends StatefulWidget {
  const InnerScrollWidget({super.key, required this.routeData, required this.sliver});

  final GoRouteData routeData;
  final Widget sliver;

  @override
  State<InnerScrollWidget> createState() => _InnerScrollWidgetState();
}

class _InnerScrollWidgetState extends State<InnerScrollWidget> with RouteBranchAware {
  late ScrollSyncController scrollSyncController;
  ScrollController? controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollSyncController = ScrollSyncScope.of(context);

    // We have a dependency on context, which is why we cannot use the following in init
    // This is supposed to be only initialized on creation, so we get the correct branch
    controller ??= scrollSyncController.getScrollController(widget.routeData, widgetKey: widget.key);

    final route = ModalRoute.of(context);
    if (route is PageRoute) routeObserver.subscribe(this, route);

    // debugPrint('${widget.routeData} didChangeDependencies');
  }

  @override
  void didPush() {
    debugPrint('${widget.routeData} didPush');
    scrollSyncController.setActiveRoute(widget.routeData, widgetKey: widget.key);
  }

  @override
  void didPopNext() {
    debugPrint('${widget.routeData} didPopNext');
    scrollSyncController.setActiveRoute(widget.routeData, widgetKey: widget.key);
  }

  @override
  void didPop() {
    debugPrint('${widget.routeData} didPop');
    scrollSyncController.setInactiveRoute(widget.routeData, widgetKey: widget.key);
  }

  @override
  void didPushNext() {
    debugPrint('${widget.routeData} didPushNext');
    scrollSyncController.setInactiveRoute(widget.routeData, widgetKey: widget.key);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    scrollSyncController.disposeScrollController(widget.routeData, widgetKey: widget.key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('${widget.routeData} build');
    final theme = Theme.of(context);

    final inStatefulShell = StatefulNavigationShell.maybeOf(context) != null;

    final footer = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        color: inStatefulShell ? theme.primaryColor : theme.colorScheme.tertiary,
        child: Center(child: Text('Footer', style: theme.primaryTextTheme.bodyLarge)),
      ),
    );

    return NotificationListener<ScrollMetricsNotification>(
      // key: ValueKey(widget.routeData.toKey(widget.key)),
      onNotification: (notification) {
        if (widget.routeData.toKey(widget.key) == scrollSyncController.activeRoute) {
          scrollSyncController.calculateScrollEnabled();
        }
        return false;
      },
      child: CustomScrollView(
        // key: ValueKey(widget.routeData.toKey(widget.key)),
        controller: controller,
        slivers: [
          SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
          widget.sliver,
          SliverFooter(child: footer),
        ],
      ),
    );
  }
}
