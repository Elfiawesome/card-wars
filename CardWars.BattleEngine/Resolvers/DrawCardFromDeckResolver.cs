using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.Resolvers;

public class DrawCardFromDeckResolver(DeckId deckId, PlayerId playerId) : Resolver
{
	private DeckId _deckId = deckId;
	private PlayerId _playerId = playerId;

	public override void Resolve(BattleEngine engine)
	{
		if (!engine.Entities.Decks.TryGetValue(_deckId, out var deck)) { Resolved(); return; }
		if (!engine.Entities.Players.TryGetValue(_playerId, out var player)) { Resolved(); return; }
		if (!player.Decks.TryGetValue(deck, out var actualDeck)) { Resolved(); return; }
		
	}
}
