params ["_moveToPosition"];	

_dog = call MWD_fnc_getDog;

_scriptHandle = _dog getVariable ["MWD_MoveToScriptHandle", objNull];
if (!isNull _scriptHandle) exitWith {};

// Calculate a path that a normal human would take
(calculatePath ["man", "safe", getPosATL _dog, _moveToPosition]) addEventHandler ["PathCalculated", {												
	params ["_agent", "_path"];
	
	_dog = call MWD_fnc_getDog;
	
	if (MWD_Debug) then {
		{								
			_markerName = str _forEachIndex;
			deleteMarker _markerName;
			_marker = createMarker [_markerName, _x]; 
			_marker setMarkerType "mil_dot"; 
			_marker setMarkerText str _forEachIndex;				
		} forEach _path;
	};
	
	_scriptHandle = [_dog, _path] spawn {				
		params ["_dog", "_path"];
		
		_lastPathPos = _path select count _path - 1;
		
		{	
			if (MWD_Debug) then {
				_markerName = "currentPosMarker";
				deleteMarker _markerName;
				_marker = createMarker [_markerName, _x]; 
				_marker setMarkerType "mil_dot"; 
				_marker setMarkerColor "ColorRed"; 
			};
					
			_dog setDestination [_x, "LEADER DIRECT", false];						
			
			waitUntil {								
				// Check for reasons to stop (external scripts/logic use this variable)
				if (_dog getVariable ["MWD_MoveToBreak", false]) exitWith {
					_dog setVariable ["MWD_MoveToBreak", false];
					terminate _thisScript, 
					true
				};
				// Check for animation locks, speed is 0 when this happens. Terminate script and start over
				if (speed _dog < 1) exitWith {					
					_dog setVariable ["MWD_AnimationLockDetected", true];	
					_dog setVariable ["MWD_MoveToBreak", true];
					true
				};
				// Are we still alive?
				if (!alive _dog) exitWith {true};
				// Are we still tracking?
				if (_dog getVariable ["MWD_Status", ""] != "TRACKING") exitWith {true};
				// Wait until agent is close to current position before moving on to the next
				_dog distance2D _x <= 5				
			};			
			
		} forEach _path;				
		
	};	
	_dog setVariable ["MWD_MoveToScriptHandle", _scriptHandle];
}];					