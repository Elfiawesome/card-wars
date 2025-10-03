using CardWars.BattleEngine.Common;

namespace CardWars.BattleEngine.Inputs;

internal interface IInputHandler<T> : IDataHandlerReturn<BattleEngine, T, bool> where T : IInput;