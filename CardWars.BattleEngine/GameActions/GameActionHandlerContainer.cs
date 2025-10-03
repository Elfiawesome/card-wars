using CardWars.BattleEngine.Common;
using CardWars.BattleEngine.GameActions.Data;

namespace CardWars.BattleEngine.GameActions;

public class GameActionHandlerContainer : DataHandlerReturnContainer<BattleEngine, GameAction, bool>
{
	public GameActionHandlerContainer() { Register(); }

	public override void Register()
	{
		RegisterHandler<AttachBattlefieldToPlayerAction, AttachBattlefieldToPlayerHandler>();

		RegisterHandler<InstantiateBattlefieldAction, InstantiateBattlefieldHandler>();
		RegisterHandler<InstantiatePlayerAction, InstantiatePlayerHandler>();
		RegisterHandler<InstantiateUnitCardAction, InstantiateUnitCardHandler>();
		RegisterHandler<InstantiateUnitSlotAction, InstantiateUnitSlotHandler>();
	}
}
