using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class InstantiateDeckAction(Guid id) : GameAction
{
	public Guid Id { get; set; } = id;
}

internal class InstantiateDeckHandler : IGameActionHandler<InstantiateDeckAction>
{
	public bool Handle(BattleEngine engine, InstantiateDeckAction data)
	{
		return engine.Entities.Decks.TryAdd(data.Id, new Deck(engine.Entities, data.Id));
	}
}