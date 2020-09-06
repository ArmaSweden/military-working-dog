/** 
* Creates a marker on map to visualize the track trigger.
* Called from the server. Only called for curator clients e.g. Zeus.
*/
params ["_id", "_pos", "_dir", "_dist"];		
	
// If the player is a curator, always draw a marker
if (!isNull getAssignedCuratorLogic player) then {
	_marker = createMarkerLocal [_id, _pos];
	_marker setMarkerShapeLocal "RECTANGLE";
	_marker setMarkerColorLocal "ColorBlue";
	_marker setMarkerDirLocal _dir;
	_marker setMarkerSizeLocal [MWD_TrackWidth, _dist];
}