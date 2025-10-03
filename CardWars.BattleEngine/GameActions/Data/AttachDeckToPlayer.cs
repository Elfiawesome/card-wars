using CardWars.BattleEngine.Common;
using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class AttachDeckToPlayerAction(DeckId deckId, PlayerId playerId) : GameAction
{
	public DeckId DeckId { get; set; } = deckId;
	public PlayerId PlayerId { get; set; } = playerId;
}

internal class AttachDeckToPlayerHandler : IGameActionHandler<AttachDeckToPlayerAction>
{
	public bool Handle(BattleEngine engine, AttachDeckToPlayerAction data)
	{
		if (!engine.Entities.Decks.TryGetValue(data.DeckId, out var deck)) { return false; }
		if (!engine.Entities.Players.TryGetValue(data.PlayerId, out var player)) { return false; }
		return player.Decks.Add(deck);
	}
}