import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'diary_page.dart';

class DiaryHomeScreen extends StatefulWidget {
  const DiaryHomeScreen({Key? key}) : super(key: key);

  @override
  State<DiaryHomeScreen> createState() => _DiaryHomeScreenState();
}

class _DiaryHomeScreenState extends State<DiaryHomeScreen> {
  final List<Map<String, String>> dummyEntries = const [
    {
      "title": "A Beautiful Start",
      "date": "May 1, 2025",
      "emoji": '😊',
      "label": 'Happy',
      "content": "Today I began my journey with journaling again. Feeling inspired!..."
    },
    {
      "title": "Rainy Day Thoughts",
      "date": "April 30, 2025",
      "emoji": '😊',
      "label": 'Happy',
      "content": "The rain always brings back memories. It's soothing and nostalgic."
    },
    {
      "title": "Creative Energy",
      "date": "April 29, 2025",
      "emoji": '🥰',
      "label": 'Loved',
      "content": "Ideas kept flowing today. I feel charged with creativity!"
    },
  ];

  int selectedIndex = 0;
  String? imagePath;

  Future<void> loadThemeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedIndex = prefs.getInt('selected_theme_index') ?? 2;
      imagePath =
      'assets/themes/theme${selectedIndex + 1}/t${selectedIndex + 1}_home.png';
    });
  }

  @override
  void initState(){
    super.initState();
    loadThemeIndex();
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: dummyEntries.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
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
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                final entry = dummyEntries[index - 1];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: OpenContainer(
                    transitionDuration: Duration(milliseconds: 600),
                    transitionType: ContainerTransitionType.fadeThrough,
                    openBuilder: (context, _) => DiaryPage(
                      title: entry["title"]!,
                      date: entry["date"]!,
                      content: entry["content"]!,
                      label: entry["label"]!,
                      emoji: entry["emoji"]!,
                    ),
                    closedElevation: 5,
                    closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    closedColor: Colors.transparent,
                    closedBuilder: (context, openContainer) {
                      return InkWell(
                        onTap: openContainer,
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE3F2FD), Color(0xFFFCE4EC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.7),
                                blurRadius: 5,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start, // 👈 this fixes alignment
                                      children: [
                                        Text(
                                          entry["title"]!,
                                          style: Theme.of(context).textTheme.titleLarge,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          entry["date"]!,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      entry["emoji"] ?? "😊",
                                      style: const TextStyle(
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  entry["content"]!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}