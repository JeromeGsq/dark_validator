import 'package:dark_validator/pages/home.dart';
import 'package:dark_validator/services/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final config = Config();
final core = Core();

final tickProvider = StateProvider<int>((ref) => 0);

void main() {
  final container = ProviderContainer();

  core.onTickChanged = (tick) {
    container.read(tickProvider.notifier).state = tick;
  };

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1F1F1F),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        colorScheme: ColorScheme.dark(
          primary: Colors.blueGrey[400]!,
          secondary: Colors.tealAccent[400]!,
          surface: const Color(0xFF1E1E1E),
          error: Colors.redAccent[400]!,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
        dividerColor: Colors.white12,
      ),
      debugShowCheckedModeBanner: false,
      home: const ProviderScope(
        child: Home(),
      ),
    );
  }
}
