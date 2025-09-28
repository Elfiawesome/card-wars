namespace CardWars.BattleEngine.Inputs;

public interface IInput
{
	internal bool Handle(string playerId, BattleEngine engine);
}