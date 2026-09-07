import 'package:flutter/material.dart';
import 'package:nested_home_page/router/routes.dart';
import 'package:nested_home_page/view/widget/adjustable_sliver_list.dart';
import 'package:nested_home_page/view/widget/branch_aware_mixin.dart';
import 'package:nested_home_page/view/widget/check_shell_mixin.dart';

class UserOverviewPage extends StatefulWidget {
  const UserOverviewPage({super.key});

  @override
  State<UserOverviewPage> createState() => _UserOverviewPageState();
}

class _UserOverviewPageState extends State<UserOverviewPage> with TabFocusAwareStateMixin, CheckShellMixin {
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
          child: Center(
            child: Text('User Overview $inStatefulShellText', style: Theme.of(context).textTheme.headlineLarge),
          ),
        ),
        AdjustableSliverList(
          prefix: 'User',
          onTap: (context, index) => inStatefulShell
              ? UserDetailsStatefulRoute(userID: index).go(context)
              : UserDetailsRoute(userID: index).go(context),
        ),
      ],
    );
  }
}
