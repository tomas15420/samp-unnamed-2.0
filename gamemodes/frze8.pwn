#include <a_samp>
#include <a_mysql>
#include <streamer>
#include <dof2>
#include <izcmd>
#include <sscanf>
#include <VehicleNames>
#include <daily>

native IsValidVehicle(vehicleid);

#file "DGRZE8"
#define VW 2000
#define CONFIG    "UnNamed/UNConfig.cfg"

new mysql;

#define function%0(%1) 	forward%0(%1); public%0(%1)

#define GM_NAME 		"Reálná Zemì"
#define GM_VERSION 		"2.0"
#define GM_AUTOR        "DeLeTe"

#define SERVER_WEB 		"Example.com"
#define SERVER_IP 		"localhost:7777"
#define SERVER_OWNER 	"ServerOwner"
#define SERVER_MAIL     "example@example.com"

#define SCM 			SendClientMessage
#define SM 				SendMessage
#define SCMTA 			SendClientMessageToAll
#define SPD 			ShowPlayerDialogEx
#define IPC 			IsPlayerConnected

#define BILA            0xFFFFFFFF
#define SEDA 			0xAFAFAFFF
#define GREEN           0x00FF00FF
#define RED             0xFF0000FF
#define CYAN            0x00FFFFFF
#define YELLOW          0xFFFF00FF
#define JCOLOR          0x7171FFFF
#define ORANGE          0xFF7F00FF
#define DARK_RED        0xA00000FF
#define DARK_GREEN      0x009300FF
#define LIGHT_GREEN     0xAEFF00FF
#define PING_RED        0xFF0059FF

#define cw             	"{FFFFFF}"
#define cs             	"{ADADAD}"
#define cg             	"{00FF00}"
#define cr             	"{FF0000}"
#define cc             	"{00FFFF}"
#define cy              "{FFFF00}"
#define cdc            	"{A9C4E4}"
#define jc              "{7171FF}"
#define co              "{FF7F00}"
#define cdr             "{A00000}"
#define cdg             "{009300}"
#define clg             "{AEFF00}"
#define cpr             "{FF0059}"

#define MAX_BANKS   		10
#define MAX_GANJAS     	 	30
#define MAX_SHOPS      	 	2
#define MAX_OFFICES 		3
#define MAX_PASSES     	 	2
#define MAX_PJOBS   		34
#define MAX_JOBS    		14
#define MAX_JSKINS  		10
#define MAX_CLOTHES     	5
#define MAX_WEAPON_DROP 	200
#define MAX_ADDONS      	4
#define MAX_MONEY       	2147483647
#define GANJA_SELL          250000
#define MAX_SPECIAL_PROPS	17
#define SPECIAL_PROP_VW		2546 //VW + playerid 
#define SPECIAL_FULL_SUPPS	7200 //seconds
#define SPECIAL_FULL_STOCK	21600	//seconds
#define SPECIAL_MAX_EARN	1000 //bodù
#define SPECIAL_SUPPS_PRICE	45.0 //cena za 25 % skladu (body)
#define SPECIAL_SUPP_TIME	60*20 //cas na dovezeni zasob
#define SPECIAL_DEST_REW	15 //body za znièení zásob
#define SPECIAL_MIN_TIME	24 //min nahranı èas (hodiny)
//--------------------------------
#define SHOP_TYPE_GANJA 	1
#define SHOP_TYPE_WEAPONS   2

#define STAND_TYPE_GANJA    0
#define STAND_TYPE_WEAPONS  1

#define DRAZBA_TYPE_GANJA   	0
#define DRAZBA_TYPE_POINTS  	1
#define DRAZBA_TYPE_VEHICLE 	2
#define DRAZBA_TYPE_PROPERTY	3
#define DRAZBA_TYPE_HOUSE       4
#define DRAZBA_TYPE_GANG        5

#define PRICE_TYPE_POINTS   0
#define PRICE_TYPE_MONEY    1

#define PICKUP_RADIUS   1.5

#define BONE_SPINE      1
#define BONE_HEAD       2
#define LEFT_UPPER_ARM 	3
#define RIGHT_UPPER_ARM 4
#define LEFT_HAND       5
#define RIGHT_HAND      6
#define LEFT_THIGH      7
#define RIGHT_THIGH     8
#define LEFT_FOREARM   	13
#define RIGHT_FOREARM   14
#define LEFT_CLAVICLE   15
#define RIGHT_CLAVICLE  16
/*
4	Right upper arm
5	Left hand
6	Right hand
7	Left thigh
8	Right thigh
9	Left foot
10	Right foot
11	Right calf
12	Left calf
13	Left forearm
15	Left clavicle (shoulder)
16	Right clavicle (shoulder)
17	Neck
18	Jaw
*/
//--------------------------------
//JOBS
#define JOB_NONE    	0
#define JOB_MAFIA   	1
#define JOB_YAKUZA  	2
#define JOB_PILOT   	3
#define JOB_MEDIC   	4
#define JOB_MECHANIC    5
#define JOB_PRAVNIK     6
#define JOB_POLICE      7
#define JOB_FIREMAN     8
#define JOB_SBS         9
#define JOB_VOJAK       10
#define JOB_DEALER      11
#define JOB_TERORIST    12
#define JOB_TAXI        13

#define PRUKAZY         3
#define P_RIDICKY       0
#define P_LETECKY       1
#define P_ZBROJNI       2

new PlayerText:Textdraw0[MAX_PLAYERS]; //Cas
new Text:Textdraw1; //Intro
new Text:Textdraw2; //Intro
new Text:Textdraw3; //Intro
new Text:Textdraw4; //Hodiny

enum ENUM_PlayerData
{
	bool:pLogged,
	bool:pNewBie,
	bool:pOldAcc,
	pSkin,
	pVehicle,
	pPlayerVehicle,
	pTest,
	pTestType,
	pLimitTimer,
	pPlayedTime,
	pPlayedTG,
	pAutoSave,
	pKills,
	pDeaths,
	pMoney,
	pBanka,
	pVyplata,
	pJob,
	pShoppingID,
	pShoppingTime,
	pShoppingType,
	pShoppingAmount,
	pShoppingPrice,
	pGanja,
	pGanjaEffect,
	pGanjaField,
	pGanjaFieldTime,
	pGanjaAction[2],
	pPrukazy[PRUKAZY],
	pJobXP[MAX_JOBS],
	pEditAddon,
	pOfferID,
	Float:pTaxa
}

enum ENUM_JobPickupData
{
	jType,
	Float:jX,Float:jY,Float:jZ,
	bool:jSlotUsed
}

enum ENUM_JobData
{
	jName[20],
	jColor,
	jMapIcon,
	jCashReward,
	jLicenses[PRUKAZY],
	jSkins[MAX_JSKINS],
}

new Job[MAX_JOBS][ENUM_JobData] =
{
	{ "Nezamìstnanı",		0xADADADFF,		0,		0,			{0,0,0},	{0,0,0,0,0,0,0,0,0,0} },
	{ "Ruská Mafia",		0xFF9900FF,		44,		15000,		{0,0,0},	{111,112,124,125,127,0,0,0,0,0} },
	{ "Yakuza",				0x6F3700FF,		43,		15000,		{0,0,0},	{117,118,122,123,0,0,0,0,0,0} },
	{ "Pilot",				0xFF0080FF,		5,		0,			{0,1,0},	{61,253,0,0,0,0,0,0,0,0} },
	{ "Zdravotník",			0x00FFCCFF,		22,		0,			{1,0,0},	{274,275,276,0,0,0,0,0,0,0} },
	{ "Mechanik",           0x99FFFFFF,     55,     0,			{1,0,0},	{50,73,0,0,0,0,0,0,0,0} },
	{ "Právník",            0xFFB164FF,     0,      15000,		{0,0,0},	{17,57,59,147,228,240,0,0,0,0} },
	{ "Policista",          0x33CCFFFF,     0,      0,			{1,0,1},	{280,281,282,283,284,285,286,288,304,307} },
	{ "Hasiè",              0xE10000FF,     20,     0,			{1,0,0},	{277,278,279,0,0,0,0,0,0,0} },
	{ "SBS",                0x808000FF,     18,     0,			{1,0,1},	{163,164,165,166,0,0,0,0,0,0} },
	{ "Voják",              0xAA3333FF,     19,     15000,		{1,0,1},	{287,179,0,0,0,0,0,0,0,0} },
	{ "Dealer",            	0x005100FF,     24,     15000,		{0,0,0},	{1,29,183,0,0,0,0,0,0} },
	{ "Terorista",          0xFFFF80FF,     42,     15000,		{0,0,0},	{30,42,100,0,0,0,0,0,0} },
	{ "Taxikáø",            0xF0F000FF,     60,     0,      	{1,0,0},	{189,0,0,0,0,0,0,0,0,0} }
};

new JobInfo[MAX_JOBS][400] =
{
	{ "Vašim úkolem je najít si zamìstnání" }, //None
	
	{ "Vašim úkolem je pøebírat podniky nepøátelské rodiny. Najdìte nemovitost patøící nepøátelské rodinì,\n\
	  vstupte na domeèek u nemovitosti a zvolte monost 'Zabrat' Spustí se Vám odpoèet na 20 sekund,\n\
	  po skonèení odpoètu pøipadne nemovitost Vaší rodinì a vy dostanete odmìnu + 1 bod" }, //Ruská Mafia

	{ "Vašim úkolem je pøebírat podniky nepøátelské rodiny. Najdìte nemovitost patøící nepøátelské rodinì,\n\
	  vstupte na domeèek u nemovitosti a zvolte monost 'Zabrat' Spustí se Vám odpoèet na 20 sekund,\n\
	  po skonèení odpoètu pøipadne nemovitost Vaší rodinì a vy dostanete odmìnu + 1 bod" }, //Yakuza

	{ "Vašim úkolem je pøeváet dokumenty, nastupte do vozidla Dodo a stisknìte klávesu SUBMISSION\n\
	  ( defaultnì + ) poté si zvolte z nabídky trasu, vyzvednìte dokumenty a doruète je na zvolené místo,\n\
	  za kadou splnìnou misí získáte odmìnu + 1 bod" }, //Pilot
	  
	{ "Vašim úkolem je léèit ranìné hráèe, nastupte do vozidla Ambulance a stisknìte klávesu SUBMISSION\n\
	  ( defaultnì + ) nebo zadejte pøíkaz /mise a zvolte misi 'Zdravotník' poté jeïte hledat ranìné hráèe\n\
	  za kadého vyléèeného hráèe získáte odmìnu + 1 bod" }, //Zdravotník

	{ "Vašim úkolem je odáet nepojízdná vozidla do autodílny, nastupte do vozidla Towtruck a stisknìte klávesu\n\
	  SUBMISSION ( defaultnì + ) poté dojeïte k vyznaèenému vozidlu a odtáhnìte ho do dílny\n\
	  za kadé odtaení vozidla získáte odmìnu + 1 bod" }, //Mechanik
	  
	{ "Vašim úkolem je soudit hledané hráèe, najdìte hledaného hráèe, pøíjïte k nìmu zadejte\n\
	   pøíkaz /soudit [ ID ]. Za kadé vysouzení získáte odmìnu (/taxa) + 1 zamìstnaneckı bod" }, //Právník
	
	{ "Vašim úkolem je zatıkat hledané hráèe, nastupte do policejního vozidla a stisknìte klávesu SUBMISSION\n\
	  ( defaultnì + ) nebo zadejte pøíkaz /mise a zvolte misi 'Policista' poté jeïte najít hledaného hráèe\n\
	  a klávesou LALT ho zatknìte, za kadé zatknutí dostanete odmìnu + 1 bod" }, //Policista
	  
	{ "Vyšim úkolem je hasit poáry, nastupte do hasièského vozidla a stisknìte klávesu SUBMISSION\n\
	  ( defaultnì + ) nebo zadejte pøíkaz /mise a zvolte misi 'Hasiè' poté jeïte k poáru, kterı se\n\
	  Vám vyznaèí na mapì èervenım checkpointem a uhaste ho, za kadı uhašenı poár získáte odmìnu + 1 bod" }, //Hasiè
	  
	{ "Toto zamìstnání nemá zatím ádné úkoly" }, //SBS

	{ "Vašim úkolem je zabíjet teroristy a hráèe s vysokım wanted-levelem (6+). Za kadé zabití\n\
	  dostanete odmìnu + 1 bod" }, //Voják

	{ "Vašim úkolem je pìstovat marihuanu. Najdìte si volné pole a pronajmìte si ho za "cg"10.000$"cdc"\n\
	  Pole pak zalívejte a hnojte, a marihuana dostateènì vyroste, sklide ji a získáte odmìnu,\n\
	  vypìstovanou marihuanu a 1 bod" }, //Dealer

	{ "Vašim úkolem je zabíjet èleny ochrannıch sloky San Andreas tj. Policie a Armáda\n\
	  Za kadé zabití èlena této sloky získáte odmìnu + 1 bod" }, //Terorista

	{ "Toto zamìstnání nemá zatím ádné úkoly" } //Taxikáø
};


new HelpMenu[][][] =
{
	{"Server",      "IP Serveru: "cg""SERVER_IP""cdc"\nWeb: "SERVER_WEB""cdc"\n\
	                Majitel: "cg""SERVER_OWNER""cdc"\nSpolumajitel: "cg"Jury"cdc"\n\
					Tvùrce: "cg"DeLeTe"},

	{"Premium Úèet","Premium Úèet se kupuje za body, není tedy potøeba platit ádnımi reálnımi penìzi\n\
					Seznam vše premium pøíkazù naleznete pod pøíkazem "cg"/premium"},

	{"Pøíkazy",     "Na serveru se nachází spousta pøíkazù\n\n\
	                Seznam základních pøíkazù: "cg"/cmds"cdc", "cg"/prikazy\n"cdc"Seznam Premium pøíkazù: "cg"/premium"},

	{"Body",		"Body na tomto serveru slouí jako další mìna, kupují se s nimi napø vozidla do garáe\n\
	         		Premium Úèet, Gangy atd. Body se dají získat rùznımi zpùsoby: plnìním misí, koupením ("cg"/shop"cdc")\n\
			 		zabíjením, vıhrou na eventu, darováním od hráèe apod." },

	{"Trestné body","Trestné body získáváte za kadé várování, umlèení, bloknutí pøíkazù a kick. Po dosaení 50 trestnıch bodù\n\
					budete zabanován na 168 hodin, trestné body starší 30 dnù budou automaticky prominuty, seznam vašich trestnıch bodù\n\
					zobrazíte pøíkazem {0077FF}/trestnebody\n\n"cg"Tabulka trestù:\n\
					"cdc"Varování: 3tb\nKick: 5tb\nUmlèení: poèet minut tb\nBloknutí pøíkazù: poèet minut tb"},

	{"Povolání",	"Na serveru je rozmístìno nìkolik povolání, v kadém povolání máte nìjakı úkol\n\
	              	ten zjistíte po napsání pøíkazu "cg"/job"cdc". Seznam všech povolání naleznete na úøadì" },

	{"Draby",      "Na serveru se nachází draby. Je moné drait: marihuanu, body, vozidla, nemovitosti, domy, gangy.\n\
					Drabu zahájíte pøíkazem /drazba, drait je moné v bodech nebo penìzích. Po zaloení draby\n\
					mùou hráèi do vaší draby pøihazovat, pokud se vám bude zdát nabídka vıhodná, mùete draenou vìc\n\
					hráèi prodat opìtovnım zadáním pøíkazu /drazba a zvolit monost: Prodat hráèi (hráè) za (cena)"},
	
  	{"Gará",		"Na serveru si mùete koupit vozidlo do garáe ("cg"/garaz"cdc") toto vozidlo Vám zùstane na poøád,\n\
	  				na vozidlu si mùete uloit vylepšení, které získáte v tuningové dílnì. Vozidlo si také\n\
					mùete pøivolat, respawnout, zamknout na heslo atd." },
					
	{"Duel",       	"2 Hráèi se spawnou v duel arénì s vybranou zbraní, ten kdo vyhraje nejvíce kol\n\
					vyhraje celı duel. Do duelu se pøipojíte pøíkazem "cg"/duel"},

	{"Sumo zápasy",	"2 Hráèi se spawnou na støeše budovy s vozidlem Sandking, kdo první shodí druhého\n\
					vyhraje. Do sumo zápasu se pøipojíte pøíkazem "cg"/sumo"},

	{"Závody",		"Skupinka hráèu mezi sebou závodí na vytvoøenıch závodních trasách s vybranım vozidlem,\n\
					kdo první projede cílem vyhrává. Je moné zaloit závod se zápisnım.\n\
					Závod zaloíte pøíkazem "cg"/zavody"},

	{"Stunty",		"Na serveru se nachází stunty, seznam všech stuntù naleznete pod pøíkazem "cg"/stunt"cdc", za kadé\n\
					první splnìní stuntu dostanete body + XP, za kadé další splnìní dostanete pouze XP"},

	{"DeathMatche", "Skupinka hráèù mezí sebou zápasí na vytvoøenıch DeathMatch zónách s vybranım zbranìmi\n\
					v této mini akci nikdo nevyhrává. Do DeathMatche se pøipojíte pøíkazem "cg"/dm"},

	{"Nemovitosti", "Na serveru jsou rozmístìny nemovitosti, které si mùete koupit. Maximálnì mùete vlastnit\n\
	                4 nemovitosti. Kadou nemovitost si mùete vylepšit na 20. level u dvou kategorií Produkce a Kasa,\n\
	                vylepšení jednoho levelu stojí "cg"50 bodù"cdc". Produkce vylepšuje prùmìrnı vıdìlek za hodinu\n\
	                a kasa zase maximální obsah kasy."},

	{"Vırobna zbraní",	"Na serveru se nachází nìkolik vıroben zbraní, které lze zakoupit. Pro to, aby Vırobna zbraní vydìlávala\n\
						musí mít neustále dostatek zásob aby mohla nemovitost produkovat zbranì. Zásoby doplníte buï zakoupením nebo\n\
						je ukradnete, pøi dovozu zásob Vás mohou pøepadnout i jiní hráèi, kteøí za znièení dostanou odmìnu.\n\
						Další podmínkou pro vıdìlek je nutnost bıt na serveru online. Dávejte pozor, abyste nepøekroèili maximální kapacitu skladu."},

	{"Domy",        "Na serveru jsou rozmístìny domy, které si mùete koupit. Maximálnì mùete vlastnit\n\
	                1 dùm. U domu si mùete nastavit spawn, zamknout dùm na heslo, èi zmìnit interiér.\n\
					Dùm si také mùete vyznaèit na mapì pøíkazem "cg"/houseloc"cdc".Normální domy mùete\n\
					vlastnit od 10 nahranıch hodin, elitní domy pak od 500 nahranıch hodin."},

	{"Gangy",       "Na serveru je rozmístìno 39 gangù, kadı gang mùe mít maximálnì 10 èlenù a 10 vozidel.\n\
					V gangu se získává respect, kterı lze získat zabíjením nepøátelskıch èlenù nebo zabíráním území.\n\
					Seznam všech gangù zobrazíte pøíkazem "cg"/gangy"},// "cdc"a seznam všech online èlenù pøíkazem "cg"/members"},

	{"Achievementy","Na serveru se nachází monost plnit achievementy, za kadı splnìnı achievement dostanete odmìnu\n\
					seznam všech splnìnıch i nesplnìnıch achievementù zobrazíte pøíkazem "cg"/achiev "cdc"po rozkliknutí zjistíte\n\
					jakou dostanete odmìnu po splnìní a kolik hráèù achievement splnilo"},

	{"Tituly",      "Na serveru si mùete nastavit titul pomocí pøíkazu "cg"/titul"cdc", tituly získáváte za plnìní achievementù\n\
					nebo pokud jste Elita nebo Legenda"},

	{"Tombola",     "Na serveru si mùete koupit losy do tomboly (1-5 losù), poté kaı den v 18:00 probáhí vylosovní (vygeneruje se náhodnı los).\n\
					Vlasntík vıherního losu obdrí všechny body, které se utratili za poøízení všech losù od všech zúèastnenıch hráèù.\n\
					Do tomboly se pøipojíte pøíkazem {00FF00}/tombola"},

	{"Kostka a Mince", "Na serveru je moné si hodit mincí, vsadíte maximálnì "cg"1000 bodù "cdc"na Pannu nebo Orla a podle toho co Vám padne\n\
						prohrajete nebo vyhrajete. Kostka zase funguje tak, e vyzevete hráèe o hod koskou o maximálnì "cg"100 000 bodù"cdc"\n\
						tomu komu padne vìtší èíslo (2 - 12) vyhraje vsazenou èástku"},

	{"Elita",       "Elita je nìco, co Vás dìlá vıjimeènımi od benıch/VIP hráèù. Elitu získate po dosaení 500 hodin a 50 levelu.\n\
					Poté získate vıhody jako napø.: Monost zakoupit elitní vozidlo do {00FF00}/garaz{A9C4E4} a nastavit si\n\
					dvojbarevnı titul {FFFFFF}Eli{0077FF}ta"},

	{"Legenda",     "Legenda je nìco, co Vás dìlá vıjimeènımi od Elitních hráèù. Legendu získate po dosaení 800 hodin a 50 levelu.\n\
					Poté získate vıhody jako napø.: 12 Warpù za minutu, hodnost Legenda pøi spawnu, /odpocet na 10 sekund a nastavit si\n\
					barevnı titul {FFBF00}Legenda. {A9C4E4}Na Walk of Fame bude také váš nic zvıraznìn"},
					
	{"Barvy",      	"V nìkterıch dialozích lze pouívat barvy (napø. /inzerat), barvy se zadávají do tìchto závorek { }\n\
					ve formátu {KÓD BARVY}\n\nSeznam kódù barev\n{FF0000}FF0000 - Èervená\n{00FF00}00FF00 - Zelená\n\
					{FFFF00}FFFF00 - lutá\n{FF00FF}FF00FF - Purpurová\n{0000FF}0000FF - Modrá\n{00FFFF}00FFFF - Svìtle modrá\
					"cdc"\n\nnamíchat lze i jiné barvy"}
};

new CommandList[][][] =
{
    {"/help",         	"Zobrazí nápovìdu"},
	{"/cmds",           "Seznam dalších pøíkazù"},
	{"/animace",        "Seznam animací"},
	{"/job",            "Zobrazí informace o povolání"},
	{"/info",           "Zobrazí informace o úètu"},
	{"/ulozit",         "Uloí herní úèet"},
	{"/kill",           "Sebevrada"},
	{"/givecash",       "Pošle hráèi peníze"},
	{"/giveammo",       "Pošle hráèi zbraò"},
	{"/vypoved",        "Podat vıpovìï"},
	{"/prodatmarihuanu","Prodá marihuanu"},
	{"/prijmout",       "Pøijme obchodní nabídku"},
	{"/zhulit",         "Zhlulí marihuanu"},
	{"/pustitzbrane",   "Pustí zbranì"},
	{"/drazba",         "Vytvoøí drabu"},
	{"/prihodit",       "Pøihodí do draby"},
	{"/drazby",         "Seznam draeb"},
	{"/doplnky",        "Správa doplòku postavy"},
	{"/pjobs",          "Zobrazí povolání online hráèù"},
	{"/taxa",			"Nastaví cenu za sluby u zamìstnání"}
};

new AnimCommandList[][] =
{
	{"/box"},
	{"/taichi"},
	{"/piss"},
	{"/dance"},
	{"/handsup"},
	{"/sit"},
	{"/ped"},
	{"/rap"},
	{"/deal"},
	{"/food"},
	{"/chat"},
	{"/wankin"},
	{"/wankout"},
	{"/robman"},
	{"/wave"},
	{"/medic"},
	{"/injured"},
	{"/kiss"},
	{"/strip"},
	{"/gangs"},
	{"/smoking"}
};

new LicenseNames[PRUKAZY][] =
{
	"Øidickı prùkaz",
	"Leteckı prùkaz",
	"Zbrojní prùkaz"
};

new JobRankNames[5][] =
{
	"Zaèáteèník",
	"Bìnı pracovník",
	"Pokroèilı pracovník",
	"Profesionální prácovník",
	"Expert ve svém oboru"
};

new Float:JobSpawn[MAX_JOBS][4] =
{
	{1606.6907,1820.5526,10.8280,359.9289}, //None
	{2177.1208,1719.3459,11.0469,131.2041}, //Ruská Mafia
	{1919.8618,962.3546,10.8203,128.4590}, //Yakuza
    {1319.0663,1253.3099,10.8203,356.2826}, //Pilot
	{1606.6907,1820.5526,10.8280,359.9289}, //Zdravotník
	{1101.8951,1796.5786,10.8203,230.0717}, //Mechanik
	{2415.6001,1123.7146,10.8203,270.0000}, //Právník
	{2295.5347,2451.3154,10.8203,94.1525}, //Policista
	{1776.3357,2078.9585,10.8203,116.7182}, //Hasiè
	{2261.5215,2038.5768,10.8203,89.7351}, //SBS
	{361.4728,2023.7751,22.6335,162.2351}, //Voják
	{-1097.0438,-1632.7438,76.3739,263.6377}, //Dealer
	{-1304.4734,2528.0298,87.6115,178.7064}, //Terorista
	{2202.3066,1823.7401,10.8203,125.5602} //Taxikáø
};

new JobWeapons[MAX_JOBS][13][2] =
{
	{{22,100},{4,1},{46,1},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //None
	{{26,1000},{28,1000},{30,1000},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //Ruská Mafia
	{{26,1000},{28,1000},{30,1000},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //Yakuza
	{{4,1},{28,1000},{46,1},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //Pilot
	{{4,1},{41,500},{40,1},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //Zdravotník
	{{9,1},{22,100},{41,500},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //Mechanik
	{{22,100},{32,1000},{41,500},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //Právník
    {{3,1},{24,100},{25,100},{31,500},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //Policista
	{{6,1},{37,100},{42,500},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //Hasiè
    {{27,700},{29,1000},{31,1000},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //SBS
	{{31,1000},{34,100},{16,20},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //Voják
    {{4,1},{18,20},{24,50},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //Dealer
    {{30,1000},{34,50},{16,10},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}, //Terorista
    {{5,1},{22,100},{40,1},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}} //Taxikáø
};

new Float:AutoskolaCP[][3] =
{
	{-2045.6188,-82.8829,34.7889},
	{-2092.3293,-67.8171,34.7935},
	{-2169.0336,-85.3786,34.7967},
	{-2238.0898,-188.0803,34.7938},
	{-2252.1311,-54.6804,34.7965},
	{-2250.1013,41.9771,34.7967},
	{-2341.5246,52.4252,34.7877},
	{-2373.9191,-56.1450,34.7955},
	{-2486.5620,-67.6839,26.3123},
	{-2498.8896,25.4925,25.1136},
	{-2435.3876,37.1408,34.3618},
	{-2418.8916,134.4520,34.6478},
	{-2398.4072,314.8046,34.6400},
	{-2318.5651,407.7718,34.6497},
	{-2255.5341,333.3906,34.4214},
	{-2131.5585,318.1661,34.7546},
	{-2020.8391,318.1923,34.6405},
	{-2009.1846,126.2243,27.1628},
	{-2009.0638,-56.5635,34.7917},
	{-2034.0604,-67.7928,34.7967},
	{-2046.6695,-95.7001,34.7942}
};

new Float:LeteckaskolaCP[][3] =
{
	{89.8214,2504.6477,33.8913},
	{-200.2263,2581.2761,80.4121},
	{-705.7348,2782.6606,115.0894},
	{-1202.3465,2806.6796,130.0951},
	{-1655.9816,2657.7448,125.3375},
	{-1847.6300,2478.6484,122.3227},
	{-1896.3480,2217.5085,107.1030},
	{-1739.2517,1841.9719,98.6593},
	{-1494.6843,1754.4981,104.5310},
	{-1149.4560,1809.3988,128.7751},
	{-762.7377,2020.3797,160.0777},
	{-585.0509,2301.4731,149.0389},
	{-314.5462,2462.9492,97.1577},
	{43.1469,2501.1933,28.9969},
	{299.3521,2502.8305,16.9441}
};

new CarMenuVehicles[][33] =
{
	{522,448,461,462,463,468,471,521,581,586},
	{481,509,510},
	{460,476,511,512,513,519,520,553,577,592,593},
	{417,425,447,469,487,488,497,548,563},
	{430,446,452,453,454,472,473,484,493,595},
	{411,541,415,402,429,451,475,477,496,494,502,503,506,558,559,565,587,589,602,603,434},
	{480,533,439,555},
	{560,562,401,405,410,419,421,426,436,445,466,467,474,491,492,504,507,516,517,518,526,527,529,540,542,546,547,549,550,551,580,585,604},
	{412,534,535,536,566,567,575,576},
	{400,424,470,489,495,500,505,444,556,557,568,573,579},
	{418,404,479,458,561},
	{416,433,431,438,437,427,490,528,407,544,596,597,598,599,432,601,420,409,423,428,442,457,485,525,574,583,588},
	{403,408,413,414,422,440,443,455,456,459,478,482,498,499,514,515,524,531,543,552,554,578,582,600,605,609,406,486,530,532},
	{441,464,465,501,564,594},
	{571,545,539,508,483}
};

new CarMenuCategories[][] =
{
	"Motorky",
	"Kola",
	"Letadla",
	"Helikoptéry",
	"Lodì",
	"Sportovní",
	"Kabriolety",
	"Salónová",
	"Lowridery",
	"Off-Road",
	"Dodávky",
	"Sluební",
	"Prùmyslová",
	"RC Modely",
	"Ostatní"
};

new WeaponsCategories[][] =
{
	"Pistole",
	"Brokovnice",
	"Odstøelovací pušky",
	"Útoèné pušky",
	"Samopaly"
};

new WeaponsList[][3] =
{
	{22,23,24},
	{25,26,27},
	{34,33},
	{31,30},
	{32,28,29}
};

enum ENUM_AddonsListData
{
	AddonName[30],AddonID,AddonBone,AddonPrice,
	AddonLevel,
	Float:AddonX,Float:AddonY,Float:AddonZ,
	Float:AddonrX,Float:AddonrY,Float:AddonrZ
}

new AddonsList[][ENUM_AddonsListData] =
{
	{"Policejní kšiltovka",18636,BONE_HEAD,45,5,			0.1750,0.0140,-0.0040,0.0000,82.4999,94.1000},
	{"Bílá kšiltovka",18933,BONE_HEAD,45,5,					0.1649,-0.0029,-0.0129,14.5999,-9.3001,6.6999},
	{"Èervená kšiltovka",18934,BONE_HEAD,45,5,				0.1649,-0.0029,-0.0129,14.5999,-9.3001,6.6999},
	{"Modrá kšiltovka",18957,BONE_HEAD,45,5,				0.1750,0.0140,-0.0040,0.0000,82.4999,94.1000},
	{"lutı šátek (na hlavu)",18894,BONE_HEAD,40,4,			0.1840,-0.0149,0.0000,-96.8999,-4.6999,-93.0999},
	{"Rùovı šátek (na hlavu)",18899,BONE_HEAD,40,4,		0.1840,-0.0149,0.0000,-96.8999,-4.6999,-93.0999},
	{"Modrı šátek (na hlavu)",18903,BONE_HEAD,40,4,			0.1840,-0.0149,0.0000,-96.8999,-4.6999,-93.0999},
	{"Zelenı šátek (na hlavu)",18898,BONE_HEAD,40,4,		0.1840,-0.0149,0.0000,-96.8999,-4.6999,-93.0999},
	{"Bílı šátek (na oblièej)",18919,BONE_HEAD,45,6,   		-0.0489,-0.0169,-0.0180,-97.7997,-29.8001,74.7999},
	{"lutı šátek (na oblièej)",18920,BONE_HEAD,45,6,  		-0.0489,-0.0169,-0.0180,-97.7997,-29.8001,74.7999},
	{"Modrı šátek (na oblièej)",18917,BONE_HEAD,45,6,  		-0.0489,-0.0169,-0.0180,-97.7997,-29.8001,74.7999},
	{"Šedı šátek (na oblièej)",18918,BONE_HEAD,45,6,   		-0.0489,-0.0169,-0.0180,-97.7997,-29.8001,74.7999},
	{"Rùovı šátek (na oblièej)",18915,BONE_HEAD,45,6, 		-0.0489,-0.0169,-0.0180,-97.7997,-29.8001,74.7999},
	{"Èernı šátek (na oblièej)",18912,BONE_HEAD,45,6,  		-0.0489,-0.0169,-0.0180,-97.7997,-29.8001,74.7999},
	{"Èernı šátek 2 (na oblièej)",18911,BONE_HEAD,45,6,		-0.0489,-0.0169,-0.0180,-97.7997,-29.8001,74.7999},
	{"Maskáèovı šátek (na oblièej)",18914,BONE_HEAD,45,6,	-0.0489,-0.0169,-0.0180,-97.7997,-29.8001,74.7999},
	{"Zelenı šátek (na oblièej)",18913,BONE_HEAD,45,6, 		-0.0489,-0.0169,-0.0180,-97.7997,-29.8001,74.7999},
	{"Brıle",19031,BONE_HEAD,60,7,   		           		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"Rùové brıle",19025,BONE_HEAD,60,7,              		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"Èervené brıle",19026,BONE_HEAD,60,7,            		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"luté brıle",19028,BONE_HEAD,60,7,              		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"Fialové brıle",19024,BONE_HEAD,60,7,            		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"Modré brıle",19023,BONE_HEAD,60,7,              		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"Rùové sluneèní brıle",19010,BONE_HEAD,60,7,     		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"Èerné sluneèní brıle",19138,BONE_HEAD,60,7,     		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"Oranové sluneèní brıle",19007,BONE_HEAD,60,7,   		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"Zelené sluneèní brıle",19008,BONE_HEAD,60,7,     		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"Policejní modré brıle",19140,BONE_HEAD,60,7,    		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"Policejní èervené brıle",19139,BONE_HEAD,60,7,   		0.1010,0.0490,-0.0060,93.4004,89.5999,-9.6999},
	{"Tmavá helma",18976,BONE_HEAD,210,20,					0.0880,0.0390,-0.0030,-62.0999,85.0998,165.4000},
	{"Èerná maska",19163,BONE_HEAD,210,20,					0.0879,0.0459,-0.0030,-62.0998,85.0998,-112.1000},
	{"Zelená maska",19038,BONE_HEAD,210,20,					0.0880,0.0390,-0.0030,-62.0999,85.0998,165.4000},
	{"Bílá maska",19036,BONE_HEAD,210,20,					0.0880,0.0390,-0.0030,-62.0999,85.0998,165.4000},
	{"Škraboška",19557,BONE_HEAD,210,20,					0.1011,0.0631,0.0020,-0.5996,-5.8000,-35.2000},
	{"Maska Zorra",18974,BONE_HEAD,210,20,					0.1219,0.0399,-0.0060,0.0000,78.2999,108.0999},
	{"Oranovı klobouk",18944,BONE_HEAD,55,6,				0.1980,0.0000,0.0000,0.0000,0.0000,0.0000},
	{"Hnìdı klobouk",18945,BONE_HEAD,55,6,					0.1980,0.0000,0.0000,0.0000,0.0000,0.0000},
	{"Èernı klobouk",18947,BONE_HEAD,55,6,					0.1980,0.0000,0.0000,0.0000,0.0000,0.0000},
	{"Èernı klobouk #2",19096,BONE_HEAD,55,6,				0.1980,0.0000,0.0000,0.0000,0.0000,0.0000},
	{"lutı klobouk",18951,BONE_HEAD,55,6,					0.1980,0.0000,0.0000,0.0000,0.0000,0.0000},
	{"Tmavı klobouk",18962,BONE_HEAD,55,6,					0.1980,0.0000,0.0000,0.0000,0.0000,0.0000},
	{"Èernı klobouk",19096,BONE_HEAD,55,6,					0.1980,0.0000,0.0000,0.0000,0.0000,0.0000},
	{"Hnìdı klobouk",19098,BONE_HEAD,55,6,					0.1980,0.0000,0.0000,0.0000,0.0000,0.0000},
	{"Policejní èepice",19521,BONE_HEAD,55,6,				0.1620,0.0000,0.0000,0.0000,0.0000,0.0000},
	{"Èarodìjnickı klobouk",19528,BONE_HEAD,285,20,			0.1980,0.0000,0.0000,0.0000,0.0000,0.0000},
	{"Slepièí hlava",19137,BONE_HEAD,210,25,				0.1039,0.0000,0.0000,0.0000,0.0000,0.0000},
	{"Neprùstøelná vesta",19515,BONE_SPINE,100,10,			0.0000,0.0340,0.0000,0.0000,0.0000,0.0000},
	{"Policejní vesta",19142,BONE_SPINE,120,10,				0.0000,0.0340,0.0000,0.0000,0.0000,0.0000},
	{"Reflexní vesta",19904,BONE_SPINE,90,10,				-0.0280,0.0810,0.0060,0.1000,95.2000,-168.3998},
	{"Chainsaw Dildo",19086,BONE_SPINE,340,9,				-0.2789,-0.2029,0.3389,10.3999,36.9000,-2.0999},
	{"Tmavá elektrická kytara",19317,BONE_SPINE,250,20,		0.0000,-0.1499,0.0000,0.8000,51.2999,1.1999},
	{"Elektická kytara",19318,BONE_SPINE,250,20,			0.0000,-0.1499,0.0000,0.8000,51.2999,1.1999},
	{"Warlock kytara",19319,BONE_SPINE,250,20,				0.0000,-0.1499,0.0000,0.8000,51.2999,1.1999},
	{"Pálka s høebíky",2045,BONE_SPINE,180,10,				0.0220,-0.1349,-0.0030,-4.8999,35.1999,-81.1000},
	{"Lopata",2228,BONE_SPINE,60,5,							0.0219,-0.1439,-0.0030,-5.7998,41.8999,178.4999},
	{"Rıè",2237,BONE_SPINE,60,5,							0.2219,-0.2049,0.3479,-2.9999,36.5999,8.8999},
	{"Èerveno bílé prkno",2404,BONE_SPINE,280,25,        	0.0000,-0.1499,0.0000,0.8000,51.2999,1.1999},
	{"Èerveno fialové prkno",2405,BONE_SPINE,280,25,     	0.0000,-0.1499,0.0000,0.8000,51.2999,1.1999},
	{"Prkno s motivem",2406,BONE_SPINE,280,25,    			0.0000,-0.1499,0.0000,0.8000,51.2999,1.1999},
	{"Hasièák",2690,BONE_SPINE,140,10,						0.0000,-0.1839,-0.0069,-0.8999,85.3999,-0.0999},
	{"Pytel s penìzi",1550,BONE_SPINE,150,10,				0.0000,-0.2370,0.0009,166.1000,86.4999,2.4999},
	{"Policejní štít",18637,RIGHT_FOREARM,237,10,			-0.0890,0.0050,0.0099,-0.2000,169.1999,173.7000},
	{"Papoušek (do pøedu)",19078,RIGHT_CLAVICLE,400,30,		0.1138,0.0390,-0.0529,19.6999,-85.5998,-169.7000},
	{"Papoušek (do zadu)",19079,RIGHT_CLAVICLE,400,30,		0.1599,-0.0790,-0.0529,0.9999,103.5000,-7.2000},
	{"Dopravní kuel",1238,BONE_HEAD,200,15, 				0.429,0.0169,0.0160,0.0000,83.0000,-6.4000},
	{"Batoh",3026,BONE_SPINE,80,5,							-0.1870,-0.0549,0.0000,0.0000,0.0000,0.0000},
	{"Turistická batoh",19559,BONE_SPINE,80,5,				-0.0619,-0.0659,0.0000,0.0000,-94.3999,0.0000},
	{"Hroší kostım",1371,BONE_SPINE,700,30,					0.2380,0.1199,0.0000,-0.1999,87.2999,175.5999},
	{"Plynová maska",19472,BONE_HEAD,55,6,   				-0.0489,0.1100,0.0150,146.6002,-12.1001,-150.8999}
};

enum ENUM_GanjaData
{
	bool:gSlotUsed,
	gPronajemID,
	Text3D:g3DText,
	gObject,
	gStatus,
	Float:gX,Float:gY,Float:gZ
}

enum ENUM_ShopData
{
	bool:sSlotUsed,
	Float:sX,Float:sY,Float:sZ,
	sType,
	sAmount
}

enum ENUM_WeaponDrop
{
	bool:wDSlotUsed,
	Float:wDX,Float:wDY,Float:wDZ,
	wDWeapons[13],wDAmmo[13],wDMoney,
	wDPickup,wDTimer,
	wDPlayer[24+1],wDVW
}

enum ENUM_PlayerDrazbaData
{
	bool:pDrazbaStatus,
	pDrazbaType,
	pDrazbaItem,
	pDrazbaAmount,
	pDrazbaPrice,
	pDrazbaPriceType,
	pDrazbaPlayer
}

enum ENUM_PlayerAddonsData
{
	pAddonID[MAX_ADDONS],
	Float:pAddonX[MAX_ADDONS],
	Float:pAddonY[MAX_ADDONS],
	Float:pAddonZ[MAX_ADDONS],
	Float:pAddonRX[MAX_ADDONS],
	Float:pAddonRY[MAX_ADDONS],
	Float:pAddonRZ[MAX_ADDONS],
	Float:pAddonSX[MAX_ADDONS],
	Float:pAddonSY[MAX_ADDONS],
	Float:pAddonSZ[MAX_ADDONS]
}

enum ENUM_SpecialPropActors
{
	aSkin,Float:aX,Float:aY,Float:aZ,Float:aA,aAnimLib[30],aAnimName[30]
}

new SpecialPropActors[][ENUM_SpecialPropActors] =
{
	{70,970.9703,2084.4004,11.0301,199.4538,"BD_FIRE","M_SMKLEAN_LOOP"},
	{144,975.9788,2082.7114,11.0301,42.7855,"BD_FIRE","M_SMKLEAN_LOOP"},
	{146,941.8237,2065.3518,10.8203,84.7726,"BD_FIRE","WASH_UP"},
	{146,942.0163,2069.0662,10.8203,83.2060,"BD_FIRE","WASH_UP"},
	{145,935.3604,2075.5925,10.8203,177.8335,"BD_FIRE","WASH_UP"},
	{145,929.5109,2075.3901,10.8203,183.7869,"BD_FIRE","WASH_UP"},
	{145,929.7650,2070.8901,10.8203,181.5936,"BD_FIRE","WASH_UP"},
	{145,935.4880,2070.7903,10.8203,181.5936,"BD_FIRE","WASH_UP"},
	{145,935.5883,2065.4902,10.8203,181.5936,"BD_FIRE","WASH_UP"},
	{145,929.8257,2065.3901,10.8203,181.5936,"BD_FIRE","WASH_UP"},
	{145,930.0447,2059.8901,10.8203,181.5936,"BD_FIRE","WASH_UP"},
	{145,935.5529,2059.8901,10.8203,181.5936,"BD_FIRE","WASH_UP"},
	{70,952.8344,2065.1240,10.8203,149.9232,"BD_FIRE","WASH_UP"}
};

enum ENUM_SpecialPropSupps
{
	sModel,Float:sX,Float:sY,Float:sZ,Float:sA,bool:sUsed
}

new SpecialPropSupps[][ENUM_SpecialPropSupps] =
{
	{428,1474.4354,787.4111,10.9456,179.0534},
	{482,1742.4036,688.0565,10.9431,269.2374},
	{428,1634.9597,983.4498,10.9459,269.9965},
	{482,1642.5332,1070.8397,10.9387,180.4147},
	{440,1935.3516,1783.4584,12.8378,359.2506},
	{427,2306.2170,2434.3062,10.9522,160.0077},
	{498,2510.4919,2530.0344,10.8908,90.2964},
	{455,2381.7749,2809.2974,11.2569,57.2659},
	{499,1050.2740,2109.3237,10.8102,88.5757},
	{456,1061.9126,1401.1095,5.9932,179.3610},
	{455,676.7411,969.3367,-12.2475,348.8731},
	{433,278.2379,1451.2327,11.0226,178.4497},
	{433,285.4966,1929.9453,18.0773,230.3025},
	{459,387.1170,2533.8193,16.5927,133.6404},
	{482,-788.1127,1617.2753,27.2431,245.4515},
	{428,-1503.2327,911.0311,7.3097,88.1732},
	{482,-1629.8285,884.7144,9.3881,180.6161},
	{440,-1808.3472,776.2315,31.3328,179.0399},
	{498,-2125.3484,654.3784,52.4106,91.0092},
	{601,-2441.1909,522.7388,29.6701,177.9499},
	{482,-2738.7947,105.5147,4.5554,180.6019},
	{428,-2754.5808,377.4970,4.3562,181.7691},
	{416,-2695.6494,624.9058,14.6015,126.2987},
	{414,-2525.9224,1229.1222,37.5221,29.7967},
	{413,-2639.1111,1396.1670,7.1891,285.9113},
	{499,-1785.8389,1203.6691,25.1168,179.8054},
	{427,-1628.5491,651.7162,7.3191,180.2998},
	{433,-1237.3113,470.9508,7.6241,120.9825},
	{455,-1822.4865,20.6072,15.5553,180.3104},
	{444,-1705.2250,14.6796,3.8220,136.1810},
	{428,-1949.5669,-1084.5183,30.8980,0.0068},
	{416,1179.9098,-1338.9235,13.9436,271.3645},
	{413,1439.5586,-1332.3636,13.6442,268.3660},
	{459,1027.7777,-1451.9318,13.5566,90.4634},
	{498,540.0832,-1282.3640,17.3111,326.7804},
	{573,497.3408,-1814.6132,6.4803,232.8299},
	{482,1061.5488,-1740.3685,13.5895,270.2579},
	{427,1573.1829,-1615.9647,13.5149,88.9703},
	{414,1664.8568,-1893.3818,13.6407,36.8088},
	{440,1837.5675,-1856.4501,13.5977,89.7442},
	{416,2016.9603,-1446.6084,15.2531,88.4099},
	{422,1916.2556,-2149.5986,13.5378,181.5986}
};

new Float:SpecialProps[MAX_SPECIAL_PROPS][4] =
{
	//X,Y,Z,Price (body)
	{966.5404,2160.6938,10.8203,2000.0},
	{1643.5560,2358.8259,10.8130,2000.0},
	{1504.3833,2363.8816,10.8203,2000.0},
	{1476.8314,2193.9011,11.0234,2000.0},
	{1617.9125,-1560.2795,14.1675,2000.0},
	{1660.0847,-1806.5034,13.5524,2000.0},
	{2347.3643,-2301.3401,13.5469,2000.0},
	{2553.1038,-2411.0564,13.6325,2000.0},
	{866.8581,-1202.6172,16.9766,2000.0},
	{-2138.0974,-248.0333,36.5156,2000.0},
	{-1979.1997,427.5773,24.7293,2000.0},
	{-1721.0480,-117.0102,3.5489,2000.0},
	{-154.4075,-289.5283,3.9053,1800.0},
	{710.0634,-569.1974,16.3359,1500.0},
	{1358.1115,362.0093,20.5009,1500.0},
	{-318.2052,2658.2356,63.8692,1800.0},
	{-2434.7405,2292.8381,4.9844,1800.0}
};

enum ENUM_PlayerSP
{
	pSPID,pSPSupplies,pSPStock,pSPEarning,pSPActors[sizeof(SpecialPropActors)],pSPSuppMapIcon,
	pSPSuppVehicle,pSPSuppRunning,pSPSuppState,pSPSuppID,pSPInProp
}

new PlayerSP[MAX_PLAYERS][ENUM_PlayerSP];
new PlayerAddons[MAX_PLAYERS][ENUM_PlayerAddonsData];
new Shops[MAX_SHOPS][ENUM_ShopData];
new Ganja[MAX_GANJAS][ENUM_GanjaData];
new WeaponDrop[MAX_WEAPON_DROP][ENUM_WeaponDrop];

new Player[MAX_PLAYERS][ENUM_PlayerData];
new PlayerDrazba[MAX_PLAYERS][ENUM_PlayerDrazbaData];
new JobPickup[MAX_PJOBS][ENUM_JobPickupData];

new bool: ShowedDialog[MAX_PLAYERS];

new Float:BankPos[MAX_BANKS][3];
new Float:PassesPos[MAX_PASSES][3];
new Float:OfficePos[MAX_OFFICES][3];
new Float:ClothesPos[MAX_CLOTHES][3];

main()
{
	print("+--------------------------------------+");
	print("|   ***        "GM_NAME"       ***   |");
	print("|  Autors: "GM_AUTOR"                      |");
	print("|  SA-MP Version:     [   0.3.7   ]    |");
	print("|  Gamemode Version:  [    "GM_VERSION"    ]    |");
	print("+--------------------------------------+\n");
	return 0;
}

public OnVehicleDeath(vehicleid, killerid)
{
	new str[145];
	for(new i; i <= GetPlayerPoolSize(); i ++)
		if(IPC(i) && !IsPlayerNPC(i))
			if(PlayerSP[i][pSPSuppState] != -1)
			{
				if(vehicleid == PlayerSP[i][pSPSuppVehicle])
				{
					for(new x; x <= GetPlayerPoolSize(); x ++)
					{
						if(IPC(x) && !IsPlayerNPC(x) && x != i)
						{
							new Float:X,Float:Y,Float:Z;
							GetVehiclePos(vehicleid,X,Y,Z);
							if(IsPlayerInRangeOfPoint(x, 30, X, Y, Z))
							{
								GivePlayerPoints(x,SPECIAL_DEST_REW);
								format(str,sizeof(str),"Obrel jste odmìnu "cg"%d bodù "cdc"za znièení zásob hráèe "cg"%s",SPECIAL_DEST_REW,Jmeno(i));
								SPD(x,0,DIALOG_STYLE_MSGBOX,"Znièení zásob",str,"Zavøít","");
							}
						}
					}
					SPD(i,0,DIALOG_STYLE_MSGBOX,"Doplnìní zásob",""cr"Doplnìní zásob selhalo\n\n"cdc"Vaše zásoby byly znièeny","Zavøít","");		
					CancelSupplyRun(i);
					break;
				}
			}
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	if(PlayerSP[forplayerid][pSPSuppRunning] > 0)
	{
		if(vehicleid == PlayerSP[forplayerid][pSPSuppVehicle])
		{
			DestroyDynamicMapIcon(PlayerSP[forplayerid][pSPSuppMapIcon]);
			new Float:X,Float:Y,Float:Z;
			GetVehiclePos(vehicleid,X,Y,Z);
			SetPlayerCheckpoint(forplayerid, X, Y, Z, 5);
			CreateInfoBox(forplayerid,"Zasoby","Zasoby jsou vyznaceny ~r~cervene ~w~na mapì",5);
			SM(forplayerid,"Zásoby jsou vyznaèeny "cr"èervenì "cw"na mapì");
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(PlayerSP[playerid][pSPSuppRunning] > 0)
	{
		if(IsPlayerInVehicle(playerid,PlayerSP[playerid][pSPSuppVehicle]) && PlayerSP[playerid][pSPSuppState] == 1)
		{
			new rand = SPECIAL_FULL_SUPPS/5+random(SPECIAL_FULL_SUPPS/6),str[145];
			if(PlayerSP[playerid][pSPSupplies]+rand > SPECIAL_FULL_SUPPS){
				rand = SPECIAL_FULL_SUPPS-PlayerSP[playerid][pSPSupplies];
				PlayerSP[playerid][pSPSupplies] = SPECIAL_FULL_SUPPS;
			}
			else
				PlayerSP[playerid][pSPSupplies] += rand;
			format(str,sizeof(str),"Zásoby doplnìny o "cg"%0.2f%% "cdc". Aktuálnì máte "cg"%0.2f%% "cdc"zásob",float((rand)*100)/SPECIAL_FULL_SUPPS,float((PlayerSP[playerid][pSPSupplies]*100))/SPECIAL_FULL_SUPPS);
			SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Zásoby doplnìny",str,"Zavøít","");
			SaveSpecialProperty(playerid);
			EnterPlayerSpecialProperty(playerid);
			CancelSupplyRun(playerid);
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	for(new i; i <= GetPlayerPoolSize(); i ++)
	{
		if(IPC(i) && !IsPlayerNPC(i) && playerid != i)
		{
			if(vehicleid == PlayerSP[i][pSPSuppVehicle])
			{
				TogglePlayerControllable(playerid, false);
				TogglePlayerControllable(playerid, true);
				SM(playerid,"Zniète tyto zásoby pro odmìnu");
			}		
		}
	}
	return 1;
}

public OnPlayerCommandPerformed(playerid,cmdtext[],success)
{
	new str[145];
	format(str,sizeof(str),"SERVER: Pøíkaz %s neexistuje -> /help",cmdtext);
	if(!success) return SCM(playerid,-1,str);
	return 1;
}

CMD:taxa(playerid,params[])
{
	new Float:taxa,str[145];
	if(sscanf(params,"f",taxa)) return SM(playerid,"Pouití: "cr"/taxa [ body ]");
	switch(Player[playerid][pJob])
	{
		case JOB_PRAVNIK:
		{
			format(str,sizeof(str),"Rozmezí taxy je "cg"0.0 - %0.1f bodù "cw"za hvìzdièku hledanosti",(GetPlayerJobRank(playerid)+1)*0.901);
			if(taxa < 0.0 || taxa > (GetPlayerJobRank(playerid)+1)*0.901) return SM(playerid,str);
			Player[playerid][pTaxa] = taxa;
			format(str,sizeof(str),"Taxa nastavena na "cg"%0.1f bodù "cw"za hvìzdièku hledanosti",taxa);
			SM(playerid,str);
		}
		default: SM(playerid,"U tohoto zamìstnání nelze nastavit taxu");
	}
	return 1;
}


CMD:pjobs(playerid,params[])
{
	new DIALOG[2000],str[145];
	for(new i; i <= GetPlayerPoolSize(); i ++)
	{
	    if(IPC(i) && !IsPlayerNPC(i))
	    {
	        format(str,sizeof(str),"%s(%d)\t{%06x}%s\n",Jmeno(i),i,Job[GetPlayerJob(i)][jColor] >>> 8,Job[GetPlayerJob(i)][jName]);
	        strcat(DIALOG,str);
	    }
	}
	SPD(playerid,0,DIALOG_STYLE_TABLIST,"Zamìstnání hráèù",DIALOG,"Zavøít","");
	return 1;
}

CMD:doplnky(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SM(playerid,"Nesmíte bıt ve vozidle");
	ShowAddonsMenu(playerid);
	return 1;
}

CMD:drazby(playerid,params[])
{
	new str[200],DIALOG[2000],drazby;
	for(new i; i <= GetPlayerPoolSize(); i ++)
	{
	    if(IPC(i) && !IsPlayerNPC(i))
	    {
	        if(PlayerDrazba[i][pDrazbaStatus] == true)
	        {
				drazby ++;
				switch(PlayerDrazba[i][pDrazbaType])
				{
				    case DRAZBA_TYPE_GANJA:
						format(str,sizeof(str),"%s(%d)\t| Draí: %dg marihuany "cr"| "cw"Aktuální cena: "cg"%s"cw" |\t/prihodit %d\n",Jmeno(i),i,PlayerDrazba[i][pDrazbaAmount],PriceTypeText(PlayerDrazba[i][pDrazbaPriceType],PlayerDrazba[i][pDrazbaPrice]),i);
				    case DRAZBA_TYPE_POINTS:
						format(str,sizeof(str),"%s(%d)\t| Draí: %d bodù "cr"| "cw"Aktuální cena: "cg"%s"cw" |\t/prihodit %d\n",Jmeno(i),i,PlayerDrazba[i][pDrazbaAmount],PriceTypeText(PlayerDrazba[i][pDrazbaPriceType],PlayerDrazba[i][pDrazbaPrice]),i);
				    case DRAZBA_TYPE_VEHICLE:
						format(str,sizeof(str),"%s(%d)\t| Draí: vozidlo %s "cr"| "cw"Aktuální cena: "cg"%s"cw" |\t/prihodit %d\n",Jmeno(i),i,GetVehicleName(GetPlayerVehicle(i,PlayerDrazba[i][pDrazbaItem])),PriceTypeText(PlayerDrazba[i][pDrazbaPriceType],PlayerDrazba[i][pDrazbaPrice]),i);
				    case DRAZBA_TYPE_PROPERTY:
						format(str,sizeof(str),"%s(%d)\t| Draí: nemovitost è.: %d (lvl: %d) "cr"| "cw"Aktuální cena: "cg"%s"cw" |\t/prihodit %d\n",Jmeno(i),i,PlayerDrazba[i][pDrazbaItem],GetPropertyLevel(PlayerDrazba[i][pDrazbaItem]),PriceTypeText(PlayerDrazba[i][pDrazbaPriceType],PlayerDrazba[i][pDrazbaPrice]),i);
				    case DRAZBA_TYPE_HOUSE:
						format(str,sizeof(str),"%s(%d)\t| Draí: dùm è.p.: %d "cr"| "cw"Aktuální cena: "cg"%s"cw" |\t/prihodit %d\n",Jmeno(i),i,PlayerDrazba[i][pDrazbaItem]+1,PriceTypeText(PlayerDrazba[i][pDrazbaPriceType],PlayerDrazba[i][pDrazbaPrice]),i);
				    case DRAZBA_TYPE_GANG:
						format(str,sizeof(str),"%s(%d)\t| Draí: gang %s "cr"| "cw"Aktuální cena: "cg"%s"cw" |\t/prihodit %d\n",Jmeno(i),i,GetGangName(PlayerDrazba[i][pDrazbaItem]),PriceTypeText(PlayerDrazba[i][pDrazbaPriceType],PlayerDrazba[i][pDrazbaPrice]),i);
					default:
					    format(str,sizeof(str),"Error\t \t \n");
				}
				strcat(DIALOG,str);
	        }
	    }
	}
	if(drazby > 0) SPD(playerid,0,DIALOG_STYLE_TABLIST,"Draby",DIALOG,"Zavøít","");
	else SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Draby","Momentálnì neprobíhá ádná draba","Zavøít","");
	return 1;
}

CMD:prihodit(playerid,params[])
{
	new id,castka,str[145];
	if(sscanf(params,"ii",id,castka)) return SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/prihodit [ ID ] [ Èástka ]");
	if(!IPC(id)) return SCM(playerid,RED,"[ ! ] "cw"Hráè s tímto ID není pøipojen");
	if(id == playerid) return SCM(playerid,RED,"[ ! ] "cw"Nemùete pøihodit do Vaší draby");
	if(PlayerDrazba[id][pDrazbaStatus] == false) return SCM(playerid,RED,"[ ! ] "cw"Tento hráè nic nedraí");
	if(PlayerDrazba[id][pDrazbaPriceType] == PRICE_TYPE_MONEY)
	{
		if(PlayerDrazba[id][pDrazbaPrice]+1 >= 1000000001) return SCM(playerid,RED,"[ ! ] "cw"Do této draby u nelze pøihazovat");
	    format(str,sizeof(str),"[ ! ] "cw"Minimálnì mùete pøihodit "cg"%s$",SeperateNumber(PlayerDrazba[id][pDrazbaPrice]+1));
	    if(castka < PlayerDrazba[id][pDrazbaPrice]+1) return SCM(playerid,RED,str);
	    if(GetMoney(playerid)+Player[playerid][pBanka] < castka) return SCM(playerid,RED,"[ ! ] "cw"Tolik penìz u sebe nemáte");
	}
	else
	{
	    format(str,sizeof(str),"[ ! ] "cw"Minimálnì mùete pøihodit "cg"%d bodù",PlayerDrazba[id][pDrazbaPrice]+1);
	    if(castka < PlayerDrazba[id][pDrazbaPrice]+1) return SCM(playerid,RED,str);
	    if(GetPlayerPoints(playerid) < castka) return SCM(playerid,RED,"[ ! ] "cw"Tolik bodù u sebe nemáte");
	}
	switch(PlayerDrazba[id][pDrazbaType])
	{
	    case DRAZBA_TYPE_GANJA:
	    	format(str,sizeof(str),"Hráè %s(%d) pøihodil "clg"%s "cpr"do draby o %dg marihuany. Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,PriceTypeText(PlayerDrazba[id][pDrazbaPriceType],castka),PlayerDrazba[id][pDrazbaAmount],id);
	    case DRAZBA_TYPE_POINTS:
	    	format(str,sizeof(str),"Hráè %s(%d) pøihodil "clg"%s "cpr"do draby o %d bodù. Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,PriceTypeText(PlayerDrazba[id][pDrazbaPriceType],castka),PlayerDrazba[id][pDrazbaAmount],id);
	    case DRAZBA_TYPE_VEHICLE:{
			if(CountPlayerVehicles(playerid) >= GetMaxVehicleSlots()) return SM(playerid,"U vlastníte maximální poèet vozidel");
	    	format(str,sizeof(str),"Hráè %s(%d) pøihodil "clg"%s "cpr"do draby o vozidlo %s. Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,PriceTypeText(PlayerDrazba[id][pDrazbaPriceType],castka),GetVehicleName(GetPlayerVehicle(id,PlayerDrazba[id][pDrazbaItem])),id);
		}
	    case DRAZBA_TYPE_PROPERTY:{
			if(GetPlayerPlayedTime(playerid) < 60*60*24) return SM(playerid,"Nemovitost si mùete koupit, a odehrajete na serveru minimálnì 24 hodin");
			else if(CountPlayerProperties(playerid) == GetMaxPropertiesPerPlayer()) return SM(playerid,"U vlastníte maximální poèet nemovitostí");
			else if(CountPlayerProperties(playerid) == GetPlayerPropertiesSlots(playerid)) return SM(playerid,"U vlastníte maximální poèet nemovitostí, navyšte si sloty v /myprops");
	    	format(str,sizeof(str),"Hráè %s(%d) pøihodil "clg"%s "cpr"do draby o nemovitost è.: %d (lvl: %d). Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,PriceTypeText(PlayerDrazba[id][pDrazbaPriceType],castka),PlayerDrazba[id][pDrazbaItem],GetPropertyLevel(PlayerDrazba[id][pDrazbaItem]),id);
		}
	    case DRAZBA_TYPE_HOUSE:{
	    	format(str,sizeof(str),"[ ! ] "cw"Tento dùm si mùete koupit, a odehrajete na serveru minimálnì %d hodin.",GetHouseNeedHours(PlayerDrazba[id][pDrazbaItem]));
			if(GetPlayerPlayedTime(playerid)/60/60 < GetHouseNeedHours(PlayerDrazba[id][pDrazbaItem])) return SCM(playerid,RED,str);
			else if(GetPlayerHouse(playerid) != -1) return SM(playerid,"U vlastníte maximální poèet domù");
	    	format(str,sizeof(str),"Hráè %s(%d) pøihodil "clg"%s "cpr"do draby o dùm è.p.: %d. Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,PriceTypeText(PlayerDrazba[id][pDrazbaPriceType],castka),PlayerDrazba[id][pDrazbaItem]+1,id);
		}
	    case DRAZBA_TYPE_GANG:{
			if(GetPlayerGang(playerid) != -1) return SM(playerid,"U vlastníte / jste èlenem gangu");
	    	format(str,sizeof(str),"Hráè %s(%d) pøihodil "clg"%s "cpr"do draby o gang %s. Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,PriceTypeText(PlayerDrazba[id][pDrazbaPriceType],castka),GetGangName(PlayerDrazba[id][pDrazbaItem]),id);
		}
	}
	SCMTA(PING_RED,str);
	PlayerDrazba[id][pDrazbaPrice] = castka;
	PlayerDrazba[id][pDrazbaPlayer] = playerid;
	return 1;
}

CMD:drazba(playerid,params[])
{
	if(PlayerDrazba[playerid][pDrazbaStatus] == false)
	{
	    SPD(playerid,22,DIALOG_STYLE_LIST,"Vytvoøit drabu","Marihuana\nBody\nVozidlo\nNemovitost\nDùm\nGang","Vybrat","Zavøít");
	}
	else
	{
	    new id = PlayerDrazba[playerid][pDrazbaPlayer],str[100],DIALOG[250];
		if(id != -1)
		{
		    if(!IPC(id))
		    {
		        PlayerDrazba[playerid][pDrazbaPlayer] = -1;
		        id = -1;
		    }
	        if(id != -1)
	        {
			    if(PlayerDrazba[playerid][pDrazbaPriceType] == PRICE_TYPE_MONEY)
			    {
		            if(GetMoney(id)+Player[id][pBanka] < PlayerDrazba[playerid][pDrazbaPrice])
		            {
				        PlayerDrazba[playerid][pDrazbaPlayer] = -1;
		            }
		        }
		        else
		        {
		            if(GetPlayerPoints(id) < PlayerDrazba[playerid][pDrazbaPrice])
		            {
				        PlayerDrazba[playerid][pDrazbaPlayer] = -1;
		            }
		        }
				if(PlayerDrazba[playerid][pDrazbaType] == DRAZBA_TYPE_VEHICLE)
				{
					if(CountPlayerVehicles(id) >= GetMaxVehicleSlots())
			        {
						PlayerDrazba[playerid][pDrazbaPlayer] = -1;
			        }
				}
				if(PlayerDrazba[playerid][pDrazbaType] == DRAZBA_TYPE_PROPERTY)
				{
					if(CountPlayerProperties(id) == GetPlayerPropertiesSlots(id))
			        {
						PlayerDrazba[playerid][pDrazbaPlayer] = -1;
			        }
				}
				if(PlayerDrazba[playerid][pDrazbaType] == DRAZBA_TYPE_HOUSE)
				{
					if(GetPlayerHouse(id) != -1)
					{
						PlayerDrazba[playerid][pDrazbaPlayer] = -1;
					}
				}
				if(PlayerDrazba[playerid][pDrazbaType] == DRAZBA_TYPE_GANG)
				{
				    if(GetPlayerGang(id) != -1)
				    {
						PlayerDrazba[playerid][pDrazbaPlayer] = -1;
				    }
				}
		    }
		}
 		id = PlayerDrazba[playerid][pDrazbaPlayer];
 		strcat(DIALOG,"Ukonèit drabu\n");
		if(IPC(id) && !IsPlayerNPC(id))
		{
		    if(PlayerDrazba[playerid][pDrazbaPriceType] == PRICE_TYPE_MONEY)
		    {
		    	format(str,sizeof(str),"Prodat hráèi "cg"%s "cw"za "cg"%s$\n",Jmeno(id),SeperateNumber(PlayerDrazba[playerid][pDrazbaPrice]));
			}
			else
			{
		    	format(str,sizeof(str),"Prodat hráèi "cg"%s "cw"za "cg"%d bodù\n",Jmeno(id),PlayerDrazba[playerid][pDrazbaPrice]);
			}
			strcat(DIALOG,str);
		}
		SPD(playerid,26,DIALOG_STYLE_LIST,"Draba",DIALOG,"Vybrat","Zavøít");
	}
	return 1;
}

CMD:saveall(playerid,params[])
{
	new str[100];
	if(!IsPlayerOnHighestLevel(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Na tento pøíkaz je tøeba mít nejvıšší oprávnìní.");
	SCM(playerid,0xADADADFF,"Start");
	for(new i; i <= GetPlayerPoolSize(); i++)
	{
		if(IPC(i) && !IsPlayerNPC(i))
		{
		    SaveData(i);
			format(str,sizeof(str),"%s [ "cg"Saved "cw"]",Jmeno(i));
			SCM(playerid,-1,str);
		    format(str,sizeof(str),""cg"%s uloeno [ Save All (%s) ]",Jmeno(i),Jmeno(playerid));
		    printEx(str);
		}
	}
	SCM(playerid,0xADADADFF,"Done");
	return 1;
}


CMD:pustitzbrane(playerid,params[])
{
	if(!DropWeapons(playerid,0)) return SCM(playerid,RED,"[ ! ] "cw"Nemáte u sebe ádné zbranì");
	return 1;
}

CMD:zhulit(playerid,params[])
{
	new amount;
	if(sscanf(params,"i",amount)) return SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/zhulit [ Mnoství (g) ]");
	if(amount < 1) return SCM(playerid,RED,"[ ! ] "cw"Chybnì zadané mnoství");
	if(Player[playerid][pGanja] < amount) return SCM(playerid,RED,"[ ! ] "cw"Tolik gramù marihuany u sebe nemáte");
	Player[playerid][pGanjaEffect] += amount*10;
	GivePlayerGanja(playerid,-amount,"/zhulit");
	GivePlayerDailyValueEx(playerid,DAILY_TYPE_SMOKE,amount);
	SetPlayerWeather(playerid,234);
	SetPlayerDrunkLevel(playerid,20000);
	return 1;
}

CMD:prijmout(playerid,params[])
{
	new price = Player[playerid][pShoppingPrice],amount = Player[playerid][pShoppingAmount],type = Player[playerid][pShoppingType],
				id = Player[playerid][pShoppingID],str[145];
	if(Player[playerid][pShoppingID] == -1) return SCM(playerid,RED,"[ ! ] "cw"Nikdo vám nic neprodává");
	if(!IPC(id)) return SCM(playerid,RED,"Hráè se odpojil");
	if(!IsPlayerNearPlayer(playerid,id)) return SCM(playerid,RED,"[ ! ] "cw"Musíte bıt blízko hráèe");
	if(GetMoney(playerid) < price) return SCM(playerid,RED,"Nemáte tolik penìz");
	if(GetMoney(id)+price < 0) return SCM(playerid,RED,"Hráè má u sebe pøíliš penìz");
	if(type == SHOP_TYPE_GANJA)
	{
    	if(Player[id][pGanja] < amount) return SCM(playerid,RED,"Hráè u nemá nabízenı poèet marihuany");
	}
	format(str,sizeof(str),"Koupení od hráèe %s",Jmeno(id));
	GivePlayerGanja(playerid,amount,str);
	format(str,sizeof(str),"Prodej hráèi %s",Jmeno(playerid));
	GivePlayerGanja(id,-amount,str);
	format(str,sizeof(str),"Obchod s hráèem %s",Jmeno(id));
	GiveMoney(playerid,-price,str);
	format(str,sizeof(str),"Obchod s hráèem %s",Jmeno(playerid));
	GiveMoney(id,price,str);
	Player[playerid][pShoppingID] = -1;
	Player[playerid][pShoppingTime] = 0;
	Player[playerid][pShoppingType] = 0;
	Player[playerid][pShoppingAmount] = 0;
	Player[playerid][pShoppingPrice] = 0;
	if(type == SHOP_TYPE_GANJA)
	{
		format(str,sizeof(str),"Hráè "cw"%s "cc"pøijal Vaši nabídku [ "cg"%dg "cc"Marihuany za "cy"%s$"cc" ]",Jmeno(playerid),amount,SeperateNumber(price));
		SCM(id,CYAN,str);
		format(str,sizeof(str),"Pøijal jste nabídku hráèe "cw"%s "cc"[ "cg"%dg "cc"Marihuany za "cy"%s$"cc" ]",Jmeno(id),amount,SeperateNumber(price));
		SCM(playerid,CYAN,str);
	}
	return 1;
}

CMD:prodatmarihuanu(playerid,params[])
{
	new id,price,ganja,str[145];
	if(sscanf(params,"iii",id,ganja,price)) return SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/prodatmarihuanu [ ID ] [ Poèet gramù ] [ Cena ]");
	if(!IPC(id)) return SCM(playerid,RED,"[ ! ] "cw"Hráè s tímto ID není pøipojen");
	if(id == playerid) return SCM(playerid,RED,"[ ! ] "cw"Nemùeš prodat marihuanu sám sobì");
	if(!IsPlayerNearPlayer(playerid,id)) return SCM(playerid,RED,"[ ! ] "cw"Musíte bıt blízko hráèe");
	if(Player[id][pShoppingID] == playerid) return SCM(playerid,RED,"[ ! ] "cw"Hráè u s vámi obchoduje");
	if(Player[id][pShoppingID] != -1) return SCM(playerid,RED,"[ ! ] "cw"Hráè u obchoduje s jinım hráèem");
	if(ganja > Player[playerid][pGanja]) return SCM(playerid,RED,"[ ! ] "cw"Nemáte u sebe tolik marihuany");
	if(ganja < 1) return SCM(playerid,RED,"[ ! ] "cw"Nemùete prodat zadanı poèet marihuany");
	if(price < 0) return SCM(playerid,RED,"[ ! ] "cw"Chybnì zadaná èástka");
	if(GetMoney(id) < price) return SCM(playerid,RED,"[ ! ] "cw"Hráè u sebe nemá tolik penìz");
	if(GetMoney(playerid)+price < 0) return SCM(playerid,RED,"[ ! ] "cw"Tolik penìz se vám do kapsy nevejde");
	Player[id][pShoppingID] = playerid;
	Player[id][pShoppingTime] = 20;
	Player[id][pShoppingType] = SHOP_TYPE_GANJA;
	Player[id][pShoppingPrice] = price;
	Player[id][pShoppingAmount] = ganja;
	format(str,sizeof(str),"Hráè "cw"%s "cc"Vám nabízí "cg"%dg "cc"marihuany za: "cy"%s$",Jmeno(playerid),ganja,SeperateNumber(price));
	SCM(id,CYAN,str);
	SCM(id,CYAN,"Pokud nabídku chcete pøijmout, napište pøíkaz: "cw"/prijmout"cc".");
	format(str,sizeof(str),"Nabídl jste hráèi "cw"%s "cc"marihuanu [ "cg"%dg "cc"] za: "cy"%s$",Jmeno(id),ganja,SeperateNumber(price));
	SCM(playerid,CYAN,str);
	return 1;
}

CMD:vypoved(playerid,params[])
{
	if(Player[playerid][pJob] == 0) return SCM(playerid,RED,"[ ! ] "cw"U jste nezamìstnanı");
	if(IsPlayerWorking(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Kdy jste v misi nemùete podat vıpovìï");
	CreateInfoBox(playerid,Job[Player[playerid][pJob]][jName],"Podal jste vıpovìï, stáváte se nezamìstnanım",5);
	Player[playerid][pJob] = 0;
	SetPlayerColor(playerid,Job[0][jColor]);
	ResetPlayerWeaponsEx(playerid);
    GivePlayerJobWeapons(playerid,0);
   	return 1;
}

CMD:givecash(playerid,params[])
{
	new id,money,str[128];
	if(sscanf(params,"ii",id,money)) return SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/givecash [ ID ] [ Èástka ]");
	if(!IPC(id)) return SCM(playerid,RED,"[ ! ] "cw"Hráè s tímto ID není pøipojen");
	if(id == playerid) return SCM(playerid,RED,"[ ! ] "cw"Nemùeš poslat peníze sám sobì");
	if(money < 1 || money > GetMoney(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Chybnì zadaná èástka");
	if(GetMoney(id)+money < 0) return SCM(playerid,RED,"[ ! ] "cw"Hráè má u sebe moc penìz");
	format(str,sizeof(str),"Dárek hráèi %s",Jmeno(id));
	GiveMoney(playerid,-money,str);
	format(str,sizeof(str),"Dárek od hráèe %s",Jmeno(playerid));
	GiveMoney(id,money,str);
	format(str,sizeof(str),"Poslal jste hráèi "cg"%s "cw"èástku "cg"%s$",Jmeno(id),SeperateNumber(money));
	SCM(playerid,BILA,str);
	format(str,sizeof(str),"Hráè "cg"%s "cw"Vám poslal "cg"%s$",Jmeno(playerid),SeperateNumber(money));
	SCM(id,BILA,str);
	return 1;
}

CMD:giveammo(playerid,params[])
{
	new id,ammo,str[145],weapon;
	if(sscanf(params,"ii",id,ammo)) return SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/giveammo [ ID ] [ Náboje ]");
	if(!IPC(id)) return SCM(playerid,RED,"[ ! ] "cw"Hráè s tímto ID není pøipojen");
	if(id == playerid) return SCM(playerid,RED,"[ ! ] "cw"Nemùeš poslat zbraò sám sobì");
	if(!IsPlayerNearPlayer(playerid,id,10)) return SCM(playerid,RED,"[ ! ] "cw"Musíte bıt blízko hráèe");
	if(IsPlayerOnEvent(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Hráè je na eventu, nemùeš mu poslat zbraò");
	if(IsPlayerOnMiniEvent(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Hráè je na mini-eventu, nemùeš mu poslat zbraò");
	if(GetPlayerWeapon(playerid) == 0) return SCM(playerid,RED,"[ ! ] "cw"Musíte mít v ruce zbraò");
	if(GetPlayerWeapon(playerid) == 38) return SCM(playerid,RED,"[ ! ] "cw"Tuto zbraò nelze nìkomu poslat");
	if(ammo < 1 || ammo > GetPlayerAmmo(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Chybnì zadány náboje");
	weapon = GetPlayerWeapon(playerid);
	GivePlayerWeaponEx(playerid,weapon,-ammo);
	GivePlayerWeaponEx(id,weapon,ammo);
	format(str,sizeof(str),"Poslal jste hráèi "cg"%s "cw"zbraò "cg"%s "cw"s "cg"%d "cw"náboji",Jmeno(id),GetWeaponNameEx(weapon),ammo);
	SCM(playerid,BILA,str);
	format(str,sizeof(str),"Hráè "cg"%s "cw"Vám poslal zbraò "cg"%s "cw"s "cg"%d "cw"náboji",Jmeno(playerid),GetWeaponNameEx(weapon),ammo);
	SCM(id,BILA,str);
	return 1;
}

CMD:soudit(playerid,params[])
{
	new id;
	if(GetPlayerJob(playerid) != JOB_PRAVNIK) return SCM(playerid,RED,"[ ! ] "cw"Musíte bıt zamìstnán jako "cr"Právník");
	if(sscanf(params,"i",id)) return SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/soudit [ ID ]");
	if(!IPC(id) || IsPlayerNPC(id)) return SCM(playerid,RED,"[ ! ] "cw"Hráè s tímto ID není pøipojen");
	if(!IsPlayerNearPlayer(playerid,id,3)) return SCM(playerid,RED,"[ ! ] "cw"Musíte bıt blízko hráèe");
	if(id == playerid) return SCM(playerid,RED,"[ ! ] "cw"Nemùete vysoudit sám sebe");
	if(GetPlayerWantedLevel(id) == 0) return SCM(playerid,RED,"[ ! ] "cw"Tento hráèe není hledanı");
	MakePlayerOffer(playerid,id,GetPlayerWantedLevel(id)*Player[playerid][pTaxa]);
	return 1;
}

CMD:ulozit(playerid,params[])
{
	SaveData(playerid);
	CreateInfoBox(playerid,"úèet","úspìšnì uloeno",3);
	new str[128];
    format(str,sizeof(str),""cg"%s uloeno [ /ulozit ]",Jmeno(playerid));
    printEx(str);
	return 1;
}

CMD:kill(playerid,params[])
{
	SetPlayerHealth(playerid,0);
	CreateInfoBox(playerid,"Sebevrada","Spáchal jste sebevradu",3);
	return 1;
}

CMD:help(playerid,params[])
{
	ShowHelpMenu(playerid);
	return 1;
}

CMD:info(playerid,params[])
{
	ShowPlayerInfo(playerid,playerid);
	return 1;
}

CMD:job(playerid,params[])
{
	ShowJobInfo(playerid,Player[playerid][pJob]);
	return 1;
}

CMD:prikazy(playerid,params[])
{
	new DIALOG[1000],str[30];
	for(new i; i < sizeof(CommandList); i ++)
	{
		format(str,sizeof(str),"{0077FF}%s\t",CommandList[i][0]);
		strcat(DIALOG,str);
		strcat(DIALOG,CommandList[i][1]);
		strcat(DIALOG,"\n");
	}
	SPD(playerid,13,DIALOG_STYLE_TABLIST,"Pøíkazy",DIALOG,"Vybrat","Zavøít");
	return 1;
}

CMD:animace(playerid,params[])
{
	new DIALOG[1000],str[30];
	for(new i; i < sizeof(AnimCommandList); i ++)
	{
		format(str,sizeof(str),"{0077FF}%s\n",AnimCommandList[i]);
		strcat(DIALOG,str);
	}
	SPD(playerid,14,DIALOG_STYLE_LIST,"Animace",DIALOG,"Vybrat","Zavøít");
	return 1;
}

//ANIMS
CMD:box(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	ApplyAnimation(playerid,"GYMNASIUM","GYMshadowbox",4.1,0,1,1,1,1,1);
	return 1;
}

CMD:piss(playerid,params[])
{   
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	SetPlayerSpecialAction(playerid,68);
	return 1;
}

CMD:dance(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	switch(strval(params))
	{
	    case 1: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
	    case 2: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);
	    case 3: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);
	    case 4: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE4);
		default: SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/dance [1 - 4]");
	}
	return 1;
}

CMD:handsup(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:sit(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	switch(strval(params))
	{
	    case 1: ApplyAnimation(playerid,"BEACH","ParkSit_M_loop",4.1,0,1,1,1,1,1);
	    case 2: ApplyAnimation(playerid,"Attractors","Stepsit_in",4.1,0,1,1,1,1,1);
	    case 3: ApplyAnimation(playerid,"SUNBATHE","batherdown",4.1,0,1,1,1,1,1);
		default: SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/sit [1 - 3]");
	}
	return 1;
}

CMD:ped(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	switch(strval(params))
	{
	    case 1: ApplyAnimation(playerid,"PED","CAR_jackedLHS",4.1,0,1,1,1,1,1);
	    case 2: ApplyAnimation(playerid,"PED","CAR_jackedRHS",4.1,0,1,1,1,1,1);
	    case 3: ApplyAnimation(playerid,"PED","SEAT_down",4.1,0,1,1,1,1,1);
	    case 4: ApplyAnimation(playerid,"PED","fucku",4.1,0,1,1,1,1,1);
	    case 5: ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1,0,1,1,1,1,1);
	    case 6: ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,1,1,1,1,1);
	    case 7: ApplyAnimation(playerid,"PED","FLOOR_hit_f",4.1,0,1,1,1,1,1);
	    case 8: ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,1,1,1);
	    case 9: ApplyAnimation(playerid,"PED","KO_shot_stom",4.1,0,1,1,1,1,1);
	    case 10: ApplyAnimation(playerid,"PED","KO_shot_face",4.1,0,1,1,1,1,1);
	    case 11: ApplyAnimation(playerid,"PED","EV_dive",4.1,0,1,1,1,1,1);
	    case 12: ApplyAnimation(playerid,"PED","BIKE_elbowL",4.1,0,1,1,1,1,1);
	    case 13: ApplyAnimation(playerid,"PED","BIKE_fallR",4.1,0,1,1,1,1,1);
	    case 14: ApplyAnimation(playerid,"PED","CAR_doorlocked_LHS",4.1,0,1,1,1,1,1);
	    case 15: ApplyAnimation(playerid,"PED","CAR_pulloutL_LHS",4.1,0,1,1,1,1,1);
	    case 16: ApplyAnimation(playerid,"PED","CAR_pulloutL_RHS",4.1,0,1,1,1,1,1);
	    case 17: ApplyAnimation(playerid,"PED","CAR_pullout_LHS",4.1,0,1,1,1,1,1);
	    case 18: ApplyAnimation(playerid,"PED","CAR_pullout_RHS",4.1,0,1,1,1,1,1);
	    case 19: ApplyAnimation(playerid,"PED","gang_gunstand",4.1,0,1,1,1,1,1);
	    case 20: ApplyAnimation(playerid,"PED","Driveby_L",4.1,0,1,1,1,1,1);
	    case 21: ApplyAnimation(playerid,"PED","Driveby_R",4.1,0,1,1,1,1,1);
	    case 22: ApplyAnimation(playerid,"PED","WALK_gang2",4.1,0,1,1,1,1,1);
	    case 23: ApplyAnimation(playerid,"PED","WALK_gang1",4.1,0,1,1,1,1,1);
	    case 24: ApplyAnimation(playerid,"PED","sprint_civi",4.1,0,1,1,1,1,1);
	    case 25: ApplyAnimation(playerid,"PED","cower",4.1,0,1,1,1,1,1);
	    case 26: ApplyAnimation(playerid,"PED","ARRESTgun",4.1,0,1,1,1,1,1);
		default: SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/ped [1 - 26]");
	}
	return 1;
}

CMD:rap(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	switch(strval(params))
	{
		case 1: ApplyAnimation(playerid,"RAPPING","RAP_C_Loop",4.1,0,1,1,1,1,1);
		case 2: ApplyAnimation(playerid,"RAPPING","RAP_A_Loop",4.1,0,1,1,1,1,1);
		case 3: ApplyAnimation(playerid,"RAPPING","Laugh_01",4.1,0,1,1,1,1,1);
		case 4: ApplyAnimation(playerid,"RIOT","RIOT_shout",4.1,0,1,1,1,1,1);
		case 5: ApplyAnimation(playerid,"RIOT","RIOT_CHANT",4.1,0,1,1,1,1,1);
		default: SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/rap [1 - 5]");
	}
	return 1;
}

CMD:deal(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	switch(strval(params))
	{
		case 1: ApplyAnimation(playerid,"COP_AMBIENT","Coplook_loop",4.1,0,1,1,1,1,1);
		case 2: ApplyAnimation(playerid,"DEALER","DEALER_DEAL",4.1,0,1,1,1,1,1);
		case 3: ApplyAnimation(playerid,"DEALER","DEALER_IDLE",4.1,0,1,1,1,1,1);
		default: SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/deal [1 - 3]");
	}
	return 1;
}

CMD:food(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	switch(strval(params))
	{
		case 1: ApplyAnimation(playerid,"FOOD","EAT_Burger",4.1,0,1,1,1,1,1);
		case 2: ApplyAnimation(playerid,"FOOD","EAT_Vomit_P",4.1,0,1,1,1,1,1);
		default: SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/food [1 - 2]");
	}
	return 1;
}

CMD:chat(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1,0,1,1,1,1,1);
	return 1;
}

CMD:wankin(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	ApplyAnimation(playerid,"PAULNMAC","wank_loop",4.1,0,1,1,1,1,1);
	return 1;
}

CMD:wankout(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	ApplyAnimation(playerid,"PAULNMAC","wank_out",4.1,0,1,1,1,1,1);
	return 1;
}

CMD:robman(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	ApplyAnimation(playerid,"SHOP","ROB_Loop_Threat",4.1,0,1,1,1,1,1);
	return 1;
}

CMD:wave(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	ApplyAnimation(playerid,"ON_LOOKERS","wave_loop",4.1,0,1,1,1,1,1);
	return 1;
}

CMD:medic(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	ApplyAnimation(playerid,"MEDIC","CPR",4.1,0,1,1,1,1,1);
	return 1;
}

CMD:injured(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	ApplyAnimation(playerid,"SWEET","Sweet_injuredloop",4.1,0,1,1,1,1,1);
	return 1;
}

CMD:taichi(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	ApplyAnimation(playerid,"PARK","Tai_Chi_Loop",4.1,0,1,1,1,1,1);
	return 1;
}

CMD:kiss(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	switch(strval(params))
	{
	    case 1: ApplyAnimation(playerid,"KISSING","BD_GF_Wave",4.1,0,1,1,1,1,1);
	    case 2: ApplyAnimation(playerid,"KISSING","gfwave2",4.1,0,1,1,1,1,1);
	    case 3: ApplyAnimation(playerid,"KISSING","GF_CarArgue_01",4.1,0,1,1,1,1,1);
	    case 4: ApplyAnimation(playerid,"KISSING","GF_CarArgue_02",4.1,0,1,1,1,1,1);
	    case 5: ApplyAnimation(playerid,"KISSING","GF_CarSpot",4.1,0,1,1,1,1,1);
	    case 6: ApplyAnimation(playerid,"KISSING","GF_StreetArgue_01",4.1,0,1,1,1,1,1);
	    case 7: ApplyAnimation(playerid,"KISSING","GF_StreetArgue_02",4.1,0,1,1,1,1,1);
	    case 8: ApplyAnimation(playerid,"KISSING","gift_give",4.1,0,1,1,1,1,1);
	    case 9: ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_01",4.1,0,1,1,1,1,1);
	    case 10: ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_02",4.1,0,1,1,1,1,1);
	    case 11: ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_03",4.1,0,1,1,1,1,1);
	    case 12: ApplyAnimation(playerid,"KISSING","Playa_Kiss_01",4.1,0,1,1,1,1,1);
	    case 13: ApplyAnimation(playerid,"KISSING","Playa_Kiss_02",4.1,0,1,1,1,1,1);
	    case 14: ApplyAnimation(playerid,"KISSING","Playa_Kiss_03",4.1,0,1,1,1,1,1);
		default: SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/kiss [1 - 14]");
	}
	return 1;
}

CMD:strip(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	switch(strval(params))
	{
	    case 1: ApplyAnimation(playerid,"STRIP","PLY_CASH",4.1,0,1,1,1,1,1);
	    case 2: ApplyAnimation(playerid,"STRIP","PUN_CASH",4.1,0,1,1,1,1,1);
	    case 3: ApplyAnimation(playerid,"STRIP","PUN_HOLLER",4.1,0,1,1,1,1,1);
	    case 4: ApplyAnimation(playerid,"STRIP","PUN_LOOP",4.1,0,1,1,1,1,1);
	    case 5: ApplyAnimation(playerid,"STRIP","strip_A",4.1,0,1,1,1,1,1);
	    case 6: ApplyAnimation(playerid,"STRIP","strip_B",4.1,0,1,1,1,1,1);
	    case 7: ApplyAnimation(playerid,"STRIP","strip_C",4.1,0,1,1,1,1,1);
	    case 8: ApplyAnimation(playerid,"STRIP","strip_D",4.1,0,1,1,1,1,1);
	    case 9: ApplyAnimation(playerid,"STRIP","strip_E",4.1,0,1,1,1,1,1);
	    case 10: ApplyAnimation(playerid,"STRIP","strip_F",4.1,0,1,1,1,1,1);
	    case 11: ApplyAnimation(playerid,"STRIP","strip_G",4.1,0,1,1,1,1,1);
	    case 12: ApplyAnimation(playerid,"STRIP","STR_A2B",4.1,0,1,1,1,1,1);
	    case 13: ApplyAnimation(playerid,"STRIP","STR_B2A",4.1,0,1,1,1,1,1);
	    case 14: ApplyAnimation(playerid,"STRIP","STR_B2C",4.1,0,1,1,1,1,1);
	    case 15: ApplyAnimation(playerid,"STRIP","STR_C1",4.1,0,1,1,1,1,1);
	    case 16: ApplyAnimation(playerid,"STRIP","STR_C2",4.1,0,1,1,1,1,1);
	    case 17: ApplyAnimation(playerid,"STRIP","STR_C2B",4.1,0,1,1,1,1,1);
	    case 18: ApplyAnimation(playerid,"STRIP","STR_Loop_A",4.1,0,1,1,1,1,1);
	    case 19: ApplyAnimation(playerid,"STRIP","STR_Loop_B",4.1,0,1,1,1,1,1);
	    case 20: ApplyAnimation(playerid,"STRIP","STR_Loop_C",4.1,0,1,1,1,1,1);
		default: SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/strip [1 - 20]");
	}
	return 1;
}

CMD:gangs(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	switch(strval(params))
	{
	    case 1: ApplyAnimation(playerid,"GANGS","hndshkba",4.1,0,1,1,1,1,1);
	    case 2: ApplyAnimation(playerid,"GANGS","hndshkda",4.1,0,1,1,1,1,1);
	    case 3: ApplyAnimation(playerid,"GANGS","hndshkfa_swt",4.1,0,1,1,1,1,1);
	    case 4: ApplyAnimation(playerid,"GANGS","prtial_gngtlkH",4.1,0,1,1,1,1,1);
	    case 5: ApplyAnimation(playerid,"GANGS","prtial_gngtlkD",4.1,0,1,1,1,1,1);
	    case 6: ApplyAnimation(playerid,"GANGS","shake_carSH",4.1,0,1,1,1,1,1);
	    case 7: ApplyAnimation(playerid,"GANGS","shake_cara",4.1,0,1,1,1,1,1);
	    case 8: ApplyAnimation(playerid,"GANGS","leanIDLE",4.1,0,1,1,1,1,1);
		default: SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/gangs [1 - 8]");
	}
	return 1;
}

CMD:smoking(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid,RED,"[ ! ] "cw"Nesmíte bıt ve vozidle");
	switch(strval(params))
	{
	    case 1: ApplyAnimation(playerid,"SMOKING","M_smk_tap",4.1,0,1,1,1,1,1);
	    case 2: ApplyAnimation(playerid,"SMOKING","M_smk_in",4.1,0,1,1,1,1,1);
	    case 3: ApplyAnimation(playerid,"SMOKING","M_smklean_loop",4.1,0,1,1,1,1,1);
	    case 4: ApplyAnimation(playerid,"SMOKING","F_smklean_loop",4.1,0,1,1,1,1,1);
	    case 5: ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",4.1,0,1,1,1,1,1);
	    case 6: ApplyAnimation(playerid,"SMOKING","M_smk_out",4.1,0,1,1,1,1,1);
		default: SCM(playerid,RED,"[ ! ] "cw"Pouití: "cr"/smoking [1 - 6]");
	}
	return 1;
}

function PlayerSecondTimer(playerid)
{
	if(Player[playerid][pLogged] == true)
	{
		new str[145];
		if(PlayerSP[playerid][pSPID] != -1)
		{
			if(PlayerSP[playerid][pSPSupplies] > 0)
				if(PlayerSP[playerid][pSPStock] < SPECIAL_FULL_STOCK && PlayerSP[playerid][pSPSuppState] == -1){
					PlayerSP[playerid][pSPSupplies] --;
					PlayerSP[playerid][pSPStock] ++;
				}
		}
		Player[playerid][pAutoSave] ++;
		if(Player[playerid][pAutoSave] == 60*10)
		{
		    Player[playerid][pAutoSave] = 0;
		    format(str,sizeof(str),""cg"%s Automaticky uloeno",Jmeno(playerid));
		    printEx(str);
		    SaveData(playerid);
		}
		if(Player[playerid][pGanjaEffect] > 0)
		{
		    Player[playerid][pGanjaEffect] --;
		    if(Player[playerid][pGanjaEffect] == 0)
		    {
				SetPlayerWeather(playerid,1);
				SetPlayerDrunkLevel(playerid,0);
		    }
		    else
		    {
		        new Float:Health;
		        GetPlayerHealth(playerid,Health);
		        if(Health < 100)
		        {
					SetPlayerHealth(playerid,Health+1);
		        }
				SetPlayerWeather(playerid,234);
				SetPlayerDrunkLevel(playerid,20000);
		    }
		}
		if(Player[playerid][pShoppingTime] > 0)
		{
			Player[playerid][pShoppingTime] --;
			if(Player[playerid][pShoppingTime] == 0)
			{
			    SCM(playerid,CYAN,"Nabídka byla automaticky zamítnuta");
				SCM(Player[playerid][pShoppingID],CYAN,"Vaše nabídka byla automaticky zamítnuta");
			    Player[playerid][pShoppingID] = -1;
			    Player[playerid][pShoppingType] = 0;
				Player[playerid][pShoppingAmount] = 0;
				Player[playerid][pShoppingPrice] = 0;
			}
		}
		if(Player[playerid][pLimitTimer] > 0)
		{
		    Player[playerid][pLimitTimer] --;
			format(str,sizeof(str),"cas: ~w~%s",SecondsToMinutes(Player[playerid][pLimitTimer]));
			PlayerTextDrawSetString(playerid,Textdraw0[playerid],str);
		    if(Player[playerid][pTest] > 0)
		    {
		        new Float:vHealth;
		        GetVehicleHealth(Player[playerid][pPlayerVehicle],vHealth);
		        if(vHealth < 950)
		        {
		            Player[playerid][pTest] = 0;
		            Player[playerid][pTestType] = 0;
		            SetPlayerVirtualWorld(playerid,0);
		            DestroyPlayerVehicle(playerid);
		            DisablePlayerRaceCheckpoint(playerid);
		            CreateInfoBox(playerid,"Autoškola","Nesloil jste zkoušky (~y~znièil jste vozidlo~w~)",5);
			        CancelLimitTimer(playerid);
		        }
		    }
		    if(Player[playerid][pLimitTimer] == 0)
		    {
		        if(Player[playerid][pTest] > 0)
		        {
		            Player[playerid][pTest] = 0;
		            Player[playerid][pTestType] = 0;
		            SetPlayerVirtualWorld(playerid,0);
		            DestroyPlayerVehicle(playerid);
		            DisablePlayerRaceCheckpoint(playerid);
		            CreateInfoBox(playerid,"Autoškola","Nesloil jste zkoušky (~y~došel vám èas~w~)",5);
		        }
		        if(IsPlayerSupplyRun(playerid))
		        {
		        	SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Doplnìní zásob",""cr"Doplnìní zásob selhalo"cdc"\n\nDošel vám èás","Zavøít","");
		        	CancelSupplyRun(playerid);
		        }
		        CancelLimitTimer(playerid);
			}
		}
		if(Player[playerid][pGanjaFieldTime] > 0)
		{
		    new ganjaid = Player[playerid][pGanjaField];
		    if(Player[playerid][pGanjaAction][1] > 0)
		    {
            	Player[playerid][pGanjaAction][1] --;
            	if(Player[playerid][pGanjaAction][1] == 0)
            	{
            	    Ganja[ganjaid][gStatus] ++;
            	    if(Ganja[ganjaid][gStatus] != 10)
	            	    format(str,sizeof(str),"Vypestovano ~y~%d%%~n~~w~Marihuana potrebuje ~y~%s",Ganja[ganjaid][gStatus]*10,(Player[playerid][pGanjaAction][0] != 1) ? ("zalit") : ("pohnojit"));
				  	else
	            	    format(str,sizeof(str),"Vypestovano ~y~%d%%~n~~w~Pripraveno ke ~r~sklizeni",Ganja[ganjaid][gStatus]*10);
	        	    CreateInfoBox(playerid,"Marihuana",str,5);
                    MoveDynamicObject(Ganja[ganjaid][gObject],Ganja[ganjaid][gX],Ganja[ganjaid][gY],Ganja[ganjaid][gZ]-2+(float(Ganja[ganjaid][gStatus])*0.1),0.1);
            	}
			}
		    Player[playerid][pGanjaFieldTime] --;
            UpdateGanjaText(ganjaid);
		    if(Player[playerid][pGanjaFieldTime] == 0)
		    {
				if(Player[playerid][pGanjaField] != -1)
				{
				    Ganja[ganjaid][gPronajemID] = -1;
		            UpdateGanjaText(Player[playerid][pGanjaField]);
				    Player[playerid][pGanjaField] = -1;
                    Player[playerid][pGanjaAction][0] = 0;
                    Player[playerid][pGanjaAction][1] = 0;
                    MoveDynamicObject(Ganja[ganjaid][gObject],Ganja[ganjaid][gX],Ganja[ganjaid][gY],Ganja[ganjaid][gZ]-2,2);
				}
		    }
		}
		if(GetMoney(playerid) != GetPlayerMoney(playerid))
		{
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,GetMoney(playerid));
		}
	}
}

function SecondTimer()
{
	new hours,minutes,str[20];
	gettime(hours,minutes);
	format(str,sizeof(str),"%02d:%02d",hours,minutes);
	TextDrawSetString(Textdraw4,str);
}

public OnGameModeInit()
{
	AddPlayerClass(0, 1958.33, 1343.12, 15.36, 269.15, 26, 36, 28, 150, 0, 0);

	SetGameModeText(""GM_NAME" "GM_VERSION"");
	EnableStuntBonusForAll(false);
	AllowInteriorWeapons(true);
	ShowPlayerMarkers(true);
	UsePlayerPedAnims();
	ShowNameTags(true);

	mysql_log(LOG_NONE);
	mysql = mysql_connect(DOF2_GetString(CONFIG,"DB_HOST"), DOF2_GetString(CONFIG,"DB_USER"), DOF2_GetString(CONFIG,"DB_NAME"), DOF2_GetString(CONFIG,"DB_PASS"));
	if(mysql_errno(mysql) != 0)
	{
		printf("[ "GM_NAME" ] MySQL (%s) [ FAIL ] [ SHUTTED DOWN ]",DOF2_GetString(CONFIG,"DB_NAME"));
		SendRconCommand("exit");
		return 0;
	}
	else
	{
		printf("[ "GM_NAME" ] MySQL (%s) [ OK ]",DOF2_GetString(CONFIG,"DB_NAME"));
		mysql_tquery(mysql,"SET character_set_client=cp1250");
		mysql_tquery(mysql,"SET character_set_connection=cp1250");
		mysql_tquery(mysql,"SET character_set_results=cp1250");
	}

	CreateSpecialProperties();

	CreateJob(JOB_MAFIA,2169.7664,1711.8387,11.0469); //LV
	CreateJob(JOB_MAFIA,-1673.2389,1367.0319,7.1722); //SF
	CreateJob(JOB_PILOT,1715.2097,1616.5674,10.0548); //LV
	CreateJob(JOB_PILOT,-1543.8795,-440.9693,6.0000); //SF
	CreateJob(JOB_PILOT,1956.9459,-2183.6123,13.5469); //LS
	CreateJob(JOB_YAKUZA,1906.1869,956.6627,10.8203); //LV
	CreateJob(JOB_YAKUZA,-2172.6973,680.0135,55.1620); //SF
	CreateJob(JOB_MEDIC,1615.2050,1818.6062,10.8203); //LV
	CreateJob(JOB_MEDIC,-2649.7976,635.6573,14.4531); //SF
	CreateJob(JOB_MEDIC,1177.4781,-1323.2365,14.0727); //LS
	CreateJob(JOB_MEDIC,2036.6229,-1413.0352,16.9922); //LS (Grove)
	CreateJob(JOB_MECHANIC,1941.4959,2184.6660,10.8203); //LV
	CreateJob(JOB_MECHANIC,-2101.9546,-391.1818,35.5313); //SF
	CreateJob(JOB_MECHANIC,2772.8943,-1819.5541,11.8438); //LS
	CreateJob(JOB_PRAVNIK,359.0569,177.7526,1008.3828); //LV
	CreateJob(JOB_PRAVNIK,1724.4799,-1652.6080,20.0625); //LS
	CreateJob(JOB_POLICE,234.8417,158.7875,1003.0234); //LV
	CreateJob(JOB_POLICE,252.0671,65.3440,1003.6406); //LS
	CreateJob(JOB_FIREMAN,1770.4496,2079.6157,10.8203); //LV
	CreateJob(JOB_FIREMAN,-2026.5299,67.2462,28.6916); //SF
	CreateJob(JOB_FIREMAN,1742.8964,-1459.7411,13.5066); //LS
	CreateJob(JOB_SBS,2262.0061,2036.5695,10.8203); //SBS LV
	CreateJob(JOB_SBS,-1819.2751,-150.1722,9.3984); //SBS SF
	CreateJob(JOB_SBS,1304.7100,-795.7449,84.1406); //SBS LS
	CreateJob(JOB_VOJAK,349.5813,2024.0856,22.6406); //LV
	CreateJob(JOB_VOJAK,-1525.9418,485.4807,7.1797); //SF
	CreateJob(JOB_VOJAK,2731.5181,-2417.1606,13.6279); //LS
	CreateJob(JOB_DEALER,-1111.0803,-1637.2302,76.3672); //Farma
	CreateJob(JOB_DEALER,-367.3138,-1427.6720,25.7266); //LS
	CreateJob(JOB_TERORIST,-1303.2765,2541.6926,93.3047); //Pouš
	CreateJob(JOB_TAXI,2184.1016,1815.7340,10.8203); //LV
	CreateJob(JOB_TAXI,-1861.9761,-145.2125,11.8984); //SF
	CreateJob(JOB_TAXI,2140.5413,-1176.5918,23.9922); //LS

	CreatePasses(-2026.8015,-114.3421,1035.1719);
	CreatePasses(1174.3197,1350.9845,10.9219);
	
	CreateOffice(362.2020,173.6784,1008.3828);
	CreateOffice(1721.7863,-1652.5521,20.0625);

	CreateBank(1716.0206,1532.7479,10.7645);
	CreateBank(816.1764,-1386.4691,13.6071);
	CreateBank(-1968.4409,308.1987,35.1719);
	CreateBank(-1549.6012,1168.7358,7.1875);
	CreateBank(2194.9407,1994.4663,12.2969);
	CreateBank(2703.4121,-1698.6483,11.8438);
	
	CreateClothesShop(201.9133,-131.2659,1003.5078); //Pro-Laps
	CreateClothesShop(208.8657,-3.7935,1001.2178); //Victim
	CreateClothesShop(214.1359,-41.8719,1002.0234); //Suburban
	CreateClothesShop(181.4458,-88.0928,1002.0234); //Zip
	CreateClothesShop(218.0923,-98.8627,1005.2578); //Binco

	CreateShop(STAND_TYPE_GANJA,"Obchod",19592,144,-1098.1539, -1630.4641, 76.5799, 0.0000, 0.0000, -90.0000,-1097.1717, -1629.9863, 76.9346,-1099.3429,-1629.9720,76.3672,269.4851);
	CreateShop(STAND_TYPE_WEAPONS,"Zbranì",1239,179,0,0,0,0,0,0,296.0396,-80.8119,1001.5156,296.2161,-82.5308,1001.5156,359.0092);

	CreateGanja(-1071.00000, -1630.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1071.00000, -1634.50000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1071.00000, -1639.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1071.00000, -1625.50000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1071.00000, -1621.00000, 76.26200,   0.00000, 0.00000, -90.00000);

	CreateGanja(-1065.50000, -1639.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1065.50000, -1634.50000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1065.50000, -1630.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1065.50000, -1621.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1065.50000, -1625.50000, 76.26200,   0.00000, 0.00000, -90.00000);

	CreateGanja(-1059.50000, -1639.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1059.50000, -1634.50000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1059.50000, -1630.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1059.50000, -1621.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1059.50000, -1625.50000, 76.26200,   0.00000, 0.00000, -90.00000);

	CreateGanja(-1053.50000, -1639.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1053.50000, -1634.50000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1053.50000, -1630.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1053.50000, -1621.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1053.50000, -1625.50000, 76.26200,   0.00000, 0.00000, -90.00000);

	CreateGanja(-1047.50000, -1639.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1047.50000, -1634.50000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1047.50000, -1630.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1047.50000, -1621.00000, 76.26200,   0.00000, 0.00000, -90.00000);
	CreateGanja(-1047.50000, -1625.50000, 76.26200,   0.00000, 0.00000, -90.00000);

	Textdraw1 = TextDrawCreate(180.000000, 107.000000, "~w~~h~Vitejte na Un");
	TextDrawBackgroundColor(Textdraw1, 255);
	TextDrawFont(Textdraw1, 0);
	TextDrawLetterSize(Textdraw1, 0.879899, 2.900000);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetOutline(Textdraw1, 1);
	TextDrawSetProportional(Textdraw1, 1);
	TextDrawSetSelectable(Textdraw1, 0);

	Textdraw2 = TextDrawCreate(338.000000, 106.000000, "Named~w~~h~ modu");
	TextDrawBackgroundColor(Textdraw2, 255);
	TextDrawFont(Textdraw2, 0);
	TextDrawLetterSize(Textdraw2, 0.879899, 2.900000);
	TextDrawColor(Textdraw2, 7864319);
	TextDrawSetOutline(Textdraw2, 1);
	TextDrawSetProportional(Textdraw2, 1);
	TextDrawSetSelectable(Textdraw2, 0);

	Textdraw3 = TextDrawCreate(471.000000, 135.000000, "Verze "GM_VERSION"");
	TextDrawAlignment(Textdraw3, 3);
	TextDrawBackgroundColor(Textdraw3, 255);
	TextDrawFont(Textdraw3, 2);
	TextDrawLetterSize(Textdraw3, 0.199899, 1.200000);
	TextDrawColor(Textdraw3, -10092289);
	TextDrawSetOutline(Textdraw3, 1);
	TextDrawSetProportional(Textdraw3, 1);
	TextDrawSetSelectable(Textdraw3, 0);

	
	Textdraw4 = TextDrawCreate(551.200000, 24.000000, "_");
//	TextDrawAlignment(Textdraw4, 2);
//	TextDrawBackgroundColor(Textdraw4, 255);
	TextDrawFont(Textdraw4, 3);
	TextDrawLetterSize(Textdraw4, 0.55, 2);
//	TextDrawColor(Textdraw4, -1);
	TextDrawSetOutline(Textdraw4, 2);
//	TextDrawSetProportional(Textdraw4, 1);
//	TextDrawSetSelectable(Textdraw4, 0);

	SetTimer("SecondTimer",1000,true);
	return 1;
}

public OnGameModeExit()
{
	DOF2_Exit();
	return 1;
}

function ConnectCamera(playerid)
{
	InterpolateCameraPos(playerid, 2057.992675, 829.817382, 43.597534, 2058.122314, 1649.025390, 45.675346, 120000);
	InterpolateCameraLookAt(playerid, 2057.971923, 834.725280, 42.642501, 2058.122314, 1649.025390, 45.675346, 120000);
	return 1;
}

public OnPlayerConnect(playerid)
{
	printf("[ DG RZE ] %s -> Connecting",Jmeno(playerid));
//	new str[128];
//	if(IsPlayerBanned(playerid) == 0)
//	{
//		format(str,sizeof(str),"Hráè %s pøišel naserver (ID: %d)",Jmeno(playerid),playerid);
//		SCMTA(0xAFAFAFFF,str);
//	}
	if(!IsPlayerNPC(playerid))
	{
		SetTimerEx("ConnectCamera",100,false,"i",playerid);
        SetPlayerPos(playerid,1606.6907,1820.5526,10.8280);
		TextDrawShowForPlayer(playerid,Textdraw1);
		TextDrawShowForPlayer(playerid,Textdraw2);
		TextDrawShowForPlayer(playerid,Textdraw3);
		TextDrawShowForPlayer(playerid,Textdraw4);
		new file[50];
		format(file,sizeof(file),"%s.dudb.sav",udb_encode(Jmeno(playerid)));
		if(fexist(file) && !fexist(USER_FILES(playerid)))
		{
			Player[playerid][pOldAcc] = true;
			SPD(playerid,4000,DIALOG_STYLE_PASSWORD,"Pøihlášení","Zadejte vaše heslo","Zadat","Odejít");
		}
		Player[playerid][pGanjaField] = -1;
		Player[playerid][pShoppingID] = -1;
		Player[playerid][pEditAddon] = -1;
		Player[playerid][pOfferID] = -1;
		PlayerSP[playerid][pSPID] = -1;
		PlayerSP[playerid][pSPSuppState] = -1;
		PlayerSP[playerid][pSPSuppID] = -1;
		PlayerDrazba[playerid][pDrazbaPlayer] = -1;
		for(new x; x < MAX_ADDONS; x ++)
		{
	    	PlayerAddons[playerid][pAddonID][x] = -1;
		}
//		PlayerPlaySound(playerid, 1185, 2113.621, 1683.4001, 10.5078);
//		SCM(playerid,GREEN,"Hrajete na Realne Zemi DG");
		SetPlayerColor(playerid,0xAFAFAFFF);

		Textdraw0[playerid] = CreatePlayerTextDraw(playerid,635.000000, 275.000000, "cas: ~w~00:00");
		PlayerTextDrawAlignment(playerid,Textdraw0[playerid], 3);
		PlayerTextDrawBackgroundColor(playerid,Textdraw0[playerid], 255);
		PlayerTextDrawFont(playerid,Textdraw0[playerid], 2);
		PlayerTextDrawLetterSize(playerid,Textdraw0[playerid], 0.190000, 1.399999);
		PlayerTextDrawColor(playerid,Textdraw0[playerid], 7864319);
		PlayerTextDrawSetOutline(playerid,Textdraw0[playerid], 1);
		PlayerTextDrawSetProportional(playerid,Textdraw0[playerid], 1);
		PlayerTextDrawSetSelectable(playerid,Textdraw0[playerid], 0);

	}
	printf("[ DG RZE ] %s -> Connected",Jmeno(playerid));
	return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
	if(!IsPlayerNPC(playerid))
	{
		CancelSupplyRun(playerid);
		for(new i; i < MAX_PLAYERS; i ++)
		{
			if(IsPlayerConnected(i))
			{
				if(Player[i][pOfferID] == playerid)
					Player[i][pOfferID] = -1;
			    if(Player[i][pShoppingID] == playerid)
			    {
			        SCM(i,CYAN,"Nabídka byla automaticky zrušena, hráè se odpojil");
			        Player[i][pShoppingID] = -1;
			        Player[i][pShoppingTime] = 0;
				    Player[i][pShoppingType] = 0;
					Player[i][pShoppingAmount] = 0;
					Player[i][pShoppingPrice] = 0;
			    }
			    if(Player[playerid][pShoppingID] == i)
			    {
			        SCM(i,CYAN,"Nabídka byla automaticky zrušena, hráè se odpojil");
			    }				
			}
		}
		if(Player[playerid][pGanjaField] != -1)
		{
		    new ganjaid = Player[playerid][pGanjaField];
	        MoveDynamicObject(Ganja[ganjaid][gObject],Ganja[ganjaid][gX],Ganja[ganjaid][gY],Ganja[ganjaid][gZ]-2,2);
		    Ganja[Player[playerid][pGanjaField]][gPronajemID] = -1;
	        UpdateGanjaText(Player[playerid][pGanjaField]);
		}
		ShowedDialog[playerid] = false;
		SaveData(playerid,0);
		DestroyVehicle(Player[playerid][pVehicle]);
		for(new i; ENUM_PlayerData:i < ENUM_PlayerData; i ++)
		    Player[playerid][ENUM_PlayerData:i] = 0;
		for(new i; ENUM_PlayerSP:i < ENUM_PlayerSP; i ++)
		    PlayerSP[playerid][ENUM_PlayerSP:i] = 0;
		for(new i; ENUM_PlayerDrazbaData:i < ENUM_PlayerDrazbaData; i ++)
		{
		    PlayerDrazba[playerid][ENUM_PlayerDrazbaData:i] = 0;
		}
		for(new i; ENUM_PlayerAddonsData:i < ENUM_PlayerAddonsData; i ++)
		{
	    	PlayerAddons[playerid][ENUM_PlayerAddonsData:i] = 0;
		}
	}
	new str[128];
	switch(reason)
	{
		case 0: format(str,sizeof(str),"Hráè %s opustil server. (Pád Hry)",Jmeno(playerid));
		case 1: format(str,sizeof(str),"Hráè %s odešel ze serveru",Jmeno(playerid));
		case 2: format(str,sizeof(str),"");
	}
	if(IsPlayerBanned(playerid) == 0 && strlen(str))
		SCMTA(0xAFAFAFFF,str);
	return 1;
}

public OnPlayerRequestClass(playerid,classid)
{
	if(!IsPlayerNPC(playerid))
	{
		if(Player[playerid][pLogged] == false && Player[playerid][pOldAcc] == false)
		{
		    if(!fexist(USER_FILES(playerid)))
		    {
				SPD(playerid,1,DIALOG_STYLE_PASSWORD,"Registrace","Prosím zadejte heslo, kterım se pozdìji budete pøihlašovat","Registrovat","Odejít");
			}
			else
			{
				SPD(playerid,1,DIALOG_STYLE_PASSWORD,"Pøihlášení","Prosím zadejte heslo, které jste zadal pøi registraci","Pøihlásit","Odejít");
			}
		}
		SetPlayerPos(playerid, 2180.8125, 1285.5476, 42.8084);
		SetPlayerFacingAngle(playerid, 89.624);
/*		switch(random(8))
		{
			case 0:
			{
				SetPlayerCameraPos(playerid, 2016.0831, 1669.5897, 13.3373);
				SetPlayerCameraLookAt(playerid, 2006.3176, 1669.4318, 17.201);
			}
			case 1:
			{
				SetPlayerCameraPos(playerid, 2057.7805, 1014.6895, 10.91);
				SetPlayerCameraLookAt(playerid, 2021.9477, 1008.3184, 15.2925);
			}
			case 2:
			{
				SetPlayerCameraPos(playerid, 2098.1823, 1159.0108, 24.5625);
				SetPlayerCameraLookAt(playerid, 2205.0881, 1103.565, 38.9416);
			}
			case 3:
			{
				SetPlayerCameraPos(playerid, 2064.3659, 1511.3061, 49.3666);
				SetPlayerCameraLookAt(playerid, 1999.7075, 1549.5496, 13.5859);
			}
			case 4:
			{
				SetPlayerCameraPos(playerid, 2109.0573, 1956.987, 10.8388);
				SetPlayerCameraLookAt(playerid, 2070.1162, 1910.0932, 37.2484);
			}
			case 5:
			{
				SetPlayerCameraPos(playerid, 1819.6752, 1571.9051, 36.7925);
				SetPlayerCameraLookAt(playerid, 1908.5758, 1522.5449, 13.871);
			}
			case 6:
			{
				SetPlayerCameraPos(playerid, 2602.3122, 1612.4586, 43.5872);
				SetPlayerCameraLookAt(playerid, 2487.9414, 1532.0664, 10.8162);
			}
			case 7:
			{
				SetPlayerCameraPos(playerid, 2160.5881, 1285.2786, 24.4754);
				SetPlayerCameraLookAt(playerid, 2172.6491, 1285.7404, 29.7654);
			}
		}
*/
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(Player[playerid][pLogged] == false && !IsPlayerNPC(playerid))
	{
	    return 0;
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(!IsPlayerNPC(playerid))
	{
		for(new i; i < MAX_ADDONS; i ++)
		{
			if(!IsPlayerAttachedObjectSlotUsed(playerid,i))
			{
				new Float:X,Float:Y,Float:Z,Float:rX,Float:rY,Float:rZ,Float:scX,Float:scY,Float:scZ,addonid = PlayerAddons[playerid][pAddonID][i];
				if(addonid != -1)
				{
					X = PlayerAddons[playerid][pAddonX][i];
					Y = PlayerAddons[playerid][pAddonY][i];
					Z = PlayerAddons[playerid][pAddonZ][i];
					rX = PlayerAddons[playerid][pAddonRX][i];
					rY = PlayerAddons[playerid][pAddonRY][i];
					rZ = PlayerAddons[playerid][pAddonRZ][i];
					scX = PlayerAddons[playerid][pAddonSX][i];
					scY = PlayerAddons[playerid][pAddonSY][i];
					scZ = PlayerAddons[playerid][pAddonSZ][i];
				    SetPlayerAttachedObject(playerid,i,AddonsList[addonid][AddonID],AddonsList[addonid][AddonBone],X,Y,Z,rX,rY,rZ,scX,scY,scZ);
				}
			}
		}
		ResetPlayerWeapons(playerid);
		ResetPlayerWeaponsEx(playerid);
//		PlayerPlaySound(playerid, 1186, 2259.8911, 1689.52, 104.5027);
	    new job = Player[playerid][pJob];
		if(Player[playerid][pNewBie] == true)
		{
			SCM(playerid,0xFC9803AA,"[TIP] Hru by jste mìl zaèít tím,e navštívíte úøad");
			SCM(playerid,0xEFEFF7AA,"Tento úøad se nachází v Las Venturas mezi pyramidou a ammo (èervenı domek na mapì).");
			SCM(playerid,0xEFEFF7AA,"Seznam volnıch pracovních míst naleznete na úøadì");
//			SCM(playerid,0xEFEFF7AA,"Pokud si chcete zavolat taxi nebo jiné sluby pouijte /telefon");
			SetPlayerPos(playerid,1683.8811,1449.0717,10.7711);
			SetPlayerColor(playerid,SEDA);
			Player[playerid][pNewBie] = false;
		}
		else
		{
		    SetPlayerPos(playerid,JobSpawn[job][0],JobSpawn[job][1],JobSpawn[job][2]);
			SetPlayerFacingAngle(playerid,JobSpawn[job][3]);
		}
		if(!IsPlayerOnMiniEvent(playerid))
		{
			if(!IsPlayerVIP(playerid))
			{
				GivePlayerJobWeapons(playerid,job);
			}
		    if(CallRemoteFunction("GetPlayerPrisonTime","i",playerid) == 0)
		    {
				if(CallRemoteFunction("GetPlayerDMArena","i",playerid) == -1)
				{
					if(CallRemoteFunction("LoadBeforeEventData","i",playerid) == 0)
					{
					    CallRemoteFunction("SpawnPlayerAtSelectedSpawnPos","i",playerid);
						if(IsPlayerVIP(playerid))
						{
							CallRemoteFunction("GivePlayerGear","ii",playerid,0);
						}
					    CallRemoteFunction("SetAntiSK","i",playerid);
					}
				}
			}
		}
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid,0);
		SetPlayerSkin(playerid,Player[playerid][pSkin]);
		CallRemoteFunction("Spawn","i",playerid);
		SetCameraBehindPlayer(playerid);
	}
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
	if(reason > 255) reason = 255;
	if(PlayerSP[playerid][pSPInProp] == 1)
		PlayerSP[playerid][pSPInProp] = 0;
	if(GetPlayerKillerID(playerid) != -1 && IPC(GetPlayerKillerID(playerid)))
	    killerid = GetPlayerKillerID(playerid);
    Player[playerid][pDeaths] ++;
	if(Player[playerid][pTest] > 0)
	{
	    Player[playerid][pTest] = 0;
	    Player[playerid][pTestType] = 0;
	    SetPlayerVirtualWorld(playerid,0);
	    DestroyPlayerVehicle(playerid);
	    DisablePlayerRaceCheckpoint(playerid);
	    CreateInfoBox(playerid,"Autoškola","Nesloil jste zkoušky (~y~zemøel jste~w~)",5);
	    CancelLimitTimer(playerid);
	}
	if(killerid != INVALID_PLAYER_ID)
	{
		SendDeathMessage(killerid,playerid,reason);
	    Player[killerid][pKills] ++;
		if(!IsPlayerOnEvent(playerid) && !IsPlayerOnMiniEvent(playerid))
		{
			if(GetPlayerJob(killerid) == JOB_VOJAK)
			{
			    if(GetPlayerWantedLevel(playerid) >= 6 || GetPlayerJob(playerid) == JOB_TERORIST)
			    {
			        GivePlayerJobReward(killerid);
			        SetPlayerWantedLevel(playerid,0);
	    			SetPlayerWantedLevel(killerid,GetPlayerWantedLevel(killerid)-1);
			    }
			}
			if(GetPlayerJob(killerid) == JOB_TERORIST)
			{
			    switch(GetPlayerJob(playerid))
			    {
			        case JOB_VOJAK,JOB_POLICE:
			        {
				        GivePlayerJobReward(killerid);
				        SetPlayerWantedLevel(killerid,GetPlayerWantedLevel(killerid)+1);
			        }
			    }
			}
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	#define PRESSED(%0) \
		(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
	if(Player[playerid][pLogged] == true)
	{
		if(PRESSED(KEY_WALK))
		{
		    if(!IsPlayerInAnyVehicle(playerid))
		    {
		    	if(IsPlayerInRangeOfPoint(playerid, PICKUP_RADIUS, 974.8262,2072.3325,10.8203))
		    		ExitPlayerSpecialProperty(playerid);
				for(new i; i < sizeof(SpecialProps); i ++)
				{
					if(IsPlayerInRangeOfPoint(playerid, PICKUP_RADIUS, SpecialProps[i][0], SpecialProps[i][1], SpecialProps[i][2]))
					{
						new str[145];
						SetPVarInt(playerid,"SpecialPropertyID",i);
						if(PlayerSP[playerid][pSPID] == i)
						{
							EnterPlayerSpecialProperty(playerid);
						}
						else
						{
							if(PlayerSP[playerid][pSPID] == -1)
							{
								format(str,sizeof(str),"Chcete koupit tuto nemovitost za "cg"%0.1f bodù"cdc"?",SpecialProps[i][3]);
								SPD(playerid,40,DIALOG_STYLE_MSGBOX,"Nemovitost",str,"Ano","Ne");
							}
						}
					}
				}

		        for(new i; i < sizeof(WeaponDrop); i ++)
		        {
		            if(WeaponDrop[i][wDSlotUsed] == true)
		            {
						if(IsPlayerInRangeOfPoint(playerid,PICKUP_RADIUS,WeaponDrop[i][wDX],WeaponDrop[i][wDY],WeaponDrop[i][wDZ]))
						{
						    new DIALOG[500],str[144];
						    format(str,sizeof(str),"Sebrat vše\t \nPeníze\t"cg"%s$\n",SeperateNumber(WeaponDrop[i][wDMoney]));
						    strcat(DIALOG,str);
						    for(new x; x < 13; x ++)
						    {
								if(WeaponDrop[i][wDWeapons][x] != 0 && WeaponDrop[i][wDAmmo][x] != 0)
								{
									format(str,sizeof(str),"%s\t%d nábojù\n",GetWeaponNameEx(WeaponDrop[i][wDWeapons][x]),WeaponDrop[i][wDAmmo][x]);
								    strcat(DIALOG,str);
								}
						    }
						    format(str,sizeof(str),"%s",WeaponDrop[i][wDPlayer]);
						    SPD(playerid,21,DIALOG_STYLE_TABLIST,str,DIALOG,"Vybrat","Zavøít");
						    SetPVarInt(playerid,"LastID",i);
						}
					}
		        }
				if(GetPlayerVirtualWorld(playerid) == 0)
				{
				    for(new i; i < MAX_PJOBS; i ++)
				    {
					    if(IsPlayerInRangeOfPoint(playerid,2,JobPickup[i][jX],JobPickup[i][jY],JobPickup[i][jZ]))
					    {
					        new jobtype = JobPickup[i][jType],str[128],DIALOG[150],bool:candoit = true;
					        if(Player[playerid][pOfferID] != -1) return SM(playerid,"Právì nìkomu nabízíte slubu, nemùete zmìnit zamìstnání");
							strcat(DIALOG,"Toto zamìstnání nemùete vykonávat, nevlastníte všechny potøebné prùkazy:\n\n");
							for(new x; x < PRUKAZY; x ++)
					        {
					            if(Job[jobtype][jLicenses][x] == 1)
					            {
					                if(Player[playerid][pPrukazy][x] == 0)
					                {
										format(str,sizeof(str),""cr"%s\n",LicenseNames[x]);
										candoit = false;
					                }
					                else
									{
										format(str,sizeof(str),""cg"%s\n",LicenseNames[x]);
					                }
					                strcat(DIALOG,str);
					            }
					        }
					        if(candoit == false) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,Job[jobtype][jName],DIALOG,"Zavøít","");
					        if(Player[playerid][pJob] != jobtype)
					        {
					        	Player[playerid][pTaxa] = 0.0; 
								Player[playerid][pJob] = jobtype;
								SetPlayerColor(playerid,Job[jobtype][jColor]);
								ResetPlayerWeaponsEx(playerid);
								GivePlayerJobWeapons(playerid,jobtype);
								CreateInfoBox(playerid,Job[jobtype][jName],"úspìšnì zamìstnán, informace o zamìstnání zobrazíte pøíkazem ~g~/job",5);
								if(jobtype == JOB_PRAVNIK)
									SM(playerid,"Nastavte si taxu "cg"/taxa");
					        }
						    SetPVarInt(playerid,"LastID",jobtype);
						    format(str,sizeof(str),"Obléct uniformu\nVybrat vıplatu ("cg"%s$"cw")\nPodat vıpovìï",SeperateNumber(Player[playerid][pVyplata]));
							SPD(playerid,5,DIALOG_STYLE_LIST,Job[jobtype][jName],str,"Vybrat","Zavøít");
						}
				    }
				}
		    }
		}
	}
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(Player[playerid][pLogged] == true)
	{
		for(new i; i < sizeof(WeaponDrop); i ++)
		{
            if(WeaponDrop[i][wDSlotUsed] == true && WeaponDrop[i][wDVW] == GetPlayerVirtualWorld(playerid))
            {
			    if(IsPlayerInRangeOfPoint(playerid,PICKUP_RADIUS,WeaponDrop[i][wDX],WeaponDrop[i][wDY],WeaponDrop[i][wDZ]))
				{
				    CreateInfoBox(playerid,"Balíèek","Pro sebrání zbraní stistknìte klávesu ~r~~h~~k~~SNEAK_ABOUT~",3);
					break;
				}
			}
		}
		if(IsPlayerInRangeOfPoint(playerid, PICKUP_RADIUS, 976.0928,2084.2607,11.03010))
		{
			if(!IsPlayerSupplyRun(playerid))
				SPD(playerid,41,DIALOG_STYLE_LIST,"Nemovitost","Zobrazit stav\nDoplnit zásoby\nProdat sklad\nProdat nemovitost","Vybrat","Zavøít");
			else
				SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Nemovitost","Aktuálnì doplòujete zásoby","Zavøít","");
		}
		if(IsPlayerInRangeOfPoint(playerid, PICKUP_RADIUS, 974.8262,2072.3325,10.8203))
			CreateInfoBox(playerid,"Nemovitost","Pro odchod stisknete ~r~LALT");
		if(GetPlayerVirtualWorld(playerid) == 0)
		{
			for(new i; i < sizeof(SpecialProps); i ++)
			{
				if(IsPlayerInRangeOfPoint(playerid, PICKUP_RADIUS, SpecialProps[i][0], SpecialProps[i][1], SpecialProps[i][2]))
				{
					if(PlayerSP[playerid][pSPID] == i)
						CreateInfoBox(playerid,"Nemovitost","Pro vstoupeni do nemovitosti stisknete ~r~LALT",2);
					else
						if(PlayerSP[playerid][pSPID] == -1)
							CreateInfoBox(playerid,"Nemovitost","Pro koupeni nemovitosti stisknete ~r~LALT",2);
						else
							CreateInfoBox(playerid,"Nemovitost","Uz vlastnis tento typ nemovitosti",2);
				}
			}
			for(new i; i < MAX_SHOPS; i ++)
			{
			    if(IsPlayerInRangeOfPoint(playerid,PICKUP_RADIUS,Shops[i][sX],Shops[i][sY],Shops[i][sZ]))
			    {
			        new DIALOG[1000],str[145];
			        if(Shops[i][sType] == STAND_TYPE_GANJA)
			        {
						format(str,sizeof(str),"Akce\tCena\tSklad\nKoupit marihuanu\t"cg"750.000$\t{0077FF}%dg\nProdat marihuanu\t"cg"%s\t{0077FF}%dg",Shops[i][sAmount],SeperateNumber(GANJA_SELL),Player[playerid][pGanja]);
			            SPD(playerid,18,DIALOG_STYLE_TABLIST_HEADERS,"Obchod s marihuanou",str,"Vybrat","Zavøít");
					}
			        if(Shops[i][sType] == STAND_TYPE_WEAPONS)
			        {
			            for(new x; x < sizeof(WeaponsCategories); x ++)
			            {
			                format(str,sizeof(str),"%s\t \n",WeaponsCategories[x]);
			                strcat(DIALOG,str);
			            }
			            strcat(DIALOG,"Vesta\t"cg"10 bodù");
			            SPD(playerid,36,DIALOG_STYLE_TABLIST,"Obchod se zbranìma",DIALOG,"Vybrat","Zavøít");
			        }
				    SetPVarInt(playerid,"LastID",i);
				    break;
			    }
			}
			for(new i; i < MAX_PASSES; i ++)
			{
			    if(IsPlayerInRangeOfPoint(playerid,PICKUP_RADIUS,PassesPos[i][0],PassesPos[i][1],PassesPos[i][2]))
			    {
					SPD(playerid,10,DIALOG_STYLE_TABLIST,"Prùkazy","Øidickı prùkaz\t"cg"10.000$\nLeteckı prùkaz\t"cg"50.000$\nZbrojní prùkaz\t"cg"75.000$","Vybrat","Zavøít");
					break;
				}
			}
			for(new i; i < MAX_CLOTHES; i ++)
			{
			    if(IsPlayerInRangeOfPoint(playerid,PICKUP_RADIUS,ClothesPos[i][0],ClothesPos[i][1],ClothesPos[i][2]))
			    {
					SPD(playerid,15,DIALOG_STYLE_INPUT,"Obchod s obleèením","Zadejte ID obleku, kterı si pøejete koupit v rozmezí 0 - 311\n\nCena jednoho obleku je: "cg"5.000$","Zkusit","Zavøít");
					break;
				}
			}
			for(new i; i < MAX_GANJAS; i ++)
			{
			    if(IsPlayerInRangeOfPoint(playerid,PICKUP_RADIUS,Ganja[i][gX],Ganja[i][gY],Ganja[i][gZ]))
			    {
					if(GetPlayerJob(playerid) == JOB_DEALER)
					{
					    if(Ganja[i][gPronajemID] == -1)
					    {
					        if(Player[playerid][pGanjaField] == -1)
					        {
								SPD(playerid,8,DIALOG_STYLE_MSGBOX,"Marihuanové Pole","Chcete si pronajmout pole za "cg"10.000$ "cdc"na 30 minut?","Ano","Ne");
								SetPVarInt(playerid,"LastID",i);
							}
							else
							{
							    CreateInfoBox(playerid,"Marihuanové Pole","U máte pronajato jedno pole",5);
							}
						}
					    else
					    {
					        if(Ganja[i][gPronajemID] == playerid)
					        {
					            if(Player[playerid][pGanjaAction][1] <= 0)
					            {
						            SPD(playerid,9,DIALOG_STYLE_LIST,"Marihuanové Pole","Zalít\nPohnojit\nSklidit","Vybrat","Zavøít");
									SetPVarInt(playerid,"LastID",i);
								}
					        }
	    			        else
					        {
					        	CreateInfoBox(playerid,"Marihuanové Pole","Toto pole u má pronajatı jinı hráè",5);
							}
					    }
					}
					else
					{
					    CreateInfoBox(playerid,"Marihuanové Pole","Pro pìstování marihuany musíte bıt zamìstnan jako Dealer",5);
					}
			        break;
			    }
			}
			for(new i; i < MAX_BANKS; i ++)
			{
			    if(IsPlayerInRangeOfPoint(playerid,PICKUP_RADIUS,BankPos[i][0],BankPos[i][1],BankPos[i][2]))
			    {
			        ShowBank(playerid);
			        break;
			    }
			}
			for(new i; i < MAX_PJOBS; i ++)
			{
			    if(IsPlayerInRangeOfPoint(playerid,PICKUP_RADIUS,JobPickup[i][jX],JobPickup[i][jY],JobPickup[i][jZ]))
			    {
			        new str[62];
			        if(Player[playerid][pJob] != JobPickup[i][jType])
			        {
						format(str,sizeof(str),"Pokud se chcete zamìstnat stisknìte ~g~~k~~SNEAK_ABOUT~");
			        }
			        else
			        {
						format(str,sizeof(str),"Pro otevøení dialogu zamìstnání stisknìte ~g~~k~~SNEAK_ABOUT~");
			        }
			        CreateInfoBox(playerid,Job[JobPickup[i][jType]][jName],str,2);
			        break;
			    }
			}
			for(new i; i < MAX_OFFICES; i ++)
			{
			    if(IsPlayerInRangeOfPoint(playerid,PICKUP_RADIUS,OfficePos[i][0],OfficePos[i][1],OfficePos[i][2]))
			    {
					SPD(playerid,7,DIALOG_STYLE_LIST,"Úøad","Banka\nInzerát\nZamìstnání","Vybrat","Zavøít");
					break;
				}
			}
		}
	}
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(Player[playerid][pTest] > 0)
	{
		if(Player[playerid][pTestType] == P_RIDICKY)
		{
		    new id = Player[playerid][pTest];
			Player[playerid][pTest] ++;
		    if(id < sizeof(AutoskolaCP)-1)
		    {
		    	SetPlayerRaceCheckpoint(playerid,0,AutoskolaCP[id][0],AutoskolaCP[id][1],AutoskolaCP[id][2],AutoskolaCP[id+1][0],AutoskolaCP[id+1][1],AutoskolaCP[id+1][2],5);
			}
			else if(id == sizeof(AutoskolaCP)-1)
			{
		    	SetPlayerRaceCheckpoint(playerid,1,AutoskolaCP[id][0],AutoskolaCP[id][1],AutoskolaCP[id][2],0,0,0,5);
			}
			else if(id == sizeof(AutoskolaCP))
			{
			    Player[playerid][pPrukazy][P_RIDICKY] ++;
			    CreateInfoBox(playerid,"Autoškola","øidické zkouky úspìšnì sloeny, získáváte øidickı prùkaz",10);
				SetPlayerInterior(playerid,0);
				SetPlayerVirtualWorld(playerid,0);
				DestroyPlayerVehicle(playerid);
				Player[playerid][pTest] = 0;
				DisablePlayerRaceCheckpoint(playerid);
				CancelLimitTimer(playerid);
			}
		}
		if(Player[playerid][pTestType] == P_LETECKY)
		{
		    new id = Player[playerid][pTest];
			Player[playerid][pTest] ++;
		    if(id < sizeof(LeteckaskolaCP)-1)
		    {
		    	SetPlayerRaceCheckpoint(playerid,3,LeteckaskolaCP[id][0],LeteckaskolaCP[id][1],LeteckaskolaCP[id][2],LeteckaskolaCP[id+1][0],LeteckaskolaCP[id+1][1],LeteckaskolaCP[id+1][2],10);
			}
			else if(id == sizeof(LeteckaskolaCP)-1)
			{
		    	SetPlayerRaceCheckpoint(playerid,1,LeteckaskolaCP[id][0],LeteckaskolaCP[id][1],LeteckaskolaCP[id][2],0,0,0,10);
			}
			else if(id == sizeof(LeteckaskolaCP))
			{
			    Player[playerid][pPrukazy][P_LETECKY] ++;
			    CreateInfoBox(playerid,"Letecká škola","Letecká zkouky úspìšnì sloeny, získáváte leteckı prùkaz",10);
				SetPlayerInterior(playerid,0);
				SetPlayerVirtualWorld(playerid,0);
				DestroyPlayerVehicle(playerid);
				Player[playerid][pTest] = 0;
				DisablePlayerRaceCheckpoint(playerid);
				CancelLimitTimer(playerid);
			}
		}
	}
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(response)
	{
	    if(fScaleX > 1.6 || fScaleY > 1.6 || fScaleZ > 1.6)
	    {
	        SCM(playerid,-1,"Doplnìkk je pøíliš zvìtšenı");
	        BackToOldAttachedObjectPos(playerid,index,modelid,boneid);
	        EditAttachedObject(playerid,index);
	    }
		else if(fOffsetX > 0.5 || fOffsetX < -1.1 || fOffsetY > 0.5 || fOffsetY < -0.5 || fOffsetZ > 0.5 || fOffsetZ < -0.5)
		{
	        SCM(playerid,-1,"Doplnìk je pøíliš vzdálenı");
	        BackToOldAttachedObjectPos(playerid,index,modelid,boneid);
	        EditAttachedObject(playerid,index);
		}
		else
		{
			PlayerAddons[playerid][pAddonX][index] = fOffsetX;
			PlayerAddons[playerid][pAddonY][index] = fOffsetY;
			PlayerAddons[playerid][pAddonZ][index] = fOffsetZ;
			PlayerAddons[playerid][pAddonRX][index] = fRotX;
			PlayerAddons[playerid][pAddonRY][index] = fRotY;
			PlayerAddons[playerid][pAddonRZ][index] = fRotZ;
			PlayerAddons[playerid][pAddonSX][index] = fScaleX;
			PlayerAddons[playerid][pAddonSY][index] = fScaleY;
			PlayerAddons[playerid][pAddonSZ][index] = fScaleZ;
			if(Player[playerid][pEditAddon] != PlayerAddons[playerid][pAddonID][index])
				CreateInfoBox(playerid,"Doplòky","Doplnìk úspìšnì uloen",3);
			else
				CreateInfoBox(playerid,"Doplòky","Doplnìk úspìšnì upraven",3);
			printf("%0.4f,%0.4f,%0.4f,%0.4f,%0.4f,%0.4f",fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ);
		}
	}
	else
	{
		if(Player[playerid][pEditAddon] != PlayerAddons[playerid][pAddonID][index])
		{
	        if(IsPlayerAttachedObjectSlotUsed(playerid,index))
			{
				RemovePlayerAttachedObject(playerid,index);
			}
		    GivePlayerPoints(playerid,AddonsList[PlayerAddons[playerid][pAddonID][index]][AddonPrice]);
	    	PlayerAddons[playerid][pAddonID][index] = -1;
		    ShowAddonsList(playerid,GetPVarInt(playerid,"Page"));
		}
		else
	        BackToOldAttachedObjectPos(playerid,index,modelid,boneid);
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		if(GetPlayerVehicleID(playerid) == PlayerSP[playerid][pSPSuppVehicle] && PlayerSP[playerid][pSPSuppRunning] > 0)
		{
			DisablePlayerCheckpoint(playerid);
			CreateInfoBox(playerid,"Zasoby","Dovezte zásoby zpìt do ~r~nemovitosti~w~ davejte pozor na ostatni hrace, muzou vam zasoby znicit",10);
			new spid = PlayerSP[playerid][pSPID];
			PlayerSP[playerid][pSPSuppState] = 1;
			SetPlayerCheckpoint(playerid, SpecialProps[spid][0], SpecialProps[spid][1], SpecialProps[spid][2], 15);
		}
	}

	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
	  	for(new i; i < MAX_ADDONS; i ++)
        {
            if(PlayerAddons[playerid][pAddonID][i] != -1)
            {
	            if(IsPlayerAttachedObjectSlotUsed(playerid,i))
	            {
	                RemovePlayerAttachedObject(playerid,i);
	            }
	        }
		}
	}
	else if(newstate == PLAYER_STATE_ONFOOT)
	{
		for(new i; i < MAX_ADDONS; i ++)
	    {
	        if(PlayerAddons[playerid][pAddonID][i] != -1)
	        {
	            if(!IsPlayerAttachedObjectSlotUsed(playerid,i))
	            {
	                ShowPlayerAddon(playerid,i);
	            }
	        }
		}
	}
	return 1;
}

public OnDialogResponse(playerid,dialogid,response,listitem,inputtext[])
{
	ShowedDialog[playerid] = false;
	if(dialogid == 1)
	{
	    if(response)
	    {
	        if(Player[playerid][pLogged] == false)
	        {
				printf("%s -> Logging In",Jmeno(playerid));
	            if(!fexist(USER_FILES(playerid)))
				{
				    if(!strlen(inputtext)) return SPD(playerid,1,DIALOG_STYLE_PASSWORD,"Registrace","Prosím zadejte heslo, kterım se pozdìji budete pøihlašovat","Registrovat","Odejít");
					if(strlen(inputtext) < 3) return SPD(playerid,1,DIALOG_STYLE_PASSWORD,"Registrace","Prosím zadejte heslo, kterım se pozdìji budete pøihlašovat\n\n"cr"Minimálnì 3 znaky","Registrovat","Odejít");
					if(strlen(inputtext) > 30) return SPD(playerid,1,DIALOG_STYLE_PASSWORD,"Registrace","Prosím zadejte heslo, kterım se pozdìji budete pøihlašovat\n\n"cr"Maximálnì 30 znakù","Registrovat","Odejít");
					DOF2_CreateFile(USER_FILES(playerid));
					HashPassword(Jmeno(playerid),inputtext);
					DOF2_SetInt(USER_FILES(playerid),"Register",gettime());
					GiveMoney(playerid,50000,"Do zaèátku");
					Player[playerid][pNewBie] = true;
					CreateInfoBox(playerid,"Registrace","Registrace probìhla úspìšnì, nezapomeòte si heslo dobøe zapamatovat. Do zaèátku dostáváte ~g~50.000$",10);
					PlayerPlaySound(playerid,4201,0,0,0);
					Player[playerid][pPlayedTG] = gettime();
					Player[playerid][pLogged] = true;
					CallRemoteFunction("OnPlayerLogged","i",playerid);
					CallRemoteFunction("OnPlayerSpawn","i",playerid);
				}
				else
				{
					if(!strlen(inputtext)) return SPD(playerid,1,DIALOG_STYLE_PASSWORD,"Pøihlášení","Prosím zadejte heslo, které jste zadal pøi registraci","Pøihlásit","Odejít");
					if(strlen(DOF2_GetString(USER_FILES(playerid),"Salt")) == 0)
					{
					    new query[500],Cache:cache;
					    mysql_format(mysql,query,sizeof(query),"SELECT * FROM `Users` WHERE `Nick`='%e' AND `Password`=PASSWORD('%e')",Jmeno(playerid),inputtext);
						cache = mysql_query(mysql,query);
						if(cache_get_row_count(mysql))
						{
							HashPassword(Jmeno(playerid),inputtext);
						}
						else
						{
							cache_delete(cache,mysql);
							SPD(playerid,1,DIALOG_STYLE_PASSWORD,"Pøihlášení","Prosím zadejte heslo, které jste zadal pøi registraci\n\n"cr"Zadal jste špatné heslo","Pøihlásit","Odejít");
							return 0;
						}
					}
					else
					{
					    if(IsPasswordBad(Jmeno(playerid),inputtext))
						{
							new vars = GetPVarInt(playerid,"LoginVars");
						 	if((vars+1) % 3 != 0) SPD(playerid,1,DIALOG_STYLE_PASSWORD,"Pøihlášení","Prosím zadejte heslo, které jste zadal pøi registraci\n\n"cr"Zadal jste špatné heslo","Pøihlásit","Odejít");
							else SPD(playerid,1,DIALOG_STYLE_PASSWORD,"Pøihlášení","Vypadá to, e jste zapomnìl svoje heslo, pro obnovu hesla napište E-Mail s\nVaším nickem na adresu "cg""SERVER_MAIL""cdc". E-Mail musí bıt odeslán z adresy,\nkterá je uvdena v údajích na Vašem herním úètu ","Pøihlásit","Odejít");
							SetPVarInt(playerid,"LoginVars",vars+1);
							return 0;
						}
					}
					LoadData(playerid);
					CreateInfoBox(playerid,"Pøihlášení","Pøíhlášení probìhlo úspìšnì, data naètena",5);
					CallRemoteFunction("OnPlayerLogged","i",playerid);
					Player[playerid][pPlayedTG] = gettime();
					SetPlayerColor(playerid,Job[Player[playerid][pJob]][jColor]);
				}
				Player[playerid][pLogged] = true;
				LoadSpecialProperties(playerid);
				TextDrawHideForPlayer(playerid,Textdraw1);
				TextDrawHideForPlayer(playerid,Textdraw2);
				TextDrawHideForPlayer(playerid,Textdraw3);
				printf("%s -> Logged In",Jmeno(playerid));
				SpawnPlayer(playerid);
	        }
	        else
	            SCM(playerid,RED,"[ ! ] "cw"U jsi pøihlášen.");
	    }
	    else
	        Kick(playerid);
		return 1;
	}
	if(dialogid == 2)
	{
	    if(response)
		{
			new str[100];
		    switch(listitem)
		    {
		        case 0: SPD(playerid,3,DIALOG_STYLE_INPUT,"Banka","Zadejte èástku, kterou si pøejete vloit do banky","Vloit","Zavøít");
		        case 1: SPD(playerid,4,DIALOG_STYLE_INPUT,"Banka","Zadejte èástku, kterou si pøejete vybrat z banky","Vybrat","Zavøít");
				case 2:
				{
					if(Player[playerid][pBanka] + GetMoney(playerid) < 0) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Banka","Nemùete mít v bance více jak 2.147.483.647$","Zavøít","");
					if(GetMoney(playerid) == 0) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Banka","Nemáte u sebe ádné peníze","Zavøít","");
					Player[playerid][pBanka] += GetMoney(playerid);
					format(str,sizeof(str),"Vloil jste ~g~%s$ ~w~na Váš úèet. Celkem máte v bance ~g~%s$",SeperateNumber(GetMoney(playerid)),SeperateNumber(Player[playerid][pBanka]));
					CreateInfoBox(playerid,"Banka",str,5);
					GiveMoney(playerid,-GetMoney(playerid),"Vklad do banky");
				}
				case 3:
				{
					if(GetMoney(playerid) + Player[playerid][pBanka] < 0) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Banka","Nemùete mít u sebe více jak 2.147.483.647$","Zavøít","");
					if(Player[playerid][pBanka] == 0) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Banka","Nemáte v bance ádné peníze","Zavøít","");
					GiveMoneyWithoutAutobank(playerid,Player[playerid][pBanka],"Vıbìr z banky");
					format(str,sizeof(str),"Vybral jste ~g~%s$ ~w~z Vášeho úètu. Celkem máte v bance ~g~%s$",SeperateNumber(Player[playerid][pBanka]),SeperateNumber(GetMoney(playerid)));
					CreateInfoBox(playerid,"Banka",str,5);
					Player[playerid][pBanka] = 0;
				}
		    }
		}
		return 1;
	}
	if(dialogid == 3)
	{
	    if(response)
	    {
			new castka = strval(inputtext),str[100];
			if(!strlen(inputtext)) return SPD(playerid,3,DIALOG_STYLE_INPUT,"Banka","Zadejte èástku, kterou si pøejete vloit do banky","Vloit","Zavøít");
			if(!IsNumeric(inputtext)) return SPD(playerid,3,DIALOG_STYLE_INPUT,"Banka","Zadejte èástku, kterou si pøejete vloit do banky","Vloit","Zavøít");
			if(castka < 1 || castka > GetMoney(playerid)) return SPD(playerid,3,DIALOG_STYLE_INPUT,"Banka","Zadejte èástku, kterou si pøejete vloit do banky\n\n"cr"Chybnì zadaná èástka","Vloit","Zavøít");
			if(Player[playerid][pBanka] + castka < 0) return SPD(playerid,3,DIALOG_STYLE_INPUT,"Banka","Zadejte èástku, kterou si pøejete vloit do banky\n\n"cr"Tolik penìz se do banky nevejde","Vloit","Zavøít");
			Player[playerid][pBanka] += castka;
			GiveMoney(playerid,-castka,"Vklad do banky");
			format(str,sizeof(str),"Vloil jste ~g~%s$ ~w~na Váš úèet. Celkem máte v bance ~g~%s$",SeperateNumber(castka),SeperateNumber(Player[playerid][pBanka]));
			CreateInfoBox(playerid,"Banka",str,5);
		}
	    return 1;
	}
	if(dialogid == 4)
	{
	    if(response)
	    {
			new castka = strval(inputtext),str[100];
			if(!strlen(inputtext)) return SPD(playerid,4,DIALOG_STYLE_INPUT,"Banka","Zadejte èástku, kterou si pøejete vybrat z banky","Vybrat","Zavøít");
			if(!IsNumeric(inputtext)) return SPD(playerid,4,DIALOG_STYLE_INPUT,"Banka","Zadejte èástku, kterou si pøejete vybrat z banky","Vybrat","Zavøít");
			if(castka < 1 || castka > Player[playerid][pBanka]) return SPD(playerid,4,DIALOG_STYLE_INPUT,"Banka","Zadejte èástku, kterou si pøejete vybrat z banky\n\n"cr"Chybnì zadaná èástka","Vybrat","Zavøít");
			if(GetMoney(playerid) + castka < 0) return SPD(playerid,4,DIALOG_STYLE_INPUT,"Banka","Zadejte èástku, kterou si pøejete vybrat z banky\n\n"cr"Tolik penìz se Vám do kapsy nevejde","Vybrat","Zavøít");
			Player[playerid][pBanka] -= castka;
			GiveMoneyWithoutAutobank(playerid,castka,"Vıber z banky");
			format(str,sizeof(str),"Vybral jste ~g~%s$ ~w~z Vášeho úèetu. Zbytek v bance ~g~%s$",SeperateNumber(castka),SeperateNumber(Player[playerid][pBanka]));
			CreateInfoBox(playerid,"Banka",str,5);
		}
	    return 1;
	}
	if(dialogid == 5)
	{
	    if(response)
	    {
	        new jobtype = GetPVarInt(playerid,"LastID");
	        switch(listitem)
	        {
	            case 0:
	            {
	                new DIALOG[1000],str[50],skins = 0;
	                for(new i; i < MAX_JSKINS; i ++)
	                {
	                    if(Job[jobtype][jSkins][i] != 0)
	                    {
	                    	format(str,sizeof(str),"%d.\tUniforma ("cg"%d"cw")\n",i+1,Job[jobtype][jSkins][i]);
							strcat(DIALOG,str);
							skins ++;
						}
					}
					if(skins) SPD(playerid,6,DIALOG_STYLE_LIST,Job[jobtype][jName],DIALOG,"Vybrat","Zavøít");
					else SPD(playerid,0,DIALOG_STYLE_MSGBOX,Job[jobtype][jName],"Toto zamìstnání nemá k dispozici ádné uniformy","Zavøít","");
		        }
		        case 1:
		        {
					if(Player[playerid][pVyplata] < 1) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,Job[jobtype][jName],"Na vıplatní pásce nemáte ádné peníze","Zavøít","");
					GiveMoney(playerid,Player[playerid][pVyplata],"Vıbìr vıplaty");
					Player[playerid][pVyplata] = 0;
				}
				case 2:
				{
					if(IsPlayerWorking(playerid)) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,Job[jobtype][jName],"Kdy jste v misi tak nemùete podat vıpovìï","Zavøít","");
					Player[playerid][pJob] = 0;
					CreateInfoBox(playerid,Job[jobtype][jName],"Podal jste vıpovìï, stáváte se nezamìstnanım",5);
					SetPlayerColor(playerid,Job[0][jColor]);
					ResetPlayerWeaponsEx(playerid);
					GivePlayerJobWeapons(playerid,0);
				}
	        }
	    }
	    return 1;
	}
	if(dialogid == 6)
	{
	    if(response)
	    {
			if(listitem < MAX_JSKINS)
			{
		        new jobtype = GetPVarInt(playerid,"LastID");
			    if(Job[jobtype][jSkins][listitem] != 0)
			    {
			        SetPlayerSkinEx(playerid,Job[jobtype][jSkins][listitem]);
			        CreateInfoBox(playerid,Job[jobtype][jName],"Uniforma obleèena",5);
			        ApplyAnimation(playerid,"CLOTHES","CLO_Buy",4.1,0,1,1,1,1,1);
			    }
			}
	    }
	    return 1;
	}
	if(dialogid == 7)
	{
		if(response)
		{
		    switch(listitem)
		    {
		        case 0: ShowBank(playerid);
		        case 1: SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Inzerát","Pro vytvoøení inzerátu pouijte pøíkaz "cg"/inzerat","Zavøít","");
		        case 2:
		        {
		            new DIALOG[500],str[50];
		            for(new i; i < MAX_JOBS; i ++)
		            {
		                new zamestnanci;
		                for(new x; x <= GetPlayerPoolSize(); x ++)
						{
							if(IPC(x) && !IsPlayerNPC(x))
							{
							    if(Player[x][pJob] == i) zamestnanci ++;
							}
						}
	            		format(str,sizeof(str),"%s\tOnline èlenù: %d\n",Job[i][jName],zamestnanci);
						strcat(DIALOG,str);
					}
					SPD(playerid,0,DIALOG_STYLE_TABLIST,"Zamìstnání",DIALOG,"Zavøít","");
		        }
		    }
		}
		return 1;
	}
	if(dialogid == 8)
	{
	    if(response)
    	{
			if(GetMoney(playerid) < 10000) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Marihuanové Pole","Nemáte dostatek penìz","Zavøít","");
			GiveMoney(playerid,-10000,"Pronajmutí marihuanového pole");
	        new ganjaid = GetPVarInt(playerid,"LastID");
	        Player[playerid][pGanjaField] = ganjaid;
	        Player[playerid][pGanjaFieldTime] = 60*30;
	        Ganja[ganjaid][gPronajemID] = playerid;
	        SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Marihuanové Pole","Marihuanové pole úspìšnì pronajato za "cg"10.000$ "cdc"na 30 minut","Zavøít","");
            UpdateGanjaText(ganjaid);
	    }
	    return 1;
	}
	if(dialogid == 9)
	{
	    if(response)
	    {
	        new ganjaid = Player[playerid][pGanjaField];
			switch(listitem)
			{
		        case 0:
		        {
		            if(Ganja[ganjaid][gStatus] == 10) return SCM(playerid,RED,"[ ! ] "cw"Marihuana u je vypìstovaná");
		            if(Player[playerid][pGanjaAction][0] == 1) return SCM(playerid,RED,"[ ! ] "cw"Marihuana potøebuje pohnojit");
		            Player[playerid][pGanjaAction][0] = 1;
		            Player[playerid][pGanjaAction][1] = 5-GetPlayerJobRank(playerid)/2;
		        }
		        case 1:
		        {
		            if(Ganja[ganjaid][gStatus] == 10) return SCM(playerid,RED,"[ ! ] "cw"Marihuana u je vypìstovaná");
		            if(Player[playerid][pGanjaAction][0] == 2) return SCM(playerid,RED,"[ ! ] "cw"Marihuana potøebuje zalít");
					Player[playerid][pGanjaAction][0] = 2;
					Player[playerid][pGanjaAction][1] = 5-GetPlayerJobRank(playerid)/2;
				}
				case 2:
				{
		            if(Ganja[ganjaid][gStatus] < 10) return SCM(playerid,RED,"[ ! ] "cw"Marihuana ještì není vypìstovaná");
					Player[playerid][pGanjaAction][0] = 0;
					Player[playerid][pGanjaAction][1] = 0;
					Ganja[ganjaid][gStatus] = 0;
                    MoveDynamicObject(Ganja[ganjaid][gObject],Ganja[ganjaid][gX],Ganja[ganjaid][gY],Ganja[ganjaid][gZ]-2,2);
                    GivePlayerJobReward(playerid);
                    new GanjaAmount[5] = {4,6,8,10,12};
                    new rand = 2,str[80];
                    rand += random(GanjaAmount[GetPlayerJobRank(playerid)]-1);
                    GivePlayerGanja(playerid,rand,"Vypìstováno");
                    GivePlayerDailyValueEx(playerid,DAILY_TYPE_GANJA,rand);
   					format(str,sizeof(str),"Sklizeno: ~g~%dg ~w~celkem máte: ~r~~h~%dg",rand,Player[playerid][pGanja]);
					CreateInfoBox(playerid,"Marihuanové Pole",str,5);
				}
			}
			UpdateGanjaText(Player[playerid][pGanjaField]);
	    }
		return 1;
	}
	if(dialogid == 10)
	{
	    if(response)
	    {
	    	if(IsPlayerSupplyRun(playerid)) return SM(playerid,"Právì plníte misi, nemùete vykonat tuto akci");
	        switch(listitem)
	        {
	            case 0:
	            {
					if(GetMoney(playerid) < 10000) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Prùkazy","Nemáte dostatek penìz","Zavøít","");
					GiveMoney(playerid,-10000,"Øidickı prùkaz");
					Player[playerid][pTest] = 1;
					Player[playerid][pTestType] = P_RIDICKY;
					SetPlayerLimitTimer(playerid,120);
					SetPlayerRaceCheckpoint(playerid,0,AutoskolaCP[0][0],AutoskolaCP[0][1],AutoskolaCP[0][2],AutoskolaCP[1][0],AutoskolaCP[1][1],AutoskolaCP[1][2],5);
					CreateInfoBox(playerid,"Autoškola","Pokraèujte podle ~r~checkpointù~w~ pokud vozidlo rozbijete nebo vám dojde èas, autoškolu nesplníte",10);
					CreatePlayerVehicle(playerid,565,-2022.8632,-97.5842,34.7891,88.5517,0,VW+playerid);
				}
	            case 1:
	            {
					if(GetMoney(playerid) < 50000) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Prùkazy","Nemáte dostatek penìz","Zavøít","");
					GiveMoney(playerid,-50000,"Leteckı prùkaz");
					Player[playerid][pTest] = 1;
					Player[playerid][pTestType] = P_LETECKY;
					SetPlayerLimitTimer(playerid,60*4);
					SetPlayerRaceCheckpoint(playerid,3,LeteckaskolaCP[0][0],LeteckaskolaCP[0][1],LeteckaskolaCP[0][2],LeteckaskolaCP[1][0],LeteckaskolaCP[1][1],LeteckaskolaCP[1][2],10);
					CreateInfoBox(playerid,"Letecká škola","Pokraèujte podle ~r~checkpointù~w~ pokud letadlo rozbijete nebo vám dojde èas, leteckou školu nesplníte",10);
					CreatePlayerVehicle(playerid,593,398.0252,2503.7021,16.9441,89.9828,0,VW+playerid);
	            }
	            case 2:
	            {
					if(GetMoney(playerid) < 75000) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Prùkazy","Nemáte dostatek penìz","Zavøít","");
					GiveMoney(playerid,-75000,"Zbrojní prùkaz");
					CreateInfoBox(playerid,"Zbrojní prùkaz","Zbrojní prùkaz zakoupen",5);
					Player[playerid][pPrukazy][P_ZBROJNI] = 1;
	            }   
	        }
	    }
	    return 1;
	}
	if(dialogid == 11)
	{
	    if(response)
	    {
			new DIALOG[500+45],str[45];
			format(str,sizeof(str),"{0077FF}%s"cdc"\n",HelpMenu[listitem][0]);
			strcat(DIALOG,str);
			strcat(DIALOG,HelpMenu[listitem][1]);
	        SPD(playerid,12,DIALOG_STYLE_MSGBOX,HelpMenu[listitem][0],DIALOG,"Zpìt","Zavøít");
	    }
	    return 1;
	}
	if(dialogid == 12)
	{
	    if(response)
	    {
	        ShowHelpMenu(playerid);
	    }
	    return 1;
	}
	if(dialogid == 13)
	{
	    if(response)
	    {
	        new cmd[50];
	        format(cmd,sizeof(cmd),"cmd_%s",CommandList[listitem][0][1]);
	        CallRemoteFunction(cmd,"i",playerid);
	    }
	    return 1;
	}
	if(dialogid == 14)
	{
	    if(response)
	    {
	        new cmd[50];
	        format(cmd,sizeof(cmd),"cmd_%s",AnimCommandList[listitem][1]);
	        CallRemoteFunction(cmd,"i",playerid);
	    }
	    return 1;
	}
	if(dialogid == 15)
	{
	    if(response)
	    {
	        new id = strval(inputtext);
	        if(!strlen(inputtext)) return SPD(playerid,15,DIALOG_STYLE_INPUT,"Obchod s obleèením","Zadejte ID obleku, kterı si pøejete koupit v rozmezí 0 - 311\n\nCena jednoho obleku je: "cg"5.000$","Zkusit","Zavøít");
	        if(!IsNumeric(inputtext)) return SPD(playerid,15,DIALOG_STYLE_INPUT,"Obchod s obleèením","Zadejte ID obleku, kterı si pøejete koupit v rozmezí 0 - 311\n\nCena jednoho obleku je: "cg"5.000$","Zkusit","Zavøít");
			if(GetPlayerSkinEx(playerid) == id) return SPD(playerid,15,DIALOG_STYLE_INPUT,"Obchod s obleèením","Zadejte ID obleku, kterı si pøejete koupit v rozmezí 0 - 311\n\nCena jednoho obleku je: "cg"5.000$\n\n"cr"Tento oblek máte nyní na sobì","Zkusit","Zavøít");
			if(id < 0 || id > 311) return SPD(playerid,15,DIALOG_STYLE_INPUT,"Obchod s obleèením","Zadejte ID obleku, kterı si pøejete koupit v rozmezí 0 - 311\n\nCena jednoho obleku je: "cg"5.000$","Zkusit","Zavøít");
			SetPVarInt(playerid,"SkinID",GetPlayerSkinEx(playerid));
			SetPlayerSkinEx(playerid,id);
			SPD(playerid,16,DIALOG_STYLE_MSGBOX,"Obchod s obleèením","Chcete si tento oblek koupit za "cg"5.000$"cdc"?","Ano","Ne");
		}
	    return 1;
	}
	if(dialogid == 16)
	{
        new id = GetPVarInt(playerid,"SkinID");
	    if(response)
	    {
	        if(GetMoney(playerid) < 5000)
	        {
	            SetPlayerSkinEx(playerid,id);
				SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Obchod s obleèením","Nemáte dostatek penìz","Zavøít","");
				return 0;
			}
			GiveMoney(playerid,-5000,"Zakoupení obleku");
			ApplyAnimation(playerid,"CLOTHES","CLO_Buy",4.1,0,1,1,1,1,1);
	    }
	    else
	    {
            SetPlayerSkinEx(playerid,id);
	    }
	    return 1;
	}
	if(dialogid == 17)
	{
        ShowPlayerActualNew(playerid);
	    return 1;
	}
	if(dialogid == 18)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0: SPD(playerid,19,DIALOG_STYLE_INPUT,"Koupit marihuanou","Zadejte poèet gramù, které si pøejete "cr"koupit","Koupit","Zavøít");
	            case 1: SPD(playerid,20,DIALOG_STYLE_INPUT,"Prodat marihuanou","Zadejte poèet gramù, které si pøejete "cg"prodat","Prodat","Zavøít");
	        }
	    }
	    return 1;
	}
	if(dialogid == 19)
	{
	    if(response)
	    {
	        new amount = strval(inputtext),id = GetPVarInt(playerid,"LastID"),amountstr[20],file[50] = "Shops.txt",str[200];
	        if(!strlen(inputtext) || !IsNumeric(inputtext) || amount < 1) return SPD(playerid,19,DIALOG_STYLE_INPUT,"Koupit marihuanou","Zadejte poèet gramù, které si pøejete "cr"koupit","Koupit","Zavøít");
			if(amount > Shops[id][sAmount]) return SPD(playerid,19,DIALOG_STYLE_INPUT,"Koupit marihuanou","Zadejte poèet gramù, které si pøejete "cr"koupit\n\n"cr"tolik marihuany není na skladì","Koupit","Zavøít");
			if(amount * 750000 < 0) return SPD(playerid,19,DIALOG_STYLE_INPUT,"Koupit marihuanou","Zadejte poèet gramù, které si pøejete "cr"koupit\n\n"cr"tolik marihuany si nelze koupit naráz","Koupit","Zavøít");
			if(amount > 2500) return SPD(playerid,19,DIALOG_STYLE_INPUT,"Koupit marihuanou","Zadejte poèet gramù, které si pøejete "cr"koupit\n\n"cr"tolik marihuany si nelze koupit naráz","Koupit","Zavøít");
			format(str,sizeof(str),"Zadejte poèet gramù, které si pøejete "cr"koupit\n\n"cr"Nemáte u sebe dostatek penìz (%s$)",SeperateNumber(amount*750000));
			if(GetMoney(playerid) < amount*750000) return  SPD(playerid,19,DIALOG_STYLE_INPUT,"Koupit marihuanou",str,"Koupit","Zavøít");
			GivePlayerGanja(playerid,amount,"Zakoupení v obchodì");
			Shops[id][sAmount] -= amount;
			format(amountstr,sizeof(amountstr),"Amount%d",id);
			DOF2_SetInt(file,amountstr,Shops[id][sAmount]);
			DOF2_SaveFile();
			GiveMoney(playerid,-(750000*amount),"Zakoupení marihuany v obchodì");
			format(str,sizeof(str),"Zakoupeno ~g~%dg ~w~marihuany za ~g~%s$",amount,SeperateNumber(amount*750000));
			CreateInfoBox(playerid,"Nákup Marihuany",str,5);
	    }
	    return 1;
	}
	if(dialogid == 20)
	{
	    if(response)
	    {
	        new amount = strval(inputtext),id = GetPVarInt(playerid,"LastID"),amountstr[20],file[50] = "Shops.txt",str[128];
	        if(!strlen(inputtext) || !IsNumeric(inputtext) || amount < 1) return SPD(playerid,20,DIALOG_STYLE_INPUT,"Prodat marihuanou","Zadejte poèet gramù, které si pøejete "cg"prodat","Prodat","Zavøít");
			if(amount > Player[playerid][pGanja]) return SPD(playerid,20,DIALOG_STYLE_INPUT,"Prodat marihuanou","Zadejte poèet gramù, které si pøejete "cg"prodat\n\n"cr"tolik marihuany u sebe nemáte","Prodat","Zavøít");
			if(amount < 100) return SPD(playerid,20,DIALOG_STYLE_INPUT,"Prodat marihuanou","Zadejte poèet gramù, které si pøejete "cg"prodat\n\n"cr"Odkupujeme minimálnì 100g","Prodat","Zavøít");
			if(amount > 2500) return SPD(playerid,20,DIALOG_STYLE_INPUT,"Prodat marihuanou","Zadejte poèet gramù, které si pøejete "cg"prodat\n\n"cr"Nemùete prodat tolik marihuany naráz","Prodat","Zavøít");
			if(GetMoney(playerid)+amount*GANJA_SELL < 0) return SPD(playerid,20,DIALOG_STYLE_INPUT,"Prodat marihuanou","Zadejte poèet gramù, které si pøejete "cg"prodat\n\n"cr"Tolik marihuany nemùete prodat (maximálnì u sebe mùete mít 2.147.483.647$)","Prodat","Zavøít");
			GivePlayerGanja(playerid,-amount,"Prodej v obchodì");
			Shops[id][sAmount] += amount;
			format(amountstr,sizeof(amountstr),"Amount%d",id);
			DOF2_SetInt(file,amountstr,Shops[id][sAmount]);
			DOF2_SaveFile();
			GiveMoney(playerid,amount*GANJA_SELL,"Prodání marihuany v obchodì");
			format(str,sizeof(str),"Prodáno ~g~%dg ~w~marihuany za ~g~%s$",amount,SeperateNumber(amount*GANJA_SELL));
			CreateInfoBox(playerid,"Prodej Marihuany",str,5);
	    }
	    return 1;
	}
	if(dialogid == 21)
	{
	    if(response)
	    {
            new id = GetPVarInt(playerid,"LastID"),str[144];
	        switch(listitem)
	        {
	            case 0:
	            {
					if(WeaponDrop[id][wDMoney] > 0)
					{
		                format(str,sizeof(str),"Sebral posmrtní balíèek hráèe %s",WeaponDrop[id][wDPlayer]);
		                GiveMoney(playerid,WeaponDrop[id][wDMoney],str);
						WeaponDrop[id][wDMoney] = 0;
					}
	                for(new i; i < 13; i ++)
	                {
		                if(WeaponDrop[id][wDWeapons][i] != 0 && WeaponDrop[id][wDAmmo][i] != 0)
		                {
		                    GivePlayerWeaponEx(playerid,WeaponDrop[id][wDWeapons][i],WeaponDrop[id][wDAmmo][i]);
		                    WeaponDrop[id][wDWeapons][i] = 0;
		                    WeaponDrop[id][wDAmmo][i] = 0;
		                }
	                }
	            }
	            case 1:
	            {
					if(WeaponDrop[id][wDMoney] > 0)
					{
		                format(str,sizeof(str),"Sebral posmrtní balíèek hráèe %s",WeaponDrop[id][wDPlayer]);
	        	        GiveMoney(playerid,WeaponDrop[id][wDMoney],str);
	        	        WeaponDrop[id][wDMoney] = 0;
					}
	            }
	        }
	        if(listitem > 1)
	        {
	            new slot = listitem-2;
	            for(new i; i <= slot; i ++)
	            {
	                if(WeaponDrop[id][wDWeapons][i] == 0 && WeaponDrop[id][wDAmmo][i] == 0)
	                {
	                    slot ++;
	                }
	            }
				GivePlayerWeaponEx(playerid,WeaponDrop[id][wDWeapons][slot],WeaponDrop[id][wDAmmo][slot]);
				WeaponDrop[id][wDWeapons][slot] = 0;
				WeaponDrop[id][wDAmmo][slot] = 0;
	        }
            new weapons = 0;
            if(WeaponDrop[id][wDMoney] == 0)
            {
				for(new i; i < 13; i ++)
				{
					if(WeaponDrop[id][wDWeapons][i] == 0 && WeaponDrop[id][wDAmmo][i] == 0)
					{
						weapons++;
		            }
				}
	        }
			if(weapons >= 13)
			{
				ResetWeaponDrop(id);
			}
	    }
	    return 1;
	}
	if(dialogid == 22)
	{
	    if(response)
	    {
			PlayerDrazba[playerid][pDrazbaType] = listitem;
			if(listitem != DRAZBA_TYPE_POINTS)
			{
				SPD(playerid,23,DIALOG_STYLE_MSGBOX,"Vytvoøit drabu","Budu drai za:",""cg"Peníze",""cc"Body");
			}
			else
			{
				PlayerDrazba[playerid][pDrazbaPriceType] = PRICE_TYPE_MONEY;
				SPD(playerid,24,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte mnoství","Zadat","Zavøít");
			}
		}
	    else
	    {
		    ResetPlayerDrazba(playerid);
	    }
	    return 1;
	}
	if(dialogid == 23)
	{
		PlayerDrazba[playerid][pDrazbaPriceType] = response;
		switch(PlayerDrazba[playerid][pDrazbaType])
		{
			case DRAZBA_TYPE_VEHICLE:{
				new vehicles,DIALOG[2500],str[100];
				for(new i; i < GetMaxVehicleSlots(); i ++)
			    {
			        new modelid = GetPlayerVehicle(playerid,i),slot = i;
					if(modelid != -1)
					{
					    vehicles ++;
						format(str,sizeof(str),"{0077FF}%d. "cw"%s\t"cc"Slot: "co"%d\n",vehicles,GetVehicleName(modelid),slot+1);
						strcat(DIALOG,str);
					}
			    }
			    if(vehicles > 0) SPD(playerid,27,DIALOG_STYLE_TABLIST,"Vytvoøit drabu",DIALOG,"Vybrat","Zavøít");
			    else SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Vytvoøit drabu","Nemáte k dispozici ádná vozidla","Zavøít","");
			}
			case DRAZBA_TYPE_PROPERTY:{
			    new properties,DIALOG[600],str[100],property;
			    for(new i; i < GetPlayerPropertiesSlots(playerid); i ++)
			    {
			        property = GetPlayerProperty(playerid,i);
					if(property != -1)
					{
						properties ++;
					    format(str,sizeof(str),"{0077FF}%d. "cw"%s\t"cc"IÈO: "co"%d\n",i+1,GetPropertyName(property),property);
						strcat(DIALOG,str);
					}
			    }
				if(properties > 0) SPD(playerid,28,DIALOG_STYLE_TABLIST,"Vytvoøit drabu",DIALOG,"Vybrat","Zavøít");
				else SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Vytvoøit drabu","Nemáte k dispozici ádné nemovitosti","Zavøít","");
			}
			case DRAZBA_TYPE_HOUSE:{
			    new house = GetPlayerHouse(playerid),str[100];
			    if(house != -1)
			    {
				    format(str,sizeof(str),"{0077FF}1. "cw"%s\t"cc"è.p.: "co"%d\n",GetHouseName(house),house+1);
				    SPD(playerid,29,DIALOG_STYLE_TABLIST,"Vytvoøit drabu",str,"Vybrat","Zavøít");
			    }
			    else SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Vytvoøit drabu","Nevlastníte ádnı dùm","Zavøít","");
			}
			case DRAZBA_TYPE_GANG:{
			    new gang = GetPlayerGangBoss(playerid),str[100];
			    if(gang != -1)
			    {
				    format(str,sizeof(str),"{0077FF}1. "cw"%s\t"cc"ID: "co"%d\n",GetGangName(gang),gang);
				    SPD(playerid,30,DIALOG_STYLE_TABLIST,"Vytvoøit drabu",str,"Vybrat","Zavøít");
			    }
			    else SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Vytvoøit drabu","Nevlastníte ádnı gang","Zavøít","");
			}
			default:
				SPD(playerid,24,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte mnoství","Zadat","Zavøít");
		}
  		return 1;
	}
	if(dialogid == 24)
	{
		if(response)
		{
			new amount = strval(inputtext);
			if(!strlen(inputtext)) return SPD(playerid,24,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte mnoství","Zadat","Zavøít");
			if(!IsNumeric(inputtext)) return SPD(playerid,24,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte mnoství","Zadat","Zavøít");
			switch(PlayerDrazba[playerid][pDrazbaType])
			{
			    case DRAZBA_TYPE_GANJA:
					if(Player[playerid][pGanja] < amount || amount < 1) return SPD(playerid,24,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte mnoství\n\n"cr"Chybnì zadanı poèet marihuany","Zadat","Zavøít");

				case DRAZBA_TYPE_POINTS:
					if(GetPlayerPoints(playerid) < amount || amount < 1) return SPD(playerid,24,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte mnoství\n\n"cr"Chybnì zadanı poèet bodù","Zadat","Zavøít");
    		}
			SPD(playerid,25,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte vyvolávací cenu","Zadat","Zavøít");
			PlayerDrazba[playerid][pDrazbaAmount] = amount;
		}
		else
		{
		    ResetPlayerDrazba(playerid);
		}
		return 1;
	}
	if(dialogid == 25)
	{
		if(response)
		{
			new castka = strval(inputtext),str[145];
			if(!strlen(inputtext)) return SPD(playerid,25,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte vyvolávací cenu","Zadat","Zavøít");
			if(!IsNumeric(inputtext)) return SPD(playerid,25,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte vyvolávací cenu","Zadat","Zavøít");
			if(PlayerDrazba[playerid][pDrazbaPriceType] == PRICE_TYPE_MONEY)
			{
				if(castka < 0 || castka > 900000000) return SPD(playerid,25,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte vyvolávací cenu\n\n"cr"Rozmezí vyvolávací ceny je 0 - 900.000.000$","Zadat","Zavøít");
			}
			else
			{
				if(castka < 0 || castka > 100000) return SPD(playerid,25,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte vyvolávací cenu\n\n"cr"Rozmezí vyvolávací ceny je 0 - 100.000 bodù","Zadat","Zavøít");
			}
			PlayerDrazba[playerid][pDrazbaPrice] = castka;
			switch(PlayerDrazba[playerid][pDrazbaType])
			{
			    case DRAZBA_TYPE_GANJA:{
			        format(str,sizeof(str),"[ /drazba ] Hráè "clg"%s(%d) "cpr"draí "clg"%dg marihuany"cpr". Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,PlayerDrazba[playerid][pDrazbaAmount],playerid);
				}
				case DRAZBA_TYPE_POINTS:{
			        format(str,sizeof(str),"[ /drazba ] Hráè "clg"%s(%d) "cpr"draí "clg"%d bodù"cpr". Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,PlayerDrazba[playerid][pDrazbaAmount],playerid);
				}
				case DRAZBA_TYPE_VEHICLE:{
			        format(str,sizeof(str),"[ /drazba ] Hráè "clg"%s(%d) "cpr"draí vozidlo"clg" %s"cpr". Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,GetVehicleName(GetPlayerVehicle(playerid,PlayerDrazba[playerid][pDrazbaItem])),playerid);
				}
				case DRAZBA_TYPE_PROPERTY:{
			        format(str,sizeof(str),"[ /drazba ] Hráè "clg"%s(%d) "cpr"draí "clg"nemovitost è.: %d (lvl: %d)"cpr". Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,PlayerDrazba[playerid][pDrazbaItem],GetPropertyLevel(PlayerDrazba[playerid][pDrazbaItem]),playerid);
				}
				case DRAZBA_TYPE_HOUSE:{
			        format(str,sizeof(str),"[ /drazba ] Hráè "clg"%s(%d) "cpr"draí "clg"dùm è.p.: %d"cpr". Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,PlayerDrazba[playerid][pDrazbaItem]+1,playerid);
				}
				case DRAZBA_TYPE_GANG:{
			        format(str,sizeof(str),"[ /drazba ] Hráè "clg"%s(%d) "cpr"draí gang "clg"%s"cpr". Pøihazujte "clg"/prihodit %d",Jmeno(playerid),playerid,GetGangName(PlayerDrazba[playerid][pDrazbaItem]),playerid);
				}
			}
	        SCMTA(PING_RED,str);
			format(str,sizeof(str),"Vyvolávací cena je "clg"%s"cpr".",PriceTypeText(PlayerDrazba[playerid][pDrazbaPriceType],PlayerDrazba[playerid][pDrazbaPrice]));
			SCMTA(PING_RED,str);
			PlayerDrazba[playerid][pDrazbaStatus] = true;
			SM(playerid,"Menu draby zobrazíte opìtovnım napsáním pøíkazu "cg"/drazba");
		}
		else
		{
		    ResetPlayerDrazba(playerid);
		}
		return 1;
	}
	if(dialogid == 26)
	{
	    if(response)
	    {
	        new str[145];
	        switch(listitem)
	        {
	            case 0:
	            {
                    ResetPlayerDrazba(playerid);
		 	        format(str,sizeof(str),"[ /drazba ] Hráè "clg"%s(%d) "cpr"ukonèil drabu.",Jmeno(playerid),playerid);
			        SCMTA(PING_RED,str);
	            }
	            case 1:
	            {
	                new id =PlayerDrazba[playerid][pDrazbaPlayer];
	                if(!IPC(id)) return SM(playerid,"Hráè se u odpojil");
	                if(!CheckPlayerDrazba(playerid)) return SM(playerid,"Vyskytl se problém s provedením platby, (hráè nemá dostatek prostøedkù apod.)");
					if(PlayerDrazba[playerid][pDrazbaPriceType] == PRICE_TYPE_MONEY)
				    {
			            if(GetMoney(id)+Player[id][pBanka] < PlayerDrazba[playerid][pDrazbaPrice]) return SM(playerid,"Hráè u sebe u nemá tolik penìz");
			            format(str,sizeof(str),"Draba hráèe %s",Jmeno(playerid));
			            new castka = PlayerDrazba[playerid][pDrazbaPrice];
			            if(castka > GetMoney(id))
			            {
			                castka -= GetMoney(id);
			            	Player[id][pBanka] -= castka;
							GiveMoney(id,-GetMoney(id),str);
						}
						else
						{
						    GiveMoney(id,-castka,str);
						}
			            format(str,sizeof(str),"Draba prodáno hráèi %s",Jmeno(id));
						GiveMoney(playerid,PlayerDrazba[playerid][pDrazbaPrice],str);
					}
			        else
			        {
			            if(GetPlayerPoints(id) < PlayerDrazba[playerid][pDrazbaPrice]) return SM(playerid,"Hráè u sebe u nemá tolik bodù");
						GivePlayerPoints(playerid,PlayerDrazba[playerid][pDrazbaPrice]);
						GivePlayerPoints(id,-PlayerDrazba[playerid][pDrazbaPrice]);
			        }
					switch(PlayerDrazba[playerid][pDrazbaType])
					{
					    case DRAZBA_TYPE_GANJA:{
							format(str,sizeof(str),"Hráè "cg"%s "cdc"Vám prodal v drabì "cg"%dg "cdc"marihuany za "cg"%s",Jmeno(playerid),PlayerDrazba[playerid][pDrazbaAmount],PriceTypeText(PlayerDrazba[playerid][pDrazbaPriceType],PlayerDrazba[playerid][pDrazbaPrice]));
							new reason[70];
							format(reason,sizeof(reason),"Prodej v drabì hráèi %s",Jmeno(id));
				            GivePlayerGanja(playerid,-PlayerDrazba[playerid][pDrazbaAmount],reason,true);
							format(reason,sizeof(reason),"Zakoupení v drabì hráèe %s",Jmeno(playerid));
				            GivePlayerGanja(id,PlayerDrazba[playerid][pDrazbaAmount],reason,true);
						}
						case DRAZBA_TYPE_POINTS:{
							format(str,sizeof(str),"Hráè "cg"%s "cdc"Vám prodal v drabì "cg"%d "cdc"bodù za "cg"%s",Jmeno(playerid),PlayerDrazba[playerid][pDrazbaAmount],PriceTypeText(PlayerDrazba[playerid][pDrazbaPriceType],PlayerDrazba[playerid][pDrazbaPrice]));
							GivePlayerPoints(playerid,-PlayerDrazba[playerid][pDrazbaAmount],true);
							GivePlayerPoints(id,PlayerDrazba[playerid][pDrazbaAmount]);
						}
						case DRAZBA_TYPE_VEHICLE:{
							format(str,sizeof(str),"Hráè "cg"%s "cdc"Vám prodal v drabì vozidlo "cg"%s "cdc" za "cg"%s",Jmeno(playerid),GetVehicleName(GetPlayerVehicle(playerid,PlayerDrazba[playerid][pDrazbaItem])),PriceTypeText(PlayerDrazba[playerid][pDrazbaPriceType],PlayerDrazba[playerid][pDrazbaPrice]));
							ChangeVehicleOwner(playerid,PlayerDrazba[playerid][pDrazbaItem],id);
						}
						case DRAZBA_TYPE_PROPERTY:{
							format(str,sizeof(str),"Hráè "cg"%s "cdc"Vám prodal v drabì nemovitost "cg"è.: %d (lvl: %d) "cdc"bodù za "cg"%s",Jmeno(playerid),PlayerDrazba[playerid][pDrazbaItem],GetPropertyLevel(PlayerDrazba[playerid][pDrazbaItem]),PriceTypeText(PlayerDrazba[playerid][pDrazbaPriceType],PlayerDrazba[playerid][pDrazbaPrice]));
							if(GetPropertyEarning(PlayerDrazba[playerid][pDrazbaItem]) > 0)
							{
								new text[200];
								format(text,sizeof(text),"Vaše nemovitost "cg"è.: %d (lvl: %d) "cdc"byla prodána v drabì. V nemovitosti bylo\nnevyzvednutıch "cg"%s$"cdc", tyto peníze byly pøevedeny do záloního trezoru\n"cg"/trezor",PlayerDrazba[playerid][pDrazbaItem],GetPropertyLevel(PlayerDrazba[playerid][pDrazbaItem]),SeperateNumber(GetPropertyEarning(PlayerDrazba[playerid][pDrazbaItem])));
								SendPlayerNotification(Jmeno(playerid),"Peníze z prodané nemovitosti",text);
								GivePlayerMoneyToTrezor(Jmeno(playerid),GetPropertyEarning(PlayerDrazba[playerid][pDrazbaItem]));
							}
							ChangePropertyOwner(PlayerDrazba[playerid][pDrazbaItem],Jmeno(id));
						}
						case DRAZBA_TYPE_HOUSE:{
							format(str,sizeof(str),"Hráè "cg"%s "cdc"Vám prodal v drabì dùm è.p.: "cg"%d "cdc"za "cg"%s",Jmeno(playerid),PlayerDrazba[playerid][pDrazbaItem]+1,PriceTypeText(PlayerDrazba[playerid][pDrazbaPriceType],PlayerDrazba[playerid][pDrazbaPrice]));
							ChangeHouseOwner(PlayerDrazba[playerid][pDrazbaItem],Jmeno(id));
						}
						case DRAZBA_TYPE_GANG:{
							format(str,sizeof(str),"Hráè "cg"%s "cdc"Vám prodal v drabì gang: "cg"%s "cdc"za "cg"%s",Jmeno(playerid),GetGangName(PlayerDrazba[playerid][pDrazbaItem]),PriceTypeText(PlayerDrazba[playerid][pDrazbaPriceType],PlayerDrazba[playerid][pDrazbaPrice]));
							ChangeGangOwner(PlayerDrazba[playerid][pDrazbaItem],Jmeno(id));
						}
					}
					SendPlayerNotification(Jmeno(id),"Draba",str);
		 	        format(str,sizeof(str),"[ /drazba ] Hráè "clg"%s(%d) "cpr"ukonèil drabu [ %s | "clg"%s "cpr"].",Jmeno(playerid),playerid,Jmeno(id),PriceTypeText(PlayerDrazba[playerid][pDrazbaPriceType],PlayerDrazba[playerid][pDrazbaPrice]));
			        SCMTA(PING_RED,str);
					ResetPlayerDrazba(playerid);
			    }
	        }
	    }
	    return 1;
	}
	if(dialogid == 27)
	{
	    if(response)
	    {
			for(new i; i <= listitem; i ++)
			{
			    new modelid = GetPlayerVehicle(playerid,i);
			    if(modelid == -1)
			    {
			        listitem++;
			    }
			}
			PlayerDrazba[playerid][pDrazbaItem] = listitem;
			new str[145];
			format(str,sizeof(str),"Vybráno vozidlo: {0077FF}%s "cw"[ "cc"Slot: "co"%d"cw" ]",GetVehicleName(GetPlayerVehicle(playerid,listitem)),listitem+1);
			SCM(playerid,-1,str);
			SPD(playerid,25,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte vyvolávací cenu","Zadat","Zavøít");
		}
		else ResetPlayerDrazba(playerid);
	    return 1;
	}
	if(dialogid == 28)
	{
	    if(response)
	    {
	        new properties,property;
			for(new i; i < GetPlayerPropertiesSlots(playerid); i ++)
			{
			    property = GetPlayerProperty(playerid,i);
				if(property != -1)
				{
					properties++;
					if(properties == listitem+1)
					{
					    break;
					}
			    }
			}
			PlayerDrazba[playerid][pDrazbaItem] = property;
			new str[145];
			format(str,sizeof(str),"Vybrána nemovitost {0077FF}%s "cw"[ "cc"IÈO: "co"%d"cw" ]",GetPropertyName(property),property);
			SCM(playerid,-1,str);
			SPD(playerid,25,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte vyvolávací cenu","Zadat","Zavøít");
	    }
	    else ResetPlayerDrazba(playerid);
	    return 1;
	}
	if(dialogid == 29)
	{
		if(response)
		{
		    new house = GetPlayerHouse(playerid);
		    if(house != -1)
		    {
				PlayerDrazba[playerid][pDrazbaItem] = house;
				new str[145];
				format(str,sizeof(str),"Vybrán dùm {0077FF}%s "cw"[ "cc"è.p.: "co"%d"cw" ]",GetHouseName(house),house+1);
				SCM(playerid,-1,str);
				SPD(playerid,25,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte vyvolávací cenu","Zadat","Zavøít");
		    }
		    else ResetPlayerDrazba(playerid);
		}
		else ResetPlayerDrazba(playerid);
		return 1;
	}
	if(dialogid == 30)
	{
		if(response)
		{
		    new gang = GetPlayerGangBoss(playerid);
		    if(gang != -1)
		    {
				PlayerDrazba[playerid][pDrazbaItem] = gang;
				new str[145];
				format(str,sizeof(str),"Vybrán gang {0077FF}%s "cw"[ "cc"ID: "co"%d"cw" ]",GetGangName(gang),gang);
				SCM(playerid,-1,str);
				SPD(playerid,25,DIALOG_STYLE_INPUT,"Vytvoøit drabu","Zadejte vyvolávací cenu","Zadat","Zavøít");
		    }
		    else ResetPlayerDrazba(playerid);
		}
		else ResetPlayerDrazba(playerid);
		return 1;
	}
	if(dialogid == 31)
	{
	    if(response)
	    {
	        new DIALOG[2000],str[50],vehicles;
	        for(new i; i < sizeof(CarMenuVehicles[]); i ++)
	        {
	            if(CarMenuVehicles[listitem][i] != 0)
	            {
	                vehicles ++;
	                format(str,sizeof(str),"{0077FF}%d. "cw"%s\n",vehicles,GetVehicleName(CarMenuVehicles[listitem][i]));
	                strcat(DIALOG,str);
	            }
	            else
	            {
	                break;
	            }
	        }
	        if(vehicles == 0) return SPD(playerid,0,DIALOG_STYLE_MSGBOX,"CarMenu","V této kategorii nebylo nalezeno ádné vozidlo","Zavøít","");
			else
			{
				format(str,sizeof(str),"%s "cw"[{0077FF} %d "cw"]",CarMenuCategories[listitem],vehicles);
				SPD(playerid,32,DIALOG_STYLE_LIST,str,DIALOG,"Vybrat","Zpìt");
			}
			SetPVarInt(playerid,"CarMenuCategory",listitem);
		}
	    return 1;
	}
	if(dialogid == 32)
	{
	    if(response)
	    {
	        new category = GetPVarInt(playerid,"CarMenuCategory");
			CreateCarMenuVehicle(playerid,CarMenuVehicles[category][listitem]);
	    }
	    else ShowCarMenu(playerid);
	    return 1;
	}
	if(dialogid == 33)
	{
	    if(response)
	    {
	        SetPVarInt(playerid,"LastSlotID",listitem);
	        if(PlayerAddons[playerid][pAddonID][listitem] == -1)
	        {
				ShowAddonsList(playerid);
			}
	        else
	        {
	            SPD(playerid,39,DIALOG_STYLE_LIST,"Doplòky","Upravit doplnìk\nOdstranit doplnìk","Vybrat","Zavøít");
	        }
	    }
	    return 1;
	}
	if(dialogid == 34)
	{
	    if(response)
	    {
	        new slot = GetPVarInt(playerid,"LastSlotID");
	        PlayerAddons[playerid][pAddonID][slot] = -1;
			if(IsPlayerAttachedObjectSlotUsed(playerid,slot))
			{
				RemovePlayerAttachedObject(playerid,slot);
			}
	    }
		ShowAddonsMenu(playerid);
		return 1;
	}
	if(dialogid == 35)
	{
	    if(response)
	    {
	        new page = GetPVarInt(playerid,"Page");
			if(listitem < 19)
			{
		        new slot = GetPVarInt(playerid,"LastSlotID"),addonid = listitem+page*19;
	            if(IsPlayerAttachedObjectSlotUsed(playerid,slot)) return SM(playerid,"Tento slot u je zabranı");
	            if(GetPlayerLevel(playerid) >= AddonsList[addonid][AddonLevel])
	            {
					if(GetPlayerPoints(playerid) > AddonsList[addonid][AddonPrice])
					{
			            GivePlayerPoints(playerid,-AddonsList[addonid][AddonPrice]);
						CreateAddon(playerid,slot,addonid);
					}
					else
					{
						SM(playerid,"Nemáte dostatek bodù");
					 	ShowAddonsList(playerid,page);
					}
				}
				else
				{
					SM(playerid,"Nemáte dostateènı level");
				 	ShowAddonsList(playerid,page);
				}
			}
			else ShowAddonsList(playerid,page+1);
		}
	    return 1;
	}
	if(dialogid == 36)
	{
	    if(response)
	    {
	        if(listitem < sizeof(WeaponsList))
	        {
				new DIALOG[500],str[145];
				for(new i; i < sizeof(WeaponsList[]); i ++)
				{
				    if(WeaponsList[listitem][i] != 0)
				    {
						format(str,sizeof(str),"%s\n",GetWeaponNameEx(WeaponsList[listitem][i]));
						strcat(DIALOG,str);
					}
				}
				SetPVarInt(playerid,"LastSlotID",listitem);
				SPD(playerid,37,DIALOG_STYLE_TABLIST,"Obchod se zbranìma",DIALOG,"Koupit","Zavøít");
	        }
	        else
	        {
	            if(GetPlayerPoints(playerid) < 10) return SM(playerid,"Nemáte dostatek bodù");
	            SetPlayerArmour(playerid,100);
	            GivePlayerPoints(playerid,-10);
	        }
		}
	    return 1;
	}
	if(dialogid == 37)
	{
	    if(response)
	    {
	        new slot = GetPVarInt(playerid,"LastSlotID");
	        GivePlayerWeapon(playerid,WeaponsList[slot][listitem],50);
	    }
	    return 1;
	}
	if(dialogid == 38)
	{
	    if(!response) SPD(playerid,38,DIALOG_STYLE_PASSWORD,"Zmìna hesla",""cr"Upozornìní:\n\n"cw"Nedávno byl zaznamenán únik hesel na jednom nejmenovaném server,\nváš úèet je mezi nimi! Proto si prosím zmìòte ihned heslo!\n\nZadejte nové heslo:","Zmìnit","");
		else
		{
		    if(!strlen(inputtext)) return SPD(playerid,38,DIALOG_STYLE_PASSWORD,"Zmìna hesla",""cr"Upozornìní:\n\n"cw"Nedávno byl zaznamenán únik hesel na jednom nejmenovaném server,\nváš úèet je mezi nimi! Proto si prosím zmìòte ihned heslo!\n\nZadejte nové heslo:","Zmìnit","");
		    if(strlen(inputtext) < 3 || strlen(inputtext) > 24) return SPD(playerid,38,DIALOG_STYLE_PASSWORD,"Zmìna hesla",""cr"Upozornìní:\n\n"cw"Nedávno byl zaznamenán únik hesel na jednom nejmenovaném server,\nváš úèet je mezi nimi! Proto si prosím zmìòte ihned heslo!\n\n"cr"Rozmezí délky hesla je 0-24","Zmìnit","");
			if(!IsPasswordBad(Jmeno(playerid),inputtext)) return SPD(playerid,38,DIALOG_STYLE_PASSWORD,"Zmìna hesla",""cr"Upozornìní:\n\n"cw"Nedávno byl zaznamenán únik hesel na jednom nejmenovaném server,\nváš úèet je mezi nimi! Proto si prosím zmìòte ihned heslo!\n\n"cr"Nemùete pouít stejné heslo, pouijte jiné","Zmìnit","");
            ChangePassword(Jmeno(playerid),inputtext);
            new sfile[50];
            format(sfile,sizeof(sfile),"Unik_hesel/%s.txt",Jmeno(playerid));
            if(fexist(sfile))
				DOF2_RemoveFile(sfile);
			new query[200];
			mysql_format(mysql,query,sizeof(query),"UPDATE `Users` SET `Password`=PASSWORD('%e') WHERE `Nick`='%e'",inputtext,Jmeno(playerid));
			mysql_tquery(mysql,query,"","");
			new str[145];
			format(str,sizeof(str),"Zmìna hesla probìhla "cg"úspìšnì"cdc", nové heslo: "cg"%s",inputtext);
			SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Zmìna hesla",str,"Zavøít","");
		}
		return 1;
	}
	if(dialogid == 39)
	{
	    if(response)
	    {
	        new id = GetPVarInt(playerid,"LastSlotID"),str[145];
			switch(listitem)
			{
			    case 0:
			    {
			        Player[playerid][pEditAddon] = PlayerAddons[playerid][pAddonID][id];
					EditAttachedObject(playerid,id);
			    }
			    case 1:
			    {
		            format(str,sizeof(str),"Opravdu si pøejete smazat object "cg"%s"cdc"?",AddonsList[PlayerAddons[playerid][pAddonID][id]][AddonName]);
		            SPD(playerid,34,DIALOG_STYLE_MSGBOX,"Doplòky",str,"Ano","Ne");
			    }
			}
	    }
	    return 1;
	}
	if(dialogid == 40)
	{
		if(response)
		{
			new spid = GetPVarInt(playerid,"SpecialPropertyID");
			BuySpecialProperty(playerid,spid);
		}
		return 1;
	}
	if(dialogid == 41)
	{
		if(response)
		{
			new str[300],msg[50];
			switch(listitem)
			{
				case 0:
				{
					if(PlayerSP[playerid][pSPSupplies] <= 0)
						format(msg,sizeof(msg),""cr"Nevydìlává (nedostatek zásob)");
					else if(PlayerSP[playerid][pSPStock] >= SPECIAL_FULL_STOCK)
						format(msg,sizeof(msg),""cr"Nevydìlává (plnı sklad)");
					else 
						format(msg,sizeof(msg),""cg"Vydìlává");

					format(str,sizeof(str),"Aktuální stav zásob: "cg"%0.2f%%\n"cdc"Aktuální stav skladu: "cg"%0.2f%%\n"cdc"Hodnota skladu: "cg"%d bodù\n"cdc"Celkovı vıdìlek: "cg"%d bodù"cdc"\n\n"cdc"Nemovitost: %s",float(PlayerSP[playerid][pSPSupplies]*100)/SPECIAL_FULL_SUPPS,float(PlayerSP[playerid][pSPStock]*100)/SPECIAL_FULL_STOCK,(PlayerSP[playerid][pSPStock]*SPECIAL_MAX_EARN)/SPECIAL_FULL_STOCK,PlayerSP[playerid][pSPEarning],msg);
					SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Nemovitost",str,"Zavøít","");
				}
				case 1:
				{
					SPD(playerid,42,DIALOG_STYLE_LIST,"Nemovitost","Ukrást zásoby\nKoupit zásoby","Vybrat","Zavøít");
				}
				case 2:
				{
					new sell = (PlayerSP[playerid][pSPStock]*SPECIAL_MAX_EARN)/SPECIAL_FULL_STOCK;
					if(sell == 0) return SM(playerid,"Váš sklad nemá aktuálnì ádnou hodnotu");
					format(str,sizeof(str),"Opravdu chcete prodat Váš sklad za "cg"%d bodù"cdc"?",sell);
					SPD(playerid,44,DIALOG_STYLE_MSGBOX,"Nemovitost",str,"Ano","Ne");
				}
				case 3:
				{
					new spid = PlayerSP[playerid][pSPID];
					if((PlayerSP[playerid][pSPStock]*SPECIAL_MAX_EARN)/SPECIAL_FULL_STOCK > 3) return SM(playerid,"Nejdøív prodejte sklad");
					format(str,sizeof(str),"Opravdu chcete prodat tuto nemovitost za "cg"%0.1f bodù"cdc"? (3/4 pùvodní ceny)",SpecialProps[spid][3]*3/4);
					SPD(playerid,45,DIALOG_STYLE_MSGBOX,"Nemovitost",str,"Ano","Ne");
				}
			}
		}
		return 1;
	}
	if(dialogid == 42)
	{
		if(response)
		{
			new str[145];
			switch(listitem)
			{
				case 0:
				{
					new Free[sizeof(SpecialPropSupps)],unused,spid = PlayerSP[playerid][pSPID],rand;
					for(new i; i < sizeof(SpecialPropSupps); i ++)
					{
						if(SpecialPropSupps[i][sUsed] == false && GetDistanceBetweenPoints(SpecialProps[spid][0],SpecialProps[spid][1],SpecialProps[spid][2],SpecialPropSupps[i][sX],SpecialPropSupps[i][sY],SpecialPropSupps[i][sZ]) > 1500.0)
						{
							Free[unused] = i;
							unused ++;
						}
					}
					if(unused == 0) return SM(playerid,"Aktuálnì nebyly nalezeny ádné zásoby, zkuste to pozdìji");
					rand = Free[random(sizeof(Free))];
					ExitPlayerSpecialProperty(playerid);
					SpecialPropSupps[rand][sUsed] = true;
					PlayerSP[playerid][pSPSuppID] = rand;
					PlayerSP[playerid][pSPSuppState] = 0;
					PlayerSP[playerid][pSPSuppRunning] = SPECIAL_SUPP_TIME;
					SetPlayerCheckpoint(playerid, SpecialPropSupps[rand][sX],SpecialPropSupps[rand][sY],SpecialPropSupps[rand][sZ], 5);
					PlayerSP[playerid][pSPSuppMapIcon] = CreateDynamicMapIcon(SpecialPropSupps[rand][sX],SpecialPropSupps[rand][sY],SpecialPropSupps[rand][sZ], 47, -1, 0,.streamdistance = 8000, .style = MAPICON_GLOBAL,.playerid = playerid);
					PlayerSP[playerid][pSPSuppVehicle] = CreateVehicle(SpecialPropSupps[rand][sModel],SpecialPropSupps[rand][sX],SpecialPropSupps[rand][sY],SpecialPropSupps[rand][sZ],SpecialPropSupps[rand][sA],-1,-1,-1);
					SetVehicleHealth(PlayerSP[playerid][pSPSuppVehicle], 1000*2);
					SM(playerid,"Zásoby lokalizovány (ikonka Z nebo èervenı checkpoint) na mapì");
					SetPlayerLimitTimer(playerid,SPECIAL_SUPP_TIME);
				}
				case 1:
				{
					if(PlayerSP[playerid][pSPSupplies] >= SPECIAL_FULL_SUPPS/4*3) return SM(playerid,"Máte více jak 75%% zásob");
					format(str,sizeof(str),"Chcete doplnit "cg"25%% "cdc"skladu za "cg"%0.1f bodù"cdc"?",SPECIAL_SUPPS_PRICE);
					SPD(playerid,43,DIALOG_STYLE_MSGBOX,"Nemovitost",str,"Ano","Ne");
				}
			}
		}
		return 1;
	}
	if(dialogid == 43)
	{
		if(response)
		{
			new str[145];
			if(GetPlayerPoints(playerid) < SPECIAL_SUPPS_PRICE) return SM(playerid,"Nemáte dostatek bodù");
			GivePlayerPoints(playerid,-SPECIAL_SUPPS_PRICE);
			PlayerSP[playerid][pSPSupplies] += SPECIAL_FULL_SUPPS/4;
			format(str,sizeof(str),"Zakoupeno "cg"25%% "cdc"zásob za "cg"%0.1f bodù "cdc". Aktuálnì máte "cg"%0.2f%% "cdc"zásob",SPECIAL_SUPPS_PRICE,float((PlayerSP[playerid][pSPSupplies]*100))/SPECIAL_FULL_SUPPS);
			SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Nemovitost",str,"Zavøít","");
			SaveSpecialProperty(playerid);
		}
		return 1;
	}
	if(dialogid == 44)
	{
		if(response)
		{
			new str[145],sell = (PlayerSP[playerid][pSPStock]*SPECIAL_MAX_EARN)/SPECIAL_FULL_STOCK;
			format(str,sizeof(str),"Sklad úspìšnì prodán za "cg"%d bodù",sell);
			SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Nemovitost",str,"Zavøít","");
			PlayerSP[playerid][pSPEarning] += sell;
			GivePlayerPoints(playerid,sell);
			PlayerSP[playerid][pSPStock] = 0;
			SaveSpecialProperty(playerid);
		}
		return 1;
	}
	if(dialogid == 45)
	{
		if(response)
		{
			new spid = PlayerSP[playerid][pSPID],str[145];
			if(spid != -1)
			{
				new query[300],Float:sell = SpecialProps[spid][3]*3/4;
				mysql_format(mysql,query,sizeof(query),"DELETE FROM `SpecialProperties` WHERE `Nick`='%e'",Jmeno(playerid));
				mysql_query(mysql,query,false);
				GivePlayerPoints(playerid,sell);
				ExitPlayerSpecialProperty(playerid);
				PlayerSP[playerid][pSPID] = -1;
				PlayerSP[playerid][pSPSupplies] = 0;
				PlayerSP[playerid][pSPStock] = 0;
				PlayerSP[playerid][pSPEarning] = 0;
				format(str,sizeof(str),"Nemovitost úspìšnì prodána za "cg"%0.1f bodù"cdc" (3/4 skladu)",sell);
				SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Nemovitost",str,"Zavøít","");
			}

		}
		return 1;
	}
	if(dialogid == 46)
	{
		new id = GetPVarInt(playerid,"OfferID"),Float:price = GetPVarFloat(playerid,"OfferPrice"),str[145];
		if(!IPC(id) || IsPlayerNPC(id)) return SM(playerid,"Hráè se odpojil, nabídka byla zrušena");
		if(!IsPlayerNearPlayer(playerid,id,10))
		{
			SM(playerid,"Hráè se od Vás pøíliš vzdálil, nabídka byla zrušena");
			SM(id,"Vzdálil jste se pøíliš od hráèe, nabídka byla zrušena");
		} 
		else
		{
			if(response)
			{
				switch(Player[id][pJob])
				{
					case JOB_PRAVNIK:
					{
						format(str,sizeof(str),"Pøijmul jste nabídku vysouzení za "cg"%0.1f bodù "cdc"od hráèe "cg"%s",price,Jmeno(id));
						SetPlayerWantedLevel(playerid, 0);
						Player[id][pJobXP][JOB_PRAVNIK] ++;
					    ApplyAnimation(id,"PED","IDLE_CHAT",4.1,0,1,1,1,1,1);
					}
					default:
					{
						SM(playerid,"chyba");
						Player[id][pOfferID] = -1;
						return 0;
					}
				}
				GivePlayerPoints(playerid,-price);
				GivePlayerPoints(id,price);
				SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Nabídka",str,"Zavøít","");
				format(str,sizeof(str),"Hráè "cg"%s "cdc"pøijal vaši nabídku za "cg"%0.1f bodù",Jmeno(playerid),price);
				SPD(id,0,DIALOG_STYLE_MSGBOX,"Nabídka",str,"Zavøít","");
			}
			else
			{
				format(str,sizeof(str),"Hráè "cg"%s "cdc"odmítnul vaši nabídku za "cg"%0.1f bodù",Jmeno(playerid),price);
				SPD(id,0,DIALOG_STYLE_MSGBOX,"Nabídka",str,"Zavøít","");
				format(str,sizeof(str),"Odmítnul jste nabídku za "cg"%0.1f bodù "cdc"od hráèe "cg"%s",price,Jmeno(id));
				SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Nabídka",str,"Zavøít","");
			}
		}
		Player[id][pOfferID] = -1;
		return 1;
	}
	if(dialogid == 47)
	{
		if(response)
		{
			new str[145],id = 0;
			if(listitem == 0)
			{

				new Float:Pos[3];
				GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
				new Float:meters = GetDistanceBetweenPoints(Pos[0],Pos[1],Pos[2],SpecialProps[id][0],SpecialProps[id][1],SpecialProps[id][2]);
				for(new i; i < sizeof(SpecialProps); i ++)
				{
					new Float:nmeters = GetDistanceBetweenPoints(Pos[0],Pos[1],Pos[2],SpecialProps[i][0],SpecialProps[i][1],SpecialProps[i][2]);
					if(nmeters < meters){
						meters = nmeters;
						id = i;
					}
				}
			}
			else{
				id = listitem-1;
			}
			NavigatePlayerToPos(playerid,SpecialProps[id][0],SpecialProps[id][1],SpecialProps[id][2]);
			format(str,sizeof(str),"~b~Vırobna zbraní %d ~w~vyznacena na mape",id+1);
			CreateInfoBox(playerid,"Navigace",str,5);
		}
		return 1;
	}
	if(dialogid == 4000)
	{
	    if(response)
	    {
			printf("%s -> Logging In [ Old Acc ]",Jmeno(playerid));
	        new file[50];
	        format(file,sizeof(file),"%s.dudb.sav",udb_encode(Jmeno(playerid)));
	        if(!strlen(inputtext)) return SPD(playerid,4000,DIALOG_STYLE_PASSWORD,"Pøihlášení","Zadejte vaše heslo","Zadat","Odejít");
	        if(DOF2_GetInt(file,"password_hash") != udb_hash(inputtext)) return SPD(playerid,4000,DIALOG_STYLE_PASSWORD,"Pøihlášení","Zadejte vaše heslo\n\n"cr"Chybné heslo","Zadat","Odejít");
			Player[playerid][pLogged] = true;
			Player[playerid][pPlayedTG] = gettime();
			DOF2_CreateFile(USER_FILES(playerid));
			HashPassword(Jmeno(playerid),inputtext);
			Player[playerid][pPlayedTime] = (DOF2_GetInt(file,"Hodin:")*60*60) + DOF2_GetInt(file,"Minut:")*60;
			Player[playerid][pMoney] = DOF2_GetInt(file,"money");
			Player[playerid][pBanka] = DOF2_GetInt(file,"Banka");
			Player[playerid][pVyplata] = DOF2_GetInt(file,"Vyplata");
			Player[playerid][pKills] = DOF2_GetInt(file,"zabil");
			Player[playerid][pDeaths] = DOF2_GetInt(file,"umrel");
			Player[playerid][pSkin] = DOF2_GetInt(file,"skin");
			SaveData(playerid);
			SCM(playerid,BILA,"Váš úèet z Realné Zemì 8 úspìšnì naèten");
			SCM(playerid,BILA,"Pokud máte pocit e jste o nìco pøišli kontaktujte nás na webu");
			SCM(playerid,BILA,SERVER_WEB);
			SpawnPlayer(playerid);
			TextDrawHideForPlayer(playerid,Textdraw1);
			TextDrawHideForPlayer(playerid,Textdraw2);
			TextDrawHideForPlayer(playerid,Textdraw3);
			ShowPlayerInfo(playerid,playerid);
			DOF2_RemoveFile(file);
			printf("%s -> Logged In [ Old Acc ]",Jmeno(playerid));
	    }
	    else
	    {
	        Kick(playerid);
	    }
	    return 1;
	}
	return 0;
}

function GivePlayerVyplata(playerid,castka)
{
	Player[playerid][pVyplata] += castka;
	return 1;
}

function GivePlayerJobPoints(playerid,points)
{
	Player[playerid][pJobXP][Player[playerid][pJob]] += points;
	return 1;
}

function GivePlayerJobReward(playerid)
{
	new jobtype = Player[playerid][pJob];
	if(Job[jobtype][jCashReward] != 0)
	{
		new str[30];
		Player[playerid][pVyplata] += (Job[jobtype][jCashReward]/5)*(GetPlayerJobRank(playerid)+1);
		format(str,sizeof(str),"~r~odmena~n~~w~%s$",SeperateNumber((Job[jobtype][jCashReward]/5)*(GetPlayerJobRank(playerid)+1)));
		GameTextForPlayer(playerid,str,4000,4);
	}
	Player[playerid][pJobXP][jobtype] ++;
	return 1;
}

function SendJobMessage(jobtype,message[])
{
	for(new i; i <= GetPlayerPoolSize(); i ++)
	{
	    if(IPC(i))
	    {
	        if(Player[i][pJob] == jobtype)
	        {
	            SendClientMessage(i,JCOLOR,message);
	        }
	    }
	}
	return 1;
}

function GetPlayerPlayedTime(playerid)
{
	return Player[playerid][pPlayedTime]+gettime()-Player[playerid][pPlayedTG];
}

function HideShowHours(playerid,type)
{
	if(type == 0)
	    TextDrawHideForPlayer(playerid,Textdraw4);
	else if(type == 1)
	    TextDrawShowForPlayer(playerid,Textdraw4);
	return 1;
}

function HashPassword(account[],pass[])
{
	new salt[11],password[65+1],acc[30];
	for(new i; i < 10; i++)
	{
		salt[i] = random(79) + 47;
	}
	salt[10] = 0;
	SHA256_PassHash(pass,salt,password,65);
	format(acc,sizeof(acc),"%s.txt",account);
	if(fexist(acc))
	{
		DOF2_SetString(acc,"Password",password);
		DOF2_SetString(acc,"Salt",salt);
		DOF2_SaveFile();
	}
	return 1;
}

function ChangePassword(account[],pass[])
{
   	HashPassword(account,pass);
	return 1;
}

function IsPasswordBad(account[],pass[])
{
	new hash[65],salt[11],acc[30];
	format(acc,sizeof(acc),"%s.txt",account);
	format(salt,sizeof(salt),DOF2_GetString(acc,"Salt"));
	SHA256_PassHash(pass,salt,hash,64);
	if(strcmp(hash,DOF2_GetString(acc,"Password"),false) != 0) return 1;
	return 0;
}

function GetPlayerGanja(playerid)
{
	return Player[playerid][pGanja];
}

function GetPlayerBankMoney(playerid)
{
	return Player[playerid][pBanka];
}

function GetPlayerJob(playerid)
{
	return Player[playerid][pJob];
}

function ShowBank(playerid)
{
	new str[145];
	format(str,sizeof(str),"Vloit hotovost\nVybrat hotovost\nVloit vše ("cg"%s$"cw")\nVybrat vše ("cg"%s$"cw")",SeperateNumber(GetMoney(playerid)),SeperateNumber(Player[playerid][pBanka]));
	SPD(playerid,2,DIALOG_STYLE_LIST,"Banka",str,"Vybrat","Zavøít");
	return 1;
}

function MakesPlayerDrivingSchool(playerid)
{
	return Player[playerid][pTest];
}

function SetPlayerJob(playerid,jobid)
{
	Player[playerid][pJob] = jobid;
	SetPlayerColor(playerid,Job[jobid][jColor]);
	return 1;
}

function EjectPlayerFromVehicle(playerid)
{
	new Float:Pos[3];
	GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
	SetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]+1);
}

function ShowCarMenu(playerid)
{
	new str[50],DIALOG[500];
	for(new i; i < sizeof(CarMenuCategories); i ++)
	{
	    format(str,sizeof(str),"{0077FF}%c"cw"%s\n",CarMenuCategories[i][0],CarMenuCategories[i][1]);
		strcat(DIALOG,str);
	}
	SPD(playerid,31,DIALOG_STYLE_LIST,"CarMenu",DIALOG,"Vybrat","Zavøít");
}

forward Float:GetDistanceBetweenPoints(Float:pos1X, Float:pos1Y, Float:pos1Z, Float:pos2X, Float:pos2Y, Float:pos2Z);

forward Float:getRand(Float:ll,Float:ul);

function IsPlayerSupplyRun(playerid)
{
	if(PlayerSP[playerid][pSPSuppState] != -1) return 1;
	return 0;
}

function ShowPlayerSpecProperties(playerid)
{
	new DIALOG[sizeof(SpecialProps)*31],str[30];
	strcat(DIALOG,"{0077FF}Nejbliší vırobna zbraní\n");
	for(new i; i < sizeof(SpecialProps); i ++)
	{
		format(str,sizeof(str),"Vırobna zbraní {0077FF}%d\n",i+1);
		strcat(DIALOG,str);
	}
	SPD(playerid,47,DIALOG_STYLE_LIST,"Vırobny zbraní",DIALOG,"Vybrat","Zavøít");
	return 1;
}

function NavigateToSpecialProperty(playerid,spid)
{
	return NavigatePlayerToPos(playerid,SpecialProps[spid][0],SpecialProps[spid][1],SpecialProps[spid][2]);
}

function IsPlayerInSpecialProperty(playerid)
{
	return PlayerSP[playerid][pSPInProp];
}


stock MakePlayerOffer(playerid,toplayerid,Float:price)
{
	new str[145];
	if(!IPC(toplayerid) || !IPC(playerid) || IsPlayerNPC(playerid) || IsPlayerNPC(toplayerid)) return 0;
	if(!IsPlayerNearPlayer(playerid,toplayerid,3)) return SM(playerid,"Musíte bıt blízko hráèe");
	if(Player[playerid][pOfferID] != -1 && toplayerid != Player[playerid][pOfferID]) return SM(playerid,"U nìkomu nìco nabízíte");
	if(ShowedDialog[toplayerid] == true) return SM(playerid,"Hráè má nevyøízenı dialog");
	if(GetPlayerPoints(toplayerid) < price) return SM(playerid,"Hráè nemá dostatek bodù");
	if(Player[playerid][pJob] == JOB_PRAVNIK)
		format(str,sizeof(str),"Hráè "cg"%s "cdc"Vám nabízí vysouzení za "cg"%0.1f bodù",Jmeno(playerid),price);
	else
	{
		SM(playerid,"Toto zamìstnání nezahrnuje nabídky");
		return 0;
	}
	SetPVarInt(toplayerid,"OfferID",playerid);
	SetPVarFloat(toplayerid,"OfferPrice",price);
	strcat(str,"\n\n"cdc"Pøíjmáte jeho nabídku?");
	SPD(toplayerid,46,DIALOG_STYLE_MSGBOX,"Nabídka",str,"Ano","Ne");
	format(str,sizeof(str),"Nabídka hráèi "cg"%s "cw"za "cg"%0.1f bodù "cw"odeslána, vyèkejte na odpovìï",Jmeno(toplayerid),price);
	SM(playerid,str);
	return 1;
}

stock SaveSpecialProperty(playerid)
{
	new query[300];
	if(PlayerSP[playerid][pSPID] != -1)
	{
		mysql_format(mysql,query,sizeof(query),"UPDATE `SpecialProperties` SET `Stock`=%d, `Supplies`=%d, `Earning`=%d WHERE `Nick`='%e'",PlayerSP[playerid][pSPStock],PlayerSP[playerid][pSPSupplies],PlayerSP[playerid][pSPEarning],Jmeno(playerid));
		mysql_query(mysql,query,false);
	}	
	return 1;
}

function CancelSupplyRun(playerid)
{
	if(PlayerSP[playerid][pSPSuppState] != -1)
	{
		new suppid = PlayerSP[playerid][pSPSuppID];
		DestroyDynamicMapIcon(PlayerSP[playerid][pSPSuppMapIcon]);
		PlayerSP[playerid][pSPSuppMapIcon] = 0;
		PlayerSP[playerid][pSPSuppState] = -1;
		PlayerSP[playerid][pSPSuppRunning] = 0;
		DestroyVehicle(PlayerSP[playerid][pSPSuppVehicle]);
		PlayerSP[playerid][pSPSuppVehicle] = 0;
		PlayerSP[playerid][pSPSuppID] = -1;
		SpecialPropSupps[suppid][sUsed] = false;
		DisablePlayerCheckpoint(playerid);
		CancelLimitTimer(playerid);
	}
	return 1;
}

stock BuySpecialProperty(playerid,spid)
{
	if(PlayerSP[playerid][pSPID] == -1 && IsPlayerLogged(playerid))
	{
		new str[145];
		format(str,sizeof(str),"Potøebujete nahrát na serveru minimálnì "cg"%d hodin",SPECIAL_MIN_TIME);
		if(GetPlayerPlayedTime(playerid)/60/60 < SPECIAL_MIN_TIME) return SM(playerid,str);
		if(GetPlayerPoints(playerid) < SpecialProps[spid][3]) return SM(playerid,"Nemáte dostatek bodù");
		new query[200];
		mysql_format(mysql,query,sizeof(query),"INSERT INTO `SpecialProperties` (`Nick`,`PropID`) VALUES ('%e',%d)",Jmeno(playerid),spid);
		mysql_query(mysql,query,false);
		PlayerSP[playerid][pSPID] = spid;
		format(str,sizeof(str),"Nemovitost úspìšnì zakoupena za "cg"%0.1f bodù\n\n"cdc"Více informací /help - Vırobna zbraní",SpecialProps[spid][3]);
		GivePlayerPoints(playerid,-SpecialProps[spid][3]);
		SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Nemovitost",str,"Zavøít","");
		EnterPlayerSpecialProperty(playerid);
	}
	return 1;
}

stock ExitPlayerSpecialProperty(playerid)
{
	new spid = PlayerSP[playerid][pSPID];
	SetPlayerPos(playerid,SpecialProps[spid][0],SpecialProps[spid][1],SpecialProps[spid][2]);
	SetPlayerVirtualWorld(playerid, 0);
	for(new i; i < sizeof(SpecialPropActors); i ++)
		DestroyDynamicActor(PlayerSP[playerid][pSPActors][i]);
	PlayerSP[playerid][pSPInProp] = 0;
	return 1;
}

stock EnterPlayerSpecialProperty(playerid)
{
	for(new i; i < sizeof(SpecialPropActors); i ++)
	{
		PlayerSP[playerid][pSPActors][i] = CreateDynamicActor(SpecialPropActors[i][aSkin],SpecialPropActors[i][aX],SpecialPropActors[i][aY],SpecialPropActors[i][aZ],SpecialPropActors[i][aA],.worldid = SPECIAL_PROP_VW+playerid);
		ApplyDynamicActorAnimation(PlayerSP[playerid][pSPActors][i], SpecialPropActors[i][aAnimLib], SpecialPropActors[i][aAnimName],4.0, 1, 0, 0, 0, 0);
	}
	SetPlayerPos(playerid,974.8262,2072.3325,10.8203);
	SetPlayerFacingAngle(playerid, 88.1934);
	SetPlayerVirtualWorld(playerid, SPECIAL_PROP_VW+playerid);
	PlayerSP[playerid][pSPInProp] = 1;
	return 1;
}

stock LoadSpecialProperties(playerid)
{
	new query[100+24],Cache:cache;
	mysql_format(mysql,query,sizeof(query),"SELECT * FROM `SpecialProperties` WHERE `Nick`='%e' LIMIT 1",Jmeno(playerid));
	cache = mysql_query(mysql,query);
	if(cache_get_row_count())
	{
		PlayerSP[playerid][pSPID] = cache_get_field_content_int(0,"PropID");
		PlayerSP[playerid][pSPSupplies] = cache_get_field_content_int(0,"Supplies");
		PlayerSP[playerid][pSPStock] = cache_get_field_content_int(0,"Stock");
		PlayerSP[playerid][pSPEarning] = cache_get_field_content_int(0,"Earning");
	}
	cache_delete(cache,mysql);
	return 1;
}

stock CreateSpecialProperties()
{
	for(new i; i < sizeof(SpecialProps); i ++)
	{
		CreateDynamicPickup(2061, 23, SpecialProps[i][0], SpecialProps[i][1], SpecialProps[i][2],0);
		CreateDynamic3DTextLabel("Vırobna zbraní", 0x0077FFFF, SpecialProps[i][0], SpecialProps[i][1], SpecialProps[i][2], 30,.testlos = 1, .worldid=0);
		CreateDynamicMapIcon(SpecialProps[i][0], SpecialProps[i][1], SpecialProps[i][2], 35, -1, 0);
	}
	CreateDynamicPickup(1318,23,974.8262,2072.3325,10.8203);
	CreateDynamic3DTextLabel("Vıchod", 0x0077FFFF, 974.8262,2072.3325,10.8203, 30,.testlos = 1);
	CreateDynamicPickup(1318,23,976.0928,2084.2607,11.0301);
	CreateDynamic3DTextLabel("Poèítaè", 0xFFFF00FF, 976.0928,2084.2607,11.0301, 30,.testlos = 1);
	return 1;
}

stock IsPlayerBanned(playerid)
{
	return CallRemoteFunction("IsPlayerBanned","i",playerid);
}

stock Float:getRand(Float:ll, Float:ul)
{
    new ulv = floatround(ul, floatround_ceil);
    new llv = floatround(ll, floatround_floor);
	new range = ulv-llv;
	new Float:number = ll+(random(32767)%range);
	return number;
}

stock GetEventType(playerid)
{
	return CallRemoteFunction("GetEventType","i",playerid);
}

stock GetPlayerKillerID(playerid)
{
	return CallRemoteFunction("GetPlayerKillerID","i",playerid);
}

stock Float:GetDistanceBetweenPoints(Float:pos1X, Float:pos1Y, Float:pos1Z, Float:pos2X, Float:pos2Y, Float:pos2Z)
{
	return floatadd(floatadd(floatsqroot(floatpower(floatsub(pos1X, pos2X), 2)), floatsqroot(floatpower(floatsub(pos1Y, pos2Y), 2))), floatsqroot(floatpower(floatsub(pos1Z, pos2Z), 2)));
}

stock NavigatePlayerToPos(playerid,Float:x,Float:y,Float:z)
{
	return CallRemoteFunction("NavigatePlayerToPos","ifff",playerid,x,y,z);
}

stock SetVehicleEngineState(vehicleid,newstate)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
	SetVehicleParamsEx(vehicleid,newstate,lights,alarm,doors,bonnet,boot,objective);
	return 1;
}

stock GetVehicleEngineState(vehicleid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
	if(engine == -1) engine = 1;
	return engine;
}

stock GetPlayerSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
    GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 179.28625;
    return floatround(ST[3]);
}

stock GetPlayerIP(playerid)
{
	new pIP[16+1];
	GetPlayerIp(playerid,pIP,sizeof(pIP));
	return pIP;
}

stock GetPlayerUniqueID(playerid)
{
	return CallRemoteFunction("GetPlayerUniqueID","i",playerid);
}

stock GetPlayerLevel(playerid)
{
	return CallRemoteFunction("GetPlayerLevel","i",playerid);
}

stock BackToOldAttachedObjectPos(playerid,slotid,modelid,boneid)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid,slotid))
	{
		new Float:X,Float:Y,Float:Z,Float:rX,Float:rY,Float:rZ,Float:scX,Float:scY,Float:scZ;
		X = PlayerAddons[playerid][pAddonX][slotid];
		Y = PlayerAddons[playerid][pAddonY][slotid];
		Z = PlayerAddons[playerid][pAddonZ][slotid];
		rX = PlayerAddons[playerid][pAddonRX][slotid];
		rY = PlayerAddons[playerid][pAddonRY][slotid];
		rZ = PlayerAddons[playerid][pAddonRZ][slotid];
		scX = PlayerAddons[playerid][pAddonSX][slotid];
		scY = PlayerAddons[playerid][pAddonSY][slotid];
		scZ = PlayerAddons[playerid][pAddonSZ][slotid];
	    SetPlayerAttachedObject(playerid,slotid,modelid,boneid,X,Y,Z,rX,rY,rZ,scX,scY,scZ);
	}
	return 1;
}

stock ShowPlayerAddon(playerid,slotid)
{
	new Float:X,Float:Y,Float:Z,Float:rX,Float:rY,Float:rZ,Float:scX,Float:scY,Float:scZ;
	X = PlayerAddons[playerid][pAddonX][slotid];
	Y = PlayerAddons[playerid][pAddonY][slotid];
	Z = PlayerAddons[playerid][pAddonZ][slotid];
	rX = PlayerAddons[playerid][pAddonRX][slotid];
	rY = PlayerAddons[playerid][pAddonRY][slotid];
	rZ = PlayerAddons[playerid][pAddonRZ][slotid];
	scX = PlayerAddons[playerid][pAddonSX][slotid];
	scY = PlayerAddons[playerid][pAddonSY][slotid];
	scZ = PlayerAddons[playerid][pAddonSZ][slotid];
	new addon = PlayerAddons[playerid][pAddonID][slotid];
    SetPlayerAttachedObject(playerid,slotid,AddonsList[addon][AddonID],AddonsList[addon][AddonBone],X,Y,Z,rX,rY,rZ,scX,scY,scZ);
    return 1;
}

stock CreateAddon(playerid,slotid,addonid)
{
	if(!IsPlayerAttachedObjectSlotUsed(playerid,slotid))
	{
	    PlayerAddons[playerid][pAddonID][slotid] = addonid;
	    PlayerAddons[playerid][pAddonX][slotid] = AddonsList[addonid][AddonX];
	    PlayerAddons[playerid][pAddonY][slotid] = AddonsList[addonid][AddonY];
	    PlayerAddons[playerid][pAddonZ][slotid] = AddonsList[addonid][AddonZ];
	    PlayerAddons[playerid][pAddonRX][slotid] = AddonsList[addonid][AddonrX];
	    PlayerAddons[playerid][pAddonRY][slotid] = AddonsList[addonid][AddonrY];
	    PlayerAddons[playerid][pAddonRZ][slotid] = AddonsList[addonid][AddonrZ];
		if(PlayerAddons[playerid][pAddonID][slotid] == 68)
		{
		    PlayerAddons[playerid][pAddonSX][slotid] = 1.4;
		    PlayerAddons[playerid][pAddonSY][slotid] = 1.4;
		    PlayerAddons[playerid][pAddonSZ][slotid] = 1.4;
		}
		else
		{
		    PlayerAddons[playerid][pAddonSX][slotid] = 1.0;
		    PlayerAddons[playerid][pAddonSY][slotid] = 1.0;
		    PlayerAddons[playerid][pAddonSZ][slotid] = 1.0;
		}
		SetPlayerAttachedObject(playerid,slotid,AddonsList[addonid][AddonID],AddonsList[addonid][AddonBone],AddonsList[addonid][AddonX],AddonsList[addonid][AddonY],AddonsList[addonid][AddonZ],AddonsList[addonid][AddonrX],AddonsList[addonid][AddonrY],AddonsList[addonid][AddonrZ],PlayerAddons[playerid][pAddonSX][slotid],PlayerAddons[playerid][pAddonSY][slotid],PlayerAddons[playerid][pAddonSZ][slotid]);
		EditAttachedObject(playerid,slotid);
		return 1;
	}
	return 0;
}

stock ShowAddonsList(playerid,page = 0)
{
    new str[145],DIALOG[2000+1000];
	SetPVarInt(playerid,"Page",page);
	new titems,items;
	for(new i = page*19; i < (page+1)*19; i ++)
	{
	    items++;
	    titems = (page*19)+items;
	    if(titems < sizeof(AddonsList)+1)
	    {
			format(str,sizeof(str),"{0077FF}%d. "cw"%s\t"cc"Level: "cw"%d\t"co"Body: "cc"%d\n",i+1,AddonsList[i][AddonName],AddonsList[i][AddonLevel],AddonsList[i][AddonPrice]);//-AddonsList[i][AddonPrice]*0.3);
			strcat(DIALOG,str);
			if(items == 19)
			{
			    strcat(DIALOG,""cg"Další stránka\n");
			}
		}
		else break;
	}
	SPD(playerid,35,DIALOG_STYLE_TABLIST,"Doplòky",DIALOG,"Vybrat","Zavøít");
	return 1;
}

function ShowAddonsMenu(playerid)
{
	new DIALOG[500],str[145];
	for(new i; i < MAX_ADDONS; i ++)
	{
	    if(PlayerAddons[playerid][pAddonID][i] == -1)
	    {
	        format(str,sizeof(str),"Slot %d:\t{adadad}Volnı slot\n",i+1);
	    }
	    else
	    {
	        format(str,sizeof(str),"Slot %d:\t"cg"%s\n",i+1,AddonsList[PlayerAddons[playerid][pAddonID][i]][AddonName]);
	    }
	    strcat(DIALOG,str);
	}
	SPD(playerid,33,DIALOG_STYLE_TABLIST,"Doplòky",DIALOG,"Vybrat","Zavøít");
	return 1;
}

stock CheckPlayerDrazba(playerid)
{
	new id = PlayerDrazba[playerid][pDrazbaPlayer];
	if(!IPC(id)) return 0;
    if(PlayerDrazba[playerid][pDrazbaPriceType] == PRICE_TYPE_MONEY)
    {
        if(GetMoney(id)+Player[id][pBanka] < PlayerDrazba[playerid][pDrazbaPrice])
        {
	        return 0;
        }
    }
    else
    {
        if(GetPlayerPoints(id) < PlayerDrazba[playerid][pDrazbaPrice])
        {
	        return 0;
        }
    }
	if(PlayerDrazba[playerid][pDrazbaType] == DRAZBA_TYPE_VEHICLE)
	{
		if(CountPlayerVehicles(id) >= GetMaxVehicleSlots())
        {
			return 0;
        }
	}
	if(PlayerDrazba[playerid][pDrazbaType] == DRAZBA_TYPE_PROPERTY)
	{
		if(CountPlayerProperties(id) == GetPlayerPropertiesSlots(id))
        {
			return 0;
        }
	}
	if(PlayerDrazba[playerid][pDrazbaType] == DRAZBA_TYPE_HOUSE)
	{
		if(GetPlayerHouse(id) != -1)
		{
			return 0;
		}
	}
	if(PlayerDrazba[playerid][pDrazbaType] == DRAZBA_TYPE_GANG)
	{
	    if(GetPlayerGang(id) != -1)
	    {
			return 0;
	    }
	}
	return 1;
}

stock GivePlayerGanja(playerid,amount,reason[],bool:drazba = false)
{
    return _GivePlayerGanja(playerid,amount,reason,drazba);
}

function _GivePlayerGanja(playerid,amount,reason[],bool:drazba)
{
	if(drazba == false)
	{
		if(PlayerDrazba[playerid][pDrazbaStatus] == true)
		{
		    if(PlayerDrazba[playerid][pDrazbaType] == DRAZBA_TYPE_GANJA)
		    {
			    if(Player[playerid][pGanja] + amount < PlayerDrazba[playerid][pDrazbaAmount])
			    {
			        ResetPlayerDrazba(playerid);
			        SM(playerid,"Nemáte tolik marihuany kolik draíte, draba byla zrušena");
			    }
			}
		}
	}
	Player[playerid][pGanja] += amount;
	if(strlen(reason))
	{
		new str[145];
		format(str,sizeof(str),"[ Marihuana ] %s "cg"+%dg "cw"[ {007700}%dg "cw"] [ %s ]",Jmeno(playerid),amount,Player[playerid][pGanja],reason);
		printEx(str);
	}
	return 1;
}

function GetPlayerDrazbaStatus(playerid)
{
	return PlayerDrazba[playerid][pDrazbaStatus];
}

function GetPlayerDrazbaType(playerid)
{
	return PlayerDrazba[playerid][pDrazbaType];
}

function GetPlayerDrazbaAmount(playerid)
{
	return PlayerDrazba[playerid][pDrazbaAmount];
}

function GetPlayerDrazbaItem(playerid)
{
	return PlayerDrazba[playerid][pDrazbaItem];
}


function GetPlayerJobRank(playerid)
{
	new xp = Player[playerid][pJobXP][Player[playerid][pJob]];
    if(xp >= 20 && xp < 60) return 1;
    else if(xp >= 60 && xp < 120) return 2;
    else if(xp >= 120 && xp < 200) return 3;
    else if(xp >= 200) return 4;
	return 0;
}

function ResetPlayerWeaponsEx(playerid)
{
	ResetPlayerWeapons(playerid);
	return 1;
}

function GivePlayerWeaponEx(playerid,weaponid,ammo)
{
	GivePlayerWeapon(playerid,weaponid,ammo);
	return 1;
}

function IsPlayerLogged(playerid)
{
	return Player[playerid][pLogged];
}

stock GetPlayerIdFromName(playername[])
{
  	for(new i = 0; i <= GetPlayerPoolSize(); i++)
  	{
    	if(IsPlayerConnected(i))
    	{
      		if(strcmp(Jmeno(i),playername,true,strlen(playername)) == 0)
      		{
        		return i;
      		}
    	}
  	}
  	return INVALID_PLAYER_ID;
}

stock GetPlayerGang(playerid)
{
	return CallRemoteFunction("GetPlayerGangMember","i",playerid);
}

stock GetPlayerGangBoss(playerid)
{
	new id = CallRemoteFunction("GetPlayerBoss","i",playerid);
	if(id == 0) id = -1;
	return id;
}

stock GetGangName(gangid)
{
	new name[24+1] = "Error (404)",query[100],Cache:cache;
	mysql_format(mysql,query,sizeof(query),"SELECT * FROM `Gangs` WHERE `GangID`=%d",gangid);
	cache = mysql_query(mysql,query);
	if(cache_get_row_count(mysql))
	{
	    cache_get_field_content(0,"Name",name,mysql);
	}
	cache_delete(cache,mysql);
	return name;
}

stock GivePlayerMoneyToTrezor(nick[],castka)
{
	return CallRemoteFunction("GivePlayerMoneyToTrezor","si",nick,castka);
}

stock GetPlayerProperty(playerid,slot)
{
	return CallRemoteFunction("GetPlayerProperty","ii",playerid,slot);
}

stock GetPlayerPropertiesSlots(playerid)
{
	return CallRemoteFunction("GetPlayerPropertiesSlots","i",playerid);
}

stock CountPlayerProperties(playerid)
{
	return CallRemoteFunction("CountPlayerProperties","i",playerid);
}

stock GetMaxProperties()
{
	return CallRemoteFunction("GetMaxProperties","");
}

stock GetMaxPropertiesPerPlayer()
{
	return CallRemoteFunction("GetMaxPropertiesPerPlayer","");
}

stock GetPropertyOwner(pid)
{
	new owner[24+1],letter[1+1];
	for(new i; i < 24; i ++)
	{
        format(letter,sizeof(letter),"%s",CallRemoteFunction("GetPropertyOwner","ii",pid,i));
		strcat(owner,letter);
	}
	return owner;
}

stock GetPropertyName(pid)
{
	new name[30] = "Error",file[50];
	format(file,sizeof(file),"UnNamed/Properties/Property%d.txt",pid);
	if(fexist(file))
	{
	    format(name,sizeof(name),DOF2_GetString(file,"Name"));
	}
	return name;
}

stock IsPlayerPropertyOwner(playerid,pid)
{
	if(strcmp(GetPropertyOwner(pid),"-1",false) == 0) return 0;
	else if(strcmp(GetPropertyOwner(pid),"0",false) == 0) return 0;
	else if(strcmp(GetPropertyOwner(pid),Jmeno(playerid),false) == 0) return 1;
	return 0;
}

stock GetPropertyEarning(pid)
{
	return CallRemoteFunction("GetPropertyEarning","i",pid);
}

stock GetPropertyExpiration(pid)
{
	return CallRemoteFunction("GetPropertyExpiration","i",pid);
}

stock GetPropertyLevel(pid)
{
	return CallRemoteFunction("GetPropertyLevel","i",pid);
}

stock ChangePropertyOwner(pid,owner[])
{
	return CallRemoteFunction("ChangePropertyOwner","is",pid,owner);
}

stock CountPlayerVehicles(playerid)
{
	return CallRemoteFunction("CountPlayerVehicles","i",playerid);
}

stock ChangeVehicleOwner(playerid,slotid,changeid)
{
	return CallRemoteFunction("ChangeVehicleOwner","iii",playerid,slotid,changeid);
}

stock PriceTypeText(pricetype,price)
{
	new Text[30];
	if(pricetype == PRICE_TYPE_MONEY)
	{
	    format(Text,sizeof(Text),"%s$",SeperateNumber(price));
	}
	else
	{
	    format(Text,sizeof(Text),"%d bodù",price);
	}
	return Text;
}

function ResetPlayerDrazba(playerid)
{
	for(new i; ENUM_PlayerDrazbaData:i < ENUM_PlayerDrazbaData; i ++)
	{
	    PlayerDrazba[playerid][ENUM_PlayerDrazbaData:i] = 0;
	}
	PlayerDrazba[playerid][pDrazbaPlayer] = -1;
}

stock SendPlayerNotification(nick[],nadpis[],text[])
{
	return CallRemoteFunction("SendPlayerNotification","sss",nick,nadpis,text);
}

stock GivePlayerPoints(playerid,Float:amount,bool:drazba = false)
{
	return CallRemoteFunction("GivePlayerPoints","ifi",playerid,amount,drazba);
}

stock GetPlayerPoints(playerid)
{
	return CallRemoteFunction("GetPoints","i",playerid);
}

stock IsPlayerOnHighestLevel(playerid)
{
	return CallRemoteFunction("IsPlayerOnHighestLevel","i",playerid);
}

stock IsPlayerVIP(playerid)
{
	return CallRemoteFunction("IsPlayerVIP","i",playerid);
}

stock GetMaxVehicleSlots()
{
	return CallRemoteFunction("GetMaxVehicleSlots","");
}

stock GetPlayerVehicle(playerid,slot)
{
	return CallRemoteFunction("GetPlayerVehicle","ii",playerid,slot);
}

stock GetWeaponSlot(weaponid)
{
	new slot;
	switch(weaponid){
		case 0, 1: slot = 0; // No weapon
		case 2 .. 9: slot = 1; // Melee
		case 22 .. 24: slot = 2; // Handguns
		case 25 .. 27: slot = 3; // Shotguns
		case 28, 29, 32: slot = 4; // Sub-Machineguns
		case 30, 31: slot = 5; // Machineguns
		case 33, 34: slot = 6; // Rifles
		case 35 .. 38: slot = 7; // Heavy Weapons
		case 16, 18, 39: slot = 8; // Projectiles
		case 42, 43: slot = 9; // Special 1
		case 14: slot = 10; // Gifts
		case 44 .. 46: slot = 11; // Special 2
		case 40: slot = 12; // Detonators
		default: slot = -1; // No slot
	}
	return slot;
}

stock DropWeapons(playerid,usemoney = 1, drop = 1, vw = 0) return fDropWeapons(playerid,usemoney,drop,vw);

function fDropWeapons(playerid,usemoney,drop,vw)
{
	if(drop == 1)
	{
		new bool:dropped;
		for(new i; i < sizeof(WeaponDrop); i ++)
		{
		    if(WeaponDrop[i][wDSlotUsed] == false)
		    {
			    for(new x; x < 13; x ++)
		        {
		            GetPlayerWeaponData(playerid,x,WeaponDrop[i][wDWeapons][x],WeaponDrop[i][wDAmmo][x]);
		            if(WeaponDrop[i][wDAmmo][x] < 0)
		            {
		                WeaponDrop[i][wDAmmo][x] = 0;
		                WeaponDrop[i][wDWeapons][x] = 0;
		            }
					if(WeaponDrop[i][wDWeapons][x] > 0 && WeaponDrop[i][wDAmmo][x] > 0)
					{
					    dropped = true;
					}
		        }
		        if(usemoney == 1)
		        {
		            if(GetMoney(playerid) > 0)
		            {
			            WeaponDrop[i][wDMoney] = GetMoney(playerid);
			            ResetMoney(playerid);
		                dropped = true;
		            }
				}
				if(dropped == true)
				{
					new Float:X,Float:Y,Float:Z;
					GetPlayerPos(playerid,X,Y,Z);
		            WeaponDrop[i][wDPickup] = CreateDynamicPickup(1550,23,X,Y,Z,vw);
		            WeaponDrop[i][wDVW] = vw;
		            WeaponDrop[i][wDX] = X;
		            WeaponDrop[i][wDY] = Y;
		            WeaponDrop[i][wDZ] = Z;
		            WeaponDrop[i][wDPlayer] = Jmeno(playerid);
		            WeaponDrop[i][wDTimer] = SetTimerEx("DestroyWeaponDrop",1000*60*5,false,"i",i);
					WeaponDrop[i][wDSlotUsed] = true;
					ResetPlayerWeaponsEx(playerid);
				}
	            break;
		    }
		}
		if(dropped == false)
		{
		    return 0;
		}
	}
	else
	    return 0;
	return 1;
}

stock ResetWeaponDrop(dropid)
{
	if(WeaponDrop[dropid][wDSlotUsed] == true)
	{
	    DestroyDynamicPickup(WeaponDrop[dropid][wDPickup]);
	    WeaponDrop[dropid][wDSlotUsed] = false;
	    WeaponDrop[dropid][wDX] = 0.0;
	    WeaponDrop[dropid][wDY] = 0.0;
	    WeaponDrop[dropid][wDZ] = 0.0;
	    WeaponDrop[dropid][wDMoney] = 0;
		WeaponDrop[dropid][wDVW] = 0;
	    format(WeaponDrop[dropid][wDPlayer],25,"");
	 	for(new i; i < 13; i ++)
	    {
			WeaponDrop[dropid][wDWeapons][i] = 0;
			WeaponDrop[dropid][wDAmmo][i] = 0;
	    }
	    KillTimer(WeaponDrop[dropid][wDTimer]);
	}
	return 1;
}

function DestroyWeaponDrop(dropid)
{
	ResetWeaponDrop(dropid);
}

stock GetPlayerAdmin(playerid)
{
	return CallRemoteFunction("GetAdminLevel","i",playerid);
}

stock ShowPlayerActualNew(playerid)
{
	return CallRemoteFunction("ShowPlayerActualNew","i",playerid);
}

stock GetHouseNeedHours(house)
{
	return CallRemoteFunction("GetHouseNeedHours","i",house);
}

stock GetPlayerHouse(playerid)
{
	return CallRemoteFunction("GetPlayerHouse","i",playerid);
}

stock ChangeGangOwner(gang,owner[])
{
	return CallRemoteFunction("ChangeGangOwner","is",gang,owner);
}

stock ChangeHouseOwner(house,owner[])
{
	return CallRemoteFunction("ChangeHouseOwner","is",house,owner);
}

stock GetHouseName(house)
{
	new name[24+1] = "Error (404)",query[100],Cache:cache;
	mysql_format(mysql,query,sizeof(query),"SELECT * FROM `Houses` WHERE `ID`=%d",house);
	cache = mysql_query(mysql,query);
	if(cache_get_row_count(mysql))
	{
	    cache_get_field_content(0,"Name",name,mysql);
	}
	cache_delete(cache,mysql);
	return name;
}

stock printEx(text[])
{
	return CallRemoteFunction("printEx","s",text);
}

stock GivePlayerJobWeapons(playerid,job)
{
	for(new i; i < sizeof(JobWeapons[]); i ++)
	{
		if(JobWeapons[job][i][0] != 0)
		{
			GivePlayerWeaponEx(playerid,JobWeapons[job][i][0],JobWeapons[job][i][1]);
		}
	}
	return 1;
}

stock SendAdminMessage(text[])
{
	return CallRemoteFunction("SendAdminMessage","s",text);
}

stock GetPlayerAutoBank(playerid)
{
	return CallRemoteFunction("GetPlayerAutoBank","i",playerid);
}

stock IsPlayerNearPlayer(playerid,nearplayerid,radius = 10)
{
	new Float:Pos[3];
	GetPlayerPos(nearplayerid,Pos[0],Pos[1],Pos[2]);
	if(IsPlayerInRangeOfPoint(playerid,radius,Pos[0],Pos[1],Pos[2])) return 1;
	return 0;
}

stock SetPlayerLimitTimer(playerid,seconds)
{
	Player[playerid][pLimitTimer] = seconds;
	new str[15];
	format(str,sizeof(str),"cas: ~w~%s",SecondsToMinutes(Player[playerid][pLimitTimer]));
	PlayerTextDrawSetString(playerid,Textdraw0[playerid],str);
	PlayerTextDrawShow(playerid,Textdraw0[playerid]);
	return 1;
}

stock CancelLimitTimer(playerid)
{
	Player[playerid][pLimitTimer] = 0;
	PlayerTextDrawHide(playerid,Textdraw0[playerid]);
	return 1;
}

stock SecondsToMinutes(seconds)
{
	new str[10];
	format(str,sizeof(str),"%02d:%02d",seconds/60,seconds%60);
	return str;
}

stock CreateCarMenuVehicle(playerid,modelid,spz[] = "Test")
{
	return CallRemoteFunction("_CreateCarMenuVehicle","iis",playerid,modelid,spz);
}

stock CreatePlayerVehicle(playerid,modelid,Float:X,Float:Y,Float:Z,Float:A,interiorid = 0,vwid = 0,color1 = -1,color2 = -1, addsiren = 0)
{
	DestroyPlayerVehicle(playerid);
	SetPlayerPos(playerid,X+2,Y+2,Z);
	Player[playerid][pPlayerVehicle] = CreateVehicle(modelid,X,Y,Z,A,color1,color2,-1,addsiren);
	SetVehicleVirtualWorld(Player[playerid][pPlayerVehicle],GetPlayerVirtualWorld(playerid));
	PutPlayerInVehicle(playerid,Player[playerid][pPlayerVehicle],0);
	SetPlayerInterior(playerid,interiorid);
	SetPlayerVirtualWorld(playerid,VW+playerid);
	LinkVehicleToInterior(Player[playerid][pPlayerVehicle],interiorid);
	SetVehicleVirtualWorld(Player[playerid][pPlayerVehicle],vwid);
	printf("%f, %f, %f, %f | vw %d, int %d",X,Y,Z,A,vwid,interiorid);
	return 1;
}

stock DestroyPlayerVehicle(playerid)
{
	DestroyVehicle(Player[playerid][pPlayerVehicle]);
	Player[playerid][pPlayerVehicle] = 0;
	return 1;
}

stock YesOrNo(value)
{
	new Nazev[11+1];
	if(value == 0) Nazev = "{FF0000}Ne";
	else Nazev = "{00FF00}Ano";
	return Nazev;
}

stock ShowHelpMenu(playerid)
{
	new DIALOG[500],str[30];
	for(new i; i < sizeof(HelpMenu); i ++)
	{
	    format(str,sizeof(str),"%s\n",HelpMenu[i][0]);
	    strcat(DIALOG,str);
	}
	SPD(playerid,11,DIALOG_STYLE_LIST,"Help",DIALOG,"Vybrat","Zavøít");
	return 1;
}
/*
function ShowPlayerInfo(toplayerid,playerid)
{
	new str[128],DIALOG[1500];
	strcat(DIALOG,"{FFFF00}Úèet\n"cw"");
	format(str,sizeof(str),"{0077FF}Nick: "cw"%s\n{0077FF}IP Adresa: "cw"%s\n{0077FF}Unikátní ID: "cw"%d\n\n",Jmeno(playerid),GetPlayerIP(playerid),GetPlayerUniqueID(playerid));
	strcat(DIALOG,str);

	strcat(DIALOG,"{FFFF00}Nahranı èas\n"cw"");
	format(str,sizeof(str),"{0077FF}Hodin: "cw"%d\n{0077FF}Minut: "cw"%d\n{0077FF}Celkem AFK: "cw"%s\n\n",GetPlayerPlayedTime(playerid)/60/60,GetPlayerPlayedTime(playerid)/60%60,SecondsToMinutes(CallRemoteFunction("GetPlayerTotalAFKTime","i",playerid)/60));
	strcat(DIALOG,str);

	strcat(DIALOG,"{FFFF00}Majetek\n"cw"");
	format(str,sizeof(str),"{0077FF}Peníze: "cw"%s$\n{0077FF}V bance: "cw"%s$\n{0077FF}Na vıplatní pásce: "cw"%s$\n",SeperateNumber(GetMoney(playerid)),SeperateNumber(Player[playerid][pBanka]),SeperateNumber(Player[playerid][pVyplata]));
	strcat(DIALOG,str);
	if(GetPlayerHouse(playerid) == -1)
	{
	    format(str,sizeof(str),"{0077FF}Dùm: "cr"Nevlastní\n\n");
	}
	else
	{
	    format(str,sizeof(str),"{0077FF}Dùm è.p: "cw"%d\n\n",GetPlayerHouse(playerid)+1);
	}
	strcat(DIALOG,str);

	strcat(DIALOG,"{FFFF00}Kriminalita\n"cw"");
	format(str,sizeof(str),"{0077FF}Zabil: "cw"%d\n{0077FF}Umøel: "cw"%d\n{0077FF}Wanted-Level: "cw"%d\n\n",Player[playerid][pKills],Player[playerid][pDeaths],GetPlayerWantedLevel(playerid));
	strcat(DIALOG,str);

	strcat(DIALOG,"{FFFF00}Návykové látky\n"cw"");
	format(str,sizeof(str),"{0077FF}Marihuana: "cw"%dg\n\n",Player[playerid][pGanja]);
	strcat(DIALOG,str);

	strcat(DIALOG,"{FFFF00}Prùkazy\n"cw"");
	for(new i; i < PRUKAZY; i ++)
	{
		format(str,sizeof(str),"{0077FF}%s: %s\n",LicenseNames[i],YesOrNo(Player[playerid][pPrukazy][i]));
		strcat(DIALOG,str);
	}
	strcat(DIALOG,"\n");

	strcat(DIALOG,"{FFFF00}Zamìstnání\n"cw"");
	format(str,sizeof(str),"{0077FF}Aktuální zamìstnání: "cw"%s\n",Job[Player[playerid][pJob]][jName]);
	strcat(DIALOG,str);
	for(new i = 1; i < MAX_JOBS; i ++)
	{
	    format(str,sizeof(str),"{0077FF}%s: "cw"%db\n",Job[i][jName],Player[playerid][pJobXP][i]);
	    strcat(DIALOG,str);
	}
	SPD(toplayerid,17,DIALOG_STYLE_TABLIST,Jmeno(playerid),DIALOG,"Zavøít","");
	return 1;
}

*/
stock IntToString(int,addon[] = "")
{
	new str[10];
	format(str,sizeof(str),"%d",int);
	if(strlen(addon)){
		strcat(str," ");
		strcat(str,addon);
	}
	return str;
}

function GetPlayerSpecialProperty(playerid)
{
	return PlayerSP[playerid][pSPID];
}

function ShowPlayerInfo(toplayerid,playerid)
{
	new str[128],DIALOG[1500];
	strcat(DIALOG,"{FFFF00}Úèet\t \n");
	format(str,sizeof(str),"{0077FF}Nick:\t%s\n{0077FF}IP Adresa:\t%s\n{0077FF}Unikátní ID:\t%d\n\n",Jmeno(playerid),GetPlayerIP(playerid),GetPlayerUniqueID(playerid));
	strcat(DIALOG,str);

	strcat(DIALOG,"{FFFF00}Nahranı èas\t \n");
	format(str,sizeof(str),"{0077FF}Hodin:\t%d\n{0077FF}Minut:\t%d\n{0077FF}Celkem AFK:\t%dhod %dmin\n\n",GetPlayerPlayedTime(playerid)/60/60,GetPlayerPlayedTime(playerid)/60%60,CallRemoteFunction("GetPlayerTotalAFKTime","i",playerid)/60/60,CallRemoteFunction("GetPlayerTotalAFKTime","i",playerid)/60%60);
	strcat(DIALOG,str);

	strcat(DIALOG,"{FFFF00}Majetek\t \n");
	format(str,sizeof(str),"{0077FF}Peníze:\t%s$\n{0077FF}V bance:\t%s$\n{0077FF}Na vıplatní pásce:\t%s$\n",SeperateNumber(GetMoney(playerid)),SeperateNumber(Player[playerid][pBanka]),SeperateNumber(Player[playerid][pVyplata]));
	strcat(DIALOG,str);
	if(GetPlayerHouse(playerid) == -1)
	{
	    format(str,sizeof(str),"{0077FF}Dùm:\t"cr"Nevlastní\n\n");
	}
	else
	{
	    format(str,sizeof(str),"{0077FF}Dùm è.p:\t%d\n\n",GetPlayerHouse(playerid)+1);
	}
	strcat(DIALOG,str);
	format(str,sizeof(str),"{0077FF}Vırobna zbraní:\t%s\n",(PlayerSP[playerid][pSPID] == -1) ? ("Nevlastnìno") : IntToString(PlayerSP[playerid][pSPID]+1));
	strcat(DIALOG,str);

	strcat(DIALOG,"{FFFF00}Kriminalita\t \n");
	format(str,sizeof(str),"{0077FF}Zabil:\t%dx\n{0077FF}Umøel\t%dx\n{0077FF}Wanted-Level:\t%d\n\n",Player[playerid][pKills],Player[playerid][pDeaths],GetPlayerWantedLevel(playerid));
	strcat(DIALOG,str);

	strcat(DIALOG,"{FFFF00}Návykové látky\t \n");
	format(str,sizeof(str),"{0077FF}Marihuana:\t%dg\n\n",Player[playerid][pGanja]);
	strcat(DIALOG,str);
	
	strcat(DIALOG,"{FFFF00}Prùkazy\t \n");
	for(new i; i < PRUKAZY; i ++)
	{
		format(str,sizeof(str),"{0077FF}%s:\t%s\n",LicenseNames[i],YesOrNo(Player[playerid][pPrukazy][i]));
		strcat(DIALOG,str);
	}
	strcat(DIALOG,"\n");

	strcat(DIALOG,"{FFFF00}Zamìstnání\t \n");
	format(str,sizeof(str),"{0077FF}Aktuální zamìstnání:\t%s\n",Job[Player[playerid][pJob]][jName]);
	strcat(DIALOG,str);
	for(new i = 1; i < MAX_JOBS; i ++)
	{
	    format(str,sizeof(str),"{0077FF}%s:\t%d bodù zk.\n",Job[i][jName],Player[playerid][pJobXP][i]);
	    strcat(DIALOG,str);
	}
	SPD(toplayerid,17,DIALOG_STYLE_TABLIST,Jmeno(playerid),DIALOG,"Zavøít","");
	return 1;
}

stock ShowJobInfo(playerid,jobtype)
{
	new DIALOG[2000],str[128];
	format(str,sizeof(str),"{%s}%s"cdc".\n",MakeEmbedColor(Job[jobtype][jColor]),Job[jobtype][jName]);
	strcat(DIALOG,str);
	strcat(DIALOG,JobInfo[jobtype]);
	if(Job[jobtype][jCashReward] != 0)
	{
		strcat(DIALOG,"\n\n");
		for(new i; i < 5; i ++)
		{
			new ranks[] = {0,20,60,120,200};
	    	format(str,sizeof(str),""cy"%s"cdc"\n",JobRankNames[i]);
	    	strcat(DIALOG,str);
			if(jobtype == JOB_DEALER)
			{
			    format(str,sizeof(str),"Doba hnojení/zalévání %d sekund\n",5-i/2);
			    strcat(DIALOG,str);
			    new GanjaAmount[] = {4,6,8,10,12};
			    format(str,sizeof(str),"Maximálnì mùete vypìstovat %dg marihuany.\n",GanjaAmount[i]);
			    strcat(DIALOG,str);
			}
			if(jobtype == JOB_PRAVNIK)
		    	format(str,sizeof(str),"Maximální odmìna (/taxa): "cg"%0.1f bodù "cdc"za hvìzdièku hledanosti\n"cdc"Potøeba %d bodù u tohoto zamìstnání.",(i+1)*0.901,ranks[i]);
			else
		    	format(str,sizeof(str),"Odmìna: "cg"%s$\n"cdc"Potøeba %d bodù u tohoto zamìstnání.",SeperateNumber((Job[jobtype][jCashReward]/5)*(i+1)),ranks[i]);
	    	strcat(DIALOG,str);
	    	if(i < 4)
	    	{
	    	    strcat(DIALOG,"\n\n");
	    	}
		}
	}
	format(str,sizeof(str),"\n\n"cg"U tohoto zamìstnání máte %d bodù. Aktuální hodnost: %s",Player[playerid][pJobXP][jobtype],JobRankNames[GetPlayerJobRank(playerid)]);
	strcat(DIALOG,str);
	SPD(playerid,0,DIALOG_STYLE_MSGBOX,Job[jobtype][jName],DIALOG,"Zavøít","");
	return 1;
}

stock MakeEmbedColor(color)
{
	new embed[6+1];
	format(embed,sizeof(embed),"%06x",color >>> 8);
	return embed;
}

stock CreatePasses(Float:X,Float:Y,Float:Z)
{
	for(new i; i < MAX_PASSES; i ++)
	{
		if(PassesPos[i][0] == 0.0 && PassesPos[i][1] == 0.0 && PassesPos[i][2] == 0.0)
		{
		    PassesPos[i][0] = X;
		    PassesPos[i][1] = Y;
		    PassesPos[i][2] = Z;
		    CreateDynamicPickup(1239,23,X,Y,Z,0);
			break;
		}
	}
	return 1;
}

stock CreateOffice(Float:X,Float:Y,Float:Z)
{
	for(new i; i < MAX_OFFICES; i ++)
	{
		if(OfficePos[i][0] == 0.0 && OfficePos[i][1] == 0.0 && OfficePos[i][2] == 0.0)
		{
		    OfficePos[i][0] = X;
		    OfficePos[i][1] = Y;
		    OfficePos[i][2] = Z;
		    CreateDynamicPickup(1272,23,X,Y,Z,0);
			break;
		}
	}
	return 1;
}

stock CreateClothesShop(Float:X,Float:Y,Float:Z)
{
	for(new i; i < MAX_CLOTHES; i ++)
	{
		if(ClothesPos[i][0] == 0.0 && ClothesPos[i][1] == 0.0 && ClothesPos[i][2] == 0.0)
		{
		    ClothesPos[i][0] = X;
		    ClothesPos[i][1] = Y;
		    ClothesPos[i][2] = Z;
		    CreateDynamicPickup(1275,23,X,Y,Z,0);
			break;
		}
	}
	return 1;
}

stock CreateJob(type,Float:X,Float:Y,Float:Z)
{
	for(new i; i < MAX_PJOBS; i ++)
	{
	    if(JobPickup[i][jSlotUsed] == false)
	    {
	        JobPickup[i][jType] = type;
	        JobPickup[i][jX] = X;
	        JobPickup[i][jY] = Y;
	        JobPickup[i][jZ] = Z;
	        JobPickup[i][jSlotUsed] = true;
			CreateDynamicPickup(1581,23,X,Y,Z,0);
			CreateDynamic3DTextLabel(Job[type][jName],Job[type][jColor],X,Y,Z+1,30,.testlos = 1,.worldid = 0);
			if(Job[type][jMapIcon] != 0)
			{
				CreateDynamicMapIcon(X,Y,Z,Job[type][jMapIcon],BILA,0,0,.streamdistance = 300);
			}
	        break;
	    }
	}
	return 1;
}

stock CreateShop(type,name[],pickupid,actorid,Float:X,Float:Y,Float:Z,Float:RotX,Float:RotY,Float:RotZ,Float:pickX,Float:pickY,Float:pickZ,Float:actorX,Float:actorY,Float:actorZ,Float:actorA)
{
	for(new i; i < MAX_SHOPS; i ++)
	{
		if(Shops[i][sSlotUsed] == false)
		{
		    new file[50] = "Shops.txt";
			if(!fexist(file))
			{
			    DOF2_CreateFile(file);
			}
			if(type == STAND_TYPE_GANJA)
			{
			    new amount[20];
			    format(amount,sizeof(amount),"Amount%d",i);
			    Shops[i][sAmount] = DOF2_GetInt(file,amount);
			}
		    Shops[i][sType] = type;
		    Shops[i][sX] = pickX;
		    Shops[i][sY] = pickY;
		    Shops[i][sZ] = pickZ;
			if(X != 0 && Y != 0 && Z != 0)
		    	CreateDynamicObject(1570,X,Y,Z,RotX,RotY,RotZ,0,0);
		    CreateDynamicPickup(pickupid,23,pickX,pickY,pickZ,0);
			CreateDynamic3DTextLabel(name,0x00FF00FF,pickX,pickY,pickZ,30,.testlos = 1,.worldid = 0);
			new actor = CreateActor(actorid,actorX,actorY,actorZ,actorA);
			ApplyActorAnimation(actor,"DEALER","DEALER_IDLE",4.1,0,1,1,1,0);
			Shops[i][sSlotUsed] = true;
			break;
		}
	}
	return 1;
}

stock CreateGanja(Float:X,Float:Y,Float:Z,Float:RotX,Float:RotY,Float:RotZ)
{
	for(new i; i < MAX_GANJAS; i ++)
	{
		if(Ganja[i][gSlotUsed] == false)
		{
		    Ganja[i][gX] = X;
		    Ganja[i][gY] = Y+3.5;
		    Ganja[i][gZ] = Z;
			Ganja[i][gPronajemID] = -1;
		    Ganja[i][gObject] = CreateDynamicObject(3409,X,Y+3.5,Z-2,RotX,RotY,RotZ,0,0);
		    CreateDynamicPickup(1279,23,X,Y+3.5,Z,0);
			Ganja[i][g3DText] = CreateDynamic3DTextLabel("Loading",-1,X,Y+3.5,Z,30,.testlos = 1,.worldid = 0);
			Ganja[i][gSlotUsed] = true;
			UpdateGanjaText(i);
			break;
		}
	}
	return 1;
}

stock UpdateGanjaText(ganjaid)
{
	new str[128];
    if(Ganja[ganjaid][gPronajemID] == -1)
	{
		format(str,sizeof(str),"Marihuanové Pole\nVolné");
	}
	else
	{
	    if(IPC(Ganja[ganjaid][gPronajemID]))
	    {
			format(str,sizeof(str),"Marihuanové Pole\n%s\n%d minut",Jmeno(Ganja[ganjaid][gPronajemID]),Player[Ganja[ganjaid][gPronajemID]][pGanjaFieldTime]/60);
	        if(Player[Ganja[ganjaid][gPronajemID]][pGanjaAction][0] == 1)
	        {
				if(Player[Ganja[ganjaid][gPronajemID]][pGanjaAction][1] > 0)
				{
					format(str,sizeof(str),""cg"Zalévání %d sekund\n"cr"Marihuanové Pole\n%s\n%d minut",Player[Ganja[ganjaid][gPronajemID]][pGanjaAction][1],Jmeno(Ganja[ganjaid][gPronajemID]),Player[Ganja[ganjaid][gPronajemID]][pGanjaFieldTime]/60);
				}
			}
	        else if(Player[Ganja[ganjaid][gPronajemID]][pGanjaAction][0] == 2)
	        {
				if(Player[Ganja[ganjaid][gPronajemID]][pGanjaAction][1] > 0)
				{
					format(str,sizeof(str),""cg"Hnojení %d sekund\n"cr"Marihuanové Pole\n%s\n%d minut",Player[Ganja[ganjaid][gPronajemID]][pGanjaAction][1],Jmeno(Ganja[ganjaid][gPronajemID]),Player[Ganja[ganjaid][gPronajemID]][pGanjaFieldTime]/60);
				}
	        }
		}
		else
		{
			format(str,sizeof(str),"Marihuanové Pole\nVolné");
		}
	}
    UpdateDynamic3DTextLabelText(Ganja[ganjaid][g3DText],RED,str);
	return 1;
}

stock CreateBank(Float:X,Float:Y,Float:Z)
{
	for(new i; i < MAX_BANKS; i ++)
	{
		if(BankPos[i][0] == 0.0 && BankPos[i][1] == 0.0 && BankPos[i][2] == 0.0)
		{
		    BankPos[i][0] = X;
		    BankPos[i][1] = Y;
		    BankPos[i][2] = Z;
			CreateDynamicPickup(1274,23,X,Y,Z,0,0);
			CreateDynamicMapIcon(X,Y,Z,52,BILA,0,0,.streamdistance = 300);
			CallRemoteFunction("LoadBank", "ifff", i,X,Y,Z);
		    break;
		}
	}
	return 1;
}

stock IsPlayerOnEvent(playerid)
{
	return CallRemoteFunction("IsPlayerOnEvent","i",playerid);
}

stock IsPlayerOnMiniEvent(playerid)
{
	return CallRemoteFunction("IsPlayerOnMiniEvent","i",playerid);
}

stock IsPlayerWorking(playerid)
{
	return CallRemoteFunction("IsPlayerWorking","i",playerid);
}

stock IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
   	return 1;
}

stock SeperateNumber(number, const separator[] = ".")
{
	new output[15]; // longest possible output given 32 bit integers: -2,147,483,648
	format(output, sizeof(output), "%d", number);

	for(new i = strlen(output) - 3; i > 0 && output[i-1] != '-'; i -= 3)
	{
		strins(output, separator, i);
	}

	return output;
}

stock LoadData(playerid)
{
    if(fexist(USER_FILES(playerid)))
    {
		GiveMoney(playerid,DOF2_GetInt(USER_FILES(playerid),"Money"),"");
		Player[playerid][pPlayedTime] = DOF2_GetInt(USER_FILES(playerid),"Odehrano");
		new skin = DOF2_GetInt(USER_FILES(playerid),"Skin");
		SetPlayerSkinEx(playerid,(skin < 25000) ? skin : 0);
		Player[playerid][pBanka] = DOF2_GetInt(USER_FILES(playerid),"Banka");
		Player[playerid][pVyplata] = DOF2_GetInt(USER_FILES(playerid),"Vyplata");
		Player[playerid][pKills] = DOF2_GetInt(USER_FILES(playerid),"Kills");
		Player[playerid][pDeaths] = DOF2_GetInt(USER_FILES(playerid),"Deaths");
		Player[playerid][pJob] = DOF2_GetInt(USER_FILES(playerid),"Povolani");
		Player[playerid][pGanja] = DOF2_GetInt(USER_FILES(playerid),"Marihuana");
		Player[playerid][pTaxa] = DOF2_GetFloat(USER_FILES(playerid),"Taxa");
		SetPlayerWantedLevel(playerid,DOF2_GetInt(USER_FILES(playerid),"Wanted"));
		new str[20];
		for(new i; i < PRUKAZY; i ++)
		{
		    format(str,sizeof(str),"Prukaz%d",i);
		    Player[playerid][pPrukazy][i] = DOF2_GetInt(USER_FILES(playerid),str);
		}
		for(new i = 1; i < MAX_JOBS; i ++)
		{
		    format(str,sizeof(str),"JobPoints%d",i);
		    Player[playerid][pJobXP][i] = DOF2_GetInt(USER_FILES(playerid),str);
		}
		new query[300],Cache:cache;
		mysql_format(mysql,query,sizeof(query),"SELECT * FROM `Addons` WHERE `Nick` = '%e' ORDER BY `SLOT` ASC LIMIT %d",Jmeno(playerid),MAX_ADDONS);
		cache = mysql_query(mysql,query);
		for(new i; i < cache_get_row_count(mysql); i ++)
		{
			PlayerAddons[playerid][pAddonID][i] = cache_get_field_content_int(i,"ADDON_ID",mysql);
			PlayerAddons[playerid][pAddonX][i] = cache_get_field_content_float(i,"X",mysql);
			PlayerAddons[playerid][pAddonY][i] = cache_get_field_content_float(i,"Y",mysql);
			PlayerAddons[playerid][pAddonZ][i] = cache_get_field_content_float(i,"Z",mysql);
			PlayerAddons[playerid][pAddonRX][i] = cache_get_field_content_float(i,"RX",mysql);
			PlayerAddons[playerid][pAddonRY][i] = cache_get_field_content_float(i,"RY",mysql);
			PlayerAddons[playerid][pAddonRZ][i] = cache_get_field_content_float(i,"RZ",mysql);
			PlayerAddons[playerid][pAddonSX][i] = cache_get_field_content_float(i,"SX",mysql);
			PlayerAddons[playerid][pAddonSY][i] = cache_get_field_content_float(i,"SY",mysql);
			PlayerAddons[playerid][pAddonSZ][i] = cache_get_field_content_float(i,"SZ",mysql);
		}
		cache_delete(cache,mysql);
	}
	return 1;
}

stock SaveData(playerid,save = 1)
{
	if(Player[playerid][pLogged] == true)
	{
	    CallRemoteFunction("SaveAccount","ii",playerid,save);
	    if(fexist(USER_FILES(playerid)))
	    {
    		DOF2_SetInt(USER_FILES(playerid),"Money",Player[playerid][pMoney]);
			DOF2_SetInt(USER_FILES(playerid),"Odehrano",GetPlayerPlayedTime(playerid));
			DOF2_SetInt(USER_FILES(playerid),"Skin",Player[playerid][pSkin]);
			DOF2_SetInt(USER_FILES(playerid),"Banka",Player[playerid][pBanka]);
			DOF2_SetInt(USER_FILES(playerid),"Vyplata",Player[playerid][pVyplata]);
			DOF2_SetInt(USER_FILES(playerid),"Kills",Player[playerid][pKills]);
			DOF2_SetInt(USER_FILES(playerid),"Deaths",Player[playerid][pDeaths]);
			DOF2_SetInt(USER_FILES(playerid),"Wanted",GetPlayerWantedLevel(playerid));
			DOF2_SetInt(USER_FILES(playerid),"Povolani",Player[playerid][pJob]);
			DOF2_SetInt(USER_FILES(playerid),"Marihuana",Player[playerid][pGanja]);
			DOF2_SetFloat(USER_FILES(playerid),"Taxa",Player[playerid][pTaxa]);
			new str[145];
			for(new i; i < PRUKAZY; i ++)
			{
			    format(str,sizeof(str),"Prukaz%d",i);
			    DOF2_SetInt(USER_FILES(playerid),str,Player[playerid][pPrukazy][i]);
			}
			for(new i = 1; i < MAX_JOBS; i ++)
			{
			    format(str,sizeof(str),"JobPoints%d",i);
			    DOF2_SetInt(USER_FILES(playerid),str,Player[playerid][pJobXP][i]);
			}
			DOF2_SaveFile();
			new query[300+30],Cache:cache;
			for(new i; i < MAX_ADDONS; i ++)
			{
			    new bool:cansave = false,modelid;
			    if(PlayerAddons[playerid][pAddonID][i] != -1)
			    {
			        modelid = AddonsList[PlayerAddons[playerid][pAddonID][i]][AddonID];
			    }
				mysql_format(mysql,query,sizeof(query),"SELECT * FROM `Addons` WHERE `NICK`='%e' AND `SLOT`=%d",Jmeno(playerid),i);
				cache = mysql_query(mysql,query);
				if(!cache_get_row_count(mysql))
				{
				    if(PlayerAddons[playerid][pAddonID][i] != -1)
				    {
						mysql_format(mysql,query,sizeof(query),"INSERT INTO `Addons` (`NICK`,`SLOT`) VALUES ('%e',%d)",Jmeno(playerid),i);
						mysql_query(mysql,query,false);
					}
					else cansave = true;
				}
				cache_delete(cache,mysql);
				if(cansave == false)
				{
					format(str,sizeof(str),"UPDATE `Addons` SET `ADDON_ID`=%d,`ADDON_MODEL`=%d,`X`=%f,`Y`=%f,`Z`=%f,",PlayerAddons[playerid][pAddonID][i],modelid,PlayerAddons[playerid][pAddonX][i],PlayerAddons[playerid][pAddonY][i],PlayerAddons[playerid][pAddonZ][i]);
					mysql_format(mysql,query,sizeof(query),"%s`RX`=%f,`RY`=%f,`RZ`=%f,`SX`=%f,`SY`=%f,`SZ`=%f WHERE `NICK`='%e' AND SLOT=%d",str,\
		                       								PlayerAddons[playerid][pAddonRX][i],PlayerAddons[playerid][pAddonRY][i],\
															PlayerAddons[playerid][pAddonRZ][i],PlayerAddons[playerid][pAddonSX][i],\
															PlayerAddons[playerid][pAddonSY][i],PlayerAddons[playerid][pAddonSZ][i],Jmeno(playerid),i);
					mysql_query(mysql,query,false);
				}
			}
			SaveSpecialProperty(playerid);
		}
	}
	return 1;
}

function GetPlayerSkinEx(playerid)
{
	return Player[playerid][pSkin];
}

function SetPlayerSkinEx(playerid,skinid)
{
	SetPlayerSkin(playerid,skinid);
	Player[playerid][pSkin] = skinid;
	return 1;
}

function GiveMoney(playerid,cash,reason[])
{
	new str[145];
	if(GetPlayerAutoBank(playerid) && cash > 0)
	{
	    if(Player[playerid][pBanka] + cash > 0)
	    {
			Player[playerid][pBanka]+= cash;
			format(str,sizeof(str),"Automaticky uloeno do banky ~g~%s$~w~ celekm máte na úètì: ~g~%s$",SeperateNumber(cash),SeperateNumber(Player[playerid][pBanka]));
			CreateInfoBox(playerid,"Banka",str,8);
			if(strlen(reason))
			{
				format(str,sizeof(str),"[ Money ] %s "cg"+%s$ "cw"[ do banky ][ {007700}%s$ "cw"] [ %s ]",Jmeno(playerid),SeperateNumber(cash),SeperateNumber(Player[playerid][pBanka]),reason);
				printEx(str);
			}
		}
		else
		{
		    GivePlayerMoneyToTrezor(Jmeno(playerid),cash);
			format(str,sizeof(str),"Automaticky uloeno do záloního trezoru ~g~%s$",SeperateNumber(cash));
			CreateInfoBox(playerid,"Banka",str,8);
			if(cash > 0)
			{
				format(str,sizeof(str),"[ Money ] %s "cg"+%s$ "cw"[ do trezoru ] [ {007700}%s$ "cw"] [ %s ]",Jmeno(playerid),SeperateNumber(cash),SeperateNumber(Player[playerid][pMoney]),reason);
			}
			else
			{
				format(str,sizeof(str),"[ Money ] %s "cr"%s$ "cw"[ z trezoru ] [ {007700}%s$ "cw"] [ %s ]",Jmeno(playerid),SeperateNumber(cash),SeperateNumber(Player[playerid][pMoney]),reason);
			}
			printEx(str);
		    return 0;
		}
	}
	else
	{
		if(Player[playerid][pMoney] + cash < 0)
		{
		    GivePlayerMoneyToTrezor(Jmeno(playerid),cash);
			format(str,sizeof(str),"Automaticky uloeno do záloního trezoru ~g~%s$",SeperateNumber(cash));
			CreateInfoBox(playerid,"Banka",str,8);
			if(cash > 0)
			{
				format(str,sizeof(str),"[ Money ] %s "cg"+%s$ "cw"[ do trezoru ] [ {007700}%s$ "cw"] [ %s ]",Jmeno(playerid),SeperateNumber(cash),SeperateNumber(Player[playerid][pMoney]),reason);
			}
			else
			{
				format(str,sizeof(str),"[ Money ] %s "cr"%s$ "cw"[ z trezoru ] [ {007700}%s$ "cw"] [ %s ]",Jmeno(playerid),SeperateNumber(cash),SeperateNumber(Player[playerid][pMoney]),reason);
			}
			printEx(str);
		    return 0;
		}
		Player[playerid][pMoney] += cash;
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,Player[playerid][pMoney]);
		if(strlen(reason))
		{
			if(cash > 0)
			{
				format(str,sizeof(str),"[ Money ] %s "cg"+%s$ "cw"[ do kapsy ] [ {007700}%s$ "cw"] [ %s ]",Jmeno(playerid),SeperateNumber(cash),SeperateNumber(Player[playerid][pMoney]),reason);
			}
			else
			{
				format(str,sizeof(str),"[ Money ] %s "cr"%s$ "cw"[ z kapsy ] [ {007700}%s$ "cw"] [ %s ]",Jmeno(playerid),SeperateNumber(cash),SeperateNumber(Player[playerid][pMoney]),reason);
			}
			printEx(str);
		}
	}
	return 1;
}

stock GiveMoneyWithoutAutobank(playerid,cash,reason[])
{
	if(Player[playerid][pMoney] + cash < 0) return 0;
	new str[256];
	Player[playerid][pMoney] += cash;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,Player[playerid][pMoney]);
	if(cash > 0)
	{
		format(str,sizeof(str),"%s "cg"+%s$ "cw"[ do kapsy ] [ {007700}%s$ "cw"] [ %s ]",Jmeno(playerid),SeperateNumber(cash),SeperateNumber(Player[playerid][pMoney]),reason);
	}
	else
	{
		format(str,sizeof(str),"%s "cr"%s$ "cw"[ z kapsy ] [ {007700}%s$ "cw"] [ %s ]",Jmeno(playerid),SeperateNumber(cash),SeperateNumber(Player[playerid][pMoney]),reason);
	}
	printEx(str);
	return 1;
}

function ResetMoney(playerid)
{
	Player[playerid][pMoney] = 0;
	ResetPlayerMoney(playerid);
	return 1;
}

function GetMoney(playerid)
{
	return Player[playerid][pMoney];
}


stock CreateInfoBox(playerid,nadpis[],text[],time = 5)
{
	#pragma unused nadpis
	return CallRemoteFunction("CreateInfoBox","isi",playerid,text,time);
}

stock Jmeno(playerid)
{
	new pName[MAX_PLAYER_NAME+1];
	if(!IsPlayerAFK(playerid)) GetPlayerName(playerid,pName,sizeof(pName));
	else GetPVarString(playerid,"afkname",pName,sizeof(pName));
	return pName;
}

stock IsPlayerAFK(playerid)
{
	return CallRemoteFunction("IsPlayerAFK","i",playerid);
}

stock SHOP_FILES(shopid)
{
	new dfile[50];
	format(dfile,sizeof(dfile),"Shops/Shop_%d.txt",shopid);
	return dfile;
}

stock USER_FILES(playerid)
{
	new dfile[50];
	format(dfile,sizeof(dfile),"%s.txt",Jmeno(playerid));
	return dfile;
}

stock ShowPlayerDialogEx(playerid,DIALOG_ID,DIALOG_STYLE,NAZEV[],TEXT[],BUTTON1[],BUTTON2[])
{
	if(ShowedDialog[playerid] == true) return false;
	ShowPlayerDialog(playerid,DIALOG_ID,DIALOG_STYLE,NAZEV,TEXT,BUTTON1,BUTTON2);
    ShowedDialog[playerid] = true;
	return 1;
}

stock GetWeaponNameEx(weaponid)
{
	new Nazev[50];
	if(weaponid == 0) Nazev = "Pìst";
	else if(weaponid == 1) Nazev = "Boxer";
	else if(weaponid == 2) Nazev = "Golfová Hùl";
	else if(weaponid == 3) Nazev = "Obušek";
	else if(weaponid == 4) Nazev = "Nù";
	else if(weaponid == 5) Nazev = "Baseballka";
	else if(weaponid == 6) Nazev = "Lopata";
	else if(weaponid == 7) Nazev = "Kuleèníková hùl";
	else if(weaponid == 8) Nazev = "Katana";
	else if(weaponid == 9) Nazev = "Motorovka";
	else if(weaponid == 10) Nazev = "Rùové Dildo";
	else if(weaponid == 11) Nazev = "Dildo";
	else if(weaponid == 12) Nazev = "Vibrátor";
	else if(weaponid == 13) Nazev = "Støíbrnı vibrátor";
	else if(weaponid == 14) Nazev = "Kvìtiny";
	else if(weaponid == 15) Nazev = "Hùl";
	else if(weaponid == 16) Nazev = "Granát";
	else if(weaponid == 17) Nazev = "Slznı Plyn";
	else if(weaponid == 18) Nazev = "Molotov";
	else if(weaponid == 22) Nazev = "Pistol";
	else if(weaponid == 23) Nazev = "Pistol s tlumièem";
	else if(weaponid == 24) Nazev = "Desert Eagle";
	else if(weaponid == 25) Nazev = "Brokovnice";
	else if(weaponid == 26) Nazev = "Sawn off Shotgun";
	else if(weaponid == 27) Nazev = "Combat Shotgun";
	else if(weaponid == 28) Nazev = "Uzi";
	else if(weaponid == 29) Nazev = "MP5";
	else if(weaponid == 30) Nazev = "AK-47";
	else if(weaponid == 31) Nazev = "M4";
	else if(weaponid == 32) Nazev = "Tec-9";
	else if(weaponid == 33) Nazev = "Puška";
	else if(weaponid == 34) Nazev = "Sniperka";
	else if(weaponid == 35) Nazev = "Raketomet";
	else if(weaponid == 36) Nazev = "Tepelnı raketomet";
	else if(weaponid == 37) Nazev = "Plamenomet";
	else if(weaponid == 38) Nazev = "Minigun";
	else if(weaponid == 39) Nazev = "C4";
	else if(weaponid == 40) Nazev = "Detonátor";
	else if(weaponid == 41) Nazev = "Spray";
	else if(weaponid == 42) Nazev = "Hasièák";
	else if(weaponid == 43) Nazev = "Fotoaparát";
	else if(weaponid == 44) Nazev = "Noèní vidìní";
	else if(weaponid == 45) Nazev = "Thermo vize";
	else if(weaponid == 46) Nazev = "Padák";
	return Nazev;
}

/*DUDB*/
stock set(dest[],source[]) {
	new count = strlen(source);
	new i=0;
	for (i=0;i<count;i++) {
		dest[i]=source[i];
	}
	dest[count]=0;
}

ret_memcpy(source[],index=0,numbytes) {
	new tmp[255];
	new i=0;
	tmp[0]=0;
	if (index>=strlen(source)) return tmp;
	if (numbytes+index>=strlen(source)) numbytes=strlen(source)-index;
	if (numbytes<=0) return tmp;
	for (i=index;i<numbytes+index;i++) {
		tmp[i-index]=source[i];
		if (source[i]==0) return tmp;
	}
	tmp[numbytes]=0;
	return tmp;
}


stock strreplace(trg[],newstr[],src[]) {
    new f=0;
    new s1[255];
    new tmp[255];
    format(s1,sizeof(s1),"%s",src);
    f = strfind(s1,trg);
    tmp[0]=0;
    while (f>=0) {
        strcat(tmp,ret_memcpy(s1, 0, f));
        strcat(tmp,newstr);
        format(s1,sizeof(s1),"%s",ret_memcpy(s1, f+strlen(trg), strlen(s1)-f));
        f = strfind(s1,trg);
    }
    strcat(tmp,s1);
    return tmp;
}

stock udb_hash(buf[]) {
	new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}


stock udb_encode(nickname[]) {
  new tmp[255];
  set(tmp,nickname);
  tmp=strreplace("_","_00",tmp);
  tmp=strreplace(";","_01",tmp);
  tmp=strreplace("!","_02",tmp);
  tmp=strreplace("/","_03",tmp);
  tmp=strreplace("\\","_04",tmp);
  tmp=strreplace("[","_05",tmp);
  tmp=strreplace("]","_06",tmp);
  tmp=strreplace("?","_07",tmp);
  tmp=strreplace(".","_08",tmp);
  tmp=strreplace("*","_09",tmp);
  tmp=strreplace("<","_10",tmp);
  tmp=strreplace(">","_11",tmp);
  tmp=strreplace("{","_12",tmp);
  tmp=strreplace("}","_13",tmp);
  tmp=strreplace(" ","_14",tmp);
  tmp=strreplace("\"","_15",tmp);
  tmp=strreplace(":","_16",tmp);
  tmp=strreplace("|","_17",tmp);
  tmp=strreplace("=","_18",tmp);
  return tmp;
}


stock SendMessage(playerid,text[])
{
	new str[145];
	format(str,sizeof(str),"[ ! ] "cw"%s"cw".",text);
	SCM(playerid,RED,str);
	return 1;
}
/*DUDB*/
/*
stock set(dest[],source[]) {
	new count = strlen(source);
	new i=0;
	for (i=0;i<count;i++) {
		dest[i]=source[i];
	}
	dest[count]=0;
}

stock ret_memcpy(source[],index=0,numbytes) {
	new tmp[255];
	new i=0;
	tmp[0]=0;
	if (index>=strlen(source)) return tmp;
	if (numbytes+index>=strlen(source)) numbytes=strlen(source)-index;
	if (numbytes<=0) return tmp;
	for (i=index;i<numbytes+index;i++) {
		tmp[i-index]=source[i];
		if (source[i]==0) return tmp;
	}
	tmp[numbytes]=0;
	return tmp;
}


stock strreplace(trg[],newstr[],src[]) {
    new f=0;
    new s1[255];
    new tmp[255];
    format(s1,sizeof(s1),"%s",src);
    f = strfind(s1,trg);
    tmp[0]=0;
    while (f>=0) {
        strcat(tmp,ret_memcpy(s1, 0, f));
        strcat(tmp,newstr);
        format(s1,sizeof(s1),"%s",ret_memcpy(s1, f+strlen(trg), strlen(s1)-f));
        f = strfind(s1,trg);
    }
    strcat(tmp,s1);
    return tmp;
}

stock udb_hash(buf[]) {
	new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}


stock udb_encode(nickname[]) {
  new tmp[255];
  set(tmp,nickname);
  tmp=strreplace("_","_00",tmp);
  tmp=strreplace(";","_01",tmp);
  tmp=strreplace("!","_02",tmp);
  tmp=strreplace("/","_03",tmp);
  tmp=strreplace("\\","_04",tmp);
  tmp=strreplace("[","_05",tmp);
  tmp=strreplace("]","_06",tmp);
  tmp=strreplace("?","_07",tmp);
  tmp=strreplace(".","_08",tmp);
  tmp=strreplace("*","_09",tmp);
  tmp=strreplace("<","_10",tmp);
  tmp=strreplace(">","_11",tmp);
  tmp=strreplace("{","_12",tmp);
  tmp=strreplace("}","_13",tmp);
  tmp=strreplace(" ","_14",tmp);
  tmp=strreplace("\"","_15",tmp);
  tmp=strreplace(":","_16",tmp);
  tmp=strreplace("|","_17",tmp);
  tmp=strreplace("=","_18",tmp);
  return tmp;
}
*/

