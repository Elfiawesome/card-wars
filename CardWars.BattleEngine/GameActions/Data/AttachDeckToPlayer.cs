using CardWars.BattleEngine.Common;

namespace CardWars.BattleEngine.GameActions.Data;

public class AttachDeckToPlayerAction(Guid deckId, Guid playerId) : GameAction
{
	public Guid DeckId { get; set; } = deckId;
	public Guid PlayerId { get; set; } = playerId;
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