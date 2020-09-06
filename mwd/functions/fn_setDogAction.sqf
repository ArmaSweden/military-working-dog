params ["_dogAction"];	
	
_dog = call MWD_fnc_getDog;	

// Exit if it's the same as current action
if (_dogAction == _dog getVariable ["MWD_Status", ""]) exitWith {};

if (!isNull _dog) then {
	_dog setVariable ["MWD_Status", _dogAction];
	
	// Reset dog tracking variables
	_dog setVariable ["MWD_TrackedGroup", objNull];		
	
	// Remove any eventhandlers 
	evId = _dog getVariable ["MWD_Draw3DEventHandlerId", -1];
	if (evId > -1) then {
		removeMissionEventHandler ["Draw3D", evId];
		_dog setVariable ["MWD_Draw3DEventHandlerId", -1];
	};
	
	// Bark to confirm
	[_dog, "bark", 0.2] call MWD_fnc_dogSay;
};