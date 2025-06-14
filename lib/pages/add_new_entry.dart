import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sentiment_dart/sentiment_dart.dart';
import '../utils/moods.dart';

class AddNewEntry extends StatefulWidget {

  final String? title;
  final String? emoji;
  final String? label;
  final DateTime? date;
  final String? content;

  const AddNewEntry({
    Key? key,
    this.title,
    this.date,
    this.content,
    this.emoji,
    this.label,
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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_onContentChanged);

    if(widget.title!=null){
      _titleController.text = widget.title!;
      _contentController.text = widget.content!;
      _selectedMood = widget.emoji!;
      _selectedDate = widget.date as DateTime;
      _isMoodManuallySelected = true;
    }
  }

  @override
  void dispose() {
    _contentController.removeListener(_onContentChanged);
    _debounce?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 3), () {
      final content = _contentController.text.trim();

      if (content.isNotEmpty && !_isMoodManuallySelected) {
        final result = Sentiment.analysis(content, emoji: true);
        final score = result.score ?? 0;

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
      body: Container(
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
                  children: [
                    Text(
                      "How are you feeling today?",
                      style: Theme.of(context).textTheme.titleLarge
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
                          label: Text("Change Date",style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
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
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title, color: Theme.of(context).colorScheme.primary),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Enter a title' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TextFormField(
                        controller: _contentController,
                        style: GoogleFonts.openSans(fontSize: 16),
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          labelText: 'Content',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 160),
                            child: Icon(Icons.edit_note, color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Enter some content' : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
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