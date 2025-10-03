using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.Inputs;

public record struct InputContext(PlayerId PlayerId, BattleEngine Engine);