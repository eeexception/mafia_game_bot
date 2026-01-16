/// Determines if police can end their phase early.
class CommissarReadyService {
  /// Returns true when the current move is commissar.
  bool isReadyEarly({required String? currentMoveId}) {
    return currentMoveId == 'night_commissar';
  }
}
