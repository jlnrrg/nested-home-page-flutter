import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin CheckShellMixin<T extends StatefulWidget> on State<T> {
  late bool inStatefulShell;
  String get inStatefulShellText => inStatefulShell ? '(stateful)' : '(stateless)';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    inStatefulShell = StatefulNavigationShell.maybeOf(context) != null;
  }
}
