namespace CardWars.BattleEngine.Core;

public abstract class DataHandlerReturnContainer<TContext, TBaseData, TReturn>
	where TBaseData : notnull
	where TReturn : notnull
{
	private delegate TReturn? HandlerDelegate(TContext context, TBaseData data);
	private readonly Dictionary<Type, HandlerDelegate> _handlers = [];

	public abstract void Register();

	public void RegisterHandler<TSpecificData, THandler>()
		where TSpecificData : notnull
		where THandler : IDataHandlerReturn<TContext, TSpecificData, TReturn>, new()
	{
		var handler = new THandler();
		if (_handlers.ContainsKey(typeof(TSpecificData)))
		{
			return;
		}
		_handlers[typeof(TSpecificData)] = (context, data) =>
		{
			if (data is TSpecificData typedData)
			{
				return handler.Handle(context, typedData);
			}
			return default;
		};
	}

	public TReturn? HandleActionData(TContext context, TBaseData data)
	{
		var dataType = data.GetType();
		if (_handlers.TryGetValue(dataType, out var handler))
		{
			return handler.Invoke(context, data);
		}
		return default;
	}
}