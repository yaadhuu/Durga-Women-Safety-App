import 'package:flutter/material.dart';

import '../../screens/home_screen.dart';
import '../../screens/safety_screen.dart';
import '../../screens/safezone_screen.dart';
import '../../screens/settings_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    SafetyScreen(),
    SafezoneScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[currentIndex],

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffC81E1E),
        elevation: 10,
        shape: const CircleBorder(),
        onPressed: () {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("🚨 SOS Activated"),
              backgroundColor: Colors.red,
            ),
          );

        },

        child: const Icon(
          Icons.campaign,
          color: Colors.white,
          size: 34,
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        height: 80,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,

        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [

            navItem(
              Icons.home_filled,
              "Home",
              0,
            ),

            navItem(
              Icons.shield_outlined,
              "Safety",
              1,
            ),

            const SizedBox(width: 45),

            navItem(
              Icons.map_outlined,
              "SafeZone",
              2,
            ),

            navItem(
              Icons.settings_outlined,
              "Settings",
              3,
            ),

          ],
        ),
      ),
    );
  }

  Widget navItem(
      IconData icon,
      String text,
      int index,
      ) {

    bool selected = currentIndex == index;

    return InkWell(

      onTap: () {

        setState(() {

          currentIndex = index;

        });

      },

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,
            color: selected
                ? const Color(0xff315E54)
                : Colors.grey,
          ),

          const SizedBox(height: 4),

          Text(
            text,
            style: TextStyle(
              color: selected
                  ? const Color(0xff315E54)
                  : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}