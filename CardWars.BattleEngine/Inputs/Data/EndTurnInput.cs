using CardWars.BattleEngine.Resolvers;

namespace CardWars.BattleEngine.Inputs.Data;

public class EndTurnInput : IInput
{
}

public class EndTurnInputHandler : IInputHandler<EndTurnInput>
{
	public bool Handle(BattleEngine engine, EndTurnInput data)
	{
		engine.QueueResolver(new EndTurnResolver());
		return true;
	}
}