using CardWars.BattleEngine.Core;
using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class InstantiateUnitCardAction : GameAction
{
	public Guid Id { get; set; }
}

internal class InstantiateUnitCardHandler : IGameActionHandler<InstantiateUnitCardAction>
{
	public bool Handle(BattleEngine engine, InstantiateUnitCardAction data)
	{
		return engine.Entities.UnitCards.TryAdd(data.Id, new UnitCard(engine.Entities, data.Id));
	}
}