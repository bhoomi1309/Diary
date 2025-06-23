import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


final ThemeData sunsetTheme = ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: const Color(0xFFFFF3E0),
  primaryColor: const Color(0xFFFFB74D),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFFFFB74D),
    primary: Color(0xFFFFB74D),
    secondary: Color(0xFFF57C00),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFFFB74D),
    elevation: 2,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Color(0xFFE65100)),
    titleTextStyle: GoogleFonts.pacifico(
      fontSize: 32,
      color: Colors.black.withOpacity(0.75),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFFFFE0B2),
  ),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.robotoSlab(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFE65100),
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
      color: Colors.black87,
    ),
    bodySmall: GoogleFonts.openSans(
      fontSize: 13,
      fontStyle: FontStyle.italic,
      color: Color(0xFF8D6E63),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFF57C00),
    elevation: 6,
  ),
);


final ThemeData pastelGardenTheme = ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: const Color(0xFFFFF9FB),
  primaryColor: const Color(0xFFF48FB1),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFFF48FB1),
    primary: Color(0xFFF48FB1),
    secondary: Color(0xFFCE93D8),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFF48FB1),
    elevation: 2,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Color(0xFF880E4F)),
    titleTextStyle: GoogleFonts.pacifico(
      fontSize: 32,
      color: Colors.black.withOpacity(0.7),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFFFCE4EC),
  ),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.robotoSlab(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF880E4F),
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
      color: Colors.black87,
    ),
    bodySmall: GoogleFonts.openSans(
      fontSize: 13,
      fontStyle: FontStyle.italic,
      color: Color(0xFF616161),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFCE93D8),
    elevation: 6,
  ),
);


final ThemeData frostTheme = ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: const Color(0xFFF0F4FF),
  primaryColor: const Color(0xFF90CAF9),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF90CAF9),
    primary: Color(0xFF90CAF9),
    secondary: Color(0xFF42A5F5),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF90CAF9),
    elevation: 2,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Color(0xFF0D47A1)),
    titleTextStyle: GoogleFonts.pacifico(
      fontSize: 32,
      color: Colors.black.withOpacity(0.7),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFFE3F2FD),
  ),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.robotoSlab(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF0D47A1),
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
      color: Colors.black87,
    ),
    bodySmall: GoogleFonts.openSans(
      fontSize: 13,
      fontStyle: FontStyle.italic,
      color: Color(0xFF546E7A),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF42A5F5),
    elevation: 6,
  ),
);


final ThemeData forestTheme = ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: const Color(0xFFE8F5E9),
  primaryColor: const Color(0xFF81C784),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF81C784),
    primary: const Color(0xFF81C784),
    secondary: const Color(0xFF388E3C),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF81C784),
    elevation: 2,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Color(0xFF1B5E20)),
    titleTextStyle: GoogleFonts.pacifico(
      fontSize: 32,
      color: Colors.black.withOpacity(0.7),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFFC8E6C9),
  ),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.robotoSlab(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF1B5E20),
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
      color: Colors.black87,
    ),
    bodySmall: GoogleFonts.openSans(
      fontSize: 13,
      fontStyle: FontStyle.italic,
      color: Color(0xFF455A64),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF388E3C),
    elevation: 6,
  ),
);


final ThemeData oceanTheme = ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: const Color(0xFFE0F7FA),
  primaryColor: const Color(0xFF4DD0E1),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4DD0E1),
    primary: const Color(0xFF4DD0E1),
    secondary: const Color(0xFF00ACC1),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF4DD0E1),
    elevation: 2,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Color(0xFF006064)),
    titleTextStyle: GoogleFonts.pacifico(
      fontSize: 32,
      color: Colors.black.withOpacity(0.7),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFFB2EBF2),
  ),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.robotoSlab(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF006064),
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
      color: Colors.black87,
    ),
    bodySmall: GoogleFonts.openSans(
      fontSize: 13,
      fontStyle: FontStyle.italic,
      color: Color(0xFF607D8B),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF00ACC1),
    elevation: 6,
  ),
);


final ThemeData blushTheme = ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: const Color(0xFFFFF8F1),
  primaryColor: const Color(0xFFCE93D8),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFCE93D8),
    primary: const Color(0xFFCE93D8),
    secondary: const Color(0xFFBA68C8),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFCE93D8),
    elevation: 2,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Color(0xFF4A148C)),
    titleTextStyle: GoogleFonts.pacifico(
      fontSize: 32,
      color: Colors.black.withOpacity(0.7),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFFF3E5F5),
  ),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.robotoSlab(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF4A148C),
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
      color: Colors.black87,
    ),
    bodySmall: GoogleFonts.openSans(
      fontSize: 13,
      fontStyle: FontStyle.italic,
      color: Color(0xFF757575),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFBA68C8),
    elevation: 6,
  ),
);