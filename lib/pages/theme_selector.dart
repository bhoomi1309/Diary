import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/theme_notifier.dart';
import '../themes/themes.dart';
import 'home.dart';

class ThemeSelector extends StatefulWidget {
  @override
  _ThemeSelectorState createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  final List<Map<String, dynamic>> themes = [
    {'themeData': sunsetTheme},
    {'themeData': pastelGardenTheme},
    {'themeData': frostTheme},
    {'themeData': forestTheme},
    {'themeData': oceanTheme},
    {'themeData': blushTheme},
  ];

  int? selectedIndex;

  int? savedThemeIndex;

  final PageController _pageController = PageController(viewportFraction: 0.8);

  ThemeData? currentTheme;

  Future<void> _loadSelectedTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedIndex = prefs.getInt('selected_theme_index');

    if (savedIndex != null && savedIndex >= 0 && savedIndex < themes.length) {
      savedThemeIndex = savedIndex;
      selectedIndex = savedIndex;
      currentTheme = themes[savedIndex]['themeData'];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(savedIndex);
        setState(() {});
      });
    } else {
      savedThemeIndex = 2;
      selectedIndex = 2;
      currentTheme = themes[2]['themeData'];
    }
  }

  Future<void> _saveSelectedTheme(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_theme_index', index);
    Provider.of<ThemeNotifier>(context, listen: false).setTheme(themes[index]['themeData']);
  }

  void showSuccessBottomSheet(BuildContext context, ThemeData? theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme?.scaffoldBackgroundColor ?? Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Theme saved successfully!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Home()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme?.colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Go to Home",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _loadSelectedTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentTheme?.scaffoldBackgroundColor ?? Colors.white,
      appBar: AppBar(
        backgroundColor: currentTheme?.colorScheme.primary,
        title: const Text(
          "Pick Your Style",
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: themes.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                  currentTheme = themes[index]['themeData'];
                });
              },
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                  child: Transform.scale(
                    scale: isSelected ? 1.05 : 0.95,
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: isSelected ? 12 : 4,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/themes/t${index+1}.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        if (savedThemeIndex == index)
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveSelectedTheme(selectedIndex!);
                  setState(() {
                    savedThemeIndex = selectedIndex;
                  });
                  showSuccessBottomSheet(context, currentTheme);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.5),
                  backgroundColor:
                      currentTheme?.colorScheme.primary ?? Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Use It",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}