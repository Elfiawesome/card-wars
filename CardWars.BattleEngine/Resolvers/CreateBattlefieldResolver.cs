using CardWars.BattleEngine.Entities;
using CardWars.BattleEngine.GameActions;
using CardWars.BattleEngine.GameActions.Data;

namespace CardWars.BattleEngine.Resolvers;

public class CreateBattlefieldResolver(BattlefieldId battlefieldId, PlayerId playerId) : Resolver
{
	private BattlefieldId _battlefieldId = battlefieldId;
	private PlayerId _playerId = playerId; // Used so that he can any abilities or something

	public override void Resolve(BattleEngine engine)
	{
		GameActionBatch batch = new();
		batch.Actions.Add(new InstantiateBattlefieldAction(_battlefieldId));
		batch.Actions.Add(new AttachBattlefieldToPlayerAction(_battlefieldId, _playerId));
		for (var i = 0; i < 4; i++)
		{
			UnitSlotId unitSlotId = new(Guid.NewGuid());
			batch.Actions.Add(new InstantiateUnitSlotAction(unitSlotId));
			batch.Actions.Add(new AttachUnitSlotToBattlefieldAction(unitSlotId, _battlefieldId));
		}

		DeckId deckId = new(Guid.NewGuid());
		batch.Actions.Add(new InstantiateDeckAction(deckId));
		batch.Actions.Add(new AttachDeckToPlayerAction(deckId, _playerId));

		AddBatch(batch);
		CommitResolve();
	}
}