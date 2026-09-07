import 'package:flutter/material.dart';
import 'package:nested_home_page/router/routes.dart';
import 'package:nested_home_page/view/widget/adjustable_sliver_list.dart';
import 'package:nested_home_page/view/widget/branch_aware_mixin.dart';
import 'package:nested_home_page/view/widget/check_shell_mixin.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key, this.userID});

  final int? userID;

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> with TabFocusAwareStateMixin, CheckShellMixin {
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
                Text('User Details $inStatefulShellText', style: theme.textTheme.headlineLarge),
                Text('UserID: ${widget.userID}', style: theme.textTheme.headlineSmall),
              ],
            ),
          ),
        ),
        AdjustableSliverList(
          prefix: 'Order',
          initialCount: 50,
          onTap: (context, index) => inStatefulShell
              ? OrderDetailsStatefulRoute(orderID: index).go(context)
              : OrderDetailsRoute(orderID: index).go(context),
        ),
      ],
    );
  }
}
