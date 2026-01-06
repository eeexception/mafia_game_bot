import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_config.freezed.dart';
part 'game_config.g.dart';

/// Configuration for a game session
@freezed
abstract class GameConfig with _$GameConfig {
  const factory GameConfig({
    required String themeId,
    @Default(true) bool autoPruningEnabled,
    @Default(false) bool donMechanicsEnabled,
    @Default(true) bool commissarEnabled,
    @Default(true) bool doctorEnabled,
    @Default(false) bool prostituteEnabled,
    @Default(false) bool maniacEnabled,
    @Default(false) bool commissarKills,
    @Default(false) bool sergeantEnabled,
    @Default(false) bool lawyerEnabled,
    @Default(false) bool poisonerEnabled,
    @Default(true) bool doctorCanHealSelf,
    @Default(false) bool doctorCanHealSameTargetConsecutively,
    @Default('en') String locale,
    
    // Timer durations in seconds
    @Default(120) int discussionTime,
    @Default(60) int votingTime,
    @Default(60) int defenseTime,
    @Default(90) int mafiaActionTime,
    @Default(60) int otherActionTime,
    
    // Role distribution (null = auto-balance)
    int? mafiaCount,
    int? commissarCount,
    int? doctorCount,
  }) = _GameConfig;
  
  factory GameConfig.fromJson(Map<String, dynamic> json) => 
      _$GameConfigFromJson(json);
}
