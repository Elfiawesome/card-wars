using CardWars.BattleEngine.GameActions;
using CardWars.BattleEngine.GameActions.Data;

namespace CardWars.BattleEngine.Resolvers;

public class CreateBattlefieldResolver(Guid battlefieldId, Guid playerId) : Resolver
{
	public Guid BattlefieldId = battlefieldId;
	public Guid PlayerId = playerId; // Used so that he can any abilities or something

	public override void Resolve(BattleEngine engine)
	{
		GameActionBatch batch = new();
		batch.Actions.Add(new InstantiateBattlefieldAction(BattlefieldId));
		batch.Actions.Add(new AttachBattlefieldToPlayerAction(BattlefieldId, PlayerId));
		for (var i = 0; i < 4; i++)
		{
			var unitSlotId = Guid.NewGuid();
			batch.Actions.Add(new InstantiateUnitSlotAction(unitSlotId));
			batch.Actions.Add(new AttachUnitSlotToBattlefieldAction(unitSlotId, BattlefieldId));
		}

		var deckId = Guid.NewGuid();
		batch.Actions.Add(new InstantiateDeckAction(deckId));
		batch.Actions.Add(new AttachDeckToPlayerAction(deckId, PlayerId));

		AddBatch(batch);
		CommitResolve();
	}
}