using CardWars.BattleEngine.Common;
using CardWars.BattleEngine.Entities;
using CardWars.BattleEngine.GameActions;
using CardWars.BattleEngine.Inputs;

namespace CardWars.BattleEngine;

public class BattleEngine
{
	public event Action<GameActionBatch> OnGameActionBatchEvent = delegate { };

	public readonly EntityContainer Entities = new();
	public readonly GameActionHandlerContainer gameActionHandler = new();

	public void HandleInput(IInput input)
	{
	}

	public void QueueGameActionBatch(GameActionBatch batch)
	{
		foreach (var action in batch.Actions)
		{
			HandleAction(action);
		}
		OnGameActionBatchEvent.Invoke(batch);
	}

	private void HandleAction(GameAction action)
	{
		var success = gameActionHandler.HandleActionData(this, action);
		if (!success) { MyLogger.Log($"Action {action.GetType().Name} failed"); }
	}
}