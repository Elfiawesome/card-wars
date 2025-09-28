namespace CardWars.BattleEngine.Core;

public static class MyLogger
{
	private static event Action<string> Logged = delegate { };

	public static void Log(string msg)
	{
		Logged.Invoke(msg);
	}

	public static void Subscribe(Action<string> handler)
	{
		Logged += handler;
	}
}