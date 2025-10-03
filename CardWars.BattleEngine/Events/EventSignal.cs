namespace CardWars.BattleEngine.Events;

public class EventSignal<TEventContext, TEventOutcome>
	where TEventContext : EventContext
	where TEventOutcome : EventOutcome
{
	private List<EventSubscriber<TEventContext, TEventOutcome>> _subscribers = [];
	public void Subscribe(EventSubscriber<TEventContext, TEventOutcome> subscriber)
	{
		_subscribers.Add(subscriber);
	}

	public List<TEventOutcome> Raise(TEventContext context)
	{
		// Get all the subcribers in a ordered list
		_subscribers.Sort(
			(s1, s2) => s1.Priority.CompareTo(s2.Priority)
		);

		List<TEventOutcome> list = [];
		foreach (var subscriber in _subscribers)
		{
			if (subscriber.RaisedLeft != 0)
			{
				list.Add(subscriber.Raise(context));
				subscriber.RaisedLeft -= 1;
			}
		}
		return list;
	}
}