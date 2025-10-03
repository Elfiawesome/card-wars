using CardWars.BattleEngine.GameActions;

namespace CardWars.BattleEngine.Resolvers;

public abstract class Resolver
{
	public event Action<List<GameActionBatch>>? OnCommited;
	public event Action<Resolver>? OnResolverQueued;
	public event Action? OnResolved;

	public enum ResolverState { Idle, Resolving, Resolved, }

	public ResolverState State = ResolverState.Idle;

	protected List<GameActionBatch> _batches = [];

	public abstract void Resolve(BattleEngine engine);

	protected void QueueResolver(Resolver resolver)
	{
		if (State == ResolverState.Resolved) { return; }
		OnResolverQueued?.Invoke(resolver);
	}

	protected void AddBatch(GameActionBatch batch) { _batches.Add(batch); }

	protected void CommitResolve()
	{
		Commit();
		Resolved();
	}

	protected void Commit()
	{
		if (State == ResolverState.Resolved) { return; }
		if (_batches.Count == 0) { return; }
		OnCommited?.Invoke(_batches);
		_batches = [];
	}

	protected void Resolved()
	{
		if (State == ResolverState.Resolved) { return; }
		OnResolved?.Invoke();
		State = ResolverState.Resolved;
	}
}