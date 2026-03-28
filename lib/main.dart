import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/expenses_provider.dart';
import 'screens/splash_screen.dart';  // ✅ NEW IMPORT


// WidgetsFlutterBinding.ensureInitialized() is required before any plugin
// (sqflite, shared_preferences) is used during app startup.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: Lock to portrait for better UX
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ExpensesProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
<<<<<<< main
      theme: ExpenseTrackerTheme.themeData,  // ✅ Professional theming
      darkTheme: ExpenseTrackerTheme.darkThemeData,  // ✅ Dark mode support
      themeMode: ThemeMode.system,  // ✅ Follows device theme
      home: const SplashScreen(),  // ✅ SPLASH SCREEN!
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ErrorBoundary(child: child!),  // ✅ Error handling
=======
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
>>>>>>> main
    );
  }
}

/// ✅ Professional Theme Definition
class ExpenseTrackerTheme {
  static const Color primaryGreen = Color(0xFF29AF32);
  static const Color primaryGreenDark = Color(0xFF1F8C28);
  
  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 6,
      shadowColor: Colors.black45,
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(225, 247, 245, 245),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
    ),
  );

  static ThemeData get darkThemeData => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 6,
      shadowColor: Colors.black54,
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
    ),
  );
}

/// ✅ Error Boundary - Prevents crashes
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  const ErrorBoundary({super.key, required this.child});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }     
}