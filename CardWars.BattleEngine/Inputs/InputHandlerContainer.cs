using CardWars.BattleEngine.Common;
using CardWars.BattleEngine.Inputs.Data;

namespace CardWars.BattleEngine.Inputs;

public class InputHandlerContainer : DataHandlerReturnContainer<InputContext, IInput, bool>
{
	public InputHandlerContainer() { Register(); }

	public override void Register()
	{
		RegisterHandler<EndTurnInput, EndTurnInputHandler>();
		RegisterHandler<DrawCardFromDeckInput, DrawCardFromDeckInputHandler>();
	}
}