import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedQuote extends StatefulWidget {
  const AnimatedQuote({super.key});

  @override
  State<AnimatedQuote> createState() => _AnimatedQuoteState();
}

class _AnimatedQuoteState extends State<AnimatedQuote> {
  final List<String> _quotes = [ 
    "Your story begins here 📖",
    "A fresh page awaits your thoughts 📝",
    "Let it all out, you're safe here 💭",
    "Small notes, big reflections ✨",
    "Ink your emotions, heal your heart 💙",
  ];

  int _index = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _nextQuote());
  }

  void _nextQuote() {
    setState(() {
      _index = (_index + 1) % _quotes.length;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _nextQuote,
      child: Center(
        child: Text(
          _quotes[_index],
          key: ValueKey(_quotes[_index]),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.grey[700],
          ),
        )
            .animate(
          key: ValueKey(_quotes[_index]),
        )
            .fadeIn(duration: 500.ms)
            .slideY(begin: 3.0, end: 0.0, duration: 500.ms)
            .then(delay: 2000.ms)
            .fadeOut(duration: 500.ms)
            .slideY(begin: 0.0, end: -5.0, duration: 700.ms),
      ),
    );
  }
}