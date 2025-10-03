using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class InstantiateBattlefieldAction(Guid id) : GameAction
{
	public Guid Id { get; set; } = id;
}

internal class InstantiateBattlefieldHandler : IGameActionHandler<InstantiateBattlefieldAction>
{
	public bool Handle(BattleEngine engine, InstantiateBattlefieldAction data)
	{
		return engine.Entities.Battlefields.TryAdd(data.Id, new Battlefield(engine.Entities, data.Id));
	}
}