// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_AirWreck.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf"

private ["_nbUnits", "_wreckPos", "_wreck", "_box", "_randomBox", "_randomCase"];

_setupVars =
{
	_missionType = "Aircraft Wreck";
	_locationsArray = MissionSpawnMarkers;
	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;
	_wreckPos = _missionPos vectorAdd ([[25 + random 20, 0, 0], random 360] call BIS_fnc_rotateVector2D);

	// Class, Position, Fuel, Ammo, Damage, Special
	_wreck = ["O_Heli_Light_02_unarmed_F", _wreckPos, 0, 0, 1] call createMissionVehicle;

	_randomBox = selectRandom ["mission_USLaunchers","mission_Main_A3snipers","mission_Uniform","mission_DLCLMGs","mission_ApexRifles","mission_USSpecial","mission_HVSniper","mission_DLCRifles","mission_HVLaunchers"];
	_randomCase = selectRandom ["Box_NATO_WpsSpecial_F","Box_East_WpsSpecial_F","Box_NATO_Wps_F","Box_East_Wps_F"];
	_box = createVehicle [_randomCase, _missionPos, [], 5, "None"];
	_box setDir random 360;
	[_box, _randomBox] call fn_refillbox;

	{ _x setVariable ["R3F_LOG_disabled", true, true] } forEach [_box];

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits] call createCustomGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> typeOf _wreck >> "picture");
	_missionHintText = "A helicopter has come down under enemy fire! Secure the crash site.";
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_box, _wreck];
};

_successExec =
{
	// Mission completed
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box];
	deleteVehicle _wreck;

	_successHintMessage = "The crash site has been secured. Well done.";
};

_this call sideMissionProcessor;
