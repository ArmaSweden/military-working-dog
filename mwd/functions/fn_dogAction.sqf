/**
* Action loop for the dog. Depending on status, the dog will behave accordingly.
*/
params ["_dog"];

[_dog] spawn { 
	params ["_dog"]; 			
	
	// Start walking on spawn
	"Dog_Walk" call MWD_fnc_dogPlayMove;
	
	while { sleep 2.5; alive _dog } do { 
						
		_dogAction = _dog getVariable ["MWD_Status", ""];
		
		if (MWD_Debug) then {
			systemChat format ["MWD_fnc_dogAction: %1", _dogAction];
		};								
								
		// Check nearby men, see if the dog reacts to people that are not members of the handlers group
		_nearestObjects = nearestObjects [_dog, ["CAManBase"], 40];
		_nearbyStranger = objNull;
		scopeName "nearbyCheck";
		{
			// Check if someone outside the handlers group is nearby
			if !(group _x isEqualTo group player) then {
										
				_trackedGroup = _dog getVariable ["MWD_TrackedGroup", objNull];
				
				switch true do {	
				
					case (_dogAction == "TRACKING" && (group _x isEqualTo _trackedGroup)) : {
						// Tracked group is close, let the dog react to that
						_dogAction = "WINDSOUND";
						_nearbyStranger = _x;
						breakTo "nearbyCheck";
					};
				};										
			};					
		} forEach _nearestObjects;												
		
		_distanceToHandler = _dog distance player;
		
		switch (_dogAction) do {
			
			case "WINDSOUND": {										
				// Tracked group is close, let the dog walk slowly, step by step in that direction
				if (MWD_Debug) then {											
					systemChat format ["Wind/sound mark: %1", _nearbyStranger];								
				};					
				_dog setVariable ["MWD_MoveToBreak", true];
				"Dog_Idle_Growl" call MWD_fnc_dogPlayMove;
				sleep 1;
				_dog setDestination [getPosATL _nearbyStranger, "LEADER DIRECT", false];
				[_dog, "barking", 1] remoteExec ["MWD_fnc_dogSay"];
				sleep 3;
				"Dog_Walk" call MWD_fnc_dogPlayMove;												
			};
			
			case "TRACKING": {
			
				// Check for animation locks
				if (_dog getVariable ["MWD_AnimationLockDetected", false]) exitWith {					
					if (MWD_Debug) then {
						systemChat format ["Animation lock detected, speed: %1", speed _dog]; 
					};
					doStop _dog;
					"Dog_Run" call MWD_fnc_dogPlayMove;
					_dog setVariable ["MWD_AnimationLockDetected", false];										
				};
				
				_trackedGroup = _dog getVariable "MWD_TrackedGroup";				
				_tracks = _trackedGroup getVariable "MWD_Tracks";
				_trackIndex = _dog getVariable "MWD_TrackIndex";
				_positions	= _tracks select _trackIndex;
				_trackPosIndex = _dog getVariable "MWD_TrackPosIndex";
				_trackEndPos = _positions select _trackPosIndex;
				_distToTrackingPos = _dog distance _trackEndPos;
				_trackDir = _dog getDir _trackEndPos;
				_distToTrackedGroup = _dog distance leader _trackedGroup;				
				
				if (MWD_Debug) then {											
					systemChat format ["Tracking index (T:P): %1:%2 (of %3)", _trackIndex, _trackPosIndex, count _positions - 1];
					systemChat format ["Near %1", _nearestObjects];
					systemChat format ["DH: %1, DEP: %2", _distanceToHandler, _distToTrackingPos];						
				};
								
				// Use custom move function using the same path a human would take, for some reason dogs (agents) will not take the shortest path to target by default
				[_trackEndPos] call MWD_fnc_dogMoveTo;				
				
				switch true do {										
					case (_distToTrackingPos <= 6) : {					
						if (_trackPosIndex == count _positions - 1) then {
							
							// Reached end of track, stop and whine
							"Dog_Walk" call MWD_fnc_dogPlayMove;
							
							[_dog, "whining", 0.5] remoteExec ["MWD_fnc_dogSay"];
							
							if (!([_trackedGroup, _trackIndex] in (_dog getVariable ["MWD_CompletedTracks", []]))) then {
								// Add lost track marker
								_dog getVariable ["MWD_Markers3D", []] pushBack [getPos _dog, "Spåret tappat"];
								// Add this track [trackedGroup, trackIndex] to completed tracks array
								_dog getVariable "MWD_CompletedTracks" pushBack [_trackedGroup, _trackIndex];
								
								if (MWD_Debug) then {
									systemChat format ["Reached end of track"];																
								};
							};							
						}
						else {
							// Ok, close enough to current track position, switch to the next track position
							_dog setVariable ["MWD_TrackPosIndex", _trackPosIndex + 1];
							// Quick fix to tell moveTo function (spawn loop) that a new target has been set (see MWD_fnc_moveTo)
							_dog setVariable ["MWD_MoveToBreak", true];							
							// Add automarker on handlers map
							[getPos _dog, _dog getDir _trackEndPos] call MWD_fnc_autoMarker;
							// Add 3D marker for in-game positions (used in eventhandler "Draw3D", see MWD_fnc_triggerActivation)
							_nextTrackEndPos = _positions select _trackPosIndex + 1;
							_dog getVariable ["MWD_Markers3D", []] pushBack [getPos _dog, format ["%1 °", round (_dog getDir _nextTrackEndPos)]];
						};
					};
					case (_distanceToHandler > 30) : {
						// Stop and wait for handler to catch up
						"Dog_Stop" call MWD_fnc_dogPlayMove;
						[_dog, "whining", 0.3] remoteExec ["MWD_fnc_dogSay"];
					};						
					case (_distanceToHandler < 10) : {
						// Use random move to "un-lock" animation locks
						//_dog playMoveNow (selectRandomWeighted ["Dog_Sprint", 0.8, "Dog_Run", 0.2]);
						selectRandomWeighted ["Dog_Sprint", 0.8, "Dog_Run", 0.2] call MWD_fnc_dogPlayMove;
						// Play panting sound every now and then
						//["panting", 0.30] call MWD_fnc_dogSay;
					};
					default {
						// Use random move to "un-lock" animation locks						
						selectRandomWeighted ["Dog_Sprint", 0.8, "Dog_Run", 0.2] call MWD_fnc_dogPlayMove;
					};						
				};										
			};																
			
			case "HEEL": {										
				switch true do {						
					case (_distanceToHandler > 10) : {
						// Sprint in handler direction
						_dog setDestination [getPos player, "LEADER DIRECT", false];
						"Dog_Sprint" call MWD_fnc_dogPlayMove;						
					};												
					default {
						// Try to stay at left side of handler
						_dog setDestination [player getRelPos [2, 280], "LEADER DIRECT", false];
						"Dog_Walk" call MWD_fnc_dogPlayMove;						
						[_dog, "whining", 0.15] remoteExec ["MWD_fnc_dogSay"];
					};						
				};										
			};
			
			case "STAY": {						
				"Dog_Sit" call MWD_fnc_dogPlayMove;
				_dog lookAt player;
				[_dog, "whining", 0.2] remoteExec ["MWD_fnc_dogSay"];
				// TODO: make the dog turn smoothly towards the player while sitting down
				// setDir is not good enough
			};
			
			case "DISMISS": {										
				// Dismiss the dog with a whining
				[_dog, "whining", 1] remoteExec ["MWD_fnc_dogSay"];
				sleep 2;
				deleteVehicle _dog;
			};
			
			default {
				// Free search mode, stick around, close and in front of the handler
				_dog setDestination [player getPos [15, direction player], "LEADER DIRECT", false];
				"Dog_Run" call MWD_fnc_dogPlayMove;				
			};
			
		}; // end switch
	}; // end while
}; // end spawn