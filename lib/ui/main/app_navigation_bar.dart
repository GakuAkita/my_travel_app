import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.edit_note),
            label: "Itinerary",
          ),
          NavigationDestination(icon: Icon(Icons.paid), label: "expenses"),
          NavigationDestination(icon: Icon(Icons.settings), label: "settings"),
        ],
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
