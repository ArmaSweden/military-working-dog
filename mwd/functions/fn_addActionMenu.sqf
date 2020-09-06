// Add actions to the players action menu
player addAction ["(Hufö) Hit", {"HEEL" call MWD_fnc_setDogAction}, [], 0, false];
player addAction ["(Hufö) Sök", {"" call MWD_fnc_setDogAction}, [], 0, false];
player addAction ["(Hufö) Stanna/sitt", {"STAY" call MWD_fnc_setDogAction}, [], 0, false];
player addAction ["(Hufö) Skall!", {[player getVariable ["MWD_Dog", objNull], "bark", 1] remoteExec ["MWD_fnc_dogSay"]}, [], 0, false];	
player addAction ["(Hufö) Vart är hunden?", {[] call MWD_fnc_whereIsTheDog}, [], 0, false];	
player addAction ["(Hufö) Gå och lägg dig (dismiss)", {"DISMISS" call MWD_fnc_setDogAction}, [], 0, false];