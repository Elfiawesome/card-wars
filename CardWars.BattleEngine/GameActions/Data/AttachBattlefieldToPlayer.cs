namespace CardWars.BattleEngine.GameActions.Data;

public class AttachBattlefieldToPlayerAction(Guid battlefieldId, Guid playerId) : GameAction
{
	public Guid BattlefieldId { get; set; } = battlefieldId;
	public Guid PlayerId { get; set; } = playerId;
}

internal class AttachBattlefieldToPlayerHandler : IGameActionHandler<AttachBattlefieldToPlayerAction>
{
	public bool Handle(BattleEngine engine, AttachBattlefieldToPlayerAction data)
	{
		if (!engine.Entities.Battlefields.TryGetValue(data.BattlefieldId, out var battlefield)) { return false; }
		if (!engine.Entities.Players.TryGetValue(data.PlayerId, out var player)) { return false; }
		return player.Battlefields.Add(battlefield);
	}
}