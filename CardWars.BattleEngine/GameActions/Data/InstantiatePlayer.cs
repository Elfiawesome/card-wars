using CardWars.BattleEngine.Core;
using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class InstantiatePlayerAction : GameAction
{
	public Guid Id { get; set; }
}

internal class InstantiatePlayerHandler : IGameActionHandler<InstantiatePlayerAction>
{
	public bool Handle(BattleEngine engine, InstantiatePlayerAction data)
	{
		return engine.Entities.Players.TryAdd(data.Id, new Player(engine.Entities, data.Id));
	}
}