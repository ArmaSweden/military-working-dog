/**
* Function to deal with units crossing (activating) a track trigger.
* It will setup relevant variables in the dog object, if present.
* This function is called via remoteExec from the server, see MWD_fnc_createTrackTrigger.
*/
params ["_unit", "_trackedGroup", "_trackIndex", "_posIndex"];		
	
if (MWD_Debug) then {
	systemChat format ["MWD_fnc_triggerActivation: %1 - T/P: %2/%3", _unit, _trackIndex, _posIndex];	
};

_dog = player getVariable ["MWD_Dog", objNull];
// The trigger will put the dog into tracking mode for this specific group, if it's not busy tracking already
if (!isNull _dog && _unit == _dog) then {

	_isTracking = _dog getVariable ["MWD_Status", ""] == "TRACKING";
	_isTrackingThisGroup = _dog getVariable ["MWD_TrackedGroup", objNull] isEqualTo _trackedGroup;
	_trackIndexHigher = _trackIndex > _dog getVariable ["MWD_TrackIndex", 0];
	_posIndexHigher = (_trackIndex == _dog getVariable ["MWD_TrackIndex", 0] && _posIndex > _dog getVariable ["MWD_TrackPosIndex", 0]);	
	_isTrackNewer = _trackIndexHigher or _posIndexHigher;
	
	if (_isTracking && _isTrackingThisGroup && _isTrackNewer) exitWith {
		// Closer to the tracked group (i.e. crossed a trigger further ahead in the track)
		_dog setVariable ["MWD_TrackIndex", _trackIndex];
		_dog setVariable ["MWD_TrackPosIndex", _posIndex];
		// Tell moveTo function (spawn loop) that a new target has been set (see MWD_fnc_moveTo)
		_dog setVariable ["MWD_MoveToBreak", true];
		_track = _trackedGroup getVariable "MWD_Tracks" select _trackIndex;
		_triggerEndPos = _track select _posIndex;
		// Add automarker on handlers map
		[getPos _dog, _dog getDir _triggerEndPos] call MWD_fnc_autoMarker;
		// Add 3D marker for in-game positions
		(_dog getVariable ["MWD_Markers3D", []]) pushBack [getPos _dog, format ["%1 °", round (_dog getDir _triggerEndPos)]];
		
		if (MWD_Debug) then {
			systemChat "Newer track or position, advance to this position";
		};
	};
	
	// Exit if dog is tracking another group than this one
	if (_isTracking && !_isTrackingThisGroup) exitWith {
		if (MWD_Debug) then {
			systemChat "Tracking another group, ignore this trigger";
		};
	};
	
	// Exit if dog is backtracking i.e. crossing an older trigger
	if (_isTracking && _isTrackingThisGroup && !_isTrackNewer) exitWith {
		if (MWD_Debug) then {
			systemChat "Backtracking, ignore this trigger";
		};
	};
	
	// Exit if this is an old track that the dog has followed to the end earlier
	if ([_trackedGroup, _trackIndex] in (_dog getVariable ["MWD_CompletedTracks", []])) exitWith {
		if (MWD_Debug) then {
			systemChat "This is an old/completed track, ignore this trigger";
		};
	};
		
	// If we reached this point, the dog is not currently tracking, let's get it into tracking mode!
	
	// Set the dog into tracking mode for this group
	_dog setVariable ["MWD_Status", "TRACKING"];
	_dog setVariable ["MWD_TrackedGroup", _trackedGroup];		
	_dog setVariable ["MWD_TrackIndex", _trackIndex];
	_dog setVariable ["MWD_TrackPosIndex", _posIndex];
	_dog setVariable ["MWD_Markers3D", []];		
	
	// Add automarker on handlers map
	[getPos _dog, -1] call MWD_fnc_autoMarker;
	// Add 3D marker for in-game positions
	(_dog getVariable ["MWD_Markers3D", []]) pushBack [getPos _dog, "Spårupptag"];
		
	// Add mission eventhandler to draw in-game track positions
	evId = addMissionEventHandler ["Draw3D", {		
		_dog = call MWD_fnc_getDog;
		_trackIcon = getMissionPath "mwd\sfx\track.paa";		
		//_trackLostIcon = getMissionPath "mwd\sfx\track_lost.paa";
		
		_markers3D = _dog getVariable ["MWD_Markers3D", []];		
		{
			_markerPos = _x select 0;
			_makerText = _x select 1;
			drawIcon3D [_trackIcon, [1,1,1,1], _markerPos, 0.5, 0.5, 0, _makerText, 2];						
			
		} forEach _markers3D;						
	}];
	// Save handle so we can delete it later on
	_dog setVariable ["MWD_Draw3DEventHandlerId", evId];
};	