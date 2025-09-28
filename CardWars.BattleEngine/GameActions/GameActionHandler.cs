using System.Reflection.Metadata;
using CardWars.BattleEngine.Core;

namespace CardWars.BattleEngine.GameActions;

internal interface IGameActionHandler<T> : IDataHandlerReturn<BattleEngine, T, bool> where T : GameAction;