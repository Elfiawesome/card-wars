using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class InstantiatePlayerAction(PlayerId id) : GameAction
{
	public PlayerId Id { get; set; } = id;
}

internal class InstantiatePlayerHandler : IGameActionHandler<InstantiatePlayerAction>
{
	public bool Handle(BattleEngine engine, InstantiatePlayerAction data)
	{
		var success = engine.Entities.Players.TryAdd(data.Id, new Player(engine.Entities, data.Id));
		if (!success) { return success; }
		engine.PlayerOrder.Add(data.Id);
		return success;
	}
}