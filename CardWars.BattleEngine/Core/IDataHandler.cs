namespace CardWars.BattleEngine.Core;

public interface IDataHandler<TContext, TData>
{
	public abstract void Handle(TContext context,TData data);
}