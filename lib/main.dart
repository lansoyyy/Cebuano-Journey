import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/player_provider.dart';
import 'features/home/main_menu_screen.dart';
import 'features/profile/name_input_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Cebuano Journey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const _AppEntry(),
    );
  }
}

class _AppEntry extends ConsumerStatefulWidget {
  const _AppEntry();

  @override
  ConsumerState<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends ConsumerState<_AppEntry> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    ref.read(playerProvider.notifier).load().then((_) {
      if (mounted) setState(() => _loaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1B3E),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFD700)),
        ),
      );
    }
    final player = ref.read(playerProvider);
    return player.name.isEmpty
        ? const NameInputScreen()
        : const MainMenuScreen();
  }
}
