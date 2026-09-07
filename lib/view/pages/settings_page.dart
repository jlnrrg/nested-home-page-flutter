import 'package:flutter/material.dart';
import 'package:nested_home_page/view/widget/navigation_button_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Settings Page outside of the Wrapper')),
      floatingActionButton: NavigationButtonsFAB(),
    );
  }
}
