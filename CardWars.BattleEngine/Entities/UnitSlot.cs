namespace CardWars.BattleEngine.Entities;

public class UnitSlot(EntityContainer container, Guid id) : Entity<Guid>(container, id)
{
	public Battlefield? ParentBattlefield;
	public UnitCard? HoldingUnit;
}

public record struct UnitSlotId(Guid Id);