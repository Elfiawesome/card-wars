using System.Collections.Generic;
using System.Linq;
using CardWars.BattleEngine;
using CardWars.BattleEngine.Inputs.Data;
using Godot;

namespace Cardwars;

public partial class MainTest : Control
{
	public BattleEngine GameEngine;
	public override void _Ready()
	{
		GameEngine = new BattleEngine();
		GameEngine.OnGameActionBatchEvent += (batch) =>
		{
			// foreach (var action in batch.Actions)
			// {
			// 	GD.Print(action);
			// }
		};
		var myId = GameEngine.AddPlayer();
		var myId2 = GameEngine.AddPlayer();
		var myId3 = GameEngine.AddPlayer();
		GameEngine.HandleInput(myId, new EndTurnInput());
		// GameEngine.HandleInput(myId2, new EndTurnInput());
		// GameEngine.HandleInput(myId3, new EndTurnInput());
	}

	public override void _Process(double delta)
	{
		if (GameEngine == null) { return; }
		string data = "";

		data += "[TurnNumber: " + GameEngine.TurnOrderIndex + "]\n";
		foreach (var playerId in GameEngine.PlayerOrder)
		{
			var entity = GameEngine.Entities.Players[playerId];
			if (playerId == GameEngine.CurrentPlayerId)
			{
				data += $"-> Player {playerId}\n";
			}
			else
			{
				data += $"   Player {playerId}\n";
			}
			foreach (var deck in entity.Decks)
			{
				data += $"      Deck {deck.Id}\n";
			}
		}

		data += "\n[Battlefields]:\n";
		foreach (var item in GameEngine.Entities.Battlefields)
		{
			data += $"   {item.Key}\n";
			foreach (var slotItem in item.Value.Slots)
			{
				data += $"      {slotItem.Id}\n";
			}
		}
		GetNode<Label>("ControlDisplayPanel/Label").Text = data;
	}

	private string FormatList<T>(List<T> list)
	{
		return string.Join(", ", list.Select(x => x.ToString()));
	}
}