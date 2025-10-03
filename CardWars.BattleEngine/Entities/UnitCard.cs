namespace CardWars.BattleEngine.Entities;

public class UnitCard(EntityContainer container, UnitCardId id) : Entity<UnitCardId>(container, id)
{
	public bool IsPlayed => ParentUnitSlot != null;
	public UnitSlot? ParentUnitSlot;
}

public record struct UnitCardId(Guid Id);