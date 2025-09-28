namespace CardWars.BattleEngine.Entities;

public class EntityContainer
{
	public Dictionary<Guid, Player> Players = [];
	public Dictionary<Guid, Battlefield> Battlefields = [];
	public Dictionary<Guid, UnitSlot> UnitSlots = [];
	public Dictionary<Guid, UnitCard> UnitCards = [];
}