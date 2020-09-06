
params ["_pos", "_dir"];

if (MWD_Automark) then {
	// Add dots/arrows in the map automagically
	_marker = createMarkerLocal [format ["automark-%1-%2", _pos, _dir], _pos];
	_marker setMarkerTypeLocal "hd_dot";
	//_marker setMarkerTypeLocal "hd_arrow";
	_marker setMarkerColorLocal "ColorBlack";
	_marker setMarkerSizeLocal [0.5, 0.5];
	_marker setMarkerAlphaLocal 0.3;
	_marker setMarkerDirLocal (_dir);	
};