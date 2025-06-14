import 'dart:async';
import 'dart:math';

import 'package:animations/animations.dart';
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

  bool _tooltipVisible = true;
  int _tooltipIndex = 0;
  late Timer _tooltipTimer;

  bool _animating = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  int selectedIndex = 0;


  final List<String> _tooltipMessages = [
    "Write your thoughts!",
    "Tap + to add entry",
    "What's on your mind?",
    "How was your day?",
    "What do you want to share?",
    "How is your mood?",
    "You have got me!",
  ];

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
    _startTooltipBounce();
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

  void _startTooltipBounce() {
    final random = Random();

    _tooltipTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        _tooltipVisible = true;
      });

      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          _tooltipVisible = false;
        });
      });

      Future.delayed(Duration(seconds: 7), () {
        setState(() {
          int newIndex;
          do {
            newIndex = random.nextInt(_tooltipMessages.length);
          } while (newIndex == _tooltipIndex);
          _tooltipIndex = newIndex;
        });
      });
    });
  }

  Future<void> _loadThemeIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedThemeIndex = prefs.getInt('selected_theme_index') ?? 2;
    });
  }

  @override
  void dispose() {
    _tooltipTimer.cancel();
    _controller.dispose();
    super.dispose();
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
                          'assets/themes/theme${selectedIndex+1}/t${selectedIndex+1}_drawer.png',
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
      floatingActionButton: _currentIndex == 1
          ? Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedSlide(
            offset: _tooltipVisible ? Offset(0, 0) : Offset(0, 0.5),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: AnimatedOpacity(
              opacity: _tooltipVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Material(
                    elevation: 6,
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _tooltipMessages[_tooltipIndex],
                        style:
                        const TextStyle(color: Colors.black, fontSize: 19),
                      ),
                    ),
                  ),
                  CustomPaint(
                    painter: TrianglePainter(
                        color: Theme.of(context).colorScheme.primary),
                    child: const SizedBox(
                      height: 10,
                      width: 25,
                    ),
                  )
                ],
              ),
            ),
          ),
          OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            transitionDuration: const Duration(milliseconds: 500),
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(56),
            ),
            closedColor: Theme.of(context).colorScheme.secondary,
            closedElevation: 6.0,
            closedBuilder: (context, openContainer) {
              return SizedBox(
                height: 72,
                width: 72,
                child: FloatingActionButton(
                  onPressed: openContainer,
                  child: const Icon(Icons.add, size: 31,),
                ),
              );
            },
            openBuilder: (context, closeContainer) {
              return AddNewEntry();
            },
          ),
        ],
      )
          : null,
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 6, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}