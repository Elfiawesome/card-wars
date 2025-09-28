namespace CardWars.BattleEngine.Entities;

public abstract class Entity<TId>
	where TId : struct
{
	public readonly TId Id;
	public EntityContainer Container;
	public bool IsDestroyed { get; private set; } = false;

	public Entity(EntityContainer container, TId id)
	{
		Id = id;
		Container = container;
		Ready(container, id);
	}

	public virtual void Ready(EntityContainer engine, TId id) { }

	public void Dispose()
	{
		IsDestroyed = true;
	}
}