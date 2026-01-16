import 'package:freezed_annotation/freezed_annotation.dart';
import '../roles/role.dart';

part 'player_action.freezed.dart';
part 'player_action.g.dart';

@freezed
abstract class PlayerAction with _$PlayerAction {
  const factory PlayerAction({
    required String type,
    required String performerId,
    String? targetId,
    String? value,
  }) = _PlayerAction;

  factory PlayerAction.fromJson(Map<String, dynamic> json) =>
      _$PlayerActionFromJson(json);
}

@freezed
abstract class WinResult with _$WinResult {
  const WinResult._();
  const factory WinResult({
    required Faction faction, 
    required String message,
  }) = _WinResult;

  Faction get winner => faction;
}
