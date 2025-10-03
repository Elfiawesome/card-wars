namespace CardWars.BattleEngine.Entities;

public class UnitSlot(EntityContainer container, UnitSlotId id) : Entity<UnitSlotId>(container, id)
{
	public Battlefield? ParentBattlefield;
	public UnitCard? HoldingUnit;
}

public record struct UnitSlotId(Guid Id);