import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_new_entry.dart';
import 'calender_screen.dart';
import 'home_screen.dart';
import 'theme_selector.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _currentIndex = 1;
  int selectedThemeIndex = 0;

  bool _animating = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  int selectedIndex = 0;


  final List<Widget> _pages = [
    CalendarScreen(),
    DiaryHomeScreen(),
    DiaryHomeScreen(),
  ];

  Future<void> loadThemeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedIndex = prefs.getInt('selected_theme_index') ?? 2;
    });
  }

  void initState() {
    super.initState();
    loadThemeIndex();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0.0, end: 2.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ))
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Navigator.of(context)
              .push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => AddNewEntry(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          )
              .then((_) {
            setState(() {
              _animating = false;
              _controller.reset();
            });
          });
        }
      });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Diary")),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    height: 225,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/themes/t${selectedIndex+1}_drawer.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Positioned(
                          top: 4,
                          left: 4,
                          child: IconButton(
                            icon: Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: const Icon(Icons.book, color: Color(0xFF6A1B9A), size: 28,),
                    title: const Text('Themes', style: TextStyle(fontSize: 18),),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ThemeSelector()));
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: const Icon(Icons.favorite, color: Color(0xFFAD1457), size: 28,),
                    title: const Text('Favorites', style: TextStyle(fontSize: 18),),
                    onTap: () {},
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: const Icon(Icons.settings, color: Color(0xFF4A148C), size: 28,),
                    title: const Text('Settings', style: TextStyle(fontSize: 18),),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                },
                icon: Icon(Icons.logout),
                label: Text('Logout', style: TextStyle(fontSize: 18),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 5,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).hintColor,
        unselectedLabelStyle: const TextStyle(
            fontSize: 14
        ),
        unselectedIconTheme: IconThemeData(
            size: 27
        ),
        selectedIconTheme: IconThemeData(
            size: 29
        ),
        selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}