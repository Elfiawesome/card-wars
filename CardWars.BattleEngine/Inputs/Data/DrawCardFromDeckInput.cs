using CardWars.BattleEngine.Entities;
using CardWars.BattleEngine.Resolvers;

namespace CardWars.BattleEngine.Inputs.Data;

public record struct DrawCardFromDeckInput(DeckId Id) : IInput
{
	public DeckId DeckId { get; } = Id;
}

public class DrawCardFromDeckInputHandler : IInputHandler<DrawCardFromDeckInput>
{
	public bool Handle(InputContext context, DrawCardFromDeckInput data)
	{
		context.Engine.QueueResolver(new DrawCardFromDeckResolver(data.Id, context.PlayerId));
		return true;
	}
}