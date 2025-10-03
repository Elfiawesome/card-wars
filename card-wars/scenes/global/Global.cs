using CardWars.BattleEngine.Common;
using Godot;
using System;

public partial class Global : Node
{
	public override void _Ready()
	{
		base._Ready();
		MyLogger.Subscribe(GD.Print);
	}
}
