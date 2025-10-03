namespace CardWars.BattleEngine.Common;

public interface IDataHandler<TContext, TData>
{
	public abstract void Handle(TContext context,TData data);
}