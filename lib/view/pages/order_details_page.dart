import 'package:flutter/material.dart';
import 'package:nested_home_page/router/routes.dart';
import 'package:nested_home_page/view/widget/adjustable_sliver_list.dart';
import 'package:nested_home_page/view/widget/branch_aware_mixin.dart';
import 'package:nested_home_page/view/widget/check_shell_mixin.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, this.orderID});

  final int? orderID;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> with TabFocusAwareStateMixin, CheckShellMixin {
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
    final theme = Theme.of(context);
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Order Details $inStatefulShellText', style: theme.textTheme.headlineLarge),
                Text('OrderID: ${widget.orderID}', style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ),
        ),
        AdjustableSliverList(
          prefix: 'User',
          initialCount: 50,
          onTap: (context, index) => inStatefulShell
              ? UserDetailsStatefulRoute(userID: index).go(context)
              : UserDetailsRoute(userID: index).go(context),
        ),
      ],
    );
  }
}
