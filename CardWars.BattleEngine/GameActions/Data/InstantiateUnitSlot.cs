using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class InstantiateUnitSlotAction(Guid id) : GameAction
{
	public Guid Id { get; set; } = id;
}

internal class InstantiateUnitSlotHandler : IGameActionHandler<InstantiateUnitSlotAction>
{
	public bool Handle(BattleEngine engine, InstantiateUnitSlotAction data)
	{
		return engine.Entities.UnitSlots.TryAdd(data.Id, new UnitSlot(engine.Entities, data.Id));
	}
}