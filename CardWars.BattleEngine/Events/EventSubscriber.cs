namespace CardWars.BattleEngine.Events;

public abstract class EventSubscriber<TEventContext, TEventOutcome>
	where TEventContext : EventContext
	where TEventOutcome : EventOutcome
{
	public int Priority = 0;
	public int RaisedLeft = -1;

	public abstract TEventOutcome Raise(TEventContext context);
}