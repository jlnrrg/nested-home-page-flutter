import 'package:flutter/material.dart';
import 'package:nested_home_page/router/routes.dart';
import 'package:nested_home_page/view/widget/adjustable_sliver_list.dart';
import 'package:nested_home_page/view/widget/branch_aware_mixin.dart';
import 'package:nested_home_page/view/widget/check_shell_mixin.dart';

class OrderOverviewPage extends StatefulWidget {
  const OrderOverviewPage({super.key});

  @override
  State<OrderOverviewPage> createState() => _OrderOverviewPageState();
}

class _OrderOverviewPageState extends State<OrderOverviewPage> with TabFocusAwareStateMixin, CheckShellMixin {
  @override
  void didGetFocus() {
    debugPrint('$this didGetFocus');
  }

  @override
  void didLoseFocus() {
    debugPrint('$this didLoseFocus');
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Center(child: Text('$this $inStatefulShellText', style: Theme.of(context).textTheme.headlineLarge)),
        ),
        AdjustableSliverList(
          prefix: 'Order',
          onTap: (context, index) => inStatefulShell
              ? OrderDetailsStatefulRoute(orderID: index).go(context)
              : OrderDetailsRoute(orderID: index).go(context),
        ),
      ],
    );
  }
}
