namespace CardWars.BattleEngine.GameActions.Data;

public class AttachBattlefieldToPlayerAction : GameAction
{
	public Guid BattlefieldId { get; set; }
	public Guid PlayerId { get; set; }
}

internal class AttachBattlefieldToPlayerHandler : IGameActionHandler<AttachBattlefieldToPlayerAction>
{
	public bool Handle(BattleEngine engine, AttachBattlefieldToPlayerAction data)
	{
		if (!engine.Entities.Battlefields.TryGetValue(data.BattlefieldId, out var battlefield)) { return false; }
		if (!engine.Entities.Players.TryGetValue(data.BattlefieldId, out var player)) { return false; }
		return player.Battlefields.Add(battlefield);
	}
}