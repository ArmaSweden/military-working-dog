params ["_move"];

_dog = call MWD_fnc_getDog;

if (_move == _dog getVariable ["MWD_CurrentMove", ""]) exitWith {};

_dog playMoveNow _move;
_dog setVariable ["MWD_CurrentMove", _move];