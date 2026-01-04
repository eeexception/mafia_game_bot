import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_config.freezed.dart';
part 'game_config.g.dart';

/// Configuration for a game session
@freezed
abstract class GameConfig with _$GameConfig {
  const factory GameConfig({
    required String themeId,
    @Default(true) bool mafiaBlindMode,    // false = Sync mode
    @Default(false) bool donMechanicsEnabled,
    @Default(true) bool prostituteEnabled,
    @Default(true) bool maniacEnabled,
    
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
