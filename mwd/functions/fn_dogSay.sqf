params ["_dog", "_sayWhat", ["_likelihood", 1]];

if (isNull _dog) exitWith {};
if ( random 1 > _likelihood ) exitWith {};

if (MWD_Debug) then {
	systemChat format ["MWD_fnc_dogSay '%1'", _sayWhat];
};

switch _sayWhat do {

	case "bark": {
		_sound = selectRandomWeighted ["bark_single", 0.1, "barks_double", 0.4, "barks", 0.5];
		_dog say _sound;
	};
	
	case "barking": {
	
		_sound = selectRandomWeighted ["barks_pants", 0.5, "barks_whiney", 0.5];
		_dog say _sound;		
	};
	
	case "whining": {
	
		_sound = selectRandomWeighted ["pants_barks_lite", 0.3, "pants_whines", 0.5, "whine_calling_out", 0.3, "whine_passing_by", 0.5, "whine_pleading_2", 0.2];
		_dog say _sound;
	};
	
	default {
		_dog say _sayWhat;
	};
};