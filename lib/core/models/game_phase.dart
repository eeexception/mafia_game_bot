/// Represents all possible game phases in the state machine
enum GamePhase {
  /// Waiting for players to connect
  lobby,
  
  /// Role distribution and game setup
  setup,
  
  /// Period for players to view their assigned roles
  roleReveal,
  
  /// Night: Prostitute selects client
  nightProstitute,
  
  /// Night: Poisoner poisons a player
  nightPoisoner,

  /// Night: Mafia selects victim
  nightMafia,

  /// Night: Commissar investigates player
  nightCommissar,

  /// Night: Maniac selects victim
  nightManiac,
  
  /// Night: Doctor selects patient
  nightDoctor,
  
  /// Morning announcement of night results
  morning,
  
  /// Day: 2-minute discussion
  dayDiscussion,
  
  /// Day: 1-minute voting for suspect
  dayVoting,
  
  /// Day: Accused player's defense speech
  dayDefense,
  
  /// Day: Pardon/Execute verdict
  dayVerdict,
  
  /// Game ended (victory or manual stop)
  gameOver,
}
