using CardWars.BattleEngine.Common;

namespace CardWars.BattleEngine.GameActions.Data;

public class AdvanceTurnOrderAction : GameAction
{
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
			engine.AllowedPlayerInput.Add((Guid)engine.CurrentPlayerId);
		}
		return true;
	}
}