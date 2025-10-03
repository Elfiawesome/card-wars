using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class InstantiateBattlefieldAction(BattlefieldId id) : GameAction
{
	public BattlefieldId Id { get; set; } = id;
}

internal class InstantiateBattlefieldHandler : IGameActionHandler<InstantiateBattlefieldAction>
{
	public bool Handle(BattleEngine engine, InstantiateBattlefieldAction data)
	{
		return engine.Entities.Battlefields.TryAdd(data.Id, new Battlefield(engine.Entities, data.Id));
	}
}