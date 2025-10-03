namespace CardWars.BattleEngine.Entities;

public class EntityContainer
{
	public Dictionary<PlayerId, Player> Players = [];
	public Dictionary<BattlefieldId, Battlefield> Battlefields = [];
	public Dictionary<UnitSlotId, UnitSlot> UnitSlots = [];
	public Dictionary<UnitCardId, UnitCard> UnitCards = [];
	public Dictionary<DeckId, Deck> Decks = [];
}