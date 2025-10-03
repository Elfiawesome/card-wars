using CardWars.BattleEngine.Common;

namespace CardWars.BattleEngine.Inputs;

internal interface IInputHandler<T> : IDataHandlerReturn<InputContext, T, bool> where T : IInput;