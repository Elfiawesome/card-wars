using CardWars.BattleEngine.Resolvers;

namespace CardWars.BattleEngine.Inputs.Data;

public record struct EndTurnInput : IInput;

public class EndTurnInputHandler : IInputHandler<EndTurnInput>
{
	public bool Handle(InputContext context, EndTurnInput data)
	{
		context.Engine.QueueResolver(new EndTurnResolver());
		return true;
	}
}