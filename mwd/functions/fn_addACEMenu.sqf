
_showMainMenu = {
	player getVariable ["MWD_Handler", false] && isNull objectParent player
};

_showSubMenu = {
	_isDogSpawned = !(player getVariable ["MWD_Dog", objNull] isEqualTo objNull);
	_notInVehicle = isNull objectParent player;	
	_isDogSpawned && _notInVehicle
};

_action = ["mwd_menu", "Tjänstehund", "mwd\sfx\icon_dog.pac", {call MWD_fnc_getDog}, _showMainMenu] call ace_interact_menu_fnc_createAction;	
[(typeOf player), 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToClass;

_seekAction = ["mwd_seek", "Sök", "", {"" call MWD_fnc_setDogAction}, _showSubMenu] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "mwd_menu"], _seekAction] call ace_interact_menu_fnc_addActionToClass;

_heelAction = ["mwd_heel", "Fot", "", {"HEEL" call MWD_fnc_setDogAction}, _showSubMenu] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "mwd_menu"], _heelAction] call ace_interact_menu_fnc_addActionToClass;

_stayAction = ["mwd_stay", "Stanna", "", {"STAY" call MWD_fnc_setDogAction}, _showSubMenu] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "mwd_menu"], _stayAction] call ace_interact_menu_fnc_addActionToClass;

_barkAction = ["mwd_bark", "Skall!", "", {[player getVariable ["MWD_Dog", objNull], "bark", 1] remoteExec ["MWD_fnc_dogSay"]}, _showSubMenu] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "mwd_menu"], _barkAction] call ace_interact_menu_fnc_addActionToClass;

_dismissAction = ["mwd_dismiss", "Gå och lägg dig (dismiss)", "", {"DISMISS" call MWD_fnc_setDogAction}, _showSubMenu] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "mwd_menu"], _dismissAction] call ace_interact_menu_fnc_addActionToClass;
