#include <a_samp>
#include <izcmd>
#include <vehicleComponents>

native IsValidVehicle(vehicleid);

#pragma dynamic 14000

#define DIALOG_ID 8465
#define SM SendMessage
#define SPD ShowPlayerDialog

#define GiveMoney(%1,%2) CallRemoteFunction("GiveMoney", "ii",%1, %2)
#define GetMoney(%1) GetPlayerMoney(%1)

new VehicleColoursTableRGBA[256] = {
// The existing colours from San Andreas
	0x000000FF, 0xF5F5F5FF, 0x2A77A1FF, 0x840410FF, 0x263739FF, 0x86446EFF, 0xD78E10FF, 0x4C75B7FF, 0xBDBEC6FF, 0x5E7072FF,
	0x46597AFF, 0x656A79FF, 0x5D7E8DFF, 0x58595AFF, 0xD6DAD6FF, 0x9CA1A3FF, 0x335F3FFF, 0x730E1AFF, 0x7B0A2AFF, 0x9F9D94FF,
	0x3B4E78FF, 0x732E3EFF, 0x691E3BFF, 0x96918CFF, 0x515459FF, 0x3F3E45FF, 0xA5A9A7FF, 0x635C5AFF, 0x3D4A68FF, 0x979592FF,
	0x421F21FF, 0x5F272BFF, 0x8494ABFF, 0x767B7CFF, 0x646464FF, 0x5A5752FF, 0x252527FF, 0x2D3A35FF, 0x93A396FF, 0x6D7A88FF,
	0x221918FF, 0x6F675FFF, 0x7C1C2AFF, 0x5F0A15FF, 0x193826FF, 0x5D1B20FF, 0x9D9872FF, 0x7A7560FF, 0x989586FF, 0xADB0B0FF,
	0x848988FF, 0x304F45FF, 0x4D6268FF, 0x162248FF, 0x272F4BFF, 0x7D6256FF, 0x9EA4ABFF, 0x9C8D71FF, 0x6D1822FF, 0x4E6881FF,
	0x9C9C98FF, 0x917347FF, 0x661C26FF, 0x949D9FFF, 0xA4A7A5FF, 0x8E8C46FF, 0x341A1EFF, 0x6A7A8CFF, 0xAAAD8EFF, 0xAB988FFF,
	0x851F2EFF, 0x6F8297FF, 0x585853FF, 0x9AA790FF, 0x601A23FF, 0x20202CFF, 0xA4A096FF, 0xAA9D84FF, 0x78222BFF, 0x0E316DFF,
	0x722A3FFF, 0x7B715EFF, 0x741D28FF, 0x1E2E32FF, 0x4D322FFF, 0x7C1B44FF, 0x2E5B20FF, 0x395A83FF, 0x6D2837FF, 0xA7A28FFF,
	0xAFB1B1FF, 0x364155FF, 0x6D6C6EFF, 0x0F6A89FF, 0x204B6BFF, 0x2B3E57FF, 0x9B9F9DFF, 0x6C8495FF, 0x4D8495FF, 0xAE9B7FFF,
	0x406C8FFF, 0x1F253BFF, 0xAB9276FF, 0x134573FF, 0x96816CFF, 0x64686AFF, 0x105082FF, 0xA19983FF, 0x385694FF, 0x525661FF,
	0x7F6956FF, 0x8C929AFF, 0x596E87FF, 0x473532FF, 0x44624FFF, 0x730A27FF, 0x223457FF, 0x640D1BFF, 0xA3ADC6FF, 0x695853FF,
	0x9B8B80FF, 0x620B1CFF, 0x5B5D5EFF, 0x624428FF, 0x731827FF, 0x1B376DFF, 0xEC6AAEFF, 0x000000FF,
	// SA-MP extended colours (0.3x)
	0x177517FF, 0x210606FF, 0x125478FF, 0x452A0DFF, 0x571E1EFF, 0x010701FF, 0x25225AFF, 0x2C89AAFF, 0x8A4DBDFF, 0x35963AFF,
	0xB7B7B7FF, 0x464C8DFF, 0x84888CFF, 0x817867FF, 0x817A26FF, 0x6A506FFF, 0x583E6FFF, 0x8CB972FF, 0x824F78FF, 0x6D276AFF,
	0x1E1D13FF, 0x1E1306FF, 0x1F2518FF, 0x2C4531FF, 0x1E4C99FF, 0x2E5F43FF, 0x1E9948FF, 0x1E9999FF, 0x999976FF, 0x7C8499FF,
	0x992E1EFF, 0x2C1E08FF, 0x142407FF, 0x993E4DFF, 0x1E4C99FF, 0x198181FF, 0x1A292AFF, 0x16616FFF, 0x1B6687FF, 0x6C3F99FF,
	0x481A0EFF, 0x7A7399FF, 0x746D99FF, 0x53387EFF, 0x222407FF, 0x3E190CFF, 0x46210EFF, 0x991E1EFF, 0x8D4C8DFF, 0x805B80FF,
	0x7B3E7EFF, 0x3C1737FF, 0x733517FF, 0x781818FF, 0x83341AFF, 0x8E2F1CFF, 0x7E3E53FF, 0x7C6D7CFF, 0x020C02FF, 0x072407FF,
	0x163012FF, 0x16301BFF, 0x642B4FFF, 0x368452FF, 0x999590FF, 0x818D96FF, 0x99991EFF, 0x7F994CFF, 0x839292FF, 0x788222FF,
	0x2B3C99FF, 0x3A3A0BFF, 0x8A794EFF, 0x0E1F49FF, 0x15371CFF, 0x15273AFF, 0x375775FF, 0x060820FF, 0x071326FF, 0x20394BFF,
	0x2C5089FF, 0x15426CFF, 0x103250FF, 0x241663FF, 0x692015FF, 0x8C8D94FF, 0x516013FF, 0x090F02FF, 0x8C573AFF, 0x52888EFF,
	0x995C52FF, 0x99581EFF, 0x993A63FF, 0x998F4EFF, 0x99311EFF, 0x0D1842FF, 0x521E1EFF, 0x42420DFF, 0x4C991EFF, 0x082A1DFF,
	0x96821DFF, 0x197F19FF, 0x3B141FFF, 0x745217FF, 0x893F8DFF, 0x7E1A6CFF, 0x0B370BFF, 0x27450DFF, 0x071F24FF, 0x784573FF,
	0x8A653AFF, 0x732617FF, 0x319490FF, 0x56941DFF, 0x59163DFF, 0x1B8A2FFF, 0x38160BFF, 0x041804FF, 0x355D8EFF, 0x2E3F5BFF,
	0x561A28FF, 0x4E0E27FF, 0x706C67FF, 0x3B3E42FF, 0x2E2D33FF, 0x7B7E7DFF, 0x4A4442FF, 0x28344EFF
};

public OnFilterScriptInit()
{
	return 1;
}

CMD:tune(playerid,params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) return SM(playerid,"Musíte být ve vozidle");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SM(playerid,"Musíte být øidiè vozidla");
	ShowPlayerTuneDialog(playerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_ID+1:
		{
			if(response)
			{
				if(!IsPlayerInAnyVehicle(playerid)) return SM(playerid,"Musíte být ve vozidle");
				if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SM(playerid,"Musíte být øidiè vozidla");

				new model = GetVehicleModel(GetPlayerVehicleID(playerid));
				if(IsVehicleHasColor(model))
				{
					if(listitem == 0)
					{
						ShowPlayerTuneColorDialog(playerid);
						return 1;
					}
					else listitem--;
				}
				if(IsVehicleHasPaintjob(model))
				{
					if(listitem == 0)
					{
						ShowPlayerTunePaintjobDialog(playerid);
						return 1;
					}
					else listitem--;
				}

				if(listitem < 0 || listitem >= COMP_CAT_SIZE) return 1;


				new compCategories[COMP_CAT_SIZE];
				LoadVehicleComponentCategories(model,compCategories);

				SetPVarInt(playerid,"TuneCategory",compCategories[listitem]);

				ShowPlayerTuneCategoryDialog(playerid,compCategories[listitem]);
			}
			return 1;
		}
		case DIALOG_ID+2:
		{
			if(response)
			{
				if(!IsPlayerInAnyVehicle(playerid)) return SM(playerid,"Musíte být ve vozidle");
				if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SM(playerid,"Musíte být øidiè vozidla");
				new category = GetPVarInt(playerid,"TuneCategory");
				new veh = GetPlayerVehicleID(playerid);
				new model = GetVehicleModel(veh);
				new components[MAX_VEH_COMPONENTS];
				LoadVehicleComponents(model,category,components);

				new compIdx = components[listitem]-1000;
				new price = Component[compIdx][compPrice];

				if(GetVehicleComponentInSlot(veh,GetVehicleComponentType(components[listitem])) != components[listitem])
				{
					if(price <= GetMoney(playerid))
					{
						GiveMoney(playerid,-price);

						for(new i; i < 2; i ++)
							AddVehicleComponent(veh,components[listitem]);
						PlayerPlaySound(playerid,1133,0,0,0);

						new str[145];
						format(str,sizeof(str),"Zakoupen komponent za {00FF00}%d$",price);
						SM(playerid,str);
					}
					else SM(playerid,"Nemáte dostatek penìz na zakoupení");				
				}
				else SM(playerid,"Tento komponent již máte zakoupený");

				ShowPlayerTuneCategoryDialog(playerid,category);
			}
			else ShowPlayerTuneDialog(playerid);
			return 1;
		}
		case DIALOG_ID+3:
		{
			if(response)
			{
				new page = GetPVarInt(playerid,"TunePage");
				if(listitem < 50)
				{
					new color = listitem+page*50;
					ChangeVehicleColor(GetPlayerVehicleID(playerid),color,color);
					ShowPlayerTuneColorDialog(playerid);
				}
				else ShowPlayerTuneColorDialog(playerid,page+1);
			}
			else ShowPlayerTuneDialog(playerid);
			return 1;
		}
		case DIALOG_ID+4:
		{
			if(response)
			{
				ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),listitem);
				ShowPlayerTunePaintjobDialog(playerid);
			}
			else ShowPlayerTuneDialog(playerid);
			return 1;
		}
	}
	return 1;
}

stock ShowPlayerTuneColorDialog(playerid,page = 0)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new DIALOG[50*20],str[20];
		for(new i = page*50; i < (page+1)*50 && i < sizeof(VehicleColoursTableRGBA); i ++)
		{
			format(str,sizeof(str),"{%06x}Barva %d\n",VehicleColoursTableRGBA[i]>>>8,i);
			strcat(DIALOG,str);
			if((i+1)%50 == 0)
				strcat(DIALOG,"Další stránka");
		}
		SPD(playerid,DIALOG_ID+3,DIALOG_STYLE_LIST,"Barva",DIALOG,"Vybrat","Zavøít");
		SetPVarInt(playerid,"TunePage",page);
		return 1;
	}
	return 0;
}


stock ShowPlayerTunePaintjobDialog(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new DIALOG[100];
		for(new i; i < 3; i ++)
		{
			new str[13];
			format(str,sizeof(str),"PaintJob %d\n",i+1);
			strcat(DIALOG,str);
		}
		strcat(DIALOG,"Odebrat paintjob");
		SPD(playerid,DIALOG_ID+4,DIALOG_STYLE_LIST,"PaintJob",DIALOG,"Vybrat","Zpìt");
		return 1;
	}
	return 0;
}

stock ShowPlayerTuneCategoryDialog(playerid,category)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && category >= 0 && category < COMP_CAT_SIZE)
	{
		new veh = GetPlayerVehicleID(playerid);
		new model = GetVehicleModel(veh);
		new DIALOG[1000];

		new components[MAX_VEH_COMPONENTS];	
		LoadVehicleComponents(model,category,components);

		for(new i; i < MAX_VEH_COMPONENTS; i ++)
		{
			new str[145];
			new comp = components[i];
			new compSlot = GetVehicleComponentType(comp);

			if(comp-1000 < 0 || comp-1000 >= sizeof(Component) || compSlot == -1) break;

			new price = GetVehicleComponentPrice(comp);
			new owned = GetVehicleComponentInSlot(veh,compSlot);

			format(str,sizeof(str),"%s\t{%s}%d$\t%s\n",GetVehicleComponentName(comp),(price < GetPlayerMoney(playerid)) ? ("00FF00") : ("FF0000"),price,(owned == comp) ? ("{B8FFB8}Zakoupeno") : " ");
			strcat(DIALOG,str);
		}
		SPD(playerid,DIALOG_ID+2,DIALOG_STYLE_TABLIST,GetComponentCategoryName(category),DIALOG,"Vybrat","Zpìt");
		return 1;
	}
	return 0;
}

stock ShowPlayerTuneDialog(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new DIALOG[500],totalComps;
		new model = GetVehicleModel(GetPlayerVehicleID(playerid));

		new compCategories[COMP_CAT_SIZE];
		LoadVehicleComponentCategories(model,compCategories);

		if(IsVehicleHasColor(model))
		{
			strcat(DIALOG,"Color\n");
			totalComps++;
		}
		if(IsVehicleHasPaintjob(model))
		{
			strcat(DIALOG,"Paintjob\n");
			totalComps++;
		}

		for(new i; i < COMP_CAT_SIZE; i ++)
		{
			if(compCategories[i] == -1) break;
			strcat(DIALOG,GetComponentCategoryName(compCategories[i]));
			strcat(DIALOG,"\n");
			totalComps++;
		}
		if(totalComps && IsModelTunable(model))
			SPD(playerid,DIALOG_ID+1,DIALOG_STYLE_LIST,"TuneMenu",DIALOG,"Vybrat","Zavøít");
		else
		{
			SM(playerid,"Vozidlo nelze tunit");
			return 0;
		}
		return 1;
	}
	return 0;
}

stock IsVehicleHasPaintjob(model)
{
	switch(model)
	{
		 case 562,565,559,561,560,534,567,536,535,576,558: return 1;
	}
	return 0;
}

stock IsVehicleHasColor(model)
{
	switch(model)
	{
		case 592,520,519,417,447,493,433,432,601,406,532,434,441,464,594,501,465,564,606,607,584,568,556,557,435,608,611,610,590,569,537,449,470: return 0;
	}
	return 1;
}

stock IsModelTunable(model)
{
	switch(model)
	{
		case 557,556,553,548,539,520,519,513,512,511,501,497,488,487,476,471,469,465,464,460,447,444,442,425,417,406: return 0;
	}
	return 1;
}

stock SendMessage(playerid,text[],color = 0xFF0000FF,color2 = -1,mark[] = "[ ! ]",end[]=".")
{
	new str[145];
	format(str,sizeof(str),"%s {%06x}%s{%06x}%s",mark,color2>>>8,text,color2>>>8,end);
	return SendClientMessage(playerid,color,str);
}

