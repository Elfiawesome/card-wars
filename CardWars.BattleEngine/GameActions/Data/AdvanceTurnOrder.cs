using CardWars.BattleEngine.Entities;

namespace CardWars.BattleEngine.GameActions.Data;

public class AdvanceTurnOrderAction : GameAction
{
	// Used to jump to the specific index of the turn (Not the player id itself)
	public int? SetIndex { get; set; }
}

internal class AdvanceTurnOrderHandler : IGameActionHandler<AdvanceTurnOrderAction>
{
	public bool Handle(BattleEngine engine, AdvanceTurnOrderAction data)
	{
		if (data.SetIndex != null)
		{
			engine.TurnOrderIndex = data.SetIndex ?? 0;
		}
		else
		{
			engine.TurnOrderIndex += 1;
			if (engine.TurnOrderIndex >= engine.PlayerOrder.Count)
			{
				engine.TurnOrderIndex = 0;
			}
		}

		engine.AllowedPlayerInput.Clear();
		if (engine.CurrentPlayerId != null)
		{
			engine.AllowedPlayerInput.Add((PlayerId)engine.CurrentPlayerId);
		}
		return true;
	}
}