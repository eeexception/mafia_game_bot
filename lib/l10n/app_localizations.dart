import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mafia Party Game'**
  String get appTitle;

  /// No description provided for @gameSetup.
  ///
  /// In en, this message translates to:
  /// **'GAME SETUP'**
  String get gameSetup;

  /// No description provided for @playersConnected.
  ///
  /// In en, this message translates to:
  /// **'{count} Players Connected'**
  String playersConnected(int count);

  /// No description provided for @rolesAndMechanics.
  ///
  /// In en, this message translates to:
  /// **'ROLES & MECHANICS'**
  String get rolesAndMechanics;

  /// No description provided for @commissarRole.
  ///
  /// In en, this message translates to:
  /// **'Commissar Role'**
  String get commissarRole;

  /// No description provided for @commissarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Town investigator (Rec: 3+ players)'**
  String get commissarSubtitle;

  /// No description provided for @doctorRole.
  ///
  /// In en, this message translates to:
  /// **'Doctor Role'**
  String get doctorRole;

  /// No description provided for @doctorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Town healer (Rec: 4+ players)'**
  String get doctorSubtitle;

  /// No description provided for @doctorCanHealSelf.
  ///
  /// In en, this message translates to:
  /// **'Doctor Can Heal Self'**
  String get doctorCanHealSelf;

  /// No description provided for @allowConsecutiveHealing.
  ///
  /// In en, this message translates to:
  /// **'Allow Consecutive Healing'**
  String get allowConsecutiveHealing;

  /// No description provided for @allowConsecutiveHealingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Can heal same player twice in a row'**
  String get allowConsecutiveHealingSubtitle;

  /// No description provided for @prostituteRole.
  ///
  /// In en, this message translates to:
  /// **'Prostitute Role'**
  String get prostituteRole;

  /// No description provided for @prostituteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Blocks night actions (Rec: 5+ players)'**
  String get prostituteSubtitle;

  /// No description provided for @maniacRole.
  ///
  /// In en, this message translates to:
  /// **'Maniac Role'**
  String get maniacRole;

  /// No description provided for @maniacSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Neutral killer (Rec: 9+ players)'**
  String get maniacSubtitle;

  /// No description provided for @sergeantRole.
  ///
  /// In en, this message translates to:
  /// **'Sergeant Role'**
  String get sergeantRole;

  /// No description provided for @sergeantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Commissar helper (Rec: 6+ players)'**
  String get sergeantSubtitle;

  /// No description provided for @lawyerRole.
  ///
  /// In en, this message translates to:
  /// **'Lawyer Role'**
  String get lawyerRole;

  /// No description provided for @lawyerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mafia investigator (Rec: 7+ players)'**
  String get lawyerSubtitle;

  /// No description provided for @poisonerRole.
  ///
  /// In en, this message translates to:
  /// **'Poisoner Role'**
  String get poisonerRole;

  /// No description provided for @poisonerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Neutral trap role (Rec: 8+ players)'**
  String get poisonerSubtitle;

  /// No description provided for @gameMechanics.
  ///
  /// In en, this message translates to:
  /// **'GAME MECHANICS'**
  String get gameMechanics;

  /// No description provided for @autoPruning.
  ///
  /// In en, this message translates to:
  /// **'Auto-pruning Roles'**
  String get autoPruning;

  /// No description provided for @autoPruningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically skip roles if player count is too low'**
  String get autoPruningSubtitle;

  /// No description provided for @donMechanics.
  ///
  /// In en, this message translates to:
  /// **'Don Mechanics'**
  String get donMechanics;

  /// No description provided for @donMechanicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mafia leader controls the kill (Rec: 3+ players)'**
  String get donMechanicsSubtitle;

  /// No description provided for @commissarKills.
  ///
  /// In en, this message translates to:
  /// **'Commissar Can Kill'**
  String get commissarKills;

  /// No description provided for @commissarKillsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Commissar shoots instead of checking'**
  String get commissarKillsSubtitle;

  /// No description provided for @discussion.
  ///
  /// In en, this message translates to:
  /// **'Discussion'**
  String get discussion;

  /// No description provided for @voting.
  ///
  /// In en, this message translates to:
  /// **'Voting'**
  String get voting;

  /// No description provided for @defense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get defense;

  /// No description provided for @mafiaAction.
  ///
  /// In en, this message translates to:
  /// **'Mafia Action'**
  String get mafiaAction;

  /// No description provided for @timers.
  ///
  /// In en, this message translates to:
  /// **'TIMERS (Seconds)'**
  String get timers;

  /// No description provided for @themeAndVoiceActing.
  ///
  /// In en, this message translates to:
  /// **'THEME & VOICE ACTING'**
  String get themeAndVoiceActing;

  /// No description provided for @readyToStart.
  ///
  /// In en, this message translates to:
  /// **'READY TO START?'**
  String get readyToStart;

  /// No description provided for @distributeRoles.
  ///
  /// In en, this message translates to:
  /// **'DISTRIBUTE ROLES'**
  String get distributeRoles;

  /// No description provided for @needAtLeast3Players.
  ///
  /// In en, this message translates to:
  /// **'Need at least 3 players'**
  String get needAtLeast3Players;

  /// No description provided for @byAuthor.
  ///
  /// In en, this message translates to:
  /// **'by {author}'**
  String byAuthor(Object author);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'START GAME'**
  String get startGame;

  /// No description provided for @waitingForPlayers.
  ///
  /// In en, this message translates to:
  /// **'Waiting for players...'**
  String get waitingForPlayers;

  /// No description provided for @mafia.
  ///
  /// In en, this message translates to:
  /// **'Mafia'**
  String get mafia;

  /// No description provided for @civilian.
  ///
  /// In en, this message translates to:
  /// **'Civilian'**
  String get civilian;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @prostitute.
  ///
  /// In en, this message translates to:
  /// **'Prostitute'**
  String get prostitute;

  /// No description provided for @commissar.
  ///
  /// In en, this message translates to:
  /// **'Commissar'**
  String get commissar;

  /// No description provided for @maniac.
  ///
  /// In en, this message translates to:
  /// **'Maniac'**
  String get maniac;

  /// No description provided for @sergeant.
  ///
  /// In en, this message translates to:
  /// **'Sergeant'**
  String get sergeant;

  /// No description provided for @lawyer.
  ///
  /// In en, this message translates to:
  /// **'Lawyer'**
  String get lawyer;

  /// No description provided for @poisoner.
  ///
  /// In en, this message translates to:
  /// **'Poisoner'**
  String get poisoner;

  /// No description provided for @scanToJoin.
  ///
  /// In en, this message translates to:
  /// **'Scan to Join'**
  String get scanToJoin;

  /// No description provided for @connectedPlayersCount.
  ///
  /// In en, this message translates to:
  /// **'Connected Players: {count}'**
  String connectedPlayersCount(int count);

  /// No description provided for @totalPlayersRegistered.
  ///
  /// In en, this message translates to:
  /// **'({count} total players registered)'**
  String totalPlayersRegistered(int count);

  /// No description provided for @removeDisconnectedPlayer.
  ///
  /// In en, this message translates to:
  /// **'Remove disconnected player'**
  String get removeDisconnectedPlayer;

  /// No description provided for @viewStatistics.
  ///
  /// In en, this message translates to:
  /// **'VIEW STATISTICS'**
  String get viewStatistics;

  /// No description provided for @setupGame.
  ///
  /// In en, this message translates to:
  /// **'SETUP GAME'**
  String get setupGame;

  /// No description provided for @audioNotFound.
  ///
  /// In en, this message translates to:
  /// **'⚠️ AUDIO NOT FOUND: {path}'**
  String audioNotFound(Object path);

  /// No description provided for @stopGame.
  ///
  /// In en, this message translates to:
  /// **'STOP GAME?'**
  String get stopGame;

  /// No description provided for @stopGameConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to stop the game? This will reveal all roles.'**
  String get stopGameConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'STOP'**
  String get stop;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get paused;

  /// No description provided for @phaseLobby.
  ///
  /// In en, this message translates to:
  /// **'Lobby'**
  String get phaseLobby;

  /// No description provided for @phaseSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get phaseSetup;

  /// No description provided for @phaseRoleReveal.
  ///
  /// In en, this message translates to:
  /// **'Role Reveal'**
  String get phaseRoleReveal;

  /// No description provided for @phaseNightMafia.
  ///
  /// In en, this message translates to:
  /// **'Night: Mafia'**
  String get phaseNightMafia;

  /// No description provided for @phaseNightProstitute.
  ///
  /// In en, this message translates to:
  /// **'Night: Prostitute'**
  String get phaseNightProstitute;

  /// No description provided for @phaseNightManiac.
  ///
  /// In en, this message translates to:
  /// **'Night: Maniac'**
  String get phaseNightManiac;

  /// No description provided for @phaseNightDoctor.
  ///
  /// In en, this message translates to:
  /// **'Night: Doctor'**
  String get phaseNightDoctor;

  /// No description provided for @phaseNightPoisoner.
  ///
  /// In en, this message translates to:
  /// **'Night: Poisoner'**
  String get phaseNightPoisoner;

  /// No description provided for @phaseNightCommissar.
  ///
  /// In en, this message translates to:
  /// **'Night: Commissar'**
  String get phaseNightCommissar;

  /// No description provided for @phaseMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get phaseMorning;

  /// No description provided for @phaseDayDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Day: Discussion'**
  String get phaseDayDiscussion;

  /// No description provided for @phaseDayVoting.
  ///
  /// In en, this message translates to:
  /// **'Day: Voting'**
  String get phaseDayVoting;

  /// No description provided for @phaseDayDefense.
  ///
  /// In en, this message translates to:
  /// **'Day: Defense'**
  String get phaseDayDefense;

  /// No description provided for @phaseDayVerdict.
  ///
  /// In en, this message translates to:
  /// **'Day: Verdict'**
  String get phaseDayVerdict;

  /// No description provided for @phaseGameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get phaseGameOver;

  /// No description provided for @resumeSpace.
  ///
  /// In en, this message translates to:
  /// **'RESUME (SPACE)'**
  String get resumeSpace;

  /// No description provided for @pauseSpace.
  ///
  /// In en, this message translates to:
  /// **'PAUSE (SPACE)'**
  String get pauseSpace;

  /// No description provided for @stopGameEsc.
  ///
  /// In en, this message translates to:
  /// **'STOP GAME (ESC)'**
  String get stopGameEsc;

  /// No description provided for @advancePhase.
  ///
  /// In en, this message translates to:
  /// **'ADVANCE PHASE'**
  String get advancePhase;

  /// No description provided for @gamePausedLarge.
  ///
  /// In en, this message translates to:
  /// **'GAME PAUSED'**
  String get gamePausedLarge;

  /// No description provided for @judgingPlayer.
  ///
  /// In en, this message translates to:
  /// **'JUDGING PLAYER {number}'**
  String judgingPlayer(int number);

  /// No description provided for @execute.
  ///
  /// In en, this message translates to:
  /// **'EXECUTE'**
  String get execute;

  /// No description provided for @pardon.
  ///
  /// In en, this message translates to:
  /// **'PARDON'**
  String get pardon;

  /// No description provided for @votesCast.
  ///
  /// In en, this message translates to:
  /// **'VOTES CAST'**
  String get votesCast;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'REMAINING'**
  String get remaining;

  /// No description provided for @eventLog.
  ///
  /// In en, this message translates to:
  /// **'EVENT LOG'**
  String get eventLog;

  /// No description provided for @eliminated.
  ///
  /// In en, this message translates to:
  /// **'ELIMINATED'**
  String get eliminated;

  /// No description provided for @votesCount.
  ///
  /// In en, this message translates to:
  /// **'VOTES: {count}'**
  String votesCount(int count);

  /// No description provided for @votingFor.
  ///
  /// In en, this message translates to:
  /// **'VOTING FOR #{number}'**
  String votingFor(int number);

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'NO.'**
  String get no;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'NICKNAME'**
  String get nickname;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'ROLE'**
  String get role;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get status;

  /// No description provided for @alive.
  ///
  /// In en, this message translates to:
  /// **'ALIVE'**
  String get alive;

  /// No description provided for @newGameKeepPlayers.
  ///
  /// In en, this message translates to:
  /// **'NEW GAME (KEEP PLAYERS)'**
  String get newGameKeepPlayers;

  /// No description provided for @exitToMainMenu.
  ///
  /// In en, this message translates to:
  /// **'EXIT TO MAIN MENU'**
  String get exitToMainMenu;

  /// No description provided for @exportLog.
  ///
  /// In en, this message translates to:
  /// **'EXPORT LOG'**
  String get exportLog;

  /// No description provided for @logExportedTo.
  ///
  /// In en, this message translates to:
  /// **'Log exported to: {path}'**
  String logExportedTo(Object path);

  /// No description provided for @failedToExportLog.
  ///
  /// In en, this message translates to:
  /// **'Failed to export log'**
  String get failedToExportLog;

  /// No description provided for @errorLoadingThemes.
  ///
  /// In en, this message translates to:
  /// **'Error loading themes: {error}'**
  String errorLoadingThemes(Object error);

  /// No description provided for @gameStatistics.
  ///
  /// In en, this message translates to:
  /// **'GAME STATISTICS'**
  String get gameStatistics;

  /// No description provided for @totalGamesPlayed.
  ///
  /// In en, this message translates to:
  /// **'TOTAL GAMES PLAYED'**
  String get totalGamesPlayed;

  /// No description provided for @townWins.
  ///
  /// In en, this message translates to:
  /// **'TOWN WINS'**
  String get townWins;

  /// No description provided for @mafiaWins.
  ///
  /// In en, this message translates to:
  /// **'MAFIA WINS'**
  String get mafiaWins;

  /// No description provided for @maniacWins.
  ///
  /// In en, this message translates to:
  /// **'MANIAC WINS'**
  String get maniacWins;

  /// No description provided for @resetAllStatistics.
  ///
  /// In en, this message translates to:
  /// **'RESET ALL STATISTICS'**
  String get resetAllStatistics;

  /// No description provided for @resultsViewing.
  ///
  /// In en, this message translates to:
  /// **'RESULTS VIEWING'**
  String get resultsViewing;

  /// No description provided for @fallAsleep.
  ///
  /// In en, this message translates to:
  /// **'FALL ASLEEP (DONE)'**
  String get fallAsleep;

  /// No description provided for @actionConfirmed.
  ///
  /// In en, this message translates to:
  /// **'ACTION CONFIRMED'**
  String get actionConfirmed;

  /// No description provided for @waitingForOthers.
  ///
  /// In en, this message translates to:
  /// **'Waiting for others...'**
  String get waitingForOthers;

  /// No description provided for @donKillAction.
  ///
  /// In en, this message translates to:
  /// **'DON KILL ACTION'**
  String get donKillAction;

  /// No description provided for @donSearch.
  ///
  /// In en, this message translates to:
  /// **'DON SEARCH (SEARCH FOR COMMISSAR)'**
  String get donSearch;

  /// No description provided for @mafiaTeamVote.
  ///
  /// In en, this message translates to:
  /// **'MAFIA TEAM VOTE'**
  String get mafiaTeamVote;

  /// No description provided for @lawyerInvestigation.
  ///
  /// In en, this message translates to:
  /// **'LAWYER INVESTIGATION (SEARCH ACTIVE TOWN)'**
  String get lawyerInvestigation;

  /// No description provided for @poisonerAction.
  ///
  /// In en, this message translates to:
  /// **'POISONER ACTION (DELAYED KILL)'**
  String get poisonerAction;

  /// No description provided for @doctorAction.
  ///
  /// In en, this message translates to:
  /// **'DOCTOR ACTION (HEAL)'**
  String get doctorAction;

  /// No description provided for @commissarActionKill.
  ///
  /// In en, this message translates to:
  /// **'COMMISSAR ACTION (KILL)'**
  String get commissarActionKill;

  /// No description provided for @commissarActionInvestigate.
  ///
  /// In en, this message translates to:
  /// **'COMMISSAR/SERGEANT ACTION (INVESTIGATE)'**
  String get commissarActionInvestigate;

  /// No description provided for @cityIsSleeping.
  ///
  /// In en, this message translates to:
  /// **'THE CITY IS SLEEPING...'**
  String get cityIsSleeping;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
