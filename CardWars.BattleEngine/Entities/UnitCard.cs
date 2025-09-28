namespace CardWars.BattleEngine.Entities;

public class UnitCard(EntityContainer container, Guid id) : Entity<Guid>(container, id)
{
	public bool IsPlayed => ParentUnitSlot != null;
	public UnitSlot? ParentUnitSlot;
}