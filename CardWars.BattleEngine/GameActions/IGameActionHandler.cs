using CardWars.BattleEngine.Common;

namespace CardWars.BattleEngine.GameActions;

internal interface IGameActionHandler<T> : IDataHandlerReturn<BattleEngine, T, bool> where T : GameAction;