// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mafia Party Game';

  @override
  String get gameSetup => 'GAME SETUP';

  @override
  String playersConnected(int count) {
    return '$count Players Connected';
  }

  @override
  String get rolesAndMechanics => 'ROLES & MECHANICS';

  @override
  String get commissarRole => 'Commissar Role';

  @override
  String get commissarSubtitle => 'Town investigator (Rec: 3+ players)';

  @override
  String get doctorRole => 'Doctor Role';

  @override
  String get doctorSubtitle => 'Town healer (Rec: 4+ players)';

  @override
  String get doctorCanHealSelf => 'Doctor Can Heal Self';

  @override
  String get allowConsecutiveHealing => 'Allow Consecutive Healing';

  @override
  String get allowConsecutiveHealingSubtitle =>
      'Can heal same player twice in a row';

  @override
  String get prostituteRole => 'Prostitute Role';

  @override
  String get prostituteSubtitle => 'Blocks night actions (Rec: 5+ players)';

  @override
  String get maniacRole => 'Maniac Role';

  @override
  String get maniacSubtitle => 'Neutral killer (Rec: 9+ players)';

  @override
  String get sergeantRole => 'Sergeant Role';

  @override
  String get sergeantSubtitle => 'Commissar helper (Rec: 6+ players)';

  @override
  String get lawyerRole => 'Lawyer Role';

  @override
  String get lawyerSubtitle => 'Mafia investigator (Rec: 7+ players)';

  @override
  String get poisonerRole => 'Poisoner Role';

  @override
  String get poisonerSubtitle => 'Neutral trap role (Rec: 8+ players)';

  @override
  String get gameMechanics => 'GAME MECHANICS';

  @override
  String get autoPruning => 'Auto-pruning Roles';

  @override
  String get autoPruningSubtitle =>
      'Automatically skip roles if player count is too low';

  @override
  String get donMechanics => 'Don Mechanics';

  @override
  String get donMechanicsSubtitle =>
      'Mafia leader controls the kill (Rec: 3+ players)';

  @override
  String get commissarKills => 'Commissar Can Kill';

  @override
  String get commissarKillsSubtitle => 'Commissar shoots instead of checking';

  @override
  String get discussion => 'Discussion';

  @override
  String get voting => 'Voting';

  @override
  String get defense => 'Defense';

  @override
  String get mafiaAction => 'Mafia Action';

  @override
  String get timers => 'TIMERS (Seconds)';

  @override
  String get themeAndVoiceActing => 'THEME & VOICE ACTING';

  @override
  String get readyToStart => 'READY TO START?';

  @override
  String get distributeRoles => 'DISTRIBUTE ROLES';

  @override
  String get needAtLeast3Players => 'Need at least 3 players';

  @override
  String byAuthor(Object author) {
    return 'by $author';
  }

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get russian => 'Russian';

  @override
  String get startGame => 'START GAME';

  @override
  String get waitingForPlayers => 'Waiting for players...';

  @override
  String get mafia => 'Mafia';

  @override
  String get civilian => 'Civilian';

  @override
  String get doctor => 'Doctor';

  @override
  String get prostitute => 'Prostitute';

  @override
  String get commissar => 'Commissar';

  @override
  String get maniac => 'Maniac';

  @override
  String get sergeant => 'Sergeant';

  @override
  String get lawyer => 'Lawyer';

  @override
  String get poisoner => 'Poisoner';

  @override
  String get scanToJoin => 'Scan to Join';

  @override
  String connectedPlayersCount(int count) {
    return 'Connected Players: $count';
  }

  @override
  String totalPlayersRegistered(int count) {
    return '($count total players registered)';
  }

  @override
  String get removeDisconnectedPlayer => 'Remove disconnected player';

  @override
  String get viewStatistics => 'VIEW STATISTICS';

  @override
  String get setupGame => 'SETUP GAME';

  @override
  String audioNotFound(Object path) {
    return '⚠️ AUDIO NOT FOUND: $path';
  }

  @override
  String get stopGame => 'STOP GAME?';

  @override
  String get stopGameConfirm =>
      'Are you sure you want to stop the game? This will reveal all roles.';

  @override
  String get cancel => 'CANCEL';

  @override
  String get stop => 'STOP';

  @override
  String get paused => 'PAUSED';

  @override
  String get phaseLobby => 'Lobby';

  @override
  String get phaseSetup => 'Setup';

  @override
  String get phaseRoleReveal => 'Role Reveal';

  @override
  String get phaseNightMafia => 'Night: Mafia';

  @override
  String get phaseNightProstitute => 'Night: Prostitute';

  @override
  String get phaseNightManiac => 'Night: Maniac';

  @override
  String get phaseNightDoctor => 'Night: Doctor';

  @override
  String get phaseNightPoisoner => 'Night: Poisoner';

  @override
  String get phaseNightCommissar => 'Night: Commissar';

  @override
  String get phaseMorning => 'Morning';

  @override
  String get phaseDayDiscussion => 'Day: Discussion';

  @override
  String get phaseDayVoting => 'Day: Voting';

  @override
  String get phaseDayDefense => 'Day: Defense';

  @override
  String get phaseDayVerdict => 'Day: Verdict';

  @override
  String get phaseGameOver => 'Game Over';

  @override
  String get resumeSpace => 'RESUME (SPACE)';

  @override
  String get pauseSpace => 'PAUSE (SPACE)';

  @override
  String get stopGameEsc => 'STOP GAME (ESC)';

  @override
  String get advancePhase => 'ADVANCE PHASE';

  @override
  String get gamePausedLarge => 'GAME PAUSED';

  @override
  String judgingPlayer(int number) {
    return 'JUDGING PLAYER $number';
  }

  @override
  String get execute => 'EXECUTE';

  @override
  String get pardon => 'PARDON';

  @override
  String get votesCast => 'VOTES CAST';

  @override
  String get remaining => 'REMAINING';

  @override
  String get eventLog => 'EVENT LOG';

  @override
  String get eliminated => 'ELIMINATED';

  @override
  String votesCount(int count) {
    return 'VOTES: $count';
  }

  @override
  String votingFor(int number) {
    return 'VOTING FOR #$number';
  }

  @override
  String get no => 'NO.';

  @override
  String get nickname => 'NICKNAME';

  @override
  String get role => 'ROLE';

  @override
  String get status => 'STATUS';

  @override
  String get alive => 'ALIVE';

  @override
  String get newGameKeepPlayers => 'NEW GAME (KEEP PLAYERS)';

  @override
  String get exitToMainMenu => 'EXIT TO MAIN MENU';

  @override
  String get exportLog => 'EXPORT LOG';

  @override
  String logExportedTo(Object path) {
    return 'Log exported to: $path';
  }

  @override
  String get failedToExportLog => 'Failed to export log';

  @override
  String errorLoadingThemes(Object error) {
    return 'Error loading themes: $error';
  }

  @override
  String get gameStatistics => 'GAME STATISTICS';

  @override
  String get totalGamesPlayed => 'TOTAL GAMES PLAYED';

  @override
  String get townWins => 'TOWN WINS';

  @override
  String get mafiaWins => 'MAFIA WINS';

  @override
  String get maniacWins => 'MANIAC WINS';

  @override
  String get resetAllStatistics => 'RESET ALL STATISTICS';

  @override
  String get resultsViewing => 'RESULTS VIEWING';

  @override
  String get fallAsleep => 'FALL ASLEEP (DONE)';

  @override
  String get actionConfirmed => 'ACTION CONFIRMED';

  @override
  String get waitingForOthers => 'Waiting for others...';

  @override
  String get donKillAction => 'DON KILL ACTION';

  @override
  String get donSearch => 'DON SEARCH (SEARCH FOR COMMISSAR)';

  @override
  String get mafiaTeamVote => 'MAFIA TEAM VOTE';

  @override
  String get lawyerInvestigation => 'LAWYER INVESTIGATION (SEARCH ACTIVE TOWN)';

  @override
  String get poisonerAction => 'POISONER ACTION (DELAYED KILL)';

  @override
  String get doctorAction => 'DOCTOR ACTION (HEAL)';

  @override
  String get commissarActionKill => 'COMMISSAR ACTION (KILL)';

  @override
  String get commissarActionInvestigate =>
      'COMMISSAR/SERGEANT ACTION (INVESTIGATE)';

  @override
  String get cityIsSleeping => 'THE CITY IS SLEEPING...';
}
