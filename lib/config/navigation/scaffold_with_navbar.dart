import 'package:flutter/material.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.appTitle,
    required this.navigationShell,
    this.appBar,
    Key? key,
    required this.currentLocation,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final String appTitle;
  final StatefulNavigationShell navigationShell;
  final AppBar? appBar;
  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: <Widget>[
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            child: NavigationRail(
              backgroundColor: lightBleu,
              groupAlignment: 0,
              indicatorColor: couleurBleuClair2,
              selectedIndex: navigationShell.currentIndex,
              labelType: NavigationRailLabelType.none,
              onDestinationSelected: (int index) => _onTap(context, index),
              selectedIconTheme: const IconThemeData(color: white),
              selectedLabelTextStyle: const TextStyle(color: black),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.calendar_month), label: Text('Upcoming')),
                NavigationRailDestination(
                    icon: Icon(Icons.calendar_today), label: Text('Events')),
                NavigationRailDestination(
                    icon: Icon(Icons.edit_calendar), label: Text('New Event')),
                NavigationRailDestination(
                    icon: Icon(Icons.code), label: Text('Functions')),
                NavigationRailDestination(
                    icon: Icon(Icons.people), label: Text('Users')),
                NavigationRailDestination(
                    icon: Icon(Icons.person_add_alt_1),
                    label: Text('New user')),
              ],
            ),
          ),
          Expanded(
            child: navigationShell,
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
