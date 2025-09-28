using System;
using CardWars.BattleEngine;
using CardWars.BattleEngine.GameActions.Data;
using Godot;

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
		GameEngine.QueueGameActionBatch(new([
			new InstantiatePlayerAction() { Id = Guid.NewGuid() },
			new InstantiateBattlefieldAction() { Id = Guid.NewGuid() }

		]));
	}

	public override void _Process(double delta)
	{
		if (GameEngine == null) { return; }
		string data = "";

		data += "Players:\n";
		foreach (var item in GameEngine.Entities.Players)
		{
			data += item.Key + ": " + item.Value + "\n";
		}

		data += "Battlefields:\n";
		foreach (var item in GameEngine.Entities.Battlefields)
		{
			data += item.Key + ": " + item.Value + "\n";
		}

		data += "UnitSlots:\n";
		foreach (var item in GameEngine.Entities.UnitSlots)
		{
			data += item.Key + ": " + item.Value + "\n";
		}

		data += "UnitCards:\n";
		foreach (var item in GameEngine.Entities.UnitCards)
		{
			data += item.Key + ": " + item.Value + "\n";
		}


		GetNode<Label>("ControlDisplayPanel/Label").Text = data;
	}

}
