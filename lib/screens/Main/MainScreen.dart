import 'package:flutter/material.dart';
import 'package:my_travel_app/components/TopAppBar.dart';
import 'package:my_travel_app/screens/Main/Expenses/AddEditExpenseScreen.dart';
import 'package:my_travel_app/screens/Main/Expenses/ExpensesScreen.dart';
import 'package:my_travel_app/screens/Main/itinerary/ItineraryScreen.dart';

import 'Settings/SettingScreen.dart';

class MainScreen extends StatefulWidget {
  static const String id = "main_screen";
  final int index;
  MainScreen({this.index = 0, super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  //ボトムバーの順番と対応させる
  final List<Widget> _screens = [
    ItineraryScreen(),
    ExpensesScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'Itinerary',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.paid), label: 'Expenses'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlueAccent,
        onTap: _onItemTapped,
      ),
      floatingActionButton:
          //@FIXME 普通に1って書いているけど、できれば定数化したい。
          _selectedIndex == 1
              ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(context, AddEditExpenseScreen.id);
                  print("Add expense");
                },
              )
              : null,
    );
  }
}
