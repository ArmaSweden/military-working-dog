/**
* Find and delete the given trigger.
*/
params ["triggerId"];
	
_allTriggers = allMissionObjects "EmptyDetector";
{
	if (_x getVariable ["triggerId"] == triggerId) exitWith {		
		deleteVehicle _x;
		// Remove MWD_Debug marker
		if (MWD_Debug) then {				
			deleteMarkerLocal triggerId;
		};			
	};						
} forEach _allTriggers;