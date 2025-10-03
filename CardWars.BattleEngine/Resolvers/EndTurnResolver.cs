using CardWars.BattleEngine.GameActions.Data;

namespace CardWars.BattleEngine.Resolvers;

public class EndTurnResolver : Resolver
{
	public override void Resolve(BattleEngine engine)
	{
		AddBatch(new([
			new AdvanceTurnOrderAction()
		]));
		CommitResolve();
	}
}