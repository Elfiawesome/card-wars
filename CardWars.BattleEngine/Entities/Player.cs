namespace CardWars.BattleEngine.Entities;

public class Player(EntityContainer container, PlayerId id) : Entity<PlayerId>(container, id)
{
	public string Name = "Default Name";
	public HashSet<Battlefield> Battlefields = [];
	public HashSet<UnitCard> HandCards = [];
	public HashSet<Deck> Decks = [];
}

public record struct PlayerId(Guid Id);
