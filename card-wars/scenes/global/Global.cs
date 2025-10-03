using CardWars.BattleEngine.Common;
using Godot;

public partial class Global : Node
{
	public override void _Ready()
	{
		base._Ready();
		MyLogger.SubscribeLog(GD.Print);
		MyLogger.SubscribeLogError(GD.PrintErr);
	}
}
