namespace CardWars.BattleEngine.GameActions.Data;

public class AttachUnitSlotToBattlefieldAction(Guid unitSlotId, Guid battlefieldId) : GameAction
{
	public Guid UnitSlotId { get; set; } = unitSlotId;
	public Guid BattlefieldId { get; set; } = battlefieldId;
}

internal class AttachUnitSlotToBattlefieldHandler : IGameActionHandler<AttachUnitSlotToBattlefieldAction>
{
	public bool Handle(BattleEngine engine, AttachUnitSlotToBattlefieldAction data)
	{
		if (!engine.Entities.UnitSlots.TryGetValue(data.UnitSlotId, out var unitSlot)) { return false; }
		if (!engine.Entities.Battlefields.TryGetValue(data.BattlefieldId, out var battlefield)) { return false; }
		return battlefield.Slots.Add(unitSlot);
	}
}