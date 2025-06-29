
#define SCM SendClientMessage
#define SM SendMessage
#define SCMTA SendClientMessageToAll
#define IPA IsPlayerAdmin
#define IPC IsPlayerConnected
#define SPD ShowPlayerDialog

#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

#define red 0xFF0000FF
#define bila 0xFFFFFFFF
#define zelinkava 0x71F80000
#define orange 0xE8751100
#define blue 0x0000FFFF
#define yellow 0xFFFF00FF
#define grey 0xAFAFAFAA
#define cyan 0x00FFFFFF
#define green 0x00FF00FF
#define magenta 0xFF00FFFF
#define sblue 0x0070FFFF

#define r "{FF0000}"
#define w "{FFFFFF}"
#define b "{0000FF}"
#define g "{00FF00}"
#define sb "{0055FF}"
#define dc "{a9c4e4}"

stock Jmeno(playerid)
{
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pName,sizeof(pName));
	return pName;
}

stock GetVehicleName(vehicleid)
{
 new name[32];
 switch(vehicleid)
 {
   case 400: format(name,32,"Landstalker");
   case 401: format(name,32,"Bravura");
   case 402: format(name,32,"Buffalo");
   case 403: format(name,32,"Linerunner");
   case 404: format(name,32,"Perenniel");
   case 405: format(name,32,"Sentinel");
   case 406: format(name,32,"Dumper");
   case 407: format(name,32,"Firetruck");
   case 408: format(name,32,"Trashmaster");
   case 409: format(name,32,"Stretch");
   case 410: format(name,32,"Manana");
   case 411: format(name,32,"Infernus");
   case 412: format(name,32,"Voodoo");
   case 413: format(name,32,"Pony");
   case 414: format(name,32,"Mule");
   case 415: format(name,32,"Cheetah");
   case 416: format(name,32,"Ambulance");
   case 417: format(name,32,"Leviathan");
   case 418: format(name,32,"Moonbeam");
   case 419: format(name,32,"Esperanto");
   case 420: format(name,32,"Taxi");
   case 421: format(name,32,"Washington");
   case 422: format(name,32,"Bobcat");
   case 423: format(name,32,"Mr Whoopee");
   case 424: format(name,32,"BF Injection");
   case 425: format(name,32,"Hunter");
   case 426: format(name,32,"Premier");
   case 427: format(name,32,"Enforcer");
   case 428: format(name,32,"Securicar");
   case 429: format(name,32,"Banshee");
   case 430: format(name,32,"Predator");
   case 431: format(name,32,"Bus");
   case 432: format(name,32,"Rhino");
   case 433: format(name,32,"Barracks");
   case 434: format(name,32,"Hotknife");
   case 435: format(name,32,"Article Trailer");
   case 436: format(name,32,"Previon");
   case 437: format(name,32,"Coach");
   case 438: format(name,32,"Cabbie");
   case 439: format(name,32,"Stallion");
   case 440: format(name,32,"Rumpo");
   case 441: format(name,32,"RC Bandit");
   case 442: format(name,32,"Romero");
   case 443: format(name,32,"Packer");
   case 444: format(name,32,"Monster");
   case 445: format(name,32,"Admiral");
   case 446: format(name,32,"Squallo");
   case 447: format(name,32,"Seasparrow");
   case 448: format(name,32,"Pizzaboy");
   case 449: format(name,32,"Tram");
   case 450: format(name,32,"Article Trailer 2");
   case 451: format(name,32,"Turismo");
   case 452: format(name,32,"Speeder");
   case 453: format(name,32,"Reefer");
   case 454: format(name,32,"Tropic");
   case 455: format(name,32,"Flatbed");
   case 456: format(name,32,"Yankee");
   case 457: format(name,32,"Caddy");
   case 458: format(name,32,"Solair");
   case 459: format(name,32,"Berkley's RC Van");
   case 460: format(name,32,"Skimmer");
   case 461: format(name,32,"PCJ-600");
   case 462: format(name,32,"Faggio");
   case 463: format(name,32,"Freeway");
   case 464: format(name,32,"RC Baron");
   case 465: format(name,32,"RC Raider");
   case 466: format(name,32,"Glendale");
   case 467: format(name,32,"Oceanic");
   case 468: format(name,32,"Sanchez");
   case 469: format(name,32,"Sparrow");
   case 470: format(name,32,"Patriot");
   case 471: format(name,32,"Quad");
   case 472: format(name,32,"Coastguard");
   case 473: format(name,32,"Dinghy");
   case 474: format(name,32,"Hermes");
   case 475: format(name,32,"Sabre");
   case 476: format(name,32,"Rustler");
   case 477: format(name,32,"ZR-350");
   case 478: format(name,32,"Walton");
   case 479: format(name,32,"Regina");
   case 480: format(name,32,"Comet");
   case 481: format(name,32,"BMX");
   case 482: format(name,32,"Burrito");
   case 483: format(name,32,"Camper");
   case 484: format(name,32,"Marquis");
   case 485: format(name,32,"Baggage");
   case 486: format(name,32,"Dozer");
   case 487: format(name,32,"Maverick");
   case 488: format(name,32,"SAN News Maverick");
   case 489: format(name,32,"Rancher");
   case 490: format(name,32,"FBI Rancher");
   case 491: format(name,32,"Virgo");
   case 492: format(name,32,"Greenwood");
   case 493: format(name,32,"Jetmax");
   case 494: format(name,32,"Hotring Racer");
   case 495: format(name,32,"Sandking");
   case 496: format(name,32,"Blista Compact");
   case 497: format(name,32,"Police Maverick");
   case 498: format(name,32,"Boxville");
   case 499: format(name,32,"Benson");
   case 500: format(name,32,"Mesa");
   case 501: format(name,32,"RC Goblin");
   case 502: format(name,32,"Hotring Racer");
   case 503: format(name,32,"Hotring Racer");
   case 504: format(name,32,"Bloodring Banger");
   case 505: format(name,32,"Rancher");
   case 506: format(name,32,"Super GT");
   case 507: format(name,32,"Elegant");
   case 508: format(name,32,"Journey");
   case 509: format(name,32,"Bike");
   case 510: format(name,32,"Mountain Bike");
   case 511: format(name,32,"Beagle");
   case 512: format(name,32,"Cropduster");
   case 513: format(name,32,"Stuntplane");
   case 514: format(name,32,"Tanker");
   case 515: format(name,32,"Roadtrain");
   case 516: format(name,32,"Nebula");
   case 517: format(name,32,"Majestic");
   case 518: format(name,32,"Buccaneer");
   case 519: format(name,32,"Shamal");
   case 520: format(name,32,"Hydra");
   case 521: format(name,32,"FCR-900");
   case 522: format(name,32,"NRG-500");
   case 523: format(name,32,"HPV1000");
   case 524: format(name,32,"Cement Truck");
   case 525: format(name,32,"Towtruck");
   case 526: format(name,32,"Fortune");
   case 527: format(name,32,"Cadrona");
   case 528: format(name,32,"FBI Truck");
   case 529: format(name,32,"Willard");
   case 530: format(name,32,"Forklift");
   case 531: format(name,32,"Tractor");
   case 532: format(name,32,"Combine Harvester");
   case 533: format(name,32,"Feltzer");
   case 534: format(name,32,"Remington");
   case 535: format(name,32,"Slamvan");
   case 536: format(name,32,"Blade");
   case 537: format(name,32,"Freight");
   case 538: format(name,32,"Brownstreak");
   case 539: format(name,32,"Vortex");
   case 540: format(name,32,"Vincent");
   case 541: format(name,32,"Bullet");
   case 542: format(name,32,"Clover");
   case 543: format(name,32,"Sadler");
   case 544: format(name,32,"Firetruck LA");
   case 545: format(name,32,"Hustler");
   case 546: format(name,32,"Intruder");
   case 547: format(name,32,"Primo");
   case 548: format(name,32,"Cargobob");
   case 549: format(name,32,"Tampa");
   case 550: format(name,32,"Sunrise");
   case 551: format(name,32,"Merit");
   case 552: format(name,32,"Utility Van");
   case 553: format(name,32,"Nevada");
   case 554: format(name,32,"Yosemite");
   case 555: format(name,32,"Windsor");
   case 556: format(name,32,"Monster A");
   case 557: format(name,32,"Monster B");
   case 558: format(name,32,"Uranus");
   case 559: format(name,32,"Jester");
   case 560: format(name,32,"Sultan");
   case 561: format(name,32,"Stratum");
   case 562: format(name,32,"Elegy");
   case 563: format(name,32,"Raindance");
   case 564: format(name,32,"RC Tiger");
   case 565: format(name,32,"Flash");
   case 566: format(name,32,"Tahoma");
   case 567: format(name,32,"Savanna");
   case 568: format(name,32,"Bandito");
   case 569: format(name,32,"Freight Flat Trailer");
   case 570: format(name,32,"Streak Trailer");
   case 571: format(name,32,"Kart");
   case 572: format(name,32,"Mower");
   case 573: format(name,32,"Dune");
   case 574: format(name,32,"Sweeper");
   case 575: format(name,32,"Broadway");
   case 576: format(name,32,"Tornado");
   case 577: format(name,32,"AT400");
   case 578: format(name,32,"DFT-30");
   case 579: format(name,32,"Huntley");
   case 580: format(name,32,"Stafford");
   case 581: format(name,32,"BF-400");
   case 582: format(name,32,"Newsvan");
   case 583: format(name,32,"Tug");
   case 584: format(name,32,"Petrol Trailer");
   case 585: format(name,32,"Emperor");
   case 586: format(name,32,"Wayfarer");
   case 587: format(name,32,"Euros");
   case 588: format(name,32,"Hotdog");
   case 589: format(name,32,"Club");
   case 590: format(name,32,"Freight Box Trailer");
   case 591: format(name,32,"Article Trailer 3");
   case 592: format(name,32,"Andromada");
   case 593: format(name,32,"Dodo");
   case 594: format(name,32,"RC Cam");
   case 595: format(name,32,"Launch");
   case 596: format(name,32,"Police Car (LSPD)");
   case 597: format(name,32,"Police Car (SFPD)");
   case 598: format(name,32,"Police Car (LVPD)");
   case 599: format(name,32,"Police Ranger");
   case 600: format(name,32,"Picador");
   case 601: format(name,32,"S.W.A.T.");
   case 602: format(name,32,"Alpha");
   case 603: format(name,32,"Phoenix");
   case 604: format(name,32,"Glendale Shit");
   case 605: format(name,32,"Sadler Shit");
   case 606: format(name,32,"Baggage Trailer A");
   case 607: format(name,32,"Baggage Trailer B");
   case 608: format(name,32,"Tug Stairs Trailer");
   case 609: format(name,32,"Boxville");
   case 610: format(name,32,"Farm Trailer");
   case 611: format(name,32,"Utility Trailer");
 }
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

stock HexToInt(string[])
{
    if(!string[0]) return 0;
    new cur = 1, res = 0;
    for(new i = strlen(string); i > 0; i--)
    {
        res += cur * (string[i - 1] - ((string[i - 1] < 58) ? (48) : (55)));
        cur = cur * 16;
    }
    return res;
}

