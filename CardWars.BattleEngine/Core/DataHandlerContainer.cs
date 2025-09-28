namespace CardWars.BattleEngine.Core;

public abstract class DataHandlerContainer<TContext, TData>
	where TData : notnull
{
	private readonly Dictionary<Type, Action<TContext, TData>> _handlers = [];

	public abstract void Register();

	public void RegisterHandler<THandler>()
		where THandler : IDataHandler<TContext, TData>, new()
	{
		var handler = new THandler();
		if (_handlers.ContainsKey(typeof(TData)))
		{
			return;
		}
		_handlers[typeof(TData)] = (context, data) =>
		{
			if (data is TData typedData)
			{
				handler.Handle(context, data);
			}
		};
	}

	public void HandleActionData(TContext context, TData data)
	{
		var dataType = data.GetType();
		if (_handlers.TryGetValue(dataType, out var handler))
		{
			handler.Invoke(context, data);
		}
	}
}