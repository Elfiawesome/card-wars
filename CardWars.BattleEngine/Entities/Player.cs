namespace CardWars.BattleEngine.Entities;

public class Player(EntityContainer container, Guid id) : Entity<Guid>(container, id)
{
	public string Name = "Default Name";
	public HashSet<Battlefield> Battlefields = [];
	public HashSet<UnitCard> HandCards = [];
}
