import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/client/screens/connection_screen.dart';
import 'ui/shared/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MafiaClientApp(),
    ),
  );
}

class MafiaClientApp extends StatelessWidget {
  const MafiaClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mafia Client',
      theme: AppTheme.darkTheme,
      home: const ConnectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
