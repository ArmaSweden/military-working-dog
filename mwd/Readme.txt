Put this line in the "init.sqf" to initiate MWD features:

[] execVM "mwd\MWDInit.sqf";

Include function definitions file "cfgFunctions.hpp" in description.ext:

class CfgFunctions 
{ 
   #include "mwd\cfgFunctions.hpp"
};

Put this command in the init section of a group that should leave tracks:

this setVariable ["MWD_Tracked", true]

Put this command in the init section of a unit to set dog handler role:

this setVariable ["MWD_Handler", true]