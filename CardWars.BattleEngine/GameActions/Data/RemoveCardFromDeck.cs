using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class RemoveCardFromDeckAction(DeckId id) : GameAction
{
	public DeckId DeckId { get; set; } = id;
	// TODO: the different types to draw a card
	// How to have the randomeness for luck based abilities that affect it
}

internal class RemoveCardFromDeckHandler : IGameActionHandler<RemoveCardFromDeckAction>
{
	public bool Handle(BattleEngine engine, RemoveCardFromDeckAction data)
	{
		if (!engine.Entities.Decks.TryGetValue(data.DeckId, out var deck)) { return false; }
		if (deck.CardIds.Count == 0) { return true; } // we will return a true not an error!
		var cardId = deck.CardIds[0];
		deck.CardIds.RemoveAt(0);
		// Ok so how do we go from here back up?

		return true;
	}
}