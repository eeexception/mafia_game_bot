import 'package:freezed_annotation/freezed_annotation.dart';
import '../roles/role.dart';
import '../roles/role_converter.dart';

part 'player.freezed.dart';
part 'player.g.dart';

/// Represents a player in the game
@freezed
abstract class Player with _$Player {
  const factory Player({
    required String id,           // Device UUID
    required int number,          // Connection order (1-indexed)
    required String nickname,
    @RoleConverter() required Role role,
    @Default(true) bool isAlive,
    @Default(true) bool isConnected,
    @Default(false) bool isReadyToVote,
    @Default(false) bool hasActed,
    @Default(false) bool isPoisoned,
    String? sessionToken,
    DateTime? lastHeartbeat,
  }) = _Player;
  
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
