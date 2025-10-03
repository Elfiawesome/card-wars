using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class InstantiateUnitCardAction(UnitCardId id) : GameAction
{
	public UnitCardId Id { get; set; } = id;
}

internal class InstantiateUnitCardHandler : IGameActionHandler<InstantiateUnitCardAction>
{
	public bool Handle(BattleEngine engine, InstantiateUnitCardAction data)
	{
		return engine.Entities.UnitCards.TryAdd(data.Id, new UnitCard(engine.Entities, data.Id));
	}
}