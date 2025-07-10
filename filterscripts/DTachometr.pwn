#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 100

enum PlayerData
{
	bool:pHide
};

new Player[MAX_PLAYERS][PlayerData];

enum TextDraws
{
	PlayerText:TachDemage,
	PlayerText:TachSpeed
};

new PlayerText:TextDraw[MAX_PLAYERS][TextDraws];

forward Tachometr(playerid);

public Tachometr(playerid)
{
	if(IsPlayerConnected(playerid) && IsPlayerInAnyVehicle(playerid))
	{
		new str[144],car = GetPlayerVehicleID(playerid),Float:Health;
		format(str,sizeof(str),"~y~Rychlost: ~w~%d KM/H",getSpeed(playerid));
		PlayerTextDrawSetString(playerid,TextDraw[playerid][TachSpeed],str);
        GetVehicleHealth(car,Health);
		if(Health > 3000)
		{
			format(str,sizeof(str),"~y~Poskozeni: ~g~~h~NEZNICITELNE");
		}
        else if(Health > 300)
        {
            if(Health > 1000)
				format(str,sizeof(str),"~y~Poskozeni: ~g~PANCIR");
			else
				format(str,sizeof(str),"~y~Poskozeni: ~w~%0.1f %",(1000-Health)/10);

		}
		else if(Health < 300 && Health > 250)
		{
			format(str,sizeof(str),"~y~Poskozeni: ~r~~h~%0.1f %",(1000-Health)/10);
		}
		else
		{
			format(str,sizeof(str),"~y~Poskozeni: ~r~~h~BOOM!");
		}
		PlayerTextDrawSetString(playerid,TextDraw[playerid][TachDemage],str);
	}
}

public OnFilterScriptInit()
{
	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(IsPlayerConnected(i))
		{
		    CallLocalFunction("OnPlayerConnect","i",i);
		}
	}
	return 1;
}

public OnFilterScriptExit()
{
	for(new x; x < MAX_PLAYERS; x ++)
	{
		for(new i; TextDraws:i < TextDraws; i ++)
		{
			PlayerTextDrawDestroy(x,TextDraw[x][TextDraws:i]);
		}
	}
	return 1;
}


public OnPlayerConnect(playerid)
{
    Player[playerid][pHide] = false;
	TextDraw[playerid][TachDemage] = CreatePlayerTextDraw(playerid,513.000000, 407.000000, "~g~Loading..");
	PlayerTextDrawBackgroundColor(playerid,TextDraw[playerid][TachDemage], 255);
	PlayerTextDrawFont(playerid,TextDraw[playerid][TachDemage], 2);
	PlayerTextDrawLetterSize(playerid,TextDraw[playerid][TachDemage], 0.200000, 1.199998);
	PlayerTextDrawColor(playerid,TextDraw[playerid][TachDemage], 8978431);
	PlayerTextDrawSetOutline(playerid,TextDraw[playerid][TachDemage], 1);
	PlayerTextDrawSetProportional(playerid,TextDraw[playerid][TachDemage], 1);
	PlayerTextDrawSetSelectable(playerid,TextDraw[playerid][TachDemage], 0);

	TextDraw[playerid][TachSpeed] = CreatePlayerTextDraw(playerid,513.000000, 397.000000, "~g~Loading..");
	PlayerTextDrawBackgroundColor(playerid,TextDraw[playerid][TachSpeed], 255);
	PlayerTextDrawFont(playerid,TextDraw[playerid][TachSpeed], 2);
	PlayerTextDrawLetterSize(playerid,TextDraw[playerid][TachSpeed], 0.200000, 1.199998);
	PlayerTextDrawColor(playerid,TextDraw[playerid][TachSpeed], 8978431);
	PlayerTextDrawSetOutline(playerid,TextDraw[playerid][TachSpeed], 1);
	PlayerTextDrawSetProportional(playerid,TextDraw[playerid][TachSpeed], 1);
	PlayerTextDrawSetSelectable(playerid,TextDraw[playerid][TachSpeed], 0);
	return 1;
}

public OnPlayerStateChange(playerid,newstate,oldstate)
{
	if(Player[playerid][pHide] == false)
	{
		if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
		{
		    for(new i; TextDraws:i < TextDraws; i ++)
		    {
		    	PlayerTextDrawShow(playerid,TextDraw[playerid][TextDraws:i]);
			}
		}
		if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
		{
		    for(new i; TextDraws:i < TextDraws; i ++)
		    {
		    	PlayerTextDrawHide(playerid,TextDraw[playerid][TextDraws:i]);
			}
		}
	}
	return 1;
}

forward HideTach(playerid);

public HideTach(playerid)
{
    if(Player[playerid][pHide] == false)
    {
		for(new i; TextDraws:i < TextDraws; i ++)
		{
		    PlayerTextDrawHide(playerid,TextDraw[playerid][TextDraws:i]);
		    Player[playerid][pHide] = true;
		}
    }
	else
	{
		for(new i; TextDraws:i < TextDraws; i ++)
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
		    	PlayerTextDrawShow(playerid,TextDraw[playerid][TextDraws:i]);
			}
			Player[playerid][pHide] = false;
		}
	}
	return 1;
}

stock getSpeed(playerid)
{
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	return floatround(VectorSize(vx, vy, vz) * 180);
}

