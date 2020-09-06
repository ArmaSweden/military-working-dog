
_dog = call MWD_fnc_getDog;
_dir = player getDir _dog;
_dist = player distance _dog;
player groupChat format ["Riktning: %1 Avstånd: %2", round _dir, round _dist];