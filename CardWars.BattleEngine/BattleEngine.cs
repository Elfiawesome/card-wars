using CardWars.BattleEngine.Common;
using CardWars.BattleEngine.Entities;
using CardWars.BattleEngine.GameActions;
using CardWars.BattleEngine.GameActions.Data;
using CardWars.BattleEngine.Inputs;
using CardWars.BattleEngine.Resolvers;

namespace CardWars.BattleEngine;

public class BattleEngine
{
	// public APIs
	public event Action<GameActionBatch> OnGameActionBatchEvent = delegate { };

	// Containers (to change into internal later on...)
	public readonly EntityContainer Entities = new();
	public readonly GameActionHandlerContainer gameActionHandler = new();
	public readonly InputHandlerContainer inputHandler = new();

	public int TurnOrderIndex = 0;
	public List<Guid> PlayerOrder = [];
	public Guid? CurrentPlayerId => (PlayerOrder.Count == 0 && TurnOrderIndex < 0 && TurnOrderIndex >= PlayerOrder.Count) ? null : PlayerOrder[TurnOrderIndex];
	public HashSet<Guid> AllowedPlayerInput = [];

	private readonly List<Resolver> _resolverStack = [];

	public Guid AddPlayer()
	{
		var playerId = Guid.NewGuid();
		QueueResolver(new PlayerJoinedResolver() { playerId = playerId });
		QueueResolver(new CreateBattlefieldResolver(Guid.NewGuid(), playerId));
		return playerId;
	}

	public void HandleInput(Guid playerId, IInput input)
	{
		if (!AllowedPlayerInput.Contains(playerId))
		{
			MyLogger.Log($"[INPUT] {input.GetType().Name} Was not allowed from player {playerId}");
			return;
		}
		var success = inputHandler.Handle(this, input);
		if (!success)
		{
			MyLogger.Log($"[INPUT] {input.GetType().Name} Failed");
		}
		else
		{
			MyLogger.Log($"[INPUT] {input.GetType().Name} Succeeded");
		}
	}

	internal void QueueGameActionBatch(GameActionBatch batch)
	{
		foreach (var action in batch.Actions)
		{
			HandleAction(action);
		}
		OnGameActionBatchEvent.Invoke(batch);
	}

	internal void QueueResolver(Resolver resolver)
	{
		_resolverStack.Add(resolver);
		HandleResolvers();
	}

	private void HandleResolvers()
	{
		if (_resolverStack.Count == 0) { return; }

		var currentResolver = _resolverStack[0];
		if (currentResolver.State == Resolver.ResolverState.Idle)
		{
			MyLogger.Log($"	[RESOLVER] {currentResolver.GetType().Name} is being handled");
			currentResolver.State = Resolver.ResolverState.Resolving;
			currentResolver.OnResolved += () => { _resolverStack.RemoveAt(0); HandleResolvers(); };
			currentResolver.OnCommited += (actionBatches) => { actionBatches.ForEach(actionBatch => QueueGameActionBatch(actionBatch)); };
			currentResolver.OnResolverQueued += _resolverStack.Add;
			currentResolver.Resolve(this);
		}
	}

	private void HandleAction(GameAction action)
	{
		var success = gameActionHandler.Handle(this, action);
		if (!success)
		{
			MyLogger.Log($"		[ACTION] {action.GetType().Name} Failed");
		}
		else
		{
			MyLogger.Log($"		[ACTION] {action.GetType().Name} Succeeded");
		}
	}
}