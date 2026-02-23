import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/player_provider.dart';
import '../home/main_menu_screen.dart';

class NameInputScreen extends ConsumerStatefulWidget {
  const NameInputScreen({super.key});

  @override
  ConsumerState<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends ConsumerState<NameInputScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final name = _ctrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _loading = true);
    await ref.read(playerProvider.notifier).setName(name);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainMenuScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A3A5C), Color(0xFF0D1B3E)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  'CEBUANO\nJOURNEY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.height * 0.08,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFD700),
                    letterSpacing: 4,
                    shadows: const [
                      Shadow(color: Colors.black, blurRadius: 12),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.06),

                // Card
                Container(
                  width: size.width * 0.42,
                  padding: EdgeInsets.all(size.width * 0.03),
                  decoration: BoxDecoration(
                    color: const Color(0xEE1C2E4A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF3A6EA5), width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Enter Your Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextField(
                        controller: _ctrl,
                        autofocus: true,
                        maxLength: 20,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Your name...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF0D1B3E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF3A6EA5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF3A6EA5)),
                          ),
                          counterStyle: const TextStyle(color: Colors.white38),
                        ),
                        onSubmitted: (_) => _confirm(),
                      ),
                      SizedBox(height: size.height * 0.025),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _confirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.022),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator()
                              : Text(
                                  'START ADVENTURE',
                                  style: TextStyle(
                                    fontSize: size.height * 0.03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
