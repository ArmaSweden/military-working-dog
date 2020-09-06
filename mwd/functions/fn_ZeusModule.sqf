
/*********************************************************************************
* Description: 
* Creates two modules for the MWD script if the Achilles mod is used. 
* Module 1: Make a player a doghandler.
* Module 2: Make a unit group tracked.
* The script should be run from init so that the functions exists on both server and client.
*
* Locality: 
* Global 
*
* Parameters: 
* 
*
* Author: Killet  
* Created: 2020-09-05
* Last Modified by: Killet 2020-09-05 
**********************************************************************************/ 

//Checks if achilles mod is running. if not dont create the functions or modules.
if (isClass (configFile >> "CfgPatches" >> "achilles_data_f_ares")) then
{
	["Military Working Dog", "Create Doghandler", {[_this select 1] call MWD_Achilles_SetHandler}] call Ares_fnc_RegisterCustomModule;
	["Military Working Dog", "Make group tracked", {[_this select 1] call MWD_Achilles_TrackedModule}] call Ares_fnc_RegisterCustomModule;

	//Checks if unit is player, then make the player a doghandler.
	MWD_Achilles_SetHandler = {

		params ["_unit"];
		if (isplayer _unit) then 
		{
			private _text = format ["%1 is now a doghandler",_unit];
			[_text] call Ares_fnc_ShowZeusMessage;
			[] remoteexec ["MWD_InitBy_Achilles",_unit];
		}
		else {["No Player was selected!"] call Achilles_fnc_showZeusErrorMessage;};
	};

	//Make the unit a doghandler.
	MWD_InitBy_Achilles = 
	{

		//This function is is purly copied from the MWD Init, a slight rework may be necessary when future updates is being made in the init. 
		player setVariable ["MWD_Handler", true];
		if (player getVariable ["MWD_Handler", false]) then {
				
			call MWD_fnc_addACEMenu;
				
			player addEventHandler ["Killed", {		
				removeAllMissionEventHandlers "Draw3D";
				if (!isNull player getVariable "MWD_Dog") then 
					{		
						deleteVehicle player getVariable "MWD_Dog";			
					};
			}];	
				
				player addEventHandler ["Respawn", {
					call MWD_fnc_addACEMenu;		
				}];	
		};
	};

	//Checks if a unit is a unit, then sets variable to make it "tracked". Also sets the variable according to the multiplayer enviroment, Local or dedicated. 
	MWD_Achilles_TrackedModule = 
	{
		params ["_unit"];

		if (!isnull _unit) then {
				
				private _text = format ["Group %1 is now tracked",_unit];
				[_text] call Ares_fnc_ShowZeusMessage;

				[_unit] remoteexec ["MWD_Achilles_MakeTracked",0];
		} else {["No object was selected!"] call Achilles_fnc_showZeusErrorMessage;
		
		
		};
	};

	//Runs only on server. sets variable.
	MWD_Achilles_MakeTracked = 
	{
		params ["_unit"];
		(group _unit) setVariable ["MWD_Tracked", true, true];
	};


};