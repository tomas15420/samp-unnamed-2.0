#undef MAX_PLAYERS
#define MAX_PLAYERS 100
new PlayerText:InfoNadpis[MAX_PLAYERS];
new PlayerText:InfoText[MAX_PLAYERS];
new PlayerText:InfoType2[MAX_PLAYERS];
new PlayerText:InfoType2Nadpis[MAX_PLAYERS];

new bool: ShowedTD[MAX_PLAYERS];

new Timer[2][MAX_PLAYERS];
new Diakritika[][2] =
{
	{'¯','r'},
	{'Ë','c'},
	{'Ï','e'},
	{'ö','s'},
	{'û','z'},
	{'é','Z'},
	{'˝','y'},
	{'·','a'},
	{'Ì','i'},
	{'È','e'},
	{'ù','t'},
	{'Ô','d'},
	{'˘','u'},
	{'˙','u'},
	{'Û','o'},
	{'Ú','n'},
	{'⁄','U'}
};



forward Hide(playerid);
forward Hide2(playerid);

stock CreateInfoTextDraw()
{

	for(new i; i < MAX_PLAYERS; i++)
	{
/*		InfoNadpis[i] = TextDrawCreate(14.000000, 225.000000, "");
		TextDrawBackgroundColor(InfoNadpis[i], 255);
		TextDrawFont(InfoNadpis[i], 0);
		TextDrawLetterSize(InfoNadpis[i], 0.310000, 1.400000);
		TextDrawColor(InfoNadpis[i], 65535);
		TextDrawSetOutline(InfoNadpis[i], 1);
		TextDrawSetProportional(InfoNadpis[i], 1);
		TextDrawUseBox(InfoNadpis[i], 1);
		TextDrawBoxColor(InfoNadpis[i], 200);
		TextDrawTextSize(InfoNadpis[i], 158.000000, 0.000000);
		TextDrawSetSelectable(InfoNadpis[i], 0);

		InfoText[i] = TextDrawCreate(14.000000, 241.000000, "");
		TextDrawBackgroundColor(InfoText[i], 200);
		TextDrawFont(InfoText[i], 1);
		TextDrawLetterSize(InfoText[i], 0.290000, 1.300000);
		TextDrawColor(InfoText[i], -1);
		TextDrawSetOutline(InfoText[i], 1);
		TextDrawSetProportional(InfoText[i], 1);
		TextDrawUseBox(InfoText[i], 1);
		TextDrawBoxColor(InfoText[i], 100);
		TextDrawTextSize(InfoText[i], 158.000000, 0.000000);
		TextDrawSetSelectable(InfoText[i], 0);
*/
		if(IsPlayerConnected(i))
		{
		    if(!IsPlayerNPC(i))
		    {
/*
				InfoNadpis[i] = TextDrawCreate(86.000000, 228.000000, "UnNamed");
				TextDrawAlignment(InfoNadpis[i], 2);
				TextDrawBackgroundColor(InfoNadpis[i], -1);
				TextDrawFont(InfoNadpis[i], 0);
				TextDrawLetterSize(InfoNadpis[i], 0.479997, 0.999997);
				TextDrawColor(InfoNadpis[i], 65535);
				TextDrawSetOutline(InfoNadpis[i], 1);
				TextDrawSetProportional(InfoNadpis[i], 1);
				TextDrawUseBox(InfoNadpis[i], 1);
				TextDrawBoxColor(InfoNadpis[i], 180);
				TextDrawTextSize(InfoNadpis[i], 158.000000, 144.000000);
				TextDrawSetSelectable(InfoNadpis[i], 0);

				InfoText[i] = TextDrawCreate(86.000000, 242.000000, "_");
				TextDrawAlignment(InfoText[i], 2);
				TextDrawBackgroundColor(InfoText[i], 255);
				TextDrawFont(InfoText[i], 1);
				TextDrawLetterSize(InfoText[i], 0.259999, 1.099997);
				TextDrawColor(InfoText[i], -1);
				TextDrawSetOutline(InfoText[i], 0);
				TextDrawSetProportional(InfoText[i], 1);
				TextDrawSetShadow(InfoText[i], 1);
				TextDrawUseBox(InfoText[i], 1);
				TextDrawBoxColor(InfoText[i], 70);
				TextDrawTextSize(InfoText[i], 158.000000, 144.000000);
				TextDrawSetSelectable(InfoText[i], 0);
*/

				InfoNadpis[i] = CreatePlayerTextDraw(i,87.000000, 182.000000, "_");
				PlayerTextDrawAlignment(i,InfoNadpis[i], 2);
				PlayerTextDrawBackgroundColor(i,InfoNadpis[i], 255);
				PlayerTextDrawFont(i,InfoNadpis[i], 2);
				PlayerTextDrawLetterSize(i,InfoNadpis[i], 0.259999, 1.299998);
				PlayerTextDrawColor(i,InfoNadpis[i], 7864319);
				PlayerTextDrawSetOutline(i,InfoNadpis[i], 1);
				PlayerTextDrawSetProportional(i,InfoNadpis[i], 1);
				PlayerTextDrawUseBox(i,InfoNadpis[i], 1);
				PlayerTextDrawBoxColor(i,InfoNadpis[i], 210);
				PlayerTextDrawTextSize(i,InfoNadpis[i], -1.000000, 134.000000);
				PlayerTextDrawSetSelectable(i,InfoNadpis[i], 0);

				InfoText[i] = CreatePlayerTextDraw(i,87.000000, 197.000000, "Uspesne zaregistrovan!");
				PlayerTextDrawAlignment(i,InfoText[i], 2);
				PlayerTextDrawBackgroundColor(i,InfoText[i], 255);
				PlayerTextDrawFont(i,InfoText[i], 2);
				PlayerTextDrawLetterSize(i,InfoText[i], 0.180000, 1.099998);
				PlayerTextDrawColor(i,InfoText[i], -1);
				PlayerTextDrawSetOutline(i,InfoText[i], 1);
				PlayerTextDrawSetProportional(i,InfoText[i], 1);
				PlayerTextDrawUseBox(i,InfoText[i], 1);
				PlayerTextDrawBoxColor(i,InfoText[i], 70);
				PlayerTextDrawTextSize(i,InfoText[i], -1.000000, 134.000000);
				PlayerTextDrawSetSelectable(i,InfoText[i], 0);

				InfoType2Nadpis[i] = CreatePlayerTextDraw(i,327.000000, 199.000000, "Mission Info");
				PlayerTextDrawAlignment(i,InfoType2Nadpis[i], 2);
				PlayerTextDrawBackgroundColor(i,InfoType2Nadpis[i], 255);
				PlayerTextDrawFont(i,InfoType2Nadpis[i], 3);
				PlayerTextDrawLetterSize(i,InfoType2Nadpis[i], 0.469999, 1.700000);
				PlayerTextDrawColor(i,InfoType2Nadpis[i], -490707969);
				PlayerTextDrawSetOutline(i,InfoType2Nadpis[i], 1);
				PlayerTextDrawSetProportional(i,InfoType2Nadpis[i], 1);
				PlayerTextDrawUseBox(i,InfoType2Nadpis[i], 1);
				PlayerTextDrawBoxColor(i,InfoType2Nadpis[i], 100);
				PlayerTextDrawTextSize(i,InfoType2Nadpis[i], 20.000000, 250.000000);
				PlayerTextDrawSetSelectable(i,InfoType2Nadpis[i], 0);

				InfoType2[i] = CreatePlayerTextDraw(i,327.000000, 218.000000, "Pro plneni mise ~r~Kuryr ~w~nastup do vozidla ~g~Sultan, Bullet ~w~nebo ~g~Cheetah ~w~a stiskni ~r~+ ~w~nebo ~r~2");
				PlayerTextDrawAlignment(i,InfoType2[i], 2);
				PlayerTextDrawBackgroundColor(i,InfoType2[i], 255);
				PlayerTextDrawFont(i,InfoType2[i], 2);
				PlayerTextDrawLetterSize(i,InfoType2[i], 0.270000, 1.200000);
				PlayerTextDrawColor(i,InfoType2[i], -1);
				PlayerTextDrawSetOutline(i,InfoType2[i], 1);
				PlayerTextDrawSetProportional(i,InfoType2[i], 1);
				PlayerTextDrawUseBox(i,InfoType2[i], 1);
				PlayerTextDrawBoxColor(i,InfoType2[i], 50);
				PlayerTextDrawTextSize(i,InfoType2[i], 20.000000, 250.000000);
				PlayerTextDrawSetSelectable(i,InfoType2[i], 0);
/*
				InfoType2[i] = TextDrawCreate(320.000000, 226.000000, "_");
				TextDrawAlignment(InfoType2[i], 2);
				TextDrawBackgroundColor(InfoType2[i], 255);
				TextDrawFont(InfoType2[i], 2);
				TextDrawLetterSize(InfoType2[i], 0.270000, 1.499999);
				TextDrawColor(InfoType2[i], -1);
				TextDrawSetOutline(InfoType2[i], 1);
				TextDrawSetProportional(InfoType2[i], 1);
				TextDrawUseBox(InfoType2[i], 1);
				TextDrawBoxColor(InfoType2[i], 80);
				TextDrawTextSize(InfoType2[i], 10.000000, 283.000000);
				TextDrawSetSelectable(InfoType2[i], 0);

				InfoType2Nadpis[i] = TextDrawCreate(320.000000, 208.000000, "_");
				TextDrawAlignment(InfoType2Nadpis[i], 2);
				TextDrawBackgroundColor(InfoType2Nadpis[i], 255);
				TextDrawFont(InfoType2Nadpis[i], 2);
				TextDrawLetterSize(InfoType2Nadpis[i], 0.349999, 1.599999);
				TextDrawColor(InfoType2Nadpis[i], 5636095);
				TextDrawSetOutline(InfoType2Nadpis[i], 1);
				TextDrawSetProportional(InfoType2Nadpis[i], 1);
				TextDrawUseBox(InfoType2Nadpis[i], 1);
				TextDrawBoxColor(InfoType2Nadpis[i], 135);
				TextDrawTextSize(InfoType2Nadpis[i], 10.000000, 283.000000);
				TextDrawSetSelectable(InfoType2Nadpis[i], 0);
*/
			}
		}
	}
	return 1;
}

stock InfoBoxConnect(playerid)
{
	if(!IsPlayerNPC(playerid))
	{
	    new i = playerid;
		
/*		InfoNadpis[i] = TextDrawCreate(86.000000, 228.000000, "UnNamed");
		TextDrawAlignment(InfoNadpis[i], 2);
		TextDrawBackgroundColor(InfoNadpis[i], -1);
		TextDrawFont(InfoNadpis[i], 0);
		TextDrawLetterSize(InfoNadpis[i], 0.479997, 0.999997);
		TextDrawColor(InfoNadpis[i], 65535);
		TextDrawSetOutline(InfoNadpis[i], 1);
		TextDrawSetProportional(InfoNadpis[i], 1);
		TextDrawUseBox(InfoNadpis[i], 1);
		TextDrawBoxColor(InfoNadpis[i], 180);
		TextDrawTextSize(InfoNadpis[i], 158.000000, 144.000000);
		TextDrawSetSelectable(InfoNadpis[i], 0);

		InfoText[i] = TextDrawCreate(86.000000, 242.000000, "_");
		TextDrawAlignment(InfoText[i], 2);
		TextDrawBackgroundColor(InfoText[i], 255);
		TextDrawFont(InfoText[i], 1);
		TextDrawLetterSize(InfoText[i], 0.259999, 1.099997);
		TextDrawColor(InfoText[i], -1);
		TextDrawSetOutline(InfoText[i], 0);
		TextDrawSetProportional(InfoText[i], 1);
		TextDrawSetShadow(InfoText[i], 1);
		TextDrawUseBox(InfoText[i], 1);
		TextDrawBoxColor(InfoText[i], 70);
		TextDrawTextSize(InfoText[i], 158.000000, 144.000000);
		TextDrawSetSelectable(InfoText[i], 0);
*/
		InfoNadpis[playerid] = CreatePlayerTextDraw(playerid,87.000000, 182.000000, "Registrace");
		PlayerTextDrawAlignment(playerid,InfoNadpis[playerid], 2);
		PlayerTextDrawBackgroundColor(playerid,InfoNadpis[playerid], 255);
		PlayerTextDrawFont(playerid,InfoNadpis[playerid], 2);
		PlayerTextDrawLetterSize(playerid,InfoNadpis[playerid], 0.259999, 1.299998);
		PlayerTextDrawColor(playerid,InfoNadpis[playerid], 7864319);
		PlayerTextDrawSetOutline(playerid,InfoNadpis[playerid], 1);
		PlayerTextDrawSetProportional(playerid,InfoNadpis[playerid], 1);
		PlayerTextDrawUseBox(playerid,InfoNadpis[playerid], 1);
		PlayerTextDrawBoxColor(playerid,InfoNadpis[playerid], 210);
		PlayerTextDrawTextSize(playerid,InfoNadpis[playerid], -1.000000, 134.000000);
		PlayerTextDrawSetSelectable(playerid,InfoNadpis[playerid], 0);

		InfoText[playerid] = CreatePlayerTextDraw(playerid,87.000000, 197.000000, "Uspesne zaregistrovan!");
		PlayerTextDrawAlignment(playerid,InfoText[playerid], 2);
		PlayerTextDrawBackgroundColor(playerid,InfoText[playerid], 255);
		PlayerTextDrawFont(playerid,InfoText[playerid], 2);
		PlayerTextDrawLetterSize(playerid,InfoText[playerid], 0.180000, 1.099998);
		PlayerTextDrawColor(playerid,InfoText[playerid], -1);
		PlayerTextDrawSetOutline(playerid,InfoText[playerid], 1);
		PlayerTextDrawSetProportional(playerid,InfoText[playerid], 1);
		PlayerTextDrawUseBox(playerid,InfoText[playerid], 1);
		PlayerTextDrawBoxColor(playerid,InfoText[playerid], 70);
		PlayerTextDrawTextSize(playerid,InfoText[playerid], -1.000000, 134.000000);
		PlayerTextDrawSetSelectable(playerid,InfoText[playerid], 0);

		InfoType2Nadpis[i] = CreatePlayerTextDraw(i,327.000000, 199.000000, "Mission Info");
		PlayerTextDrawAlignment(i,InfoType2Nadpis[i], 2);
		PlayerTextDrawBackgroundColor(i,InfoType2Nadpis[i], 255);
		PlayerTextDrawFont(i,InfoType2Nadpis[i], 3);
		PlayerTextDrawLetterSize(i,InfoType2Nadpis[i], 0.469999, 1.700000);
		PlayerTextDrawColor(i,InfoType2Nadpis[i], -490707969);
		PlayerTextDrawSetOutline(i,InfoType2Nadpis[i], 1);
		PlayerTextDrawSetProportional(i,InfoType2Nadpis[i], 1);
		PlayerTextDrawUseBox(i,InfoType2Nadpis[i], 1);
		PlayerTextDrawBoxColor(i,InfoType2Nadpis[i], 100);
		PlayerTextDrawTextSize(i,InfoType2Nadpis[i], 20.000000, 250.000000);
		PlayerTextDrawSetSelectable(i,InfoType2Nadpis[i], 0);

		InfoType2[i] = CreatePlayerTextDraw(i,327.000000, 218.000000, "Pro plneni mise ~r~Kuryr ~w~nastup do vozidla ~g~Sultan, Bullet ~w~nebo ~g~Cheetah ~w~a stiskni ~r~+ ~w~nebo ~r~2");
		PlayerTextDrawAlignment(i,InfoType2[i], 2);
		PlayerTextDrawBackgroundColor(i,InfoType2[i], 255);
		PlayerTextDrawFont(i,InfoType2[i], 2);
		PlayerTextDrawLetterSize(i,InfoType2[i], 0.270000, 1.200000);
		PlayerTextDrawColor(i,InfoType2[i], -1);
		PlayerTextDrawSetOutline(i,InfoType2[i], 1);
		PlayerTextDrawSetProportional(i,InfoType2[i], 1);
		PlayerTextDrawUseBox(i,InfoType2[i], 1);
		PlayerTextDrawBoxColor(i,InfoType2[i], 50);
		PlayerTextDrawTextSize(i,InfoType2[i], 20.000000, 250.000000);
		PlayerTextDrawSetSelectable(i,InfoType2[i], 0);

/*		InfoType2[i] = TextDrawCreate(320.000000, 226.000000, "_");
		TextDrawAlignment(InfoType2[i], 2);
		TextDrawBackgroundColor(InfoType2[i], 255);
		TextDrawFont(InfoType2[i], 2);
		TextDrawLetterSize(InfoType2[i], 0.270000, 1.499999);
		TextDrawColor(InfoType2[i], -1);
		TextDrawSetOutline(InfoType2[i], 1);
		TextDrawSetProportional(InfoType2[i], 1);
		TextDrawUseBox(InfoType2[i], 1);
		TextDrawBoxColor(InfoType2[i], 80);
		TextDrawTextSize(InfoType2[i], 10.000000, 283.000000);
		TextDrawSetSelectable(InfoType2[i], 0);

		InfoType2Nadpis[i] = TextDrawCreate(320.000000, 208.000000, "_");
		TextDrawAlignment(InfoType2Nadpis[i], 2);
		TextDrawBackgroundColor(InfoType2Nadpis[i], 255);
		TextDrawFont(InfoType2Nadpis[i], 2);
		TextDrawLetterSize(InfoType2Nadpis[i], 0.349999, 1.599999);
		TextDrawColor(InfoType2Nadpis[i], 5636095);
		TextDrawSetOutline(InfoType2Nadpis[i], 1);
		TextDrawSetProportional(InfoType2Nadpis[i], 1);
		TextDrawUseBox(InfoType2Nadpis[i], 1);
		TextDrawBoxColor(InfoType2Nadpis[i], 135);
		TextDrawTextSize(InfoType2Nadpis[i], 10.000000, 283.000000);
		TextDrawSetSelectable(InfoType2Nadpis[i], 0);
*/
	}
	return 1;
}

stock InfoBoxDisconnect(playerid)
{
	PlayerTextDrawDestroy(playerid,InfoText[playerid]);
	PlayerTextDrawDestroy(playerid,InfoType2[playerid]);
	PlayerTextDrawDestroy(playerid,InfoType2Nadpis[playerid]);
	PlayerTextDrawDestroy(playerid,InfoNadpis[playerid]);
	ShowedTD[playerid] = false;
	return 1;
}

public Hide(playerid)
{
	PlayerTextDrawHide(playerid,InfoNadpis[playerid]);
	PlayerTextDrawHide(playerid,InfoText[playerid]);
	ShowedTD[playerid] = false;
	return 1;
}

public Hide2(playerid)
{
	PlayerTextDrawHide(playerid,InfoType2[playerid]);
	PlayerTextDrawHide(playerid,InfoType2Nadpis[playerid]);
	return 1;
}

forward CreateInfoBox(playerid,text[],time);
public CreateInfoBox(playerid,text[],time)
{
	if(ShowedTD[playerid] == false)
	{
		PlayerPlaySound(playerid,1057,0.0, 0.0, 0.0);
	}
	KillTimer(Timer[0][playerid]);
	PlayerTextDrawHide(playerid,InfoNadpis[playerid]);
	PlayerTextDrawHide(playerid,InfoText[playerid]);
	PlayerTextDrawSetString(playerid,InfoNadpis[playerid],"UnNamed");
	TextDrawDiakritika(text);
	FixTextDrawFont2(text);
	new string[256];
	format(string,sizeof(string),"~w~%s",text);
	PlayerTextDrawSetString(playerid,InfoText[playerid],string);
	PlayerTextDrawShow(playerid,InfoNadpis[playerid]);
	PlayerTextDrawShow(playerid,InfoText[playerid]);
	Timer[0][playerid] = SetTimerEx("Hide",time*1000,false,"i",playerid);
	ShowedTD[playerid] = true;
	return 1;
}

stock TextDrawDiakritika(text[])
{
	for(new i; i < strlen(text); i ++)
	{
	    for(new x; x < sizeof(Diakritika); x++)
	    {
	    	if(text[i] == Diakritika[x][0]) text[i] = Diakritika[x][1];
		}
	}
	return 1;
}

stock FixTextDrawFont2(text[])
{
	for(new i; i < strlen(text); i ++)
	{
	    if(text[i] == '[') text[i] = '(';
	    if(text[i] == ']') text[i] = ')';
	    if(text[i] == '*') text[i] = ']';
	}
}

stock CreateCompleteMessage(playerid,nadpis[],text[],time,bool:sound = true)
{
	if(sound == true)
	{
		PlayerPlaySound(playerid,1057,0.0, 0.0, 0.0);
	}	
	KillTimer(Timer[1][playerid]);
	PlayerTextDrawHide(playerid,InfoType2[playerid]);
	PlayerTextDrawHide(playerid,InfoType2Nadpis[playerid]);
	PlayerTextDrawSetString(playerid,InfoType2Nadpis[playerid],nadpis);
	for(new i; i < strlen(text); i ++)
	{
	    for(new x; x < sizeof(Diakritika); x++)
	    {
	    	if(text[i] == Diakritika[x][0]) text[i] = Diakritika[x][1];
		}
	}
	PlayerTextDrawSetString(playerid,InfoType2[playerid],text);
	PlayerTextDrawShow(playerid,InfoType2Nadpis[playerid]);
	PlayerTextDrawShow(playerid,InfoType2[playerid]);
	Timer[1][playerid] = SetTimerEx("Hide2",time*1000,false,"i",playerid);
	return 1;
}

