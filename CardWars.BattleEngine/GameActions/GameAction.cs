namespace CardWars.BattleEngine.GameActions;

public abstract class GameAction
{
	public List<Guid> BoundedPlayers { get; set; } = [];
	public bool BoundedAllPlayers => BoundedPlayers.Count == 0;
	public bool BoundedSource { get; set; } = true;
}