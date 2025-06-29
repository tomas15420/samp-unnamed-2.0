#include <dudb>
#pragma unused ret_memcpy
#include <BCL>
#include <InfoBox>
#include <timestamp_dg>
#undef MAX_PLAYERS
#define MAX_PLAYERS 100
#define SCM SendClientMessage
#define SCMTA SendClientMessageToAll
//#define SPD ShowPlayerDialogEx
#define IPA IsPlayerAdmin
#define IPC IsPlayerConnected
#define CONFIG "UnNamed/UNConfig.cfg"

#undef MAX_PLAYERS
#define MAX_PLAYERS 100

#define RCMD_PREFIX "/"
#define rcmd(%1,%2,%3) if((strcmp((%3), RCMD_PREFIX #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (rcmd_%1(""))) || (((%3)[(%2) + 1] == 32) && (rcmd_%1((%3)[(%2) + 2]))))) return 1
#define ForPlayers(%0) for(new %0; %0 <= MAX_PLAYERS;%0++) if(IsPlayerConnected(%0))

//#define SPD(%1,%2,%3,%4,%5,%6,%7) ShowPlayerDialog(%1,%2,%3,""g"#%4",""w"#%5","#%6","#%7")
//#define SM(%1,%2) SendClientMessage(%1,red,"[ ! ] "w"#%2"w".")

#define SPD ShowPlayerDialogEx
#define SM SendMessage

#define red 0xFF0000FF
#define bila 0xFFFFFFFF
#define zelinkava 0x71F800FF
#define orange 0xE87511FF
#define blue 0x0000FFFF
#define yellow 0xFFFF00FF
#define grey 0xAFAFAFAA
#define cyan 0x00FFFFFF
#define green 0x00FF00FF
#define magenta 0xFF00FFFF

#define redH 0xFF000000
#define bilaH 0xFFFFFF00
#define orangeH 0xFF920000
#define blueH 0x0000FF00
#define yellowH 0xFFFF0000
#define greyH 0xAFAFAF00
#define cyanH 0x00FFFF00
#define greenH 0x00FF0000
#define magentaH 0xFF00FF00
#define sblue 0x0055FFFF

#define zl "{71F800}"
#define or "{E87511}"
#define s "{AFAFAF}"
#define r "{FF0000}"
#define g "{00FF00}"
#define c "{00FFFF}"
#define b "{0000FF}"
#define w "{FFFFFF}"
#define y "{FFFF00}"
#define z "{A8FF00}"
#define sb "{0055FF}"
#define m "{FF00FF}"
#define dc "{a9c4e4}"

#define CARMENU 3000

#define SCMTOAA(%1) format(str,sizeof(str),"%s %s",%1,params); SCMTOA(playerid,str);
#define USER_FILES "UnNamed/%s.save"
#define IsNoAdmin(%1) if(Admin[playerid] <= 2) return SM(%1,"Nem  dostate n  Admin Pr va");
#define IsNoEventer(%1) if(Admin[playerid] == 0) return SM(%1,"Nem  dostate n  Admin Pr va");
#define IsNoModerator(%1) if(Admin[playerid] <= 1) return SM(%1,"Nem  dostate n  Admin Pr va");
#define IsNoVIP(%1) if(vip[%1] == 0) return SM(%1,"Nevlastn  Premium   et "g"/premium");

#define RCMD_PREFIX "/"
#define rcmd(%1,%2,%3) if((strcmp((%3), RCMD_PREFIX #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (rcmd_%1(""))) || (((%3)[(%2) + 1] == 32) && (rcmd_%1((%3)[(%2) + 2]))))) return 1
#define ForPlayers(%0) for(new %0; %0 <= MAX_PLAYERS;%0++) if(IsPlayerConnected(%0))
#define DGTEXT "                                                {FFFFFF}D{0066FF}G"

#pragma dynamic 140000

new CCAR[MAX_PLAYERS] = 0;
new Admin[MAX_PLAYERS];
new bool:ShowedDialog[MAX_PLAYERS];
new str[255];
new vip[MAX_PLAYERS];
new dfile[50];
new Neony[MAX_VEHICLES];
new Neon1[MAX_VEHICLES];
new Neon2[MAX_VEHICLES];
new Text:Textdraw15;
new Text:Textdraw14;

new VybavaAllowedWeapons[] =
{
	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,23,24,25,26,27,28,29,30,31,32,33,34,41,43,46
};

new VehicleNames[][] =
{
	{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},{"Dumper"},
	{"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},
	{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},{"Washington"},
	{"Bobcat"},{"Mr Whoopee"},{"BF Injection"},{"Hunter"},{"Premier"},{"Enforcer"},{"Securicar"},
	{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Trailer 1"},{"Previon"},
	{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},
	{"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Trailer 2"},{"Turismo"},
	{"Speeder"},{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},
	{"Skimmer"},{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},
	{"Sanchez"},{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},
	{"Rustler"},{"ZR-350"},{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},
	{"Baggage"},{"Dozer"},{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},
	{"Jetmax"},{"Hotring"},{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},
	{"Mesa"},{"RC Goblin"},{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},
	{"Super GT"},{"Elegant"},{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},
	{"Tanker"}, {"Roadtrain"},{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},
	{"NRG-500"},{"HPV1000"},{"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},
	{"Willard"},{"Forklift"},{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},
	{"Blade"},{"Freight"},{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},
	{"Firetruck LA"},{"Hustler"},{"Intruder"},{"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},
	{"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},{"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},
	{"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},
	{"Bandito"},{"Freight Flat"},{"Streak Carriage"},{"Kart"},{"Mower"},{"Duneride"},{"Sweeper"},
	{"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},
	{"Tug"},{"Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},{"Freight Carriage"},
	{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},{"Police Car (SFPD)"},
	{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},{"Alpha"},{"Phoenix"},{"Glendale"},
	{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},{"Boxville"},{"Farm Plow"},
	{"Utility Trailer"},{"Srnka"},{" elva"},{"Kr va"},{"V no n  d rek"},{"Wildfire XN1"},{"Wildfire XN2"},
	{"Thunder ZX1"},{"Thunder ZX2"},{"Comet XR1"},{"Bull ZX1"},{"Bull BX1"},{"Bull XN1"},{"Bull RX1"},
	{"Bull XZ1"},{"Secure-Z"},{"Bull CX1"},{"Cheetah ZX1"},{"Bull 420"},{"Infernus Bull-RX"},{"Bullet-R"},{"Quad-R"},
	{"NRG-R"},{"Cheetah X-Mas17"},{"D n "},{"Infernus X-Mas18"}
};

forward KickPlayerAfterTime(playerid,time);

public KickPlayerAfterTime(playerid,time)
{
	SetTimerEx("KPAT",time,false,"d",playerid);
	return 1;
}

stock BanPlayerAfterTime(playerid,time)
{
	SetTimerEx("BPAT",time,false,"d",playerid);
	return 1;
}

forward KPAT(playerid);
forward BPAT(playerid, duvod[]);

public KPAT(playerid)
{
 	Kick(playerid);
 	return 1;
}

public BPAT(playerid)
{
	new reason[100];
	GetPVarString(playerid,"BanReason",reason,sizeof(reason));
	BanEx(playerid,reason);
	return 1;
}

stock ShowPlayerDialogEx(playerid,DIALOG_ID,DIALOG_STYLE,NAZEV[],TEXT[],BUTTON1[],BUTTON2[])
{
	if(ShowedDialog[playerid] == true) return false;
	new strr[128];
	new strrr[15000];
	format(strr,sizeof(strr),""w"Un{0077FF}Named"w" - %s",NAZEV);
	format(strrr,sizeof(strrr),""w"%s",TEXT);
	ShowPlayerDialog(playerid,DIALOG_ID,DIALOG_STYLE,strr,strrr,BUTTON1,BUTTON2);
	ShowedDialog[playerid] = true;
	return 1;
}

stock SM(playerid,message[])
{
	new sss[145];
	format(sss,sizeof(sss),"[ ! ] "w"%s"w".",message);
	SCM(playerid,red,sss);
	return 1;
}

stock CreateNeon(playerid,neonid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(Neony[vehicleid] == 1)
	{
	   	DestroyObject(Neon1[vehicleid]); DestroyObject(Neon2[vehicleid]);
		Neony[vehicleid] = 0;
		Neon1[vehicleid] = 0;
		Neon2[vehicleid] = 0;
	}
	Neon1[vehicleid] = CreateObject(neonid,0,0,0,0,0,0,100);
	Neon2[vehicleid] = CreateObject(neonid,0,0,0,0,0,0,100);
	AttachObjectToVehicle(Neon1[vehicleid], vehicleid, -0.8,0.0,-0.70,0.0,0.0,0.0);
	AttachObjectToVehicle(Neon2[vehicleid], vehicleid, 0.8,0.0,-0.70,0.0,0.0,0.0);
	SM(playerid,"Neony  sp n  namontov ny");
	Neony[vehicleid] = 1;
	return 1;
}
stock GetIP(playerid)
{
	new gIP[24];
	GetPlayerIp(playerid,gIP,sizeof(gIP));
	return gIP;
}

stock LoadAdmin(playerid)
{
	new f[50];
	format(f,sizeof(f),"UnNamed/%s.save",Jmeno(playerid));
	Admin[playerid] = dini_Int(f,"Admin Level");
	return 1;
}

new blik[2];

stock TurnBlinkWeb()
{
	SetTimer("BlinkWeb",700,true);
	return 1;
}


forward BlinkWeb();

public BlinkWeb()
{
    blik[0]++;
    blik[1]++;

    new blik1[][] =
    {
        "~b~U~w~n~b~N~w~amed ~b~2.0",
        "~r~U~w~n~b~N~w~amed ~b~2.0",
        "~b~U~y~n~b~N~w~amed ~b~2.0",
        "~b~U~w~n~r~N~w~amed ~b~2.0",
        "~b~U~w~n~b~N~y~a~w~med ~b~2.0",
        "~b~U~w~n~b~N~w~a~y~m~w~ed ~b~2.0",
        "~b~U~w~n~b~N~w~am~y~e~w~d ~b~2.0",
        "~b~U~w~n~b~N~w~ame~y~d ~b~2.0",
        "~b~U~w~n~b~N~w~amed ~r~2.0",
        "~b~U~w~n~b~N~w~amed ~b~2.0",
        "~r~U~w~n~r~N~w~amed ~r~2.0",
        "~b~U~w~n~b~N~w~amed ~b~2.0",
        "~r~U~w~n~r~N~w~amed ~r~2.0"
    };

    new blik2[][] =
    {
        "~b~U~w~n~b~N~w~amed",
        "~r~U~w~n~b~N~w~amed",
        "~b~U~y~n~b~N~w~amed",
        "~b~U~w~n~r~N~w~amed",
        "~b~U~w~n~b~N~y~a~w~med",
        "~b~U~w~n~b~N~w~a~y~m~w~ed",
        "~b~U~w~n~b~N~w~am~y~e~w~d",
        "~b~U~w~n~b~N~w~ame~y~d",
        "~b~U~w~n~b~N~w~amed",
        "~r~U~w~n~r~N~w~amed",
        "~b~U~w~n~b~N~w~amed",
        "~r~U~w~n~r~N~w~amed"
    };

    if (blik[0]-1 >= sizeof(blik1)) blik[0] = 1;
    TextDrawSetString(Textdraw15, blik1[blik[0]-1]);

    if (blik[1]-1 >= sizeof(blik2)) blik[1] = 1;
    TextDrawSetString(Textdraw14, blik2[blik[1]-1]);

    return 1;
}

stock DATE(timestamp,type = 0)
{
	new dstr[30],den,mesic,rok,hodina,minuta,sekunda;
	TimestampToDate(timestamp,rok,mesic,den,hodina,minuta,sekunda,1);
	switch(type)
	{
		case 0: format(dstr,sizeof(dstr),"%02d.%02d.%d %02d:%02d",den,mesic,rok,hodina,minuta,sekunda);
		case 1:
		{
		    new day,month,year;
		    getdate(year,month,day);
		    if(rok != year)
		    {
		        format(dstr,sizeof(dstr),"%02d.%02d.%d %02d:%02d",den,mesic,rok,hodina,minuta,sekunda);
		    }
		    else
		    {
		        format(dstr,sizeof(dstr),"%02d.%02d. %02d:%02d",den,mesic,hodina,minuta,sekunda);
		    }
		}
		case 2: format(dstr,sizeof(dstr),"%02d.%02d.%d",den,mesic,rok);
	}
	return dstr;
}


stock fsearch(fn[],srch[],bool:caps=false)
{
    new File:fhandle = fopen(fn, io_read),temp[1000];
	while(fread(fhandle,temp))
	{
		StripNewLine(temp);
		if(equal(temp,srch,caps)) return true;
	}
	return false;
}

forward SCMTOA(playerid,message[]);
public SCMTOA(playerid,message[])
{
	#pragma unused playerid
	#pragma unused message
	return 1;
}


stock GetVehicleName(vehicleid)
{
 	new name[50];
	format(name,sizeof(name),VehicleNames[GetVehicleModel(vehicleid)-400]);
 	return name;
}
stock GetVehicleNameByCarID(vehicleid)
{
 	new name[50];
	format(name,sizeof(name),VehicleNames[vehicleid-400]);
 	return name;
}

stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{

				new changestr[16], changepos = 0, strpos = stringPos;
				while(changepos < 16 && string[strpos] && string[strpos] != delim)
				{
					changestr[changepos++] = string[strpos++];
    				}
				changestr[changepos] = '\0';
				setarg(paramPos,0,_:floatstr(changestr));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}

stock CarMenu(playerid,dialogid,response,listitem)
{
	if(dialogid == CARMENU)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0:
			    {
					new DIALOG[10000];
					strcat(DIALOG,"NRG-500\nPizzaboy\nPCJ-600\nFaggio\n");
					strcat(DIALOG,"Freeway\nSanchez\nQuad\nFCR-900\n");
					strcat(DIALOG,"BF-400\nWayfarer\nHPV-1000");
					SPD(playerid,CARMENU+1,DIALOG_STYLE_LIST,"CarMenu - Motorky",DIALOG,"Vybrat","Zp t");
			    }
			    case 1:
			    {
					new DIALOG[10000];
					strcat(DIALOG,"BMX\nKolo\nHorsk  Kolo");
					SPD(playerid,CARMENU+2,DIALOG_STYLE_LIST,"CarMenu - "c"Kola",DIALOG,"Vybrat","Zp t");
			    }
			    case 2:
			    {
					new DIALOG[10000];
					strcat(DIALOG,"Skimmer\nRustler\nBeagle\nCropduster\n");
					strcat(DIALOG,"Stuntplane\nShamal\nHydra\nNevada\n");
					strcat(DIALOG,"AT-400\nAndromada\nDodo");
					SPD(playerid,CARMENU+3,DIALOG_STYLE_LIST,"CarMenu - "c"Letadla",DIALOG,"Vybrat","Zp t");
			    }
			    case 3:
			    {
					new DIALOG[10000];
					strcat(DIALOG,"Leviathan\nHunter\nSeasparrow\n");
					strcat(DIALOG,"Sparrow\nMaverick\nSan News Maverick\nPolice Maverick\n");
					strcat(DIALOG,"Cargobob\nRaindance");
					SPD(playerid,CARMENU+4,DIALOG_STYLE_LIST,"CarMenu - "c"Helikopt ry",DIALOG,"Vybrat","Zp t");
			    }
			    case 4:
			    {
					new DIALOG[10000];
					strcat(DIALOG,"Predator\nSqallo\nSpeeder\nReefer\n");
					strcat(DIALOG,"Tropic\nCoastguard\nDinghy\nMarquis\n");
					strcat(DIALOG,"Jetmax\nLaunch");
					SPD(playerid,CARMENU+5,DIALOG_STYLE_LIST,"CarMenu - "c"Lod ",DIALOG,"Vybrat","Zp t");
			    }
			    case 5:
			    {
					new DIALOG[10000];
					strcat(DIALOG,"Infernus\nBullet\nCheetah\nBuffalo\n");
					strcat(DIALOG,"Banshee\nTurismo\nSabre\nZR-350\n");
					strcat(DIALOG,"Hotring Racer (A)\nHotring Racer (B)\nHotring Racer (C)\n");
					strcat(DIALOG,"Blista Compact\nSuper GT\nUranus\n");
  					strcat(DIALOG,"Jester\nFlash\nEuros\nClub\n");
  					strcat(DIALOG,"Alpha\nPhoenix");
					SPD(playerid,CARMENU+6,DIALOG_STYLE_LIST,"CarMenu - "c"Sprotovn ",DIALOG,"Vybrat","Zp t");
			    }
			    case 6:
			    {
					new DIALOG[10000];
					strcat(DIALOG,"Bravura\nSentinel\nManana\nEsperanto\n");
					strcat(DIALOG,"Washington\nPremier\nPrevion\nAdmiral\n");
					strcat(DIALOG,"Glendale\nOceanic\nHermes\nVirgo\nGreenwood\n");
					strcat(DIALOG,"Bloodring Banger\nElegant\n\nNebula\n");
					strcat(DIALOG,"Majestic\nBuccaneer\nFortune\nCadrona\n");
					strcat(DIALOG,"Willard\nVincent\nClover\nIntruder\nPrimo\n");
					strcat(DIALOG,"Tampa\nSunrise\nMerit\nSultan\nElegy\nStafford\n");
					strcat(DIALOG,"Emperor\nGlendale "r"-Po kozen ");
					SPD(playerid,CARMENU+7,DIALOG_STYLE_LIST,"CarMenu - "c"Salonov ",DIALOG,"Vybrat","Zp t");
			    }
				case 7:
				{
					new DIALOG[10000];
				    strcat(DIALOG,"Voodoo\nRemington\nSlamvan\nBlade\nTahoma\n");
				    strcat(DIALOG,"Savanna\nBroadway\nTornado\n");
					SPD(playerid,CARMENU+8,DIALOG_STYLE_LIST,"CarMenu - "c"Lowridery",DIALOG,"Vybrat","Zp t");
				}
				case 8:
				{
					new DIALOG[10000];
				    strcat(DIALOG,"Landstalker\nBF Injection\nMonster\nPatriot\nRancher (A)\n");
				    strcat(DIALOG,"Sandking\nMesa\nRancher (B)\nMonster (A)\nMonster (B)\n");
				    strcat(DIALOG,"Bandito\nDune\nHuntley");
					SPD(playerid,CARMENU+9,DIALOG_STYLE_LIST,"CarMenu - "c"Off-Roady",DIALOG,"Vybrat","Zp t");
				}
				case 9:
				{
					new DIALOG[10000];
				    strcat(DIALOG,"Linerunner\nTrashmaster\nPony\nMule\nBobcat\n");
				    strcat(DIALOG,"Rumbo\nPacker\nFlatbed\nYankee\nTopfun Van\n");
				    strcat(DIALOG,"Walton\nBurrito\nBoxville\nBanson\nTanker\n");
				    strcat(DIALOG,"Roadtrain\nCement Truck\nTractor\nSadler\nUtility Van\n");
				    strcat(DIALOG,"Yosemite\nDFT-30\nNewsvan\nPicador\nSadler - "r"Po kozen \n");
					SPD(playerid,CARMENU+10,DIALOG_STYLE_LIST,"CarMenu - "c"Pr myslov ",DIALOG,"Vybrat","Zp t");
				}
				case 10:
				{
					new DIALOG[10000];
					strcat(DIALOG,"Firetruck\nAmbulance\nTaxi\nEnforcer\nBus\n");
					strcat(DIALOG,"Rhino\nBarracks\nCoach\nCabbie\nFBI Rancher\n");
					strcat(DIALOG,"FBI Truck\nFiretruck LA\nPolice Car ("r"LSPD"w")\nPolice Car ("r"SFPD"w")\nPolice Car ("r"LVPD"w")\n");
					strcat(DIALOG,"Police Ranger\nS.W.A.T.");
					SPD(playerid,CARMENU+11,DIALOG_STYLE_LIST,"CarMenu - "c"Slu ebn ",DIALOG,"Vybrat","Zp t");
				}
			}
		}
		return 1;
	}
	if(dialogid == CARMENU+1)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: CreateCarMenuVehicle(playerid,522);
			    case 1: CreateCarMenuVehicle(playerid,448);
			    case 2: CreateCarMenuVehicle(playerid,461);
			    case 3: CreateCarMenuVehicle(playerid,462);
			    case 4: CreateCarMenuVehicle(playerid,463);
			    case 5: CreateCarMenuVehicle(playerid,468);
			    case 6: CreateCarMenuVehicle(playerid,471);
			    case 7: CreateCarMenuVehicle(playerid,521);
			    case 8: CreateCarMenuVehicle(playerid,581);
				case 9: CreateCarMenuVehicle(playerid,586);
				case 10: CreateCarMenuVehicle(playerid,523);
			}
		}
		else
		{
		    Menu(playerid);
		}
		return 1;
	}
	if(dialogid == CARMENU+2)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: CreateCarMenuVehicle(playerid,481);
			    case 1: CreateCarMenuVehicle(playerid,509);
			    case 2: CreateCarMenuVehicle(playerid,510);
			}
		}
		else
		{
  			Menu(playerid);
		}
		return 1;
	}
	if(dialogid == CARMENU+3)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: CreateCarMenuVehicle(playerid,460);
			    case 1: CreateCarMenuVehicle(playerid,476);
			    case 2: CreateCarMenuVehicle(playerid,511);
			    case 3: CreateCarMenuVehicle(playerid,512);
			    case 4: CreateCarMenuVehicle(playerid,513);
			    case 5: CreateCarMenuVehicle(playerid,519);
			    case 6:
				{
					IsNoVIP(playerid)
					CreateCarMenuVehicle(playerid,520);
				}
				case 7: CreateCarMenuVehicle(playerid,553);
			    case 8: CreateCarMenuVehicle(playerid,577);
			    case 9: CreateCarMenuVehicle(playerid,592);
			    case 10: CreateCarMenuVehicle(playerid,593);
			}
		}
		else
		{
  			Menu(playerid);
		}
		return 1;
	}
	if(dialogid == CARMENU+4)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: CreateCarMenuVehicle(playerid,417);
			    case 1:
				{
					IsNoVIP(playerid)
				 	CreateCarMenuVehicle(playerid,425);
				}
				case 2: CreateCarMenuVehicle(playerid,447);
			    case 3: CreateCarMenuVehicle(playerid,469);
			    case 4: CreateCarMenuVehicle(playerid,487);
			    case 5: CreateCarMenuVehicle(playerid,488);
			    case 6: CreateCarMenuVehicle(playerid,497);
			    case 7: CreateCarMenuVehicle(playerid,548);
			    case 8: CreateCarMenuVehicle(playerid,563);
			}
		}
		else
		{
  			Menu(playerid);
		}
		return 1;
	}
	if(dialogid == CARMENU+5)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: CreateCarMenuVehicle(playerid,430);
			    case 1: CreateCarMenuVehicle(playerid,446);
			    case 2: CreateCarMenuVehicle(playerid,452);
			    case 3: CreateCarMenuVehicle(playerid,453);
			    case 4: CreateCarMenuVehicle(playerid,454);
			    case 5: CreateCarMenuVehicle(playerid,472);
			    case 6: CreateCarMenuVehicle(playerid,473);
			    case 7: CreateCarMenuVehicle(playerid,484);
			    case 8: CreateCarMenuVehicle(playerid,493);
			    case 9: CreateCarMenuVehicle(playerid,595);
			}
		}
		else
		{
  			Menu(playerid);
		}
		return 1;
	}
	if(dialogid == CARMENU+6)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: CreateCarMenuVehicle(playerid,411);
			    case 1: CreateCarMenuVehicle(playerid,541);
			    case 2: CreateCarMenuVehicle(playerid,415);
			    case 3: CreateCarMenuVehicle(playerid,402);
			    case 4: CreateCarMenuVehicle(playerid,429);
			    case 5: CreateCarMenuVehicle(playerid,451);
			    case 6: CreateCarMenuVehicle(playerid,475);
			    case 7: CreateCarMenuVehicle(playerid,477);
			    case 8: CreateCarMenuVehicle(playerid,494);
			    case 9: CreateCarMenuVehicle(playerid,502);
			    case 10: CreateCarMenuVehicle(playerid,503);
			    case 11: CreateCarMenuVehicle(playerid,496);
			    case 12: CreateCarMenuVehicle(playerid,506);
			    case 13: CreateCarMenuVehicle(playerid,558);
			    case 14: CreateCarMenuVehicle(playerid,559);
			    case 15: CreateCarMenuVehicle(playerid,565);
			    case 16: CreateCarMenuVehicle(playerid,587);
			    case 17: CreateCarMenuVehicle(playerid,589);
			    case 18: CreateCarMenuVehicle(playerid,602);
			    case 19: CreateCarMenuVehicle(playerid,603);
			}
		}
		else
		{
  			Menu(playerid);
		}
		return 1;
	}
	if(dialogid == CARMENU+7)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: CreateCarMenuVehicle(playerid,401);
			    case 1: CreateCarMenuVehicle(playerid,405);
			    case 2: CreateCarMenuVehicle(playerid,410);
			    case 3: CreateCarMenuVehicle(playerid,419);
			    case 4: CreateCarMenuVehicle(playerid,421);
			    case 5: CreateCarMenuVehicle(playerid,426);
			    case 6: CreateCarMenuVehicle(playerid,436);
			    case 7: CreateCarMenuVehicle(playerid,445);
			    case 8: CreateCarMenuVehicle(playerid,466);
			    case 9: CreateCarMenuVehicle(playerid,467);
			    case 10: CreateCarMenuVehicle(playerid,474);
			    case 11: CreateCarMenuVehicle(playerid,491);
			    case 12: CreateCarMenuVehicle(playerid,492);
			    case 13: CreateCarMenuVehicle(playerid,504);
			    case 14: CreateCarMenuVehicle(playerid,507);
			    case 15: CreateCarMenuVehicle(playerid,516);
			    case 16: CreateCarMenuVehicle(playerid,517);
			    case 17: CreateCarMenuVehicle(playerid,518);
			    case 18: CreateCarMenuVehicle(playerid,526);
			    case 19: CreateCarMenuVehicle(playerid,527);
				case 20: CreateCarMenuVehicle(playerid,529);
				case 21: CreateCarMenuVehicle(playerid,540);
				case 22: CreateCarMenuVehicle(playerid,542);
				case 23: CreateCarMenuVehicle(playerid,546);
				case 24: CreateCarMenuVehicle(playerid,547);
				case 25: CreateCarMenuVehicle(playerid,549);
				case 26: CreateCarMenuVehicle(playerid,550);
				case 27: CreateCarMenuVehicle(playerid,551);
				case 28: CreateCarMenuVehicle(playerid,560);
				case 29: CreateCarMenuVehicle(playerid,562);
				case 30: CreateCarMenuVehicle(playerid,580);
				case 31: CreateCarMenuVehicle(playerid,585);
				case 32: CreateCarMenuVehicle(playerid,604);
			}
		}
		else
		{
  			Menu(playerid);
		}
		return 1;
	}
	if(dialogid == CARMENU+8)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: CreateCarMenuVehicle(playerid,412);
			    case 1: CreateCarMenuVehicle(playerid,534);
			    case 2: CreateCarMenuVehicle(playerid,535);
			    case 3: CreateCarMenuVehicle(playerid,536);
			    case 4: CreateCarMenuVehicle(playerid,566);
			    case 5: CreateCarMenuVehicle(playerid,567);
			    case 6: CreateCarMenuVehicle(playerid,575);
			    case 7: CreateCarMenuVehicle(playerid,576);
			}
		}
		else
		{
  			Menu(playerid);
		}
		return 1;
	}
	if(dialogid == CARMENU+9)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: CreateCarMenuVehicle(playerid,400);
			    case 1: CreateCarMenuVehicle(playerid,424);
			    case 2: CreateCarMenuVehicle(playerid,444);
			    case 3: CreateCarMenuVehicle(playerid,470);
			    case 4: CreateCarMenuVehicle(playerid,489);
			    case 5: CreateCarMenuVehicle(playerid,495);
			    case 6: CreateCarMenuVehicle(playerid,500);
			    case 7: CreateCarMenuVehicle(playerid,505);
			    case 8: CreateCarMenuVehicle(playerid,556);
				case 9: CreateCarMenuVehicle(playerid,557);
				case 10: CreateCarMenuVehicle(playerid,568);
				case 11: CreateCarMenuVehicle(playerid,573);
				case 12: CreateCarMenuVehicle(playerid,579);

			}
		}
		else
		{
		    Menu(playerid);
		}
		return 1;
	}
	if(dialogid == CARMENU+10)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: CreateCarMenuVehicle(playerid,403);
			    case 1: CreateCarMenuVehicle(playerid,408);
			    case 2: CreateCarMenuVehicle(playerid,413);
			    case 3: CreateCarMenuVehicle(playerid,414);
			    case 4: CreateCarMenuVehicle(playerid,422);
			    case 5: CreateCarMenuVehicle(playerid,440);
			    case 6: CreateCarMenuVehicle(playerid,443);
			    case 7: CreateCarMenuVehicle(playerid,455);
			    case 8: CreateCarMenuVehicle(playerid,456);
			    case 9: CreateCarMenuVehicle(playerid,459);
			    case 10: CreateCarMenuVehicle(playerid,478);
			    case 11: CreateCarMenuVehicle(playerid,482);
			    case 12: CreateCarMenuVehicle(playerid,498);
			    case 13: CreateCarMenuVehicle(playerid,499);
			    case 14: CreateCarMenuVehicle(playerid,514);
			    case 15: CreateCarMenuVehicle(playerid,515);
			    case 16: CreateCarMenuVehicle(playerid,524);
			    case 17: CreateCarMenuVehicle(playerid,531);
			    case 18: CreateCarMenuVehicle(playerid,543);
			    case 19: CreateCarMenuVehicle(playerid,552);
				case 20: CreateCarMenuVehicle(playerid,554);
				case 21: CreateCarMenuVehicle(playerid,578);
				case 22: CreateCarMenuVehicle(playerid,582);
				case 23: CreateCarMenuVehicle(playerid,600);
				case 24: CreateCarMenuVehicle(playerid,605);
			}
		}
		else
		{
		    Menu(playerid);
		}
		return 1;
	}
	if(dialogid == CARMENU+11)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0: CreateCarMenuVehicle(playerid,407);
			    case 1: CreateCarMenuVehicle(playerid,416);
			    case 2: CreateCarMenuVehicle(playerid,420);
			    case 3: CreateCarMenuVehicle(playerid,427);
			    case 4: CreateCarMenuVehicle(playerid,431);
			    case 5:
			    {
					IsNoVIP(playerid)
					CreateCarMenuVehicle(playerid,432);
				}
				case 6: CreateCarMenuVehicle(playerid,433);
			    case 7: CreateCarMenuVehicle(playerid,437);
			    case 8: CreateCarMenuVehicle(playerid,438);
			    case 9: CreateCarMenuVehicle(playerid,490);
			    case 10: CreateCarMenuVehicle(playerid,528);
			    case 11: CreateCarMenuVehicle(playerid,544);
			    case 12: CreateCarMenuVehicle(playerid,596);
			    case 13: CreateCarMenuVehicle(playerid,597);
			    case 14: CreateCarMenuVehicle(playerid,598);
			    case 15: CreateCarMenuVehicle(playerid,599);
			    case 16: CreateCarMenuVehicle(playerid,601);
			}
		}
		else
		{
		    Menu(playerid);
		}
		return 1;
	}
	return 0;
}

stock Menu(playerid)
{
	new DIALOG_CARMENU[1000];
	strcat(DIALOG_CARMENU,""y"M"w"otorky\n");
	strcat(DIALOG_CARMENU,""y"K"w"ola\n");
	strcat(DIALOG_CARMENU,""y"L"w"etadla\n");
	strcat(DIALOG_CARMENU,""y"H"w"elikopt ry\n");
	strcat(DIALOG_CARMENU,""y"L"w"od \n");
	strcat(DIALOG_CARMENU,""y"S"w"portovn \n");
	strcat(DIALOG_CARMENU,""y"S"w"alonov \n");
	strcat(DIALOG_CARMENU,""y"L"w"owridery\n");
	strcat(DIALOG_CARMENU,""y"O"w"ff-Road\n");
	strcat(DIALOG_CARMENU,""y"P"w"r myslov \n");
 	strcat(DIALOG_CARMENU,""y"S"w"lu ebn ");
	SPD(playerid,CARMENU,DIALOG_STYLE_LIST,"CarMenu",DIALOG_CARMENU,"Vybrat","Zav  t");
	return 0;
}

