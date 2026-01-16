import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/client/screens/connection_screen.dart';
import 'ui/shared/app_theme.dart';
import 'presentation/state/app/providers.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  // Initialize Hive
  await container.read(storageServiceProvider).init();
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MafiaClientApp(),
    ),
  );
}


class MafiaClientApp extends ConsumerWidget {
  const MafiaClientApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'Mafia Client',
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: const ConnectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
