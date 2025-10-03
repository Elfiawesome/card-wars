namespace CardWars.BattleEngine.Common;

public interface IDataHandlerReturn<TContext, TData, TReturn>
	where TData : notnull
	where TReturn : notnull
{
	public abstract TReturn Handle(TContext context,TData data);
}