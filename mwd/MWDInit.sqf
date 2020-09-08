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
		// Dismiss the dog if it's spawned 				
		_dog = player getVariable ["MWD_Dog", objNull];
		if (!isNull _dog) then {					
			// TODO: make the dog whine over the handlers dead body? :)
			// dismiss the dog
			"DISMISS" call MWD_fnc_setDogAction;			
		};	
		// Reset dog respawn timer
		player setVariable ["MWD_RespawnTimer", 0];
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