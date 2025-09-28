namespace CardWars.BattleEngine.GameActions;

public class GameActionBatch
{
	public List<GameAction> Actions = [];
	public string AnimationId = "";

	public GameActionBatch(string animationId = "") { AnimationId = animationId; }
	public GameActionBatch(List<GameAction> actions, string animationId = "") { Actions = actions; AnimationId = animationId; }
	public GameActionBatch(GameAction action, string animationId = "") { Actions.Add(action); AnimationId = animationId; }
}