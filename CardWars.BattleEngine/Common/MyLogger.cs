namespace CardWars.BattleEngine.Common;

public static class MyLogger
{
	private static event Action<string> Logged = delegate { };
	private static event Action<string> LoggedError = delegate { };

	public static void Log(string msg)
	{
		Logged.Invoke(msg);
	}

	public static void LogError(string msg)
	{
		LoggedError.Invoke(msg);
	}

	public static void SubscribeLog(Action<string> handler)
	{
		Logged += handler;
	}
	public static void SubscribeLogError(Action<string> handler)
	{
		LoggedError += handler;
	}
}