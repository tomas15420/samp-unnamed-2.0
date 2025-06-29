#define DAILY_TYPE_RACE 			0
#define DAILY_TYPE_KILLS    		1
#define DAILY_TYPE_MISSION_KURYR    2
#define DAILY_TYPE_ROB              3
#define DAILY_TYPE_EVENT            4
#define DAILY_TYPE_STUNTS           5
#define DAILY_TYPE_DM_KILLS         6
#define DAILY_TYPE_MISSION_PILOT    7
#define DAILY_TYPE_GANJA            8
#define DAILY_TYPE_MISSION_MEDIC    9 
#define DAILY_TYPE_SUMO             10
#define DAILY_TYPE_MISSION_TRUCKER  11
#define DAILY_TYPE_DUEL             12
#define DAILY_TYPE_TIME             13 
#define DAILY_TYPE_MISSION_POLICE   14 
#define DAILY_TYPE_CARS_SELL        15
#define DAILY_TYPE_MISSION_HASIC    16
#define DAILY_TYPE_MISSION_BUS      17
#define DAILY_TYPE_RACE_WIN         18
#define DAILY_TYPE_MISSION_DREVORUBEC   19
#define DAILY_TYPE_GANG_TAKE        20 
#define DAILY_TYPE_GANG_KILLS       21 
#define DAILY_TYPE_YAKUZA_TAKE      22 
#define DAILY_TYPE_MISSION_MECHANIC 23
#define DAILY_TYPE_KOSTKA           24
#define DAILY_TYPE_SMOKE            25 
#define DAILY_TYPE_MAFIA_TAKE		26

#define MAX_DAILY_TYPE              26+1

stock GivePlayerDailyValueEx(playerid,type,value = 1)
{
	return CallRemoteFunction("GivePlayerDailyValue", "iii", playerid,type,value);
}