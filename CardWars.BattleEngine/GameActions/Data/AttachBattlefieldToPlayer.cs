using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class AttachBattlefieldToPlayerAction(BattlefieldId battlefieldId, PlayerId playerId) : GameAction
{
	public BattlefieldId BattlefieldId { get; set; } = battlefieldId;
	public PlayerId PlayerId { get; set; } = playerId;
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