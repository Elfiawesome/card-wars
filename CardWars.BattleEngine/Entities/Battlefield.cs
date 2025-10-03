namespace CardWars.BattleEngine.Entities;

public class Battlefield(EntityContainer container, BattlefieldId id) : Entity<BattlefieldId>(container, id)
{
	public HashSet<UnitSlot> Slots = [];
}

public record struct BattlefieldId(Guid Id);