using CardWars.BattleEngine.Core;
using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class InstantiateUnitSlotAction : GameAction
{
	public Guid Id { get; set; }
}

internal class InstantiateUnitSlotHandler : IGameActionHandler<InstantiateUnitSlotAction>
{
	public bool Handle(BattleEngine engine, InstantiateUnitSlotAction data)
	{
		return engine.Entities.UnitSlots.TryAdd(data.Id, new UnitSlot(engine.Entities, data.Id));
	}
}