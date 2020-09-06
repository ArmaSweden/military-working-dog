# mwd
Military Working Dog - Add tracking features with dog to the scenario

Usage:

1. Add the mwd folder to your mission directory.

2. Put this line in the "init.sqf" to initiate MWD features:
The file MWDInit.sqf contain settings. 
You will only need to change "MWD_Respawn" and "MWD_Debug".

[] execVM "mwd\MWDInit.sqf";

3. Add the following classes in the mission definition file (description.ext):

class CfgFunctions 
{ 
   #include "mwd\cfgFunctions.hpp"
};


class CfgSounds
{
	sounds[] = {};
	class bark_single
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "mwd_bark_single";
		// filename, volume, pitch, distance (optional)
		sound[] = { "mwd\sfx\bark_single.ogg",  1, 1};
		// subtitle delay in seconds, subtitle text
		titles[] = { 1, "" };
	};
	class barks
	{		
		name = "mwd_barks";
		sound[] = { "mwd\sfx\barks.ogg", 1, 1};
		titles[] = { 1, "" };
	};
	class barks_double
	{		
		name = "mwd_barks_double";
		sound[] = { "mwd\sfx\barks_double.ogg", 1, 1};
		titles[] = { 1, "" };
	};
	class barks_pants
	{		
		name = "mwd_barks_pants";
		sound[] = { "mwd\sfx\barks_pants.ogg", 1, 1};
		titles[] = { 1, "" };
	};
	class barks_whiney
	{		
		name = "mwd_barks_whiney";
		sound[] = { "mwd\sfx\barks_whiney.ogg", 1, 1};
		titles[] = { 1, "" };
	};
	class pants_barks_lite
	{
		name = "mwd_pants_barks_lite";
		sound[] = { "mwd\sfx\pants_barks_lite.ogg", 1, 1};
		titles[] = { 1, "" };
	};
	class pants_whines
	{
		name = "mwd_pants_whines";
		sound[] = { "mwd\sfx\pants_whines.ogg", 1, 1};
		titles[] = { 1, "" };
	};
	class whine_calling_out
	{
		name = "mwd_whine_calling_out";
		sound[] = { "mwd\sfx\whine_calling_out.ogg", 1, 1};
		titles[] = { 1, "" };
	};	
	class whine_passing_by
	{
		name = "mwd_whine_passing_by";
		sound[] = { "mwd\sfx\whine_passing_by.ogg", 1, 1};
		titles[] = { 1, "" };
	};
	class whine_pleading_2
	{
		name = "mwd_whine_pleading_2";
		sound[] = { "mwd\sfx\whine_pleading_2.ogg", 1, 1};
		titles[] = { 1, "" };
	};			
};

4. Put this command in the init section of any group that should leave tracks:

this setVariable ["MWD_Tracked", true]

5. Put this command in the init section of any unit to set dog handler role:

this setVariable ["MWD_Handler", true]
