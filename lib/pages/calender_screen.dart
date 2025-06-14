import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<String>> _entriesByDate = {
    DateTime(2025, 5, 1): ['A Beautiful Start'],
    DateTime(2025, 4, 30): ['Rainy Day Thoughts'],
    DateTime(2025, 4, 29): ['Creative Energy'],
  };

  List<String> _getEntriesForDay(DateTime day) {
    return _entriesByDate[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final entries =
        _selectedDay != null ? _getEntriesForDay(_selectedDay!) : [];
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
              child: TableCalendar(
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: CalendarFormat.month,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) => _getEntriesForDay(day),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(entries[index]),
                  onTap: () {
                    // Navigate to entry detail
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
