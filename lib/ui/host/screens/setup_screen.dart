import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/providers.dart';
import '../../../core/models/game_config.dart';
import 'game_screen.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  late GameConfig _config;

  @override
  void initState() {
    super.initState();
    _config = const GameConfig(themeId: 'classic_chicago');
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(gameStateProvider).players;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GAME SETUP'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text('${players.length} Players Connected', style: const TextStyle(color: Colors.amber))),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left side: Settings
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(32),
              children: [
                _buildSectionTitle('ROLES & MECHANICS'),
                SwitchListTile(
                  title: const Text('Prostitute Role'),
                  subtitle: const Text('Can block night actions'),
                  value: _config.prostituteEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(prostituteEnabled: v)),
                ),
                SwitchListTile(
                  title: const Text('Maniac Role'),
                  subtitle: const Text('Neutral killer'),
                  value: _config.maniacEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(maniacEnabled: v)),
                ),
                SwitchListTile(
                  title: const Text('Don Mechanics'),
                  subtitle: const Text('Mafia leader with special powers'),
                  value: _config.donMechanicsEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(donMechanicsEnabled: v)),
                ),
                SwitchListTile(
                  title: const Text('Mafia Blind Mode'),
                  subtitle: const Text('Mafia players target independently'),
                  value: _config.mafiaBlindMode,
                  onChanged: (v) => setState(() => _config = _config.copyWith(mafiaBlindMode: v)),
                ),
                const Divider(height: 48),
                _buildSectionTitle('TIMERS (Seconds)'),
                _buildTimerSlider('Discussion', _config.discussionTime, (v) => setState(() => _config = _config.copyWith(discussionTime: v.toInt()))),
                _buildTimerSlider('Voting', _config.votingTime, (v) => setState(() => _config = _config.copyWith(votingTime: v.toInt()))),
                _buildTimerSlider('Defense', _config.defenseTime, (v) => setState(() => _config = _config.copyWith(defenseTime: v.toInt()))),
                _buildTimerSlider('Mafia Action', _config.mafiaActionTime, (v) => setState(() => _config = _config.copyWith(mafiaActionTime: v.toInt()))),
              ],
            ),
          ),
          
          // Right side: Player List Summary & Start
          Container(
            width: 400,
            decoration: const BoxDecoration(
              color: Colors.black26,
              border: Border(left: BorderSide(color: Colors.white10)),
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Text('READY TO START?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: CircleAvatar(child: Text('${players[index].number}')),
                      title: Text(players[index].nickname),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: players.length >= 5 ? _startGame : null,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                    child: const Text('DISTRIBUTE ROLES', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (players.length < 5)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('Need at least 5 players', style: TextStyle(color: Colors.redAccent)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }

  Widget _buildTimerSlider(String label, int value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${value}s', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: 10,
          max: 300,
          divisions: 29,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _startGame() async {
    await ref.read(gameControllerProvider).startGame(_config);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HostGameScreen()),
      );
    }
  }
}
