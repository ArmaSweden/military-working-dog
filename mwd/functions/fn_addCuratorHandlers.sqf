/////////////////////////////////////////////////////////////////////////////
// Setup curator handlers and other stuff
/////////////////////////////////////////////////////////////////////////////
{
	/*
	_x addEventHandler ["CuratorWaypointPlaced", {
		params ["_curator", "_group", "_waypointID"];		
		systemChat format ["Waypoint created: %1", _waypointID];
								
	}];
	
	_x addEventHandler ["CuratorWaypointEdited", {
		params ["_curator", "_group", "_waypointID"];
		systemChat format ["Waypoint edited: %1", _waypointID];			
				
	}];

	_x addEventHandler ["CuratorWaypointDeleted", {
		params ["_curator", "_group", "_waypointID"];
		systemChat format ["Waypoint deleted: %1", _waypointID];			
						
	}];		
	
	_x addEventHandler ["CuratorObjectDeleted", {
		params ["_curator", "_entity"];				
				
		// undo the delete of this group
		systemChat format ["Deleted: %1", _entity];				
	}];
	
	_x addEventHandler ["CuratorGroupSelectionChanged", {
		params ["_curator", "_group"];
		systemChat format ["Group: %1", _group];
	}];

	_x addEventHandler ["CuratorWaypointSelectionChanged", {
		params ["_curator", "_waypoint"];
		systemChat format ["Waypoint: %1", _waypoint];
	}];

	_x addEventHandler ["CuratorObjectSelectionChanged", {
		params ["_curator", "_entity"];		
		systemChat format ["Entity: %1", _entity];
	}];

	*/
} foreach allCurators;