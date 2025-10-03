namespace CardWars.BattleEngine.Entities;

public class Deck(EntityContainer container, Guid id) : Entity<Guid>(container, id)
{
	public string CardType = "Unit"; // | Spell
	public List<string> CardId = [
		"card-001"
	];
}

public record struct DeckId(Guid Id);
