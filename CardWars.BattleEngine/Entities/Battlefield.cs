namespace CardWars.BattleEngine.Entities;

public class Battlefield(EntityContainer container, Guid id) : Entity<Guid>(container, id)
{
	public HashSet<UnitSlot> Slots = [];
}