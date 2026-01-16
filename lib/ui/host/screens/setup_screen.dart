import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/providers.dart';
import 'package:mafia_game/core/models/game_config.dart';
import '../../../../l10n/app_localizations.dart';
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
    final initialLocale = ref.read(localeProvider);
    _config = GameConfig(
      themeId: 'default',
      locale: initialLocale.languageCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(gameStateProvider).players;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.gameSetup),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(l10n.playersConnected(players.length), style: const TextStyle(color: Colors.amber))),
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
                _buildSectionTitle(l10n.rolesAndMechanics),
                SwitchListTile(
                  title: Text(l10n.commissarRole),
                  subtitle: Text(l10n.commissarSubtitle),
                  value: _config.commissarEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(commissarEnabled: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.doctorRole),
                  subtitle: Text(l10n.doctorSubtitle),
                  value: _config.doctorEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(doctorEnabled: v)),
                ),
                if (_config.doctorEnabled) ...[
                  SwitchListTile(
                    contentPadding: const EdgeInsets.only(left: 48, right: 16),
                    title: Text(l10n.doctorCanHealSelf),
                    value: _config.doctorCanHealSelf,
                    onChanged: (v) => setState(() => _config = _config.copyWith(doctorCanHealSelf: v)),
                  ),
                  SwitchListTile(
                    contentPadding: const EdgeInsets.only(left: 48, right: 16),
                    title: Text(l10n.allowConsecutiveHealing),
                    subtitle: Text(l10n.allowConsecutiveHealingSubtitle),
                    value: _config.doctorCanHealSameTargetConsecutively,
                    onChanged: (v) => setState(() => _config = _config.copyWith(doctorCanHealSameTargetConsecutively: v)),
                  ),
                ],
                SwitchListTile(
                  title: Text(l10n.prostituteRole),
                  subtitle: Text(l10n.prostituteSubtitle),
                  value: _config.prostituteEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(prostituteEnabled: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.maniacRole),
                  subtitle: Text(l10n.maniacSubtitle),
                  value: _config.maniacEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(maniacEnabled: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.sergeantRole),
                  subtitle: Text(l10n.sergeantSubtitle),
                  value: _config.sergeantEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(sergeantEnabled: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.lawyerRole),
                  subtitle: Text(l10n.lawyerSubtitle),
                  value: _config.lawyerEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(lawyerEnabled: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.poisonerRole),
                  subtitle: Text(l10n.poisonerSubtitle),
                  value: _config.poisonerEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(poisonerEnabled: v)),
                ),
                const Divider(height: 32),
                _buildSectionTitle(l10n.gameMechanics),
                SwitchListTile(
                  title: Text(l10n.autoPruning),
                  subtitle: Text(l10n.autoPruningSubtitle),
                  value: _config.autoPruningEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(autoPruningEnabled: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.donMechanics),
                  subtitle: Text(l10n.donMechanicsSubtitle),
                  value: _config.donMechanicsEnabled,
                  onChanged: (v) => setState(() => _config = _config.copyWith(donMechanicsEnabled: v)),
                ),
                if (_config.donMechanicsEnabled)
                  Padding(
                    padding: const EdgeInsets.only(left: 48, right: 16, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.donActionLabel),
                        DropdownButton<DonAction>(
                          value: _config.donAction,
                          items: [
                            DropdownMenuItem(value: DonAction.kill, child: Text(l10n.donActionKill)),
                            DropdownMenuItem(value: DonAction.search, child: Text(l10n.donActionSearch)),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _config = _config.copyWith(donAction: v));
                          },
                        ),
                      ],
                    ),
                  ),
                SwitchListTile(
                  title: Text(l10n.commissarKills),
                  subtitle: Text(l10n.commissarKillsSubtitle),
                  value: _config.commissarKills,
                  onChanged: (v) => setState(() => _config = _config.copyWith(commissarKills: v)),
                ),
                const Divider(height: 48),
                _buildSectionTitle(l10n.timers),
                _buildTimerSlider(l10n.discussion, _config.discussionTime, (v) => setState(() => _config = _config.copyWith(discussionTime: v.toInt()))),
                _buildTimerSlider(l10n.voting, _config.votingTime, (v) => setState(() => _config = _config.copyWith(votingTime: v.toInt()))),
                _buildTimerSlider(l10n.defense, _config.defenseTime, (v) => setState(() => _config = _config.copyWith(defenseTime: v.toInt()))),
                _buildTimerSlider(l10n.mafiaAction, _config.mafiaActionTime, (v) => setState(() => _config = _config.copyWith(mafiaActionTime: v.toInt()))),
                const Divider(height: 48),
                _buildSectionTitle(l10n.language.toUpperCase()),
                Row(
                  children: [
                    _buildLanguageChip(l10n.english, 'en', ref),
                    const SizedBox(width: 16),
                    _buildLanguageChip(l10n.russian, 'ru', ref),
                  ],
                ),
                const Divider(height: 48),
                _buildSectionTitle(l10n.themeAndVoiceActing),
                ref.watch(themesProvider).when(
                  data: (themes) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: themes.length,
                    itemBuilder: (context, index) {
                      final t = themes[index];
                      final isSelected = _config.themeId == t.id;
                      return ListTile(
                        title: Text(t.name.toUpperCase(), style: TextStyle(
                          color: isSelected ? Colors.amber : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        )),
                        subtitle: Text(l10n.byAuthor(t.author), style: const TextStyle(color: Colors.white54)),
                        trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.amber) : null,
                        tileColor: isSelected ? Colors.amber.withValues(alpha: 0.1) : null,
                        onTap: () => setState(() => _config = _config.copyWith(themeId: t.id)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error loading themes: $err'),
                ),
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
                Text(l10n.readyToStart, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                    onPressed: players.length >= 3 ? _startGame : null,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                    child: Text(l10n.distributeRoles, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (players.length < 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(l10n.needAtLeast3Players, style: const TextStyle(color: Colors.redAccent)),
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

  Widget _buildLanguageChip(String label, String code, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isSelected = currentLocale.languageCode == code;
    
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          ref.read(localeProvider.notifier).setLocale(code);
          setState(() => _config = _config.copyWith(locale: code));
        }
      },
      selectedColor: Colors.amber.withValues(alpha: 0.3),
      labelStyle: TextStyle(color: isSelected ? Colors.amber : Colors.white70),
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
