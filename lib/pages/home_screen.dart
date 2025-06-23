import 'dart:async';
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/diary_entry_card.dart';
import '../components/home_animated_quote.dart';
import '../components/home_triangle_painter.dart';
import '../database/database_functions.dart';
import '../database/diary_database.dart';
import 'add_new_entry.dart';
import 'diary_page.dart';

class DiaryHomeScreen extends StatefulWidget {
  const DiaryHomeScreen({Key? key}) : super(key: key);

  @override
  State<DiaryHomeScreen> createState() => _DiaryHomeScreenState();
}

class _DiaryHomeScreenState extends State<DiaryHomeScreen> {
  int selectedIndex = 0;
  String? imagePath;
  bool _tooltipVisible = true;
  late Timer _tooltipTimer;
  int _tooltipIndex = 0;
  bool _isLoading = true;

  final List<String> _tooltipMessages = [
    "Write your thoughts!",
    "Tap + to add entry",
    "What's on your mind?",
    "How was your day?",
    "What do you want to share?",
    "How is your mood?",
    "You have got me!",
  ];

  void _startTooltipBounce() {
    final random = Random();

    _tooltipTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (!mounted) return;

      setState(() {
        _tooltipVisible = true;
      });

      Future.delayed(Duration(seconds: 5), () {
        if (!mounted) return; // ✅ Prevent crash
        setState(() {
          _tooltipVisible = false;
        });
      });

      Future.delayed(Duration(seconds: 7), () {
        if (!mounted) return; // ✅ Prevent crash
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

  @override
  void dispose() {
    _tooltipTimer.cancel();
    super.dispose();
  }

  Future<void> loadThemeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedIndex = prefs.getInt('selected_theme_index') ?? 2;
      imagePath = 'assets/images/themes/t${selectedIndex + 1}_home.png';
    });
  }

  late DiaryDatabase db;
  List<DiaryEntry> entries = [];

  @override
  void initState() {
    super.initState();
    _startTooltipBounce();
    loadThemeIndex();
    Future.microtask(() {
      db = Provider.of<DiaryDatabase>(context, listen: false);
      loadEntries();
    });
  }

  final dao = DiaryDao();

  Future<void> loadEntries() async {
    setState(() {
      _isLoading = true;
    });
    List<DiaryEntry> dbEntries = await dao.getAllEntries();
    setState(() {
      entries = dbEntries;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: entries.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 8),
                                child: imagePath != null
                                    ? ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context)
                                              .scaffoldBackgroundColor
                                              .withOpacity(0.7),
                                          BlendMode.modulate,
                                        ),
                                        child: Image.asset(
                                          imagePath!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                      )
                                    : SizedBox(
                                        height: 200,
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                              ),
                              if (entries.isEmpty)
                                SizedBox(
                                  height: MediaQuery.of(context).size.height -
                                      290 -
                                      kToolbarHeight,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const AnimatedQuote(),
                                          const SizedBox(height: 30),
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              final result =
                                                  await Navigator.of(context)
                                                      .push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const AddNewEntry()),
                                              );
                                              if (result == true) {
                                                await loadEntries();
                                              }
                                            },
                                            icon:
                                                const Icon(Icons.edit_rounded),
                                            label: const Text("Start Writing"),
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12),
                                              textStyle:
                                                  const TextStyle(fontSize: 16),
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }
                        final entry = entries[index - 1];
                        return Dismissible(
                          key: Key(entry.id.toString()),
                          direction: DismissDirection.endToStart,
                          background: Padding(
                            padding: const EdgeInsets.only(
                                right: 12, bottom: 18, top: 16, left: 12),
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: const Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded,
                                        color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Confirm Deletion'),
                                  ],
                                ),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Are you sure you want to delete this entry?',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "This action can't be undone",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                actionsPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                actionsAlignment: MainAxisAlignment.end,
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (shouldDelete ?? false) {
                              await dao.deleteEntry(entry.id!);
                              setState(() {
                                entries.removeAt(index - 1);
                              });
                              return true;
                            }
                            return false;
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: DiaryEntryCard(
                              entry: entry,
                              showDate: true,
                              heroOnEmoji: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
        floatingActionButton: entries.isNotEmpty
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
                                  horizontal: 12, vertical: 8),
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
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
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
                        height: 66,
                        width: 66,
                        child: FloatingActionButton(
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const AddNewEntry()),
                            );
                            if (result == true) {
                              await loadEntries();
                            }
                          },
                          child: const Icon(Icons.add, size: 30),
                        ),
                      );
                    },
                    openBuilder: (context, closeContainer) {
                      return AddNewEntry();
                    },
                  ),
                ],
              )
            : null);
  }
}