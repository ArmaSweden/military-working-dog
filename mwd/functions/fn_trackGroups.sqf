/**
* Server function to handle all "tracked" groups. 
* It places a "track trigger" at given intervals/distances between a groups positions.
*
*/
[] spawn {		
				
	while { sleep MWD_TrackCheckInterval; true } do { 
	
		_trackedGroups =  allGroups select {(_x getVariable ["MWD_Tracked", false])};						
		{
			_group = _x;												
			
			// Add trigger if someone in the tracked group is still alive
			if ({ alive _x } count units _group > 0) then {				
					
				_currentPosition = getPosATL leader _group; // current position of this tracked group						
				// Initalize tracks array if it does not exist, need to save it here since we only update it when new positions/triggers are placed
				_tracks = _group getVariable ["MWD_Tracks", []];
				if (count _tracks == 0) then {
					_group setVariable ["MWD_Tracks", [[_currentPosition]]];
				};				
				_tracks = _group getVariable "MWD_Tracks"; // all tracks laid by this group, defaults to an array with starting position
				_startNewTrack = false; // defaults to false, below logic might change that
				_stopCondition = false; // defaults to false, below logic might change that
				
				// Check if this group is on foot, or has entered a vehicle?				
				_isOnFoot = isNull objectParent leader _group;
				_wasOnFoot = _group getVariable ["MWD_OnFoot", true];
				if (!_isOnFoot && _wasOnFoot) then {
					// Unit has entered a vehicle, stop tracking until they disembark
					_group setVariable ["MWD_OnFoot", false];
					if (MWD_Debug) then {systemChat "Unit has entered a vechile, stop tracking";};
					_stopCondition = true;
				};				
				if (!_isOnFoot && !_wasOnFoot) exitWith {
					// Unit is still in the vehicle
					if (MWD_Debug) then {systemChat "Unit still in vehicle";};
				};												
				if (_isOnFoot && !_wasOnFoot) then {
					// Unit has exited the vehicle, start a new track
					if (MWD_Debug) then {systemChat "Unit exited the vehicle, continue tracking";};
					_group setVariable ["MWD_OnFoot", true];
					_startNewTrack = true;
				};
				
				// Check if this group is in water
				_isInWater = surfaceIsWater getPos leader _group;
				_wasInWater = _group getVariable ["MWD_InWater", false];
				if (_isInWater && !_wasInWater) then {
					if (MWD_Debug) then {systemChat "Unit is in water, stop tracking";};
					_group setVariable ["MWD_InWater", true];
					_stopCondition = true;
				};				
				if (_isInWater && _wasInWater) exitWith {
					// Unit is still in water
					if (MWD_Debug) then {systemChat "Unit still in water";};
				};				
				if (!_isInWater && _wasInWater) then {
					// Unit is now on land again, start a new track
					if (MWD_Debug) then {systemChat "Unit exited the water, continue tracking";};
					_group setVariable ["MWD_InWater", false];
					_startNewTrack = true;
				};
								
				// Start a new track
				if (_startNewTrack) then {						
					// Check if previous track only contains one point, it means that the group is getting in and out of a vehicle on the same spot
					_prevTrack = _tracks select (count _tracks - 1);
					if (count _prevTrack > 1) then {
						_tracks pushBack [_currentPosition];
					}
					else {
						if (MWD_Debug) then {systemChat "Prev track contains one point only, getting in and out of the vehicle?";};
					};
					_startNewTrack = false;
				};
								
				_positions = _tracks select (count _tracks - 1); // the current track (last in track array)
				_prevPosition = _positions select (count _positions - 1);
				_timer = _group getVariable ["MWD_LastPosTimer", 0];
				_distance = _currentPosition distance _prevPosition;
				// If the group has moved more than MWD_TriggerDistance meters since last check
				_distanceCondition = _distance > MWD_TriggerDistance;			
				// If the group has stopped and has moved more than 10 meters since last trigger
				_timerCondition =  _timer > 60 && _distance > 10 && (speed leader _group) == 0;																
								
				// Check falty move? If distance is to far, maybe the curator moved the group by accident?
				_movedToFar = _distance > (MWD_TriggerDistance * 2);
				if (_movedToFar) exitWith { systemChat "Moved to far"; };																
					
				// Finally, create a track trigger if one of the conditions are met
				if (_stopCondition || _distanceCondition || _timerCondition) then {
										
					// Add current position to positions array
					_positions pushBack _currentPosition;						
					// Reset timer when last position was recorded
					_timer = 0;
					// Add a trigger between the previous and current position
					_trgDist = (_prevPosition distance _currentPosition) / 2;
					_trgDir = _prevPosition getDir _currentPosition;
					_trgPos = _prevPosition getPos [_trgDist, _trgDir];
					[_trgPos, _trgDist, _trgDir, _group, count _tracks - 1, count _positions - 1] call MWD_fnc_createTrackTrigger;
					
					_stopCondition = false;										
					// TODO: Remove tracks that contains only two points that are close together. When tracked units gets in and out of vechicles
					// on the same spot, tracks with two points close together gets created.
					
					
					// Send track updates to all clients, hence "true" (so the dog client can act on them)					
					_group setVariable ["MWD_Tracks", _tracks, true];
				};
				
				if (MWD_Debug) then {
					systemChat format ["(%1) T:%2, P:%3, D:%4", _group, count _tracks, count _positions, _distance];
				};
				
				// Update track timer
				_group setVariable ["MWD_LastPosTimer", _timer + MWD_TrackCheckInterval];
				
			}; // end if
			
		} forEach _trackedGroups;
				
	}; // end while
}; // end spawn