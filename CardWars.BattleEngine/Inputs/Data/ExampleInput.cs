using CardWars.BattleEngine.Common;

namespace CardWars.BattleEngine.Inputs.Data;

public class ExampleInput : IInput
{
}

public class ExampleInputHandler : IInputHandler<ExampleInput>
{
	public bool Handle(BattleEngine context, ExampleInput data)
	{
		MyLogger.Log("ExampleInputHandler handled");
		return true;
	}
}