import 'package:flutter/material.dart';
import 'package:vricalc/calculator_screen.dart';
import 'package:vricalc/conversion_screen.dart';

class CalcBotNavBar extends StatefulWidget {
  const CalcBotNavBar({super.key});

  @override
  State<CalcBotNavBar> createState() => _CalcBotNavBarState();
}

class _CalcBotNavBarState extends State<CalcBotNavBar> {
  int currentPageIndex = 0;
  List screens = const [CalculatorScreen(), ConversionScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blue,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
              selectedIcon: Icon(Icons.calculate),
              icon: Icon(Icons.calculate),
              label: 'Calculator'),
          NavigationDestination(
              icon: Icon(Icons.compare_arrows), label: 'Conversion')
        ],
      ),
      body: screens[currentPageIndex],
    );
  }
}
