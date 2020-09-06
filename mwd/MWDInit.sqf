/**
* Adds military working dog (MWD) and related features to the game.
* An MWD handler role can spawn a dog that is able to follow tracks laid by tracked groups.
* The dog can also be used to patrol an area to mark smell- and hearing observations.
*
* See Readme.txt for setup and usage of this script.
*
* @author Beck [ASE] - (Discord: Beck#1679)
* @co-author Killet [SPG] - (Discord: Killet#5653) - Specific features, testing, gfx, code review and bug finding/fixing
* @credit [Anrop] Dahlgren - (Dahlgren#1337) - Arma 3 scripting guru
* @credit Poolpunk - ACE menu icon (the dog)
*
* TODO: Mark other tracks on map to let handler know when dog is a crossing a track that is currently not being followed
* TODO: Mark start- and end of tracks with different colors on the map
* TODO: fn_moveTo: the dogs make a 360 for every new path caclulated?
* TODO: Animation locks happens when the dog tries to sprint downhill, can we check if its downhill/uphill and not use sprint in elevated terrain? 
* TODO: If group leader gets killed, start a new track (or group) with the new leader (the two may be very far apart)
* TODO: How to handle nearby units that are not part of the handlers group?
* TODO: What if the enemy detects the dog? what should happen?
* TODO: Connect rope between handler and dog? https://community.bistudio.com/wiki/ropeCreate
* TODO: When in HEEL, let the dog adjust speed to handlers speed
*
* https://community.bistudio.com/wiki/Arma_3_Animals:_Override_Default_Animal_Behaviour_Via_Script
*/

//
// MWD Global Settings
// 
MWD_Debug = true;				// print MWD_Debug info or not
MWD_Automark = true;      		// automagically mark track detection arrows on handlers local map
MWD_TrackCheckInterval = 3;	    // server position check interval for tracked groups
MWD_TriggerDistance = 50;    	// rough distance between trigger positions i.e. distance between two saved group positions
MWD_TrackWidth = 3;	      	    // track width in meters
MWD_Respawn = 300;              // time until the dog allowed to respawn again (if it has been killed), set on player object

if (player getVariable ["MWD_Handler", false]) then {
	
	// Add ACE menus
	call MWD_fnc_addACEMenu;
	
	player addEventHandler ["Killed", {		
		// Remove old event handlers
		removeAllMissionEventHandlers "Draw3D";
		// Dismiss the dog if it's spawned 		
		// TODO: make the dog whine over the handlers dead body? :)
		_dog = player getVariable ["MWD_Dog", objNull];
		if (!isNull _dog) then {		
			deleteVehicle _dog;			
		};
	}];	
	
	player addEventHandler ["Respawn", {
		// Re-add ACE menus		
		call MWD_fnc_addACEMenu;
	}];	
	
	player addEventHandler ["GetInMan", {
		// Dismiss the dog if the handler moves into a vehicle
		_dog = player getVariable ["MWD_Dog", objNull];
		if (!isNull _dog) then {		
			deleteVehicle _dog;			
		};
	}];
};

// Add Achilles modules for Zeus
call MWD_fnc_ZeusModule;

// Call on server only, server is in charge of handling tracking triggers etc.
if (isServer) then {
	call MWD_fnc_trackGroups;
};

/*
History/completed todo's (from 3/8-20):

TODO: Use custom fnc_dogPlayMove to make sure we are not resetting animations all the time
TODO: Remove ACE menu when in vehicle, and dismiss the dog when getting into vehicle
TODO: Save tracks that has been followed to the end, the dog should not be interested in old tracks when crossing a trigger again
TODO: Create 3D icons in-game for track points? https://community.bistudio.com/wiki/drawIcon3D
TODO: If tracked group is in a vehicle or otherwise un-tracable
TODO: Use ACE commnand interface instead?

*/