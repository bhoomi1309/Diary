import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sentiment_dart/sentiment_dart.dart';
import '../database/database_functions.dart';
import '../utils/moods.dart';

class AddNewEntry extends StatefulWidget {

  final int? id;

  const AddNewEntry({
    Key? key,
    this.id,
  }) : super(key: key);


  @override
  State<AddNewEntry> createState() => _AddNewEntryState();
}

class _AddNewEntryState extends State<AddNewEntry> {

  bool _isMoodManuallySelected = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedMood = '😊';
  String _selectedLabel = 'Happy';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_onContentChanged);

    if(widget.id!=null){
      _loadEntryById(widget.id!);
    }
  }

  Future<void> _loadEntryById(int id) async {
    final dao = DiaryDao();
    final entry = await dao.getEntryById(id);

    if (entry != null) {
      setState(() {
        _titleController.text = entry.title;
        _contentController.text = entry.content;
        _selectedMood = entry.emoji;
        _selectedLabel = entry.label;
        _selectedDate = DateTime.parse(entry.date);
        _isMoodManuallySelected = true;
      });
    }
  }

  void _onContentChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      final content = _contentController.text.trim();

      if (content.isNotEmpty && !_isMoodManuallySelected) {
        final result = Sentiment.analysis(content, emoji: true);
        final score = result.score;

        setState(() {
          _selectedMood = mapScoreToMood(score as int);
        });
      }
    });
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Entry'),
      ),
      body:Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E5F5), Color(0xFFFFF3E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      "How are you feeling today?",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: moods.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final mood = moods[index];
                          final isSelected = _selectedMood == mood['emoji'];
                          final moodColor = getMoodColor(mood['label']!);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMood = mood['emoji']!;
                                _selectedLabel = mood['label']!;
                                _isMoodManuallySelected = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? moodColor : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? moodColor : Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(mood['emoji']!, style: const TextStyle(fontSize: 22)),
                                  const SizedBox(width: 6),
                                  Text(
                                    mood['label']!,
                                    style: GoogleFonts.openSans(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${DateFormat.yMMMd().format(_selectedDate)}",
                          style: GoogleFonts.openSans(fontSize: 16),
                        ),
                        TextButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            "Change Date",
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      style: GoogleFonts.robotoSlab(fontSize: 20),
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title, color: Theme.of(context).colorScheme.primary),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Enter a title' : null,
                    ),
                    const SizedBox(height: 20),
                    // Make the content field expandable only if space is available
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 150,
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: TextFormField(
                        controller: _contentController,
                        style: GoogleFonts.openSans(fontSize: 16),
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          labelText: 'Content',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 160),
                            child: Icon(Icons.edit_note, color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Enter some content' : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    final newEntry = DiaryEntry(
                      id: widget.id,
                      title: _titleController.text,
                      content: _contentController.text,
                      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
                      emoji: _selectedMood,
                      label: _selectedLabel,
                    );

                    final dao = DiaryDao();

                    if(widget.id!=null){
                      await dao.updateEntry(newEntry);
                      Navigator.pop(context, true);
                    }
                    else {
                      await dao.insertEntry(newEntry);
                      Navigator.pop(context, true);
                    }
                  },
                  label: Text(
                    'Save Entry',
                    style: GoogleFonts.openSans(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}