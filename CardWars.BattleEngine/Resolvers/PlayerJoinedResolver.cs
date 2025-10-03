using CardWars.BattleEngine.GameActions;
using CardWars.BattleEngine.GameActions.Data;

namespace CardWars.BattleEngine.Resolvers;

public class PlayerJoinedResolver : Resolver
{
	public required Guid playerId;
	public override void Resolve(BattleEngine engine)
	{
		GameActionBatch gameActionBatch = new();
		gameActionBatch.Actions.Add(new InstantiatePlayerAction() { Id = playerId });

		if (engine.PlayerOrder.Count == 0)
		{
			gameActionBatch.Actions.Add(new AdvanceTurnOrderAction());
		}
		AddBatch(gameActionBatch);
		CommitResolve();
	}
}