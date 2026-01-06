// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Мафия';

  @override
  String get gameSetup => 'НАСТРОЙКА ИГРЫ';

  @override
  String playersConnected(int count) {
    return 'Подключено игроков: $count';
  }

  @override
  String get rolesAndMechanics => 'РОЛИ И МЕХАНИКИ';

  @override
  String get commissarRole => 'Роль Комиссара';

  @override
  String get commissarSubtitle =>
      'Следователь города (Рекомендуется: 3+ игрока)';

  @override
  String get doctorRole => 'Роль Доктора';

  @override
  String get doctorSubtitle => 'Лекарь города (Рекомендуется: 4+ игрока)';

  @override
  String get doctorCanHealSelf => 'Доктор может лечить себя';

  @override
  String get allowConsecutiveHealing => 'Разрешить последовательное лечение';

  @override
  String get allowConsecutiveHealingSubtitle =>
      'Можно лечить одного игрока два хода подряд';

  @override
  String get prostituteRole => 'Роль Проститутки';

  @override
  String get prostituteSubtitle =>
      'Блокирует ночные действия (Рекомендуется: 5+ игроков)';

  @override
  String get maniacRole => 'Роль Маньяка';

  @override
  String get maniacSubtitle => 'Нейтральный убийца (Рекомендуется: 9+ игроков)';

  @override
  String get sergeantRole => 'Роль Сержанта';

  @override
  String get sergeantSubtitle =>
      'Помощник комиссара (Рекомендуется: 6+ игроков)';

  @override
  String get lawyerRole => 'Роль Адвоката';

  @override
  String get lawyerSubtitle => 'Следователь мафии (Рекомендуется: 7+ игроков)';

  @override
  String get poisonerRole => 'Роль Отравителя';

  @override
  String get poisonerSubtitle =>
      'Нейтральная роль с ловушками (Рекомендуется: 8+ игроков)';

  @override
  String get gameMechanics => 'МЕХАНИКА ИГРЫ';

  @override
  String get autoPruning => 'Автоматическое сокращение ролей';

  @override
  String get autoPruningSubtitle =>
      'Пропускать роли, если недостаточно игроков';

  @override
  String get donMechanics => 'Механика Дона';

  @override
  String get donMechanicsSubtitle =>
      'Лидер мафии управляет убийством (Рекомендуется: 3+ игрока)';

  @override
  String get commissarKills => 'Комиссар может убивать';

  @override
  String get commissarKillsSubtitle => 'Комиссар стреляет вместо проверки';

  @override
  String get discussion => 'Обсуждение';

  @override
  String get voting => 'Голосование';

  @override
  String get defense => 'Защита';

  @override
  String get mafiaAction => 'Ход мафии';

  @override
  String get timers => 'ТАЙМЕРЫ (Секунды)';

  @override
  String get themeAndVoiceActing => 'ТЕМА И ОЗВУЧКА';

  @override
  String get readyToStart => 'ГОТОВЫ НАЧАТЬ?';

  @override
  String get distributeRoles => 'РАСПРЕДЕЛИТЬ РОЛИ';

  @override
  String get needAtLeast3Players => 'Нужно минимум 3 игрока';

  @override
  String byAuthor(Object author) {
    return 'от $author';
  }

  @override
  String get language => 'Язык';

  @override
  String get english => 'English';

  @override
  String get russian => 'Русский';

  @override
  String get startGame => 'НАЧАТЬ ИГРУ';

  @override
  String get waitingForPlayers => 'Ожидание игроков...';

  @override
  String get mafia => 'Мафия';

  @override
  String get civilian => 'Мирный житель';

  @override
  String get doctor => 'Доктор';

  @override
  String get prostitute => 'Проститутка';

  @override
  String get commissar => 'Комиссар';

  @override
  String get maniac => 'Маньяк';

  @override
  String get sergeant => 'Сержант';

  @override
  String get lawyer => 'Адвокат';

  @override
  String get poisoner => 'Отравитель';

  @override
  String get scanToJoin => 'Сканируйте, чтобы подключиться';

  @override
  String connectedPlayersCount(int count) {
    return 'Подключено игроков: $count';
  }

  @override
  String totalPlayersRegistered(int count) {
    return '($count всего зарегистрировано)';
  }

  @override
  String get removeDisconnectedPlayer => 'Удалить отключенного игрока';

  @override
  String get viewStatistics => 'ПРОСМОТР СТАТИСТИКИ';

  @override
  String get setupGame => 'НАСТРОЙКА ИГРЫ';

  @override
  String audioNotFound(Object path) {
    return '⚠️ АУДИОФАЙЛ НЕ НАЙДЕН: $path';
  }

  @override
  String get stopGame => 'ОСТАНОВИТЬ ИГРУ?';

  @override
  String get stopGameConfirm =>
      'Вы уверены, что хотите остановить игру? Все роли будут раскрыты.';

  @override
  String get cancel => 'ОТМЕНА';

  @override
  String get stop => 'СТОП';

  @override
  String get paused => 'ПАУЗА';

  @override
  String get phaseLobby => 'Лобби';

  @override
  String get phaseSetup => 'Настройка';

  @override
  String get phaseRoleReveal => 'Распределение ролей';

  @override
  String get phaseNightMafia => 'Ночь: Мафия';

  @override
  String get phaseNightProstitute => 'Ночь: Проститутка';

  @override
  String get phaseNightManiac => 'Ночь: Маньяк';

  @override
  String get phaseNightDoctor => 'Ночь: Доктор';

  @override
  String get phaseNightPoisoner => 'Ночь: Отравитель';

  @override
  String get phaseNightCommissar => 'Ночь: Комиссар';

  @override
  String get phaseMorning => 'Утро';

  @override
  String get phaseDayDiscussion => 'День: Обсуждение';

  @override
  String get phaseDayVoting => 'День: Голосование';

  @override
  String get phaseDayDefense => 'День: Оправдательная речь';

  @override
  String get phaseDayVerdict => 'День: Вердикт';

  @override
  String get phaseGameOver => 'Конец игры';

  @override
  String get resumeSpace => 'ПРОДОЛЖИТЬ (SPACE)';

  @override
  String get pauseSpace => 'ПАУЗА (SPACE)';

  @override
  String get stopGameEsc => 'ОСТАНОВИТЬ ИГРУ (ESC)';

  @override
  String get advancePhase => 'СЛЕДУЮЩАЯ ФАЗА';

  @override
  String get gamePausedLarge => 'ИГРА НА ПАУЗЕ';

  @override
  String judgingPlayer(int number) {
    return 'СУД НАД ИГРОКОМ $number';
  }

  @override
  String get execute => 'КАЗНИТЬ';

  @override
  String get pardon => 'ПОМИЛОВАТЬ';

  @override
  String get votesCast => 'ГОЛОСОВ ПОДАНО';

  @override
  String get remaining => 'ОСТАЛОСЬ';

  @override
  String get eventLog => 'ЖУРНАЛ СОБЫТИЙ';

  @override
  String get eliminated => 'ВЫБЫЛ';

  @override
  String votesCount(int count) {
    return 'ГОЛОСОВ: $count';
  }

  @override
  String votingFor(int number) {
    return 'ГОЛОСУЕТ ПРОТИВ #$number';
  }

  @override
  String get no => '№';

  @override
  String get nickname => 'НИКНЕЙМ';

  @override
  String get role => 'РОЛЬ';

  @override
  String get status => 'СТАТУС';

  @override
  String get alive => 'ЖИВ';

  @override
  String get newGameKeepPlayers => 'НОВАЯ ИГРА (ТЕ ЖЕ ИГРОКИ)';

  @override
  String get exitToMainMenu => 'ВЫХОД В ГЛАВНОЕ МЕНЮ';

  @override
  String get exportLog => 'ЭКСПОРТ ЛОГА';

  @override
  String logExportedTo(Object path) {
    return 'Лог экспортирован в: $path';
  }

  @override
  String get failedToExportLog => 'Не удалось экспортировать лог';

  @override
  String errorLoadingThemes(Object error) {
    return 'Ошибка при загрузке тем: $error';
  }

  @override
  String get gameStatistics => 'ИГРОВАЯ СТАТИСТИКА';

  @override
  String get totalGamesPlayed => 'ВСЕГО ИГР ПРОВЕДЕНО';

  @override
  String get townWins => 'ПОБЕД ГОРОДА';

  @override
  String get mafiaWins => 'ПОБЕД МАФИИ';

  @override
  String get maniacWins => 'ПОБЕД МАНЬЯКА';

  @override
  String get resetAllStatistics => 'СБРОСИТЬ ВСЮ СТАТИСТИКУ';

  @override
  String get resultsViewing => 'ПРОСМОТР РЕЗУЛЬТАТОВ';

  @override
  String get fallAsleep => 'ЗАСНУТЬ (ГОТОВО)';

  @override
  String get actionConfirmed => 'ДЕЙСТВИЕ ПОДТВЕРЖДЕНО';

  @override
  String get waitingForOthers => 'Ожидание остальных...';

  @override
  String get donKillAction => 'ХОД ДОНА (УБИЙСТВО)';

  @override
  String get donSearch => 'ПОИСК ДОНА (ИЩЕТ КОМИССАРА)';

  @override
  String get mafiaTeamVote => 'ГОЛОСОВАНИЕ КОМАНДЫ МАФИИ';

  @override
  String get lawyerInvestigation =>
      'РАССЛЕДОВАНИЕ АДВОКАТА (ИЩЕТ АКТИВНЫХ ГОРОЖАН)';

  @override
  String get poisonerAction => 'ХОД ОТРАВИТЕЛЯ (ОТЛОЖЕННОЕ УБИЙСТВО)';

  @override
  String get doctorAction => 'ХОД ДОКТОРА (ЛЕЧЕНИЕ)';

  @override
  String get commissarActionKill => 'ХОД КОМИССАРА (УБИЙСТВО)';

  @override
  String get commissarActionInvestigate => 'ХОД КОМИССАРА/СЕРЖАНТА (ПРОВЕРКА)';

  @override
  String get cityIsSleeping => 'ГОРОД ЗАСЫПАЕТ...';
}
