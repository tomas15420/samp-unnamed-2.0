#include <a_samp>
#include <streamer>
#include <dof2>
#include <izcmd>
#include <ostatni>
#include <dini>
#include <a_mysql>
#include <daily>
//============================================================================//
#define function%0(%1) 	forward%0(%1); public%0(%1)
#define GANG_FILE "GangSystem/Gang[%d].ini"
#define UNCONFIG "UnNamed/UNConfig.cfg"
#define MAX_GANGS 40
#define MAX_MEMBERS 25
#define MAX_SLOTS 10
#define GANG_PRICE 10000
#define GANG 546
#undef MAX_PLAYERS
#define MAX_PLAYERS 100
#define SCMTOAA(%1) format(str,sizeof(str),"%s %s",%1,params); CallRemoteFunction("SCMTOA","is",playerid,str);
#define ZONES_FILE "GangSystem/Zones.txt"

#pragma dynamic 140000

#define TAKEOVER_PLAYERS    3
#define TAKEOVER_TIME       300
#define TAKEOVER_TIME_NONE  60

#define MAX_PLAYERS_EX 100
#define MAX_USED_INT 6
#define MAX_USED_FLOAT 3
#define MAX_USED_STRING 2
#define MAX_USED_STRING_LENGTH 24
#include <AVS>

new mysql;
new Member[MAX_PLAYERS];
new gOwner[MAX_PLAYERS];

#define SPAWN_TYPE_NONE 	0
#define SPAWN_TYPE_GANG 	1
#define SPAWN_TYPE_HOUSE    2

//============================================================================//
new dfile[50];
new str[255];
new bool:ShowedInfoBox[MAX_PLAYERS];
new PlayerText:Textdraw0[MAX_PLAYERS];
new PlayerText:InfoBox[MAX_PLAYERS];
new PlayerText:TimeBox[MAX_PLAYERS];
new PlayerText:FightInfo[MAX_PLAYERS];
new SecondTimer[MAX_PLAYERS];
new Text3D:Text[MAX_PLAYERS];
new LastZone[MAX_PLAYERS];
new SavedCar[MAX_GANGS][MAX_SLOTS];
enum ParkData
{
	Model,
	Float:pX,Float:pY,Float:pZ,Float:pA,
	PaintJob,Color1,Color2,
	TuneSlot0,TuneSlot1,TuneSlot2,TuneSlot3,TuneSlot4,TuneSlot5,TuneSlot6,TuneSlot7,TuneSlot8,TuneSlot9,TuneSlot10,TuneSlot11,TuneSlot12,TuneSlot13
};
enum CarsData
{
	GarageID,GarageNazev[30],GarageCena
}
new ParkInfo[MAX_GANGS][MAX_SLOTS][ParkData];
new GarageCategories[][] =
{
	"Sportovní",
	"Motorky",
	"Salónové",
	"Off-Road",
	"Lowridery",
	"Lodì",
	"Letadla",
	"Helikoptéry",
	"Kola",
	"Dodávky",
	"Unikátní",
	"Limuzíny",
	"Kabriolety",
	"Služební",
	"Prùmyslová"
};

new Functions[][] =
{
	"Pøejmenovat Gang",
	"Zmìnit barvu gangu",
	"Nastavit povinný skin Gangu",
	"Pozvat èleny",
	"Upravit popis gangu",
	"Gang Garáž",
	"Vyhodit èlena",
	"Vybrat body"
};
new BlockedNames[][] =
{
	"Majitel","Eventer","Eventér","Majytel","Admin","Admyn","Pawner","Admln","Donator",
	"Moderátor","Moderator","Helper","{","}","Webmaster","Elita","EIta","Legenda","legenda",
	"Správce","spravce","Pumpkin"
};
//============================================================================//
enum GangData
{
	Float:GX,Float:GY,Float:GZ,Owner[MAX_PLAYER_NAME],
	GPickup,Text3D:GText,GBank,GName[255],GSkin,GRespect,
	GColor[255],GMapIcon,GSlots,GSName[255],GPopis[255],
	Audio,AudioStream[255],GFight,GFightKills
};
new Gang[MAX_GANGS][GangData];

//============================================================================//
enum ColorsData
{
	ColorCode[255],ColorName[255]
};
new Colors[][ColorsData] =
{
	{"FFFFFF","Bílá"},
	{"FF0000","Èervená"},
	{"0C7C00","Tmavì zelená"},
	{"00FF00","Zelená"},
	{"90FF00","Zelinkavá"},
	{"FFFF00","Žlutá"},
	{"FF00FF","Purpurová"},
	{"A100FF","Fialová"},
	{"00FFFF","Tyrkysová"},
	{"0055FF","Modrá"},
	{"0000FF","Tmavì Modrá"},
	{"FFA100","Oranžová"},
	{"FF5400","Tmavá Oranžová"}
};
//============================================================================//
enum ZoneData
{
	Float:ZoneMIX,Float:ZoneMIY,Float:ZoneMXX,Float:ZoneMXY,ZoneGang
};

new Zones[][ZoneData] =
{
	{ 2491.0, 2640.5, 2763.0, 2866.5 },
	{ 2744.0, 2305.5, 2923.0, 2640.5 },
	{ 2420.0, 2224.5, 2533.0, 2419.5 },
	{ 2032.0, 2447.5, 2227.0, 2535.5 },
	{ 2082.0, 2705.5, 2238.0, 2854.5 },
	{ 1897.0, 2644.5, 2081.0, 2789.5 },
	{ 1684.0, 2711.5, 1884.0, 2886.5 },
	{ 1771.0, 2559.5, 1893.0, 2680.5 },
	{ 1534.0, 2680.5, 1681.0, 2875.5 },
	{ 1198.0, 2500.5, 1389.0, 2632.5 },
	{ 1389.0, 2500.5, 1489.0, 2600.5 },
	{ 1489.0, 2500.5, 1682.0, 2633.5 },
	{ 1389.0, 2600.5, 1489.0, 2714.5 },
	{ 906.0, 1962.5, 1011.0, 2191.5 },
	{ 904.0, 1851.5, 1010.0, 1956.5 },
	{ 1018.0, 1826.5, 1145.0, 2051.5 },
	{ 1011.0, 2161.5, 1171.0, 2293.5 },
	{ 1008.0, 1371.5, 1186.0, 1710.5 },
	{ 1008.0, 1195.5, 1184.0, 1371.5 },
	{ 1266.0, 2054.5, 1523.0, 2317.5 },
	{ 1569.0, 2173.5, 1726.0, 2279.5 },
	{ 1523.0, 2014.5, 1702.0, 2173.5 },
	{ 1293.0, 1874.5, 1523.0, 2054.5 },
	{ 1523.0, 1873.5, 1701.0, 2014.5 },
	{ 1710.0, 2057.5, 1801.0, 2173.5 },
	{ 1647.0, 1135.5, 1757.0, 1274.5 },
	{ 1273.0, 1077.5, 1438.0, 1195.5 },
	{ 1383.0, 915.5, 1492.0, 1077.5 },
	{ 1502.0, 913.5, 1571.0, 1133.5 },
	{ 1583.0, 887.5, 1752.0, 1119.5 },
	{ 1347.0, 653.5, 1568.0, 805.5 },
	{ 1568.0, 653.5, 1761.0, 805.5 },
	{ 1821.0, 620.5, 1996.0, 791.5 },
	{ 1996.0, 619.5, 2147.0, 791.5 },
	{ 2148.0, 618.5, 2287.0, 757.5 },
	{ 2287.0, 619.5, 2472.0, 757.5 },
	{ 2235.0, 505.5, 2402.0, 607.5 },
	{ 2500.0, 687.5, 2690.0, 776.5 },
	{ 2551.0, 777.5, 2728.0, 922.5 },
	{ 2776.0, 829.5, 2898.0, 1021.5 },
	{ 2748.0, 1216.5, 2882.0, 1395.5 },
	{ 2511.0, 1621.5, 2679.0, 1955.5 },
	{ 2428.0, 1477.5, 2606.0, 1621.5 },
	{ 2082.0, 978.5, 2344.0, 1188.5 },
	{ 1836.0, 899.5, 2036.0, 1098.5 },
	{ 1834.0, 1099.5, 2039.0, 1271.5 },
	{ 1832.0, 1271.5, 2039.0, 1451.5 },
	{ 2079.0, 1196.5, 2420.0, 1373.5 },
	{ 2353.0, 954.5, 2420.0, 1069.5 },
	{ 2075.0, 1540.5, 2326.0, 1769.5 },
	{ 2076.0, 1377.5, 2245.0, 1532.5 },
	{ 2255.0, 1378.5, 2361.0, 1532.5 },
	{ 1824.0, 1458.5, 2052.0, 1703.5 },
	{ 1839.0, 1827.5, 2116.0, 2019.5 },
	{ 1839.0, 1725.5, 2072.0, 1827.5 },
	{ 2151.0, 1780.5, 2350.0, 1885.5 },
	{ 2362.0, 1794.5, 2505.0, 1973.5 },
	{ 2148.0, 2145.5, 2345.0, 2271.5 },
	{ 2149.0, 2026.5, 2345.0, 2137.5 },
	{ 2152.0, 1890.5, 2347.0, 2020.5 },
	{ 2359.0, 2139.5, 2526.0, 2224.5 },
	{ 2360.0, 2058.5, 2523.0, 2133.5 },
	{ 2548.0, 2240.5, 2660.0, 2427.5 },
	{ 2227.0, 2518.5, 2376.0, 2572.5 },
	{ 2527.0, 1254.5, 2630.0, 1375.5 },
	{ 2430.0, 1077.5, 2524.0, 1192.5 },
	{ 2530.0, 1016.5, 2614.0, 1070.5 },
	{ 1830.0, 2392.5, 2025.0, 2510.5 },
	{ 100.0, 1328.5, 296.0, 1494.5 },
	{ 674.0, 1924.5, 804.0, 2099.5 },
	{ 658.0, 1790.5, 806.0, 1924.5 },
	{ -96.0, 1901.5, 188.0, 2154.5 },
	{ -96.0, 1648.5, 188.0, 1901.5 },
	{ 188.0, 1648.5, 472.0, 1901.5 },
	{ 188.0, 1901.5, 472.0, 2154.5 },
	{ -50.0, 1317.5, 50.0, 1417.5 },
	{ -289.0, 2587.5, -193.0, 2620.5 },
	{ -347.0, 2634.5, -141.0, 2754.5 },
	{ -1044.0, 2642.5, -893.0, 2763.5 },
	{ -893.0, 2716.5, -713.0, 2792.5 },
	{ -688.0, 2675.5, -554.0, 2734.5 },
	{ -901.0, 1805.5, -801.0, 1983.5 },
	{ -634.0, 1805.5, -534.0, 1983.5 },
	{ -923.0, 1983.5, -511.0, 2163.5 },
	{ -380.0, 1723.5, -271.0, 1904.5 },
	{ -845.0, 1408.5, -751.0, 1471.5 },
	{ -355.0, 1286.5, -278.0, 1343.5 },
	{ -390.0, 1098.5, -274.0, 1224.5 },
	{ -274.0, 1098.5, -158.0, 1224.5 },
	{ -158.0, 1117.5, -42.0, 1243.5 },
	{ -42.0, 1117.5, 74.0, 1243.5 },
	{ 74.0, 1004.5, 196.0, 1243.5 },
	{ -390.0, 994.5, -275.0, 1098.5 },
	{ -275.0, 984.5, -158.0, 1098.5 },
	{ -158.0, 996.5, -42.0, 1117.5 },
	{ -42.0, 1002.5, 74.0, 1117.5 },
	{ -158.0, 858.5, -42.0, 984.5 },
	{ -42.0, 888.5, 77.0, 1004.5 },
	{ -357.0, 777.5, -287.0, 891.5 },
	{ 776.0, 811.5, 931.0, 936.5 },
	{ 294.0, 801.5, 420.0, 940.5 },
	{ 492.0, 801.5, 704.0, 928.5 },
	{ -2651.0, 2252.5, -2544.0, 2448.5 },
	{ -1365.0, 2659.5, -1221.0, 2737.5 },
	{ -1345.0, 2456.5, -1245.0, 2556.5 },
	{ -1553.0, 2549.5, -1418.0, 2600.5 },
	{ -2509.0, 2474.5, -2420.0, 2550.5 },
	{ -2538.0, 1502.5, -2293.0, 1592.5 },
	{ -1514.0, 1466.5, -1344.0, 1518.5 },
	{ -1565.0, 1111.5, -1504.0, 1229.5 },
	{ -1565.0, 1003.5, -1505.0, 1111.5 },
	{ -1505.0, 839.5, -1431.0, 1003.5 },
	{ -1484.0, 470.5, -1232.0, 534.5 },
	{ -1551.0, 359.5, -1320.0, 470.5 },
	{ -1609.0, 260.5, -1464.0, 359.5 },
	{ -1576.0, 71.5, -1476.0, 171.5 },
	{ -2140.0, -515.5, -1953.0, -367.5 },
	{ -2158.0, -856.5, -1925.0, -715.5 },
	{ -2158.0, -997.5, -1925.0, -856.5 },
	{ -2096.0, -1137.5, -1925.0, -997.5 },
	{ -1129.0, -758.5, -974.0, -583.5 },
	{ -977.0, -557.5, -902.0, -481.5 },
	{ -1454.0, -982.5, -1396.0, -928.5 },
	{ -1938.0, -1736.5, -1740.0, -1586.5 },
	{ -2563.0, -734.5, -2475.0, -583.5 },
	{ -2380.0, 53.5, -2257.0, 239.5 },
	{ -2247.0, -184.5, -2167.0, -73.5 },
	{ -1999.0, 72.5, -1903.0, 218.5 },
	{ -2001.0, 231.5, -1902.0, 316.5 },
	{ -1857.0, 505.5, -1757.0, 595.5 },
	{ -2143.0, 112.5, -2016.0, 320.5 },
	{ -2707.0, -66.5, -2603.0, 40.5 },
	{ -2852.0, 372.5, -2731.0, 463.5 },
	{ -2731.0, 372.5, -2610.0, 463.5 },
	{ -2852.0, 281.5, -2731.0, 372.5 },
	{ -2731.0, 281.5, -2610.0, 372.5 },
	{ -2763.0, 158.5, -2701.0, 239.5 },
	{ -2528.0, 571.5, -2390.0, 707.5 },
	{ -2137.0, 889.5, -2006.0, 976.5 },
	{ -2000.0, 851.5, -1891.0, 922.5 },
	{ -2011.0, 1335.5, -1895.0, 1386.5 },
	{ -1896.0, 1267.5, -1740.0, 1326.5 },
	{ -2721.0, 1306.5, -2592.0, 1471.5 },
	{ -2366.0, -1673.5, -2266.0, -1573.5 },
	{ -2115.0, -2585.5, -2015.0, -2485.5 },
	{ -2064.0, -2448.5, -1936.0, -2319.5 },
	{ 136.0, -136.5, 230.0, -73.5 },
	{ 23.0, -347.5, 212.0, -216.5 },
	{ -147.0, 10.5, 9.0, 126.5 },
	{ -172.0, -105.5, -16.0, 10.5 },
	{ 685.0, 244.5, 817.0, 394.5 },
	{ 1390.0, 310.5, 1508.0, 408.5 },
	{ 1252.0, 134.5, 1333.0, 211.5 },
	{ 1507.0, -27.5, 1592.0, 69.5 },
	{ 2226.0, -95.5, 2290.0, -23.5 },
	{ 2225.0, 50.5, 2293.0, 144.5 },
	{ 2293.0, -92.5, 2346.0, 91.5 },
	{ -1207.0, -1073.5, -998.0, -892.5 },
	{ -1174.0, -1268.5, -1046.0, -1139.5 },
	{ -1488.0, -1606.5, -1383.0, -1431.5 },
	{ 1431.4999389648438, -1725.0, 1530.4999389648438, -1601.0 },
	{ -2523.0, 910.5, -2390.0, 1085.5 },
	{ -2004.0, 605.5, -1898.0, 732.5 },
	{ 800.0, -1393.5, 920.0, -1321.5 },
	{ 916.0, -1392.5, 1058.0, -1321.5 },
	{ 800.0, -1239.5, 942.0, -1142.5 },
	{ 800.0, -1322.5, 941.0, -1239.5 },
	{ 941.0, -1321.5, 1058.0, -1221.5 },
	{ 941.0, -1221.5, 1058.0, -1142.5 },
	{ 1126.0, -1390.5, 1190.0, -1284.5 },
	{ 1069.0, -1390.5, 1126.0, -1283.5 },
	{ 929.0, -1568.5, 1039.0, -1490.5 },
	{ 929.0, -1490.5, 1057.0, -1412.5 },
	{ 813.0, -1761.5, 913.0, -1661.5 },
	{ 813.0, -1661.5, 913.0, -1561.5 },
	{ 645.0, -1392.5, 791.0, -1328.5 },
	{ 644.0, -1313.5, 791.0, -1212.5 },
	{ 703.0, -1144.5, 790.0, -1064.5 },
	{ 703.0, -1214.5, 790.0, -1144.5 },
	{ 968.0, -1134.5, 1078.0, -1097.5 },
	{ 968.0, -1098.5, 1078.0, -1042.5 },
	{ 1078.0, -1135.5, 1171.0, -1042.5 },
	{ 1169.0, -1135.5, 1264.0, -1043.5 },
	{ 1264.0, -1135.5, 1350.0, -1043.5 },
	{ 1039.0, -1568.5, 1190.0, -1487.5 },
	{ 1057.0, -1487.5, 1189.0, -1412.5 },
	{ 2651.0, -1782.5, 2844.0, -1667.5 },
	{ 2651.0, -1901.5, 2843.0, -1782.5 },
	{ 2718.0, -2156.5, 2816.0, -2056.5 },
	{ 2374.0, -2601.5, 2525.0, -2508.5 },
	{ 2374.0, -2694.5, 2526.0, -2601.5 },
	{ 2456.0, -2478.5, 2556.0, -2378.5 },
	{ 2177.0, -2553.5, 2276.0, -2450.5 },
	{ 2176.0, -2653.5, 2276.0, -2553.5 },
	{ 2441.0, -1723.5, 2541.0, -1623.5 },
	{ 2427.0, -1835.5, 2527.0, -1735.5 },
	{ 2226.0, -1826.5, 2325.0, -1756.5 },
	{ 2325.0, -1826.5, 2405.0, -1756.5 },
	{ 1974.0, -1250.5, 2062.0, -1144.5 },
	{ 1858.0, -1249.5, 1974.0, -1145.5 },
	{ 1824.0, -1745.5, 1942.0, -1609.5 },
	{ 1046.0, -1701.5, 1150.0, -1578.5 },
	{ 1048.0, -1797.5, 1171.0, -1717.5 },
	{ 1071.0, -1846.5, 1170.0, -1797.5 },
	{ 1361.0, -1328.5, 1451.0, -1246.5 },
	{ 1361.0, -1395.5, 1450.0, -1328.5 },
	{ 162.0, -1870.5, 307.0, -1773.5 },
	{ 136.0, -1972.5, 172.0, -1936.5 },
	{ 349.0, -2090.5, 410.0, -2047.5 },
	{ 377.0, -1933.5, 400.0, -1818.5 },
	{ 340.0, -1643.5, 443.0, -1600.5 },
	{ 443.0, -1654.5, 533.0, -1600.5 },
	{ 533.0, -1667.5, 617.0, -1600.5 },
	{ 556.0, -1573.5, 618.0, -1471.5 },
	{ 556.0, -1471.5, 618.0, -1415.5 },
	{ 1863.0, -1453.5, 1977.0, -1350.5 },
	{ 2169.0, -1219.5, 2262.0, -1121.5 },
	{ 1868.0, -1134.5, 1968.0, -1034.5 },
	{ 1968.0, -1134.5, 2065.0, -1070.5 },
	{ 2748.0, -1650.5, 2819.0, -1573.5 },
	{ 2748.0, -1573.5, 2863.0, -1494.5 },
	{ 2646.0, -1430.5, 2722.0, -1262.5 },
	{ 2646.0, -1598.5, 2722.0, -1430.5 },
	{ 2449.0, -1504.0001678466797, 2550.0, -1437.0001678466797 },
	{ 2410.0, -2139.5, 2553.0, -2061.5 },
	{ 2410.0, -2042.5, 2544.0, -1986.5 },
	{ 2410.0, -1986.5, 2544.0, -1935.5 },
	{ 1823.0, -2158.5, 1923.0, -2058.5 },
	{ 1823.0, -2058.5, 1957.0, -1958.5 },
	{ 1819.0, -1935.5, 1957.0, -1890.5 },
	{ 2128.0, -1622.5, 2191.0, -1578.5 },
	{ 2115.0, -1746.5, 2190.0, -1643.5 },
	{ 2007.0, -1677.5, 2077.0, -1619.5 },
	{ 2005.0, -1747.5001678466797, 2077.0, -1677.5001678466797 },
	{ 2053.0, -1599.5, 2095.0, -1543.5 },
	{ 2077.0, -1218.5, 2169.0, -1121.5 },
	{ 600.9998779296875, -535.9999389648438, 725.9998779296875, -485.99993896484375 },
	{ 639.0, -600.9999389648438, 716.0, -535.9999389648438 },
	{ 790.0, -599.9999389648438, 838.0, -527.9999389648438 },
	{ 1005.0, -375.99993896484375, 1121.0, -288.99993896484375 },
	{ 1858.0, -1350.4999237060547, 1974.0, -1249.4999237060547 },
	{ 1974.0, -1349.4999237060547, 2062.0, -1250.4999237060547 },
	{ 2077.0, -1303.4999237060547, 2169.0, -1218.4999237060547 },
	{ 2077.0, -1384.4999389648438, 2167.0, -1303.4999389648438 },
	{ 2169.0, -1303.4999237060547, 2268.0, -1218.4999237060547 },
	{ 2167.0, -1383.4999389648438, 2267.0, -1303.4999389648438 },
	{ 2124.0, -1502.4999389648438, 2211.0, -1384.4999389648438 },
	{ 2211.0, -1501.4999389648438, 2282.0, -1383.4999389648438 },
	{ 2225.0, -1758.5001831054688, 2326.0, -1656.5001831054688 },
	{ 2325.0, -1759.5001831054688, 2416.0, -1656.5001831054688 },
	{ 1824.0, -1814.5001678466797, 1963.0, -1745.5001678466797 },
	{ 1963.0, -1813.5001831054688, 2091.0, -1745.5001831054688 },
	{ 2090.0, -1833.5001678466797, 2201.0, -1746.5001678466797 },
	{ 2587.0, -2245.0001831054688, 2765.0, -2181.0001831054688 },
	{ 2433.0, -2244.0001831054688, 2588.0, -2181.0001831054688 },
	{ 2410.0, -1938.0001831054688, 2538.0, -1877.0001831054688 },
	{ 2221.0, -1975.0001831054688, 2320.0, -1882.0001831054688 },
	{ 2220.0, -2043.0001831054688, 2319.0, -1975.0001831054688 },
	{ 2319.0, -2043.0001831054688, 2411.0, -1975.0001831054688 },
	{ 2449.0, -1436.9999237060547, 2514.0, -1260.9999237060547 },
	{ 2514.0, -1437.9999237060547, 2574.0, -1260.9999237060547 },
	{ 2574.0, -1436.9999237060547, 2646.0, -1260.9999237060547 },
	{ 2648.0, -1148.9999389648438, 2715.0, -1091.9999389648438 },
	{ 2369.000244140625, -1261.0, 2448.000244140625, -1187.0 },
	{ 2722.0, -1428.4999389648438, 2796.0, -1262.4999389648438 },
	{ 2320.0, -1976.0001831054688, 2411.0, -1877.0001831054688 },
	{ 968.0, -1044.9999389648438, 1078.0, -959.9999389648438 },
	{ 1078.0, -1044.9999237060547, 1163.0, -959.9999237060547 },
	{ 1163.0, -1043.9999237060547, 1260.0, -959.9999237060547 },
	{ 1260.0, -1044.4999237060547, 1349.0, -943.4999237060547 },
	{ 902.0, -960.9999389648438, 1038.0, -892.9999389648438 },
	{ 1038.0, -959.9999389648438, 1148.0, -859.9999389648438 },
	{ 2370.0, -1385.9999389648438, 2449.0, -1260.9999389648438 },
	{ 2353.0, -1479.0001678466797, 2449.0, -1386.0001678466797 },
	{ 2437.0, -1564.5001678466797, 2498.0, -1506.5001678466797 },
	{ 2272.0, -1552.5001678466797, 2337.0, -1501.5001678466797 },
	{ 2337.0, -1552.5001831054688, 2430.0, -1477.5001831054688 },
	{ 2566.0, -1262.9999389648438, 2716.0, -1186.9999389648438 },
	{ 2618.0, -2156.5001831054688, 2718.0, -2056.5001831054688 },
	{ 2616.0, -2038.0001831054688, 2716.0, -1938.0001831054688 },
	{ 2716.0, -2001.5001678466797, 2816.0, -1901.5001678466797 },
	{ 2718.0, -2036.5001831054688, 2817.0, -2001.5001831054688 },
	{ 421.5, -1915.0, 606.5, -1833.0 },
	{ 853.5, -1905.0, 1012.5, -1831.0 }
};

new ZoneID[sizeof(Zones)];
new ZoneAttackTime[sizeof(Zones)];
new ZoneAttacker[sizeof(Zones)];
new ZoneVictim[sizeof(Zones)];
//============================================================================//
new gangid;
//============================================================================//
public OnGameModeInit()
{
    EnableVehicleFriendlyFire();
	return 1;
}
//============================================================================//
forward SaveData();

public SaveData()
{
	SaveGangs();
	return 1;
}

public OnFilterScriptInit()
{


	SetTimer("SaveData",1000*60*60,true);
	mysql_log(LOG_ERROR | LOG_WARNING);
	mysql = mysql_connect(DOF2_GetString(UNCONFIG,"DB_HOST"), DOF2_GetString(UNCONFIG,"DB_USER"), DOF2_GetString(UNCONFIG,"DB_NAME"), DOF2_GetString(UNCONFIG,"DB_PASS"));
	if(mysql_errno(mysql) != 0)
	{
		 print("Pøipojení k databázi selhalo");
		 SendRconCommand("exit");
		 return 0;
	}
	else
	{
		printf("Pøipojeno k databázi: %s",DOF2_GetString(UNCONFIG,"DB_NAME"));
		mysql_set_charset("cp1250",mysql);
	}


	for(new i; i < sizeof(Zones); i ++)
	{
		new query[100],Cache:cache;
		mysql_format(mysql,query,sizeof(query),"SELECT * FROM `GangZones` WHERE `ZoneID`=%d LIMIT 1",i);
		cache = mysql_query(mysql,query);
		if(!cache_get_row_count(mysql))
		{
		    mysql_format(mysql,query,sizeof(query),"INSERT INTO `GangZones` (`ZoneID`,`GangID`) VALUES (%d,-1)",i);
		    mysql_query(mysql,query,false);
			Zones[i][ZoneGang] = -1;
		}
		else
		{
		    Zones[i][ZoneGang] = cache_get_field_content_int(0,"GangID",mysql);
		}
		cache_delete(cache,mysql);
	}

	for(new i; i < sizeof(Zones); i ++)
	{
	    ZoneID[i] = GangZoneCreate(Zones[i][ZoneMIX],Zones[i][ZoneMIY],Zones[i][ZoneMXX],Zones[i][ZoneMXY]);
	}

	for(new i; i < MAX_PLAYERS; i ++)
	{
	    SetPlayerTeam(i,255);
	    if(IPC(i) && !IsPlayerNPC(i))
	    {
	    	CreateInfoTD(i);
		}
	}
	for(new i; i < MAX_GANGS; i ++)
	{
	    format(dfile,sizeof(dfile),GANG_FILE,i);
		if(fexist(dfile))
		{
		    new Float:X,Float:Y,Float:Z;
		    X = dini_Float(dfile,"X");
		    Y = dini_Float(dfile,"Y");
		    Z = dini_Float(dfile,"Z");
		    CreateGang(X,Y,Z);
		    Gang[i][GFight] = -1;
		}
	}
	new member[50];
	for(new i; i < MAX_GANGS; i ++)
	{
		format(dfile,sizeof(dfile),GANG_FILE,i);
		if(fexist(dfile))
		{
			for(new e; e <= GetPlayerPoolSize(); e ++)
			{
				if(IPC(e) && !IsPlayerNPC(e))
				{
					if(strcmp(dini_Get(dfile,"Owner"),Jmeno(e),false) == 0)
					{
					    SetInt(e,"Spawned",1);
						SetInt(e,"Member",i);
						Member[e] = i;
						SetInt(e,"Owner",i);
						gOwner[e] = i;
						SetInt(e,"MemberSpawn",dini_Int(dfile,"OwnerSpawn"));
						if(strlen(Gang[i][GSName]) == 0)
						{
							format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GName]);
						}
						else
						{
							format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GSName]);
						}
						Text[e] = Create3DTextLabel(str,bila,0,0,0,50,-1,true);
						Attach3DTextLabelToPlayer(Text[e],e,0,0,0.5);
						SetPlayerTeam(e,i);
					}
					for(new x; x < MAX_MEMBERS; x ++)
					{
						format(member,sizeof(member),"Member[%d]",x);
						if(strcmp(dini_Get(dfile,member),Jmeno(e),false) == 0)
						{
							format(member,sizeof(member),"MemberSpawn[%d]",x);
							SetInt(e,"Member",i);
							Member[e] = i;
						    SetInt(e,"Spawned",1);
							SetInt(e,"MemberSpawn",dini_Int(dfile,member));
							SetInt(e,"MemberPos",x);
							if(strlen(Gang[i][GSName]) == 0)
							{
								format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GName]);
							}
							else
							{
								format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GSName]);
							}
							Text[e] = Create3DTextLabel(str,bila,0,0,0,50,-1,true);
							Attach3DTextLabelToPlayer(Text[e],e,0,0,0.5);
							SetPlayerTeam(e,i);
						}
    				}
				}
			}
		}
	}
	return 1;
}
//============================================================================//
public OnFilterScriptExit()
{
	DOF2_Exit();
	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(IPC(i) && !IsPlayerNPC(i))
		{
			PlayerTextDrawDestroy(i,Textdraw0[i]);
			SetPlayerTeam(i,255);
			if(GetInt(i,"Member") > 0)
			{
				Delete3DTextLabel(Text[i]);
			}
		}
	}
	for(new i; i < MAX_GANGS; i ++)
	{
	    DestroyPickup(Gang[i][GPickup]);
	    DestroyDynamic3DTextLabel(Gang[i][GText]);
	    DestroyDynamicMapIcon(Gang[i][GMapIcon]);
	    for(new x; x < MAX_SLOTS; x ++)
	    {
	        DestroyVehicle(SavedCar[i][x]);
	    }
	}
	SaveGangs();
	mysql_close(mysql);
	return 1;
}
//============================================================================//
public OnVehicleSpawn(vehicleid)
{
	for(new i; i < MAX_GANGS; i ++)
	{
		for(new x; x < MAX_SLOTS; x ++)
		{
			if(vehicleid == SavedCar[i][x])
			{
			    SpawnCar(i,x);
			}
		}
	}
	return 1;
}
//============================================================================//
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	for(new x; x < MAX_GANGS; x ++)
	{
		for(new i; i < MAX_SLOTS; i ++)
		{
		    if(IsPlayerInVehicle(playerid,SavedCar[x][i]))
		    {
				ParkInfo[x][i][PaintJob] = paintjobid;
			}
		}
	}
	return 1;
}
//============================================================================//
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	for(new x; x < MAX_GANGS; x ++)
	{
		for(new i; i < MAX_SLOTS; i ++)
		{
		    if(IsPlayerInVehicle(playerid,SavedCar[x][i]))
		    {
				ParkInfo[x][i][Color1] = color1;
				ParkInfo[x][i][Color2] = color2;
			}
		}
	}
	return 1;
}
//============================================================================//
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == BULLET_HIT_TYPE_PLAYER)
	{
		if(GetPlayerVirtualWorld(playerid) == 0)
		{
		    if(GetInt(playerid,"Member") == GetInt(hitid,"Member"))
		    {
		        if(GetInt(playerid,"Member") != 0)
		        {
		        	CInfoBox(playerid,"Nemuzes zabit clena stejneho gangu",3);
				}
			}
/*			for(new i; i < MAX_GANGS; i ++)
			{
			    if(Gang[i][GX] != 0 && Gang[i][GY] != 0 && Gang[i][GZ] != 0)
			    {
			        if(IsPlayerInArea(hitid,Gang[i][GX]-50,Gang[i][GY]-50,Gang[i][GX]+50,Gang[i][GY]+50))
			        {
			            SetPlayerArmedWeapon(playerid,0);
			            SM(playerid,"V gang zónì nemùžeš zabíjet");
			            return 0;
			        }
			    }
			}
*/		}
	}
    return 1;
}
//============================================================================//
public OnPlayerEnterVehicle(playerid,vehicleid,ispassenger)
{
	if(ispassenger == 0)
	{
		for(new i; i < MAX_GANGS; i ++)
		{
		    for(new x; x < MAX_SLOTS; x++)
		    {
			    if(i != GetInt(playerid,"Member"))
			    {
			    	if(vehicleid == SavedCar[i][x])
			    	{
						TogglePlayerControllable(playerid,false);
						TogglePlayerControllable(playerid,true);
						format(str,sizeof(str),"Nejste èlenem gangu {%s}%s",Gang[i][GColor],Gang[i][GName]);
						SM(playerid,str);
			    	}
				}
			}
		}
	}
	return 1;
}
//============================================================================//
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
	if(PRESSED(KEY_WALK))
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
	        for(new i; i < MAX_GANGS; i ++)
	        {
			    if(IsPlayerInRangeOfPoint(playerid,1.5,Gang[i][GX],Gang[i][GY],Gang[i][GZ]))
		    	{
		    	    SetPVarInt(playerid,"GangID",i);
			   		format(dfile,sizeof(dfile),GANG_FILE,i);
			        if(dini_Int(dfile,"Owner") == -1)
			        {
			            format(str,sizeof(str),"Už vlastníš gang: {%s}%s",Gang[GetInt(playerid,"Owner")][GColor],Gang[GetInt(playerid,"Owner")][GName]);
						if(GetInt(playerid,"Owner") > 0) return SM(playerid,str);
			            format(str,sizeof(str),"Si èlenem gangu: {%s}%s "w"nemùžeš si tedy koupit gang",Gang[GetInt(playerid,"Member")][GColor],Gang[GetInt(playerid,"Member")][GName]);
						if(GetInt(playerid,"Member") > 0) return SM(playerid,str);
			        	if(GetPoints(playerid) < GANG_PRICE) return SM(playerid,"Nemáte dostatek bodù");
			        	dini_Set(dfile,"Owner",Jmeno(playerid));
			        	format(str,sizeof(str),"%s Gang",Jmeno(playerid));
			        	dini_Set(dfile,"Name",str);
			        	Gang[i][GName] = str;
			        	format(str,sizeof(str),"-");
			        	Gang[i][GPopis] = str;
			        	dini_Set(dfile,"Popis","-");
			        	dini_IntSet(dfile,"Bank",1000);
			        	Gang[i][GBank] = 1000;
			        	SetInt(playerid,"Owner",i);
			        	SetInt(playerid,"Member",i);
			        	Member[playerid] = i;
						gOwner[playerid] = i;
						UpdateGangText(i);
						for(new c; c < sizeof(Zones); c ++)
						{
						    GangZoneShowForPlayer(playerid,ZoneID[c],GetZoneColor(c));
						}
					    GivePlayerPoints(playerid,-GANG_PRICE);
						format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GName]);
						Text[playerid] = Create3DTextLabel(str,bila,0,0,0,50,-1,true);
						Attach3DTextLabelToPlayer(Text[playerid],playerid,0,0,0.5);
						SM(playerid,"Gang zakoupen");
						format(str,sizeof(str),"Hráè "g"%s "w"si zakoupil gang (%d)",Jmeno(playerid),i);
						printEx(str);
						SetPlayerTeam(playerid,i);
					}
					else if(GetInt(playerid,"Owner") == i)
					{
					    format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GName]);
						if(GetPlayerSpawn(playerid) != SPAWN_TYPE_GANG)
						{
							SPD(playerid,GANG,DIALOG_STYLE_LIST,str,"Seznam èlenù\nPøejmenovat Gang\nZmìnit barvu gangu\nUpravit popis gangu\nNastavit èlenské pravomoce\nNastavit povinný skin Gangu\nPozvat èleny\nNastavit spawn "dc"u gangu\nVložit body\nVybrat body\nGang Garáž\nVyhodit èlena\nZrušit gang","Vybrat","Zavøít");
						}
						else
						{
							SPD(playerid,GANG,DIALOG_STYLE_LIST,str,"Seznam èlenù\nPøejmenovat Gang\nZmìnit barvu gangu\nUpravit popis gangu\nNastavit èlenské pravomoce\nNastavit povinný skin Gangu\nPozvat èleny\nNastavit spawn "dc"u povolání\nVložit body\nVybrat body\nGang Garáž\nVyhodit èlena\nZrušit gang","Vybrat","Zavøít");
						}
					}
					else if(GetInt(playerid,"Member") == i)
					{
						new DIALOG_FUNCTIONS[1000];
						strcat(DIALOG_FUNCTIONS,"Seznam èlenù\nVložit body\n");
						if(GetInt(playerid,"MemberSpawn") == 0)
						{
						    strcat(DIALOG_FUNCTIONS,"Nastavit spawn "dc"u gangu\n");
						}
						else
						{
						    strcat(DIALOG_FUNCTIONS,"Nastavit spawn "dc"u povolání\n");
						}
					    format(dfile,sizeof(dfile),GANG_FILE,i);
						for(new x; x < sizeof(Functions); x ++)
						{
						    new member[50];
						    format(member,sizeof(member),"MemberFunction[%d](%d)",GetInt(playerid,"MemberPos"),x);
						    if(dini_Int(dfile,member) == 1)
						    {
						    	format(str,sizeof(str),"%s\n",Functions[x]);
						    	strcat(DIALOG_FUNCTIONS,str);
							}
						}
						strcat(DIALOG_FUNCTIONS,"Opustit gang\n");
					    format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GName]);
						SPD(playerid,GANG,DIALOG_STYLE_LIST,str,DIALOG_FUNCTIONS,"Vybrat","Zavøít");
					}
					else
					{
					    new DIALOG_G_INFO[2000];
						format(dfile,sizeof(dfile),GANG_FILE,i);
						if(dini_Int(dfile,"Owner") == -1)
						{
					    	format(str,sizeof(str),"{%s}Gang Info:\t                  \t                  \n"w"Boss:\t{%s}Nikdo\n"w"Respect:\t{%s}%d\n"w"Bank:\t"g"%d bodù\n"w"Popis:\t{%s}%s",Gang[i][GColor],Gang[i][GColor],Gang[i][GColor],Gang[i][GRespect],Gang[i][GBank],Gang[i][GColor],Gang[i][GPopis]);
						}
						else
						{
					    	format(str,sizeof(str),"{%s}Gang Info:\t                  \t                  \n"w"Boss:\t{%s}%s\n"w"Respect:\t{%s}%d\n"w"Bank:\t"g"%d bodù\n"w"Popis:\t{%s}%s",Gang[i][GColor],Gang[i][GColor],dini_Get(dfile,"Owner"),Gang[i][GColor],Gang[i][GRespect],Gang[i][GBank],Gang[i][GColor],Gang[i][GPopis]);
						}
					    strcat(DIALOG_G_INFO,str);
					    format(str,sizeof(str),"\n\n{%s}Èlenové:\n",Gang[i][GColor]);
					    strcat(DIALOG_G_INFO,str);
						if(dini_Int(dfile,"Owner") != -1)
						{
							format(str,sizeof(str),""w"%s [ {%s}Boss "w"]\t{%s}%d Bodù\t{%s}%d RS\n",dini_Get(dfile,"Owner"),Gang[i][GColor],Gang[i][GColor],dini_Int(dfile,"OwnerBank"),Gang[i][GColor],dini_Int(dfile,"OwnerRespect"));
						    strcat(DIALOG_G_INFO,str);
						}
						new member[50],member2[50];
						for(new x; x < MAX_MEMBERS; x ++)
						{
						    format(str,sizeof(str),"Member[%d]",x);
						    format(member,sizeof(member),"MemberRespect[%d]",x);
						    format(member2,sizeof(member2),"MemberBank[%d]",x);
						    if(dini_Int(dfile,str) != -1)
						    {
								format(str,sizeof(str),""w"%s\t{%s}%d Bodù\t{%s}%d RS\n",dini_Get(dfile,str),Gang[i][GColor],dini_Int(dfile,member2),Gang[i][GColor],dini_Int(dfile,member));
	              				strcat(DIALOG_G_INFO,str);
						    }
						}
					    format(str,sizeof(str),"\n\n{%s}Vozový park:\n",Gang[i][GColor]);
						strcat(DIALOG_G_INFO,str);
						for(new x; x < MAX_SLOTS; x ++)
						{
						    if(x < Gang[i][GSlots])
						    {
								format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",i,x);
								if(!fexist(dfile))
								{
								    format(str,sizeof(str),"Slot [ {%s}%d "w"]\t{898989}Volný slot\n",Gang[i][GColor],x+1);
								    strcat(DIALOG_G_INFO,str);
								}
								else
								{
								    format(str,sizeof(str),"Slot [ {%s}%d "w"]\t{%s}%s\n",Gang[i][GColor],x+1,Gang[i][GColor],GetVehicleName(dini_Int(dfile,"Model")));
								    strcat(DIALOG_G_INFO,str);
								}
						    }
						}
					    format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GName]);
					    SPD(playerid,0,DIALOG_STYLE_TABLIST,str,DIALOG_G_INFO,"Zavøít","");
					}
				}
			}
		}
	}
	return 1;
}
//============================================================================//
public OnPlayerDisconnect(playerid,reason)
{
	KillTimer(SecondTimer[playerid]);
	Member[playerid] = 0;
	SecondTimer[playerid] = 0;
	SetPlayerTeam(playerid,255);
    ShowedInfoBox[playerid] = false;
	PlayerTextDrawDestroy(playerid,Textdraw0[playerid]);
	if(GetInt(playerid,"Member") > 0)
	{
		Delete3DTextLabel(Text[playerid]);
	}
	DeleteAllVariables(playerid);
    RemovePlayerMapIcon(playerid,99);
	return 1;
}
//============================================================================//
forward OnPlayerUpdateSecond(playerid);

public OnPlayerUpdateSecond(playerid)
{
	if(GetInt(playerid,"Spawned") == 1)
	{
		if(GetPlayerVirtualWorld(playerid) == 0)
		{
			if(GetPlayerGangMember(playerid) > 0)
			{
				for(new i; i < sizeof(Zones); i ++)
				{
					if(IsPlayerInZone(playerid,i))
					{
						if(LastZone[playerid] != GetZoneOwner(i))
						{
						    LastZone[playerid] = GetZoneOwner(i);
							if(GetZoneOwner(i) == GetPlayerGangMember(playerid))
							{
						    	format(str,sizeof(str),"Vstupujete na uzemi ~g~vaseho gangu");
							}
							else if(GetZoneOwner(i) != -1)
							{
						    	format(str,sizeof(str),"Vstupujete na uzemi gangu ~r~%s~w~ pro zabrani uzemi pouzijte prikaz ~g~/zabrat",Gang[GetZoneOwner(i)][GName]);
							}
							else if(GetZoneOwner(i) == -1)
							{
						    	format(str,sizeof(str),"Vstupujete na ~y~volne uzemi~w~ pro zabrani uzemi pouzijte prikaz ~g~/zabrat");
							}
							CInfoBox(playerid,str,5);
						}
					}
				}
			}
		}
	}
	return 1;
}
//============================================================================//
public OnPlayerConnect(playerid)
{
	LastZone[playerid] = -2;
	CreateInfoTD(playerid);
	SecondTimer[playerid] = SetTimerEx("OnPlayerUpdateSecond",1000,true,"i",playerid);

	InfoBox[playerid] = CreatePlayerTextDraw(playerid,140.000000, 338.000000, "");
	PlayerTextDrawBackgroundColor(playerid,InfoBox[playerid], 255);
	PlayerTextDrawFont(playerid,InfoBox[playerid], 1);
	PlayerTextDrawLetterSize(playerid,InfoBox[playerid], 0.339999, 1.699999);
	PlayerTextDrawColor(playerid,InfoBox[playerid], -1);
	PlayerTextDrawSetOutline(playerid,InfoBox[playerid], 0);
	PlayerTextDrawSetProportional(playerid,InfoBox[playerid], 1);
	PlayerTextDrawSetShadow(playerid,InfoBox[playerid], 1);
	PlayerTextDrawUseBox(playerid,InfoBox[playerid], 1);
	PlayerTextDrawBoxColor(playerid,InfoBox[playerid], 0);
	PlayerTextDrawTextSize(playerid,InfoBox[playerid], 403.000000, -19.000000);
	PlayerTextDrawSetSelectable(playerid,InfoBox[playerid], 0);

	TimeBox[playerid] = CreatePlayerTextDraw(playerid,572.000000, 276.000000, "");
	PlayerTextDrawAlignment(playerid,TimeBox[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid,TimeBox[playerid], 255);
	PlayerTextDrawFont(playerid,TimeBox[playerid], 3);
	PlayerTextDrawLetterSize(playerid,TimeBox[playerid], 0.319997, 1.099997);
	PlayerTextDrawColor(playerid,TimeBox[playerid], 7864319);
	PlayerTextDrawSetOutline(playerid,TimeBox[playerid], 1);
	PlayerTextDrawSetProportional(playerid,TimeBox[playerid], 1);
	PlayerTextDrawUseBox(playerid,TimeBox[playerid], 1);
	PlayerTextDrawBoxColor(playerid,TimeBox[playerid], 70);
	PlayerTextDrawTextSize(playerid,TimeBox[playerid], 688.000000, 144.000000);
	PlayerTextDrawSetSelectable(playerid,TimeBox[playerid], 0);

	FightInfo[playerid] = CreatePlayerTextDraw(playerid,572.000000, 290.000000, "~g~Zabiti: ~w~10 ~y~/ ~r~Umrti: ~w~10");
	PlayerTextDrawAlignment(playerid,FightInfo[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid,FightInfo[playerid], 255);
	PlayerTextDrawFont(playerid,FightInfo[playerid], 2);
	PlayerTextDrawLetterSize(playerid,FightInfo[playerid], 0.169997, 0.899996);
	PlayerTextDrawColor(playerid,FightInfo[playerid], -1);
	PlayerTextDrawSetOutline(playerid,FightInfo[playerid], 1);
	PlayerTextDrawSetProportional(playerid,FightInfo[playerid], 1);
	PlayerTextDrawUseBox(playerid,FightInfo[playerid], 1);
	PlayerTextDrawBoxColor(playerid,FightInfo[playerid], 70);
	PlayerTextDrawTextSize(playerid,FightInfo[playerid], 688.000000, 144.000000);
	PlayerTextDrawSetSelectable(playerid,FightInfo[playerid], 0);

	printf("Gang System %s connected",Jmeno(playerid));
	return 1;
}
//============================================================================//
public OnPlayerSpawn(playerid)
{
	new member[50];
	if(GetInt(playerid,"Spawned") == 0)
	{
	    SetInt(playerid,"Spawned",1);
	    SetPlayerTeam(playerid,255);
		for(new i; i < MAX_GANGS; i ++)
		{
			format(dfile,sizeof(dfile),GANG_FILE,i);
			if(fexist(dfile))
			{
				if(strcmp(dini_Get(dfile,"Owner"),Jmeno(playerid),false) == 0)
				{
					SetInt(playerid,"Member",i);
					Member[playerid] = i;
					SetInt(playerid,"Owner",i);
					gOwner[playerid] = i;
					SetInt(playerid,"MemberSpawn",dini_Int(dfile,"OwnerSpawn"));
					if(strlen(Gang[i][GSName]) == 0)
					{
						format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GName]);
					}
					else
					{
						format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GSName]);
					}
					Text[playerid] = Create3DTextLabel(str,bila,0,0,0,50,-1,true);
					Attach3DTextLabelToPlayer(Text[playerid],playerid,0,0,0.5);
					SetPlayerTeam(playerid,i);
					format(str,sizeof(str),"Vítejte šéfe gangu {%s}%s",Gang[i][GColor],Gang[i][GName],i);
					SM(playerid,str);
					new query[500],rows,fields,Cache:cache;
					mysql_format(mysql,query,sizeof(query),"SELECT * FROM `Gangs` WHERE `GangID` = '%d'",i);
					cache = mysql_query(mysql,query);
					cache_get_data(rows,fields,mysql);
					if(rows)
					{
						mysql_format(mysql,query,sizeof(query),"UPDATE `Gangs` SET `OwnerLastActivity`='%d' WHERE `GangID` = '%d'",gettime(),i);
						mysql_query(mysql,query,false);
					}
					cache_delete(cache,mysql);
					for(new c; c < sizeof(Zones); c ++)
					{
					    GangZoneShowForPlayer(playerid,ZoneID[c],GetZoneColor(c));
					}
					break;
				}
				for(new x; x < MAX_MEMBERS; x ++)
				{
					format(member,sizeof(member),"Member[%d]",x);
					if(strcmp(dini_Get(dfile,member),Jmeno(playerid),false) == 0)
					{
					    format(member,sizeof(member),"MemberSpawn[%d]",x);
						SetInt(playerid,"Member",i);
						Member[playerid] = i;
						SetInt(playerid,"MemberSpawn",dini_Int(dfile,member));
						SetInt(playerid,"MemberPos",x);
						if(strlen(Gang[i][GSName]) == 0)
						{
							format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GName]);
						}
						else
						{
							format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GSName]);
						}
						Text[playerid] = Create3DTextLabel(str,bila,0,0,0,50,-1,true);
						Attach3DTextLabelToPlayer(Text[playerid],playerid,0,0,0.5);
						SetPlayerTeam(playerid,i);
					    format(str,sizeof(str),"Vítejte èlene gangu {%s}%s",Gang[i][GColor],Gang[i][GName],i);
						SM(playerid,str);
						for(new c; c < sizeof(Zones); c ++)
						{
						    GangZoneShowForPlayer(playerid,ZoneID[c],GetZoneColor(c));
						}
						break;
					}
				}
			}
		}
	}
	return 1;
}

forward Spawn(playerid);
public Spawn(playerid)
{
	if(GetInt(playerid,"Member") > 0)
	{
		if(!IsPlayerInDM(playerid) && !IsPlayerOnEvent(playerid))
		{
			SetPlayerTeam(playerid,GetInt(playerid,"Member"));
		    format(dfile,sizeof(dfile),GANG_FILE,GetInt(playerid,"Member"));
		    format(str,sizeof(str),"0x%sFF",dini_Get(dfile,"Color"));
		    SetPlayerColor(playerid,HexToInt(str));
		}
	    if(Gang[GetInt(playerid,"Member")][GSkin] > -1)
		{
		    SetPlayerSkinEx(playerid,Gang[GetInt(playerid,"Member")][GSkin]);
		    TogglePlayerControllable(playerid,true);
		}
	}
	return 1;
}
//============================================================================//
CMD:getzoneid(playerid,params[])
{
	format(str,sizeof(str),"ZoneID: %d",GetPlayerZone(playerid));
	SM(playerid,str);
	return 1;
}
//============================================================================//
CMD:zabrat(playerid)
{
	new zone = GetPlayerZone(playerid),gang = GetPlayerGangMember(playerid),zoneowner,bool:canfight;
	if(GetPlayerGangMember(playerid) == -1) return SM(playerid,"Nejsi èlenem žádného gangu");
	if(IsPlayerWorking(playerid)) return SM(playerid,"Nesmíte plnit žádnou misi");
	if(GetPlayerVirtualWorld(playerid) != 0) return SM(playerid,"Nesmíte být ve virtual worldu");
	if(zone == -1) return SM(playerid,"Nejsi v žádné gang zónì");
	zoneowner = GetZoneOwner(zone);
	if(zoneowner == gang) return SM(playerid,"Nemùžete napadnou vaše území");
	if(Gang[gang][GFight] != -1) return SM(playerid,"Váš gang už má nìco na práci");
	if(zoneowner != -1)
	{
		for(new i; i <= GetPlayerPoolSize(); i ++)
		{
		    if(IPC(i) && !IsPlayerNPC(i))
		    {
		        if(GetPlayerGangMember(i) == zoneowner)
		        {
					canfight = true;
		        }
		    }
		}
		if(canfight == false) return SM(playerid,"Aby si mohl zaútoèit na toto území, musí být online alespoò jeden èlen tohoto gangu");
		if(Gang[zoneowner][GFight] != -1) return SM(playerid,"Tento gang právì bojuje o jiné území");
	}
	if(ZoneAttackTime[zone] > 0) return SM(playerid,"Toto území už zabírá jiný gang");
	if(GetGangPlayersInZone(zone,gang) < TAKEOVER_PLAYERS) return SM(playerid,"Na zabrání území potøebujete minimálnì 3 èleny vašeho gangu");
	Gang[gang][GFight] = zone;
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	ZoneAttacker[zone] = gang;
	if(zoneowner != -1)
	{
		ZoneVictim[zone] = zoneowner;
		Gang[zoneowner][GFight] = zone;
		format(str,sizeof(str),"Gang ~r~%s ~w~napadl vase uzemi, uzemi bylo vyznaceno na mape",Gang[gang][GName]);
		for(new i; i <= GetPlayerPoolSize(); i ++)
		{
		    if(GetPlayerGangMember(i) == zoneowner)
		    {
				CreateInfoBox(i,str,10);
				SetPlayerMapIcon(i,99,X,Y,Z,19,bila,MAPICON_GLOBAL);
			}
		}
	}
	if(zoneowner != -1)
	{
		format(str,sizeof(str),"Vas gang vyvolal valku o uzemi gangu ~g~%s~w~, uzemi bylo vyznaceno na mape",Gang[zoneowner][GName]);
		ZoneAttackTime[zone] = TAKEOVER_TIME;
	}
	else
	{
		format(str,sizeof(str),"Vas gang zabira ~y~volne uzemi~w~, uzemi bylo vyznaceno na mape");
		ZoneAttackTime[zone] = TAKEOVER_TIME_NONE;
	}
	for(new i; i <= GetPlayerPoolSize(); i ++)
	{
	    if(GetPlayerGangMember(i) == gang)
	    {
			CreateInfoBox(i,str,10);
			SetPlayerMapIcon(i,99,X,Y,Z,62,bila,MAPICON_GLOBAL);
	    }
	}
    GangZoneFlashForAll(ZoneID[zone],GetGangColor(gang));
	SetTimerEx("GangFight",1000,false,"iii",zone,gang,zoneowner);
	return 1;
}

forward GangFight(zoneid,attacker,victim);

public GangFight(zoneid,attacker,victim)
{
	ZoneAttackTime[zoneid]--;
	if(ZoneAttackTime[zoneid] > 0)
	{
		SetTimerEx("GangFight",1000,false,"iii",zoneid,attacker,victim);
		for(new i; i <= GetPlayerPoolSize(); i ++)
		{
		    if(IPC(i) && !IsPlayerNPC(i))
		    {
	            if(GetPlayerGangMember(i) == attacker || GetPlayerGangMember(i) == victim)
	            {
					if(GetPlayerGangMember(i) != -1)
					{
			            new ingwstate = GetPVarInt(i,"InWarState");
				        if(IsPlayerInZone(i,zoneid))
				        {
				            format(str,sizeof(str),"%s - Gang War",Gang[GetInt(i,"Member")][GName]);
				            UpdateGangTitle(i,str);
							if(IsPlayerInAnyVehicle(i))
							{
							    new Float:X,Float:Y,Float:Z;
							    GetPlayerPos(i,X,Y,Z);
							    SetPlayerPos(i,X,Y,Z+1);
							    SM(i,"V gang válce se nedají používat vozidla");
							}
							if(ingwstate == 0)
							{
							    SetPVarInt(i,"InWarState",1);
							    SetPlayerVirtualWorld(i,zoneid+500);
							}
						    format(str,sizeof(str),"%02d:%02d",ZoneAttackTime[zoneid]/60,ZoneAttackTime[zoneid]%60);
							PlayerTextDrawSetString(i,TimeBox[i],str);
			                PlayerTextDrawShow(i,TimeBox[i]);
							if(victim != -1)
							{
								if(GetPlayerGangMember(i) == attacker)
								{
				                	format(str,sizeof(str),"~g~Zabiti: ~w~%d ~y~/ ~r~Umrti: ~w~%d",Gang[attacker][GFightKills],Gang[victim][GFightKills]);
				                	PlayerTextDrawSetString(i,FightInfo[i],str);
								}
								else if(GetPlayerGangMember(i) == victim)
								{
				                	format(str,sizeof(str),"~g~Zabiti: ~w~%d ~y~/ ~r~Umrti: ~w~%d",Gang[victim][GFightKills],Gang[attacker][GFightKills]);
				                	PlayerTextDrawSetString(i,FightInfo[i],str);
								}
								PlayerTextDrawShow(i,FightInfo[i]);
							}
						}
                    	else
                    	{
                    	    if(ingwstate == 1)
                    	    {
    						    SetPVarInt(i,"InWarState",0);
							    SetPlayerVirtualWorld(i,0);
                    	    }
                    	    PlayerTextDrawHide(i,TimeBox[i]);
                    	    PlayerTextDrawHide(i,FightInfo[i]);
				            UpdateGangTitle(i);
                    	}
					}
	            }
		    }
		}
	}
	else
	{
		new rand;
		ZoneAttacker[zoneid] = 0;
		ZoneVictim[zoneid] = 0;
		if(victim != -1)
		{
		    rand = 15+random(5);
		}
		else
		{
		    rand = 5;
		}
	    GangZoneStopFlashForAll(ZoneID[zoneid]);
		Gang[attacker][GFight] = -1;
		if(victim != -1)
		{
			Gang[victim][GFight] = -1;
		}
		new attackers = GetGangPlayersInZone(zoneid,attacker);
		if(victim == -1)
		{
			if(attackers > 0)
			{
	   			GiveGangRS(attacker,rand);
			    ChangeZoneOwner(zoneid,attacker);
				format(str,sizeof(str),"Vas gang zabral ~y~volne uzemi ~w~( ~y~5 RS ~w~)");
			}
			else
			{
		    	format(str,sizeof(str),"Vasemu gangu se ~r~nepodarilo ~w~zabrat ~y~volne uzemi~w~ ( ~y~-5 RS ~w~)");
			}
			for(new i; i <= GetPlayerPoolSize(); i ++)
			{
			    if(GetPlayerGangMember(i) == attacker)
			    {
					PlayerTextDrawHide(i,TimeBox[i]);
					PlayerTextDrawHide(i,FightInfo[i]);
					new ingwstate = GetPVarInt(i,"InWarState");
            	    if(ingwstate == 1)
            	    {
					    SetPVarInt(i,"InWarState",0);
					    SetPlayerVirtualWorld(i,0);
            	    }
			        CreateInfoBox(i,str,5);
                    RemovePlayerMapIcon(i,99);
		            UpdateGangTitle(i);
			    }
			}
			return 0;
		}
		if(Gang[victim][GFightKills] <= Gang[attacker][GFightKills] && attackers > 0)
		{
   			GiveGangRS(attacker,rand);
			if(victim != -1)
			{
				GiveGangRS(victim,-rand);
			}
			if(victim != -1)
			{
				format(str,sizeof(str),"Vas gang vyhral valku o uzemi gangu ~g~%s~w~ ( ~y~%d RS ~w~)",Gang[victim][GName],rand);
			}
			else
			{
				format(str,sizeof(str),"Vas gang zabral ~y~volne uzemi ~w~( ~y~5 RS ~w~)");
			}
			for(new i; i <= GetPlayerPoolSize(); i ++)
			{
			    if(GetPlayerGangMember(i) == attacker && IPC(i))
			    {
					PlayerTextDrawHide(i,TimeBox[i]);
					PlayerTextDrawHide(i,FightInfo[i]);
					new ingwstate = GetPVarInt(i,"InWarState");
            	    if(ingwstate == 1)
            	    {
					    SetPVarInt(i,"InWarState",0);
					    SetPlayerVirtualWorld(i,0);
            	    }
            	    GivePlayerDailyValueEx(i,DAILY_TYPE_GANG_TAKE);
			        CreateInfoBox(i,str,5);
                    RemovePlayerMapIcon(i,99);
		            UpdateGangTitle(i);
			    }
			}
			if(victim != -1)
			{
				format(str,sizeof(str),"Vas gang ~r~prohral ~w~valku o vase uzemi s gangem ~r~%s ~w~( ~y~-%d RS~w~ )",Gang[victim][GName],rand);
				for(new i; i <= GetPlayerPoolSize(); i ++)
				{
				    if(GetPlayerGangMember(i) == victim)
				    {
				        CreateInfoBox(i,str,10);
						PlayerTextDrawHide(i,TimeBox[i]);
						PlayerTextDrawHide(i,FightInfo[i]);
						new ingwstate = GetPVarInt(i,"InWarState");
	            	    if(ingwstate == 1)
	            	    {
						    SetPVarInt(i,"InWarState",0);
						    SetPlayerVirtualWorld(i,0);
	            	    }
	                    RemovePlayerMapIcon(i,99);
			            UpdateGangTitle(i);
				    }
				}
			}
		    ChangeZoneOwner(zoneid,attacker);
		}
		else// if(Gang[victim][GFightKills] > Gang[attacker][GFightKills] && victims > 0)
		{
	    	GiveGangRS(attacker,-rand);
			if(victim != -1)
		    {
				GiveGangRS(victim,rand);
				format(str,sizeof(str),"Vas gang ~g~vyhral ~w~valku nad gangem ~r~%s ~w~o vase uzemi (~y~ %d RS ~w~)",Gang[attacker][GName],rand);
				for(new i; i <= GetPlayerPoolSize(); i ++)
				{
				    if(GetPlayerGangMember(i) == victim)
				    {
						new ingwstate = GetPVarInt(i,"InWarState");
						PlayerTextDrawHide(i,TimeBox[i]);
						PlayerTextDrawHide(i,FightInfo[i]);
	            	    if(ingwstate == 1)
	            	    {
						    SetPVarInt(i,"InWarState",0);
						    SetPlayerVirtualWorld(i,0);
	            	    }
						CreateInfoBox(i,str,10);
                        RemovePlayerMapIcon(i,99);
			            UpdateGangTitle(i);
				    }
				}
		    }
		    if(victim != -1)
		    {
		    	format(str,sizeof(str),"Vas gang ~r~prohral ~w~valku o uzemi gangu ~r~%s~w~ (~y~ -%d RS ~w~)",Gang[victim][GName],rand);
			}
			else
			{
		    	format(str,sizeof(str),"Vasemu gangu se ~r~nepodarilo ~w~zabrat ~y~volne uzemi~w~ ( ~y~-5 RS ~w~)");
			}
			for(new i; i <= GetPlayerPoolSize(); i ++)
			{
			    if(GetPlayerGangMember(i) == attacker)
			    {
					PlayerTextDrawHide(i,TimeBox[i]);
					PlayerTextDrawHide(i,FightInfo[i]);
 					new ingwstate = GetPVarInt(i,"InWarState");
	           	    if(ingwstate == 1)
            	    {
					    SetPVarInt(i,"InWarState",0);
					    SetPlayerVirtualWorld(i,0);
            	    }
			        CreateInfoBox(i,str,5);
                    RemovePlayerMapIcon(i,99);
		            UpdateGangTitle(i);
			    }
			}
		}
		if(victim != -1)
		{
		    Gang[victim][GFightKills] = 0;
		}
		Gang[attacker][GFightKills] = 0;
	}
	return 1;
}
//============================================================================//
CMD:movegang(playerid,params[])
{
	if(!IPA(playerid)) return SM(playerid,"Nejste pøihlášený pøes RCON");
	new gid = strval(params);
	if(!strlen(params)) return SM(playerid,"Použití: "r"/movegang [ ID Gangu ]");
	if(gid < 1 || gid > MAX_GANGS) return SM(playerid,"Chybnì zadané ID");
	new id = GetGangRealID(gid);
	if(id == -1) return SM(playerid,"Tento gang není vytvoøený");
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	Gang[id][GX] = X;
	Gang[id][GY] = Y;
	Gang[id][GZ] = Z;
	format(dfile,sizeof(dfile),GANG_FILE,id);
	dini_FloatSet(dfile,"X",X);
	dini_FloatSet(dfile,"Y",Y);
	dini_FloatSet(dfile,"Z",Z);
	DOF2_SaveFile();
	DestroyDynamicPickup(Gang[id][GPickup]);
	DestroyDynamicMapIcon(Gang[id][GMapIcon]);
	DestroyDynamic3DTextLabel(Gang[id][GText]);
	Gang[id][GPickup] = CreateDynamicPickup(1314,23,X,Y,Z,0,0);
	Gang[id][GMapIcon] = CreateDynamicMapIcon(X,Y,Z,23,0,0,0,-1);
	Gang[id][GText] = CreateDynamic3DTextLabel(str,bila,X,Y,Z,50,0,true);
	UpdateGangText(id);
	format(str,sizeof(str),"Gang {%s}%s úspìšnì pøemístìn",Gang[id][GColor],Gang[id][GName]);
	SM(playerid,str);
	return 1;
}
//============================================================================//
CMD:setgspecialname(playerid,params[])
{
	if(!IPA(playerid)) return SM(playerid,"Nejste pøihlášený pøes RCON");
	new gid = strval(params);
	if(!strlen(params)) return SM(playerid,"Použití: "r"/setspecialname [ ID Gangu ]");
	if(gid < 1 || gid > MAX_GANGS) return SM(playerid,"Chybnì zadané ID");
	new id = GetGangRealID(gid);
	if(id == -1) return SM(playerid,"Tento gang není vytvoøený");
	SetPVarInt(playerid,"LastID",id);
	SPD(playerid,GANG+21,DIALOG_STYLE_INPUT,Gang[id][GName],"Zadejte specialní název gangu","Nastavit","Zavøít");
	return 1;
}
//============================================================================//
CMD:gotog(playerid,params[])
{
	SCMTOAA("rgang")
	if(!IPA(playerid)) return SM(playerid,"Nejste pøihlášený pøes RCON");
	new gid = strval(params);
	if(!strlen(params)) return SM(playerid,"Použití: "r"/gotog [ ID Gangu ]");
	if(gid < 1 || gid > MAX_GANGS) return SM(playerid,"Chybnì zadané ID");
	new id = GetGangRealID(gid);
	if(id == -1) return SM(playerid,"Tento gang není vytvoøený");
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		SetVehiclePos(GetPlayerVehicleID(playerid),Gang[id][GX],Gang[id][GY],Gang[id][GZ]);
		SetPlayerInterior(GetPlayerVehicleID(playerid),0);
		SetPlayerInterior(playerid,0);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid),0);
	}
	else
	{
		SetPlayerPos(playerid,Gang[id][GX],Gang[id][GY],Gang[id][GZ]);
		SetPlayerInterior(playerid,0);
	}
	format(str,sizeof(str),"Portnul si se k gangu {%s}%s",Gang[id][GColor],Gang[id][GName]);
	SM(playerid,str);
	return 1;
}
//============================================================================//
CMD:rgang(playerid,params[])
{
	SCMTOAA("rgang")
	if(!IPA(playerid)) return SM(playerid,"Nejste pøihlášený pøes RCON");
	new gid;
	if(sscanf(params,"i",gid)) return SM(playerid,"Použití: "r"/rgang [ Gang ID ]");
	if(gid < 1 || gid > MAX_GANGS) return SM(playerid,"Chybnì zadané ID");
	new rows,fields,Cache:cache;
	cache = mysql_query(mysql,"SELECT * FROM  `Gangs` ORDER BY `Respect` DESC, `Bank` DESC");
	cache_get_data(rows,fields,mysql);
	gid = cache_get_field_content_int(gid-1,"GangID",mysql);
	cache_delete(cache,mysql);
	format(dfile,sizeof(dfile),"GangSystem/Gang[%d].ini",gid);
	if(!fexist(dfile)) return SM(playerid,"Tento gang není vytvoøený");
	format(str,sizeof(str),"Gang {%s}%s "w"úspìšnì resetován",Gang[gid][GColor],Gang[gid][GName]);
	SM(playerid,str);
	format(dfile,sizeof(dfile),GANG_FILE,gid);
	for(new i; i <= GetPlayerPoolSize(); i ++)
	{
	    if(GetInt(i,"Member") == gid)
	    {
	        SetInt(i,"Owner",0);
	        SetInt(i,"Member",0);
	        Member[i] = 0;
	        gOwner[i] = 0;
	        SetInt(i,"MemberPos",0);
	        SetInt(i,"MemberSpawn",0);
			Delete3DTextLabel(Text[i]);
	        SetPlayerTeam(i,255);
			SM(i,str);
	    }
	}
	for(new c; c < sizeof(Zones); c ++)
	{
	    GangZoneHideForPlayer(playerid,ZoneID[c]);
	}
	for(new x; x < sizeof(Zones); x ++)
	{
	    if(Zones[x][ZoneGang] == gid)
	    {
	        ChangeZoneOwner(x,-1);
	    }
	}
	dini_Set(dfile,"Name","Volný Gang");
	format(str,sizeof(str),"Volný Gang");
	Gang[gid][GName] = str;
	format(str,sizeof(str),"");
	Gang[gid][GSName] = str;
	Gang[gid][GRespect] = 0;
	format(str,sizeof(str),"0000FF");
	Gang[gid][GColor] = str;
	Gang[gid][GBank] = 0;
	format(str,sizeof(str),"-");
	dini_Set(dfile,"Popis","-");
	Gang[gid][GPopis] = str;
	Gang[gid][GSkin] = -1;
	dini_Set(dfile,"Color","0000FF");
	dini_IntSet(dfile,"Bank",0);
	dini_IntSet(dfile,"Skin",-1);
	dini_IntSet(dfile,"Respect",0);
	dini_IntSet(dfile,"Owner",-1);
	dini_IntSet(dfile,"OwnerSpawn",0);
	dini_IntSet(dfile,"OwnerBank",0);
	dini_IntSet(dfile,"OwnerRespect",0);
	dini_Set(dfile,"SpecialName","");
	new member[50];
	for(new i; i < MAX_MEMBERS; i ++)
	{
		format(member,sizeof(member),"Member[%d]",i);
		format(dfile,sizeof(dfile),"UnNamed/%s.save",dini_Get(dfile,member));
		if(dini_Int(dfile,"Member") != -1)
		{
			dini_Set(dfile,"Titul","VIP");
			dini_Set(dfile,"BarvaTitulu","FFFFFF");
		}
		format(dfile,sizeof(dfile),GANG_FILE,gid);
		dini_IntSet(dfile,member,-1);
		format(member,sizeof(member),"MemberSpawn[%d]",i);
		dini_IntSet(dfile,member,0);
		format(member,sizeof(member),"MemberRespect[%d]",i);
		dini_IntSet(dfile,member,0);
		format(member,sizeof(member),"MemberBank[%d]",i);
		dini_IntSet(dfile,member,0);
		for(new x; x < sizeof(Functions); x ++)
		{
			format(member,sizeof(member),"MemberFunction[%d](%d)",i,x);
			dini_IntSet(dfile,member,0);
		}
	}
    format(str,sizeof(str),"Název: "b"Volný Gang\n"w"Boss: "r"Nikdo\n"w"Cena: "g"%d bodù",GANG_PRICE);
    UpdateDynamic3DTextLabelText(Gang[gid][GText],bila,str);
	return 1;
}
//============================================================================//
CMD:members(playerid,params[])
{
	new players = 0;
//	strcat(DIALOG,"Nick\tGang\tHodnost\n");
	for(new i; i <= GetPlayerPoolSize(); i ++)
	{
		if(IPC(i) && !IsPlayerNPC(i))
		{
		    new gid = Member[i];
//		    printf("gid = %d",gid);
		    if(gid > 0)
		    {
		        players++;
//				if(!strlen(Gang[gid][GSName]))
//					format(str,sizeof(str),""w"%s (%d)\t{%s}%s\t"w"%s\n",Jmeno(i),i,Gang[gid][GColor],Gang[gid][GName],GangHodnost(i));
//				else
//				format(str,sizeof(str),""w"%s (%d)\t{%s}%s\t"w"%s\n",Jmeno(i),i,Gang[gid][GColor],Gang[gid][GName],GangHodnost(i));
				format(str,sizeof(str),""dc"%s (%d): {%s}%s "w"(%s)",Jmeno(i),i,Gang[gid][GColor],Gang[gid][GName],GangHodnost(i));
				SCM(playerid,-1,str);
//				printf("Gang Members: %s",str);
//				strcat(DIALOG,str)
//				printf("strcat");
			}
		}
	}
	if(players == 0) return SM(playerid,"Žádný èlen gangu není online");
//	SPD(playerid,0,DIALOG_STYLE_TABLIST_HEADERS,"Seznam On-Line èlenù gangù",DIALOG,"Zavøít","");
	return 1;
}
//============================================================================//
CMD:gangy(playerid,params[])
{
	SCMTOAA("gangy")
	new DIALOG_GANGS[5000];
	new rows,fields,Cache:cache;
	cache = mysql_query(mysql,"SELECT * FROM  `Gangs` ORDER BY `Respect` DESC, `Bank` DESC");
	cache_get_data(rows,fields,mysql);
	strcat(DIALOG_GANGS,"Název\tRespect\tBank\n");
	for(new x; x < rows; x ++)
	{
		new i = cache_get_field_content_int(x,"GangID",mysql);
		format(dfile,sizeof(dfile),GANG_FILE,i);
		if(fexist(dfile))
		{
			if(strlen(Gang[i][GSName]) == 0)
			{
				format(str,sizeof(str),""w"%d. {%s}%s\t"w"%d RS\t{%s}%d bodù\n",x+1,Gang[i][GColor],Gang[i][GName],Gang[i][GRespect],Gang[i][GColor],Gang[i][GBank]);
			}
			else
			{
				format(str,sizeof(str),""w"%d. {%s}%s\t"w"%d RS\t{%s}%d bodù\n",x+1,Gang[i][GColor],Gang[i][GSName],Gang[i][GRespect],Gang[i][GColor],Gang[i][GBank]);
			}
			strcat(DIALOG_GANGS,str);
		}
	}
	SPD(playerid,GANG+13,DIALOG_STYLE_TABLIST_HEADERS,"Gangy",DIALOG_GANGS,"Vybrat","Zavøít");
	cache_delete(cache,mysql);
	return 1;
}
//============================================================================//
CMD:gangloc(playerid,params[])
{
	new id;
	if(sscanf(params,"i",id)) return SM(playerid,"Použití: "r"/gangloc [ Gang ID ]");
	if(id < 1 || id > MAX_GANGS) return SM(playerid,"Chybnì zadané ID");
	new rows,fields,Cache:cache;
	cache = mysql_query(mysql,"SELECT * FROM  `Gangs` ORDER BY `Respect` DESC, `Bank` DESC");
	cache_get_data(rows,fields,mysql);
	id = cache_get_field_content_int(id-1,"GangID",mysql);
	cache_delete(cache,mysql);
	format(dfile,sizeof(dfile),"GangSystem/Gang[%d].ini",id);
	if(!fexist(dfile)) return SM(playerid,"Tento gang není vytvoøený");
	SetPlayerNavigation(playerid,Gang[id][GX],Gang[id][GY],Gang[id][GZ]);
	format(str,sizeof(str),"Gang ~r~%s ~w~uspesne oznacen na mape",Gang[id][GName]);
	CInfoBox(playerid,str,5);
	return 1;
}
//============================================================================//
CMD:gangview(playerid,params[])
{
	new id;
	if(sscanf(params,"i",id)) return SM(playerid,"Použití: "r"/gangview [ Gang ID ]");
	if(id < 1 || id > MAX_GANGS) return SM(playerid,"Chybnì zadané ID");
	new rows,fields,Cache:cache;
	cache = mysql_query(mysql,"SELECT * FROM  `Gangs` ORDER BY `Respect` DESC, `Bank` DESC");
	cache_get_data(rows,fields,mysql);
	id = cache_get_field_content_int(id-1,"GangID",mysql);
	cache_delete(cache,mysql);
	format(dfile,sizeof(dfile),"GangSystem/Gang[%d].ini",id);
	if(!fexist(dfile)) return SM(playerid,"Tento gang není vytvoøený");
    SetPlayerCameraAtPos(playerid,Gang[id][GX],Gang[id][GY],Gang[id][GZ]);
	return 1;
}
//============================================================================//
CMD:editgslot(playerid,params[])
{
	SCMTOAA("editgslot")
	if(!IPA(playerid)) return SM(playerid,"Nejste pøihlášený pøes RCON");
	new id,slotid;
	if(sscanf(params,"ii",id,slotid)) return SM(playerid,"Použití: "r"/editgslot [ Gang ID ] [ Slot ID ]");
	if(id < 1 || id > MAX_GANGS) return SM(playerid,"Chybnì zadané ID");
	new rows,fields,Cache:cache;
	cache = mysql_query(mysql,"SELECT * FROM  `Gangs` ORDER BY `Respect` DESC, `Bank` DESC");
	cache_get_data(rows,fields,mysql);
	id = cache_get_field_content_int(id-1,"GangID",mysql);
	cache_delete(cache,mysql);
	format(dfile,sizeof(dfile),"GangSystem/Gang[%d].ini",id);
	if(!fexist(dfile)) return SM(playerid,"Tento gang není vytvoøený");
	new Float:X,Float:Y,Float:Z,Float:Angle;
	if(!IsPlayerInAnyVehicle(playerid))
	{
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
	}
	else
	{
	    GetVehiclePos(GetPlayerVehicleID(playerid),X,Y,Z);
	    GetVehicleZAngle(GetPlayerVehicleID(playerid),Angle);
	}
	format(dfile,sizeof(dfile),GANG_FILE,id);
	if(fexist(dfile))
	{
		format(str,sizeof(str),"SlotX[%d]",slotid);
	    if(dini_Int(dfile,str) == 0) return SM(playerid,"Tento slot neexistuje");
		dini_FloatSet(dfile,str,X);
		format(str,sizeof(str),"SlotY[%d]",slotid);
		dini_FloatSet(dfile,str,Y);
		format(str,sizeof(str),"SlotZ[%d]",slotid);
		dini_FloatSet(dfile,str,Z);
		format(str,sizeof(str),"SlotA[%d]",slotid);
		dini_FloatSet(dfile,str,Angle);
		format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",id,slotid-1);
		if(fexist(dfile))
		{
			dini_FloatSet(dfile,"X",X);
			dini_FloatSet(dfile,"Y",Y);
			dini_FloatSet(dfile,"Z",Z);
			dini_FloatSet(dfile,"A",Angle);
			LoadGarageData(id);
			SpawnCar(id,slotid-1);
		}
		format(str,sizeof(str),"Vehicle Slot "g"%d "w"gangu {%s}%s "w"upraven",slotid,Gang[id][GColor],Gang[id][GName]);
		SM(playerid,str);
	}
	else
	{
		SM(playerid,"Tento gang neexistuje");
	}
	return 1;
}
//============================================================================//
CMD:addgslot(playerid,params[])
{
	SCMTOAA("addgslot")
	if(!IPA(playerid)) return SM(playerid,"Nejste pøihlášený pøes RCON");
	new id;
	if(sscanf(params,"i",id)) return SM(playerid,"Použití: "r"/addgslot [ Gang ID ]");
	if(id < 1 || id > MAX_GANGS) return SM(playerid,"Chybnì zadané ID");
	new rows,fields,Cache:cache;
	cache = mysql_query(mysql,"SELECT * FROM  `Gangs` ORDER BY `Respect` DESC, `Bank` DESC");
	cache_get_data(rows,fields,mysql);
	id = cache_get_field_content_int(id-1,"GangID",mysql);
	cache_delete(cache,mysql);
	format(dfile,sizeof(dfile),"GangSystem/Gang[%d].ini",id);
	if(!fexist(dfile)) return SM(playerid,"Tento gang není vytvoøený");
	new Float:X,Float:Y,Float:Z,Float:Angle;
	if(!IsPlayerInAnyVehicle(playerid))
	{
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
	}
	else
	{
	    GetVehiclePos(GetPlayerVehicleID(playerid),X,Y,Z);
	    GetVehicleZAngle(GetPlayerVehicleID(playerid),Angle);
	}
	format(dfile,sizeof(dfile),GANG_FILE,id);
	if(fexist(dfile))
	{
	    Gang[id][GSlots] ++;
	    dini_IntSet(dfile,"Slots",Gang[id][GSlots]);
		format(str,sizeof(str),"SlotX[%d]",Gang[id][GSlots]);
		dini_FloatSet(dfile,str,X);
		format(str,sizeof(str),"SlotY[%d]",Gang[id][GSlots]);
		dini_FloatSet(dfile,str,Y);
		format(str,sizeof(str),"SlotZ[%d]",Gang[id][GSlots]);
		dini_FloatSet(dfile,str,Z);
		format(str,sizeof(str),"SlotA[%d]",Gang[id][GSlots]);
		dini_FloatSet(dfile,str,Angle);
		format(str,sizeof(str),"Pøidal si gangu {%s}%s "w"Vehicle Slot "g"%d",Gang[id][GColor],Gang[id][GName],Gang[id][GSlots]);
		SM(playerid,str);
	}
	else
	{
		SM(playerid,"Tento gang neexistuje");
	}
	return 1;
}
//============================================================================//
CMD:cgang(playerid,params[])
{
	SCMTOAA("cgang")
	if(!IPA(playerid)) return SM(playerid,"Nejste pøihlášený pøes RCON");
	if(gangid >= MAX_GANGS) return SM(playerid,"Byl pøekroèen limit gangù");
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	CreateGang(X,Y,Z);
	format(str,sizeof(str),"Gang [ID: "r"%d "w"] vytvoøen.",gangid);
	SM(playerid,str);
	return 1;
}
//============================================================================//
public OnPlayerPickUpDynamicPickup(playerid,pickupid)
{
	for(new i; i < MAX_GANGS; i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid,1.5,Gang[i][GX],Gang[i][GY],Gang[i][GZ]))
	    {
			if(!IsPlayerInAnyVehicle(playerid))
			{
		   		format(dfile,sizeof(dfile),GANG_FILE,i);
		        if(dini_Int(dfile,"Owner") == -1)
		        {
		        	CInfoBox(playerid,"Pro zakoupeni gangu stistknete ~r~~k~~SNEAK_ABOUT~",3);
				}
				else if(GetInt(playerid,"Owner") == i)
				{
		        	CInfoBox(playerid,"Pro spravu gangu stisknete ~r~~k~~SNEAK_ABOUT~",3);
				}
				else if(GetInt(playerid,"Member") == i)
				{
		        	CInfoBox(playerid,"Pro spravu gangu stisknete ~r~~k~~SNEAK_ABOUT~",3);
				}
				else
				{
		        	CInfoBox(playerid,"Pro info gangu stisknete ~r~~k~~SNEAK_ABOUT~",3);
				}
			}
		}
	}
	return 1;
}
//============================================================================//
public OnPlayerDeath(playerid,killerid,reason)
{
	if(reason > 255) reason = 255;
	if(GetPlayerKillerID(playerid) != -1 && IPC(GetPlayerKillerID(playerid)))
  	  killerid = GetPlayerKillerID(playerid);
	if(killerid != INVALID_PLAYER_ID)
	{
	    new gang = GetPlayerGangMember(playerid);
	    if(gang != -1)
	    {
	        if(!IsPlayerInDM(playerid) && !IsPlayerOnEvent(playerid) && !IsPlayerInDuel(playerid))
	        {
			    if(Gang[gang][GFight] != -1)
			    {
					new zone = Gang[gang][GFight],attacker = ZoneAttacker[zone],victim = ZoneVictim[zone];
					if(IsPlayerInZone(killerid,zone) && IsPlayerInZone(playerid,zone))
					{
						if(GetPlayerGangMember(killerid) == attacker || GetPlayerGangMember(killerid) == victim)
						{
							if(reason == 35 || reason == 36 || reason == 51) return SM(killerid,"Použil si RPG nebo Granát, nebyl zapoèítaný respect");
							if(GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
							{
							    SM(killerid,"Zabil si èlena nepøátelského gangu Car/Heli/Bike killem");
							    SM(killerid,"Nebyl vám pøiètený respect");
								return 0;
							}
							Gang[GetPlayerGangMember(killerid)][GFightKills] ++;
						}
					}
			    }
				if(GetInt(playerid,"Member") > 0 && GetInt(killerid,"Member") > 0)
				{
					if(reason == 35 || reason == 36 || reason == 51) return SM(killerid,"Použil si RPG nebo Granát, nebyl zapoèítaný respect");
					if(GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
					{
					    SM(killerid,"Zabil si èlena nepøátelského gangu Car/Heli/Bike killem");
					    SM(killerid,"Nebyl vám pøiètený respect");
						return 0;
					}
				    if(GetInt(playerid,"Member") == GetInt(killerid,"Member"))
					{
						if(Gang[GetInt(playerid,"Member")][GRespect] > 0)
						{
					    	SM(killerid,"Zabil si èlená tvého gangu -"r"1 RS");
							AddGangRespect(GetInt(killerid,"Member"),-1);
						    SM(playerid,str);
						}
					    return 1;
					}
					new member[50];
					if(Gang[GetInt(playerid,"Member")][GRespect] > 0)
					{
					    format(str,sizeof(str),"Byl si zabit èlenem gangu: {%s}%s "w"-"r"1 RS",Gang[GetInt(killerid,"Member")][GColor],Gang[GetInt(killerid,"Member")][GName]);
					    SM(playerid,str);
						AddGangRespect(GetInt(playerid,"Member"),-1);
						format(dfile,sizeof(dfile),GANG_FILE,GetInt(playerid,"Member"));
						if(GetInt(playerid,"Owner") < 1)
						{
							format(member,sizeof(member),"MemberRespect[%d]",GetInt(playerid,"MemberPos"));
							new resp = dini_Int(dfile,member);
							dini_IntSet(dfile,member,resp-1);
						}
						else
						{
							new resp = dini_Int(dfile,"OwnerRespect");
							dini_IntSet(dfile,"OwnerRespect",resp-1);
						}
					}
					else
					{
					    format(str,sizeof(str),"Byl si zabit èlenem gangu: {%s}%s",Gang[GetInt(killerid,"Member")][GColor],Gang[GetInt(killerid,"Member")][GName]);
					    SM(playerid,str);
					}
					format(str,sizeof(str),"%s gangu {%s}%s "w"byl zabit èlenem gangu {%s}%s "w"",GangHodnost(playerid),Gang[GetInt(playerid,"Member")][GColor],Jmeno(playerid),Gang[GetInt(killerid,"Member")][GColor],Gang[GetInt(killerid,"Member")][GName]);
					SendGangMessage(GetInt(playerid,"Member"),str);
				    format(str,sizeof(str),"Zabil si èlena gangu: {%s}%s "w"+"g"2 RS",Gang[GetInt(playerid,"Member")][GColor],Gang[GetInt(playerid,"Member")][GName]);
				    SM(killerid,str);
					AddGangRespect(GetInt(killerid,"Member"),2);
					GivePlayerDailyValueEx(killerid,DAILY_TYPE_GANG_KILLS);
					format(str,sizeof(str),"%s gangu {%s}%s "w"zabil èlena gangu {%s}%s "w"",GangHodnost(killerid),Gang[GetInt(killerid,"Member")][GColor],Jmeno(killerid),Gang[GetInt(playerid,"Member")][GColor],Gang[GetInt(playerid,"Member")][GName]);
					SendGangMessage(GetInt(killerid,"Member"),str);
					format(dfile,sizeof(dfile),GANG_FILE,GetInt(killerid,"Member"));
					if(GetInt(killerid,"Owner") < 1)
					{
						format(member,sizeof(member),"MemberRespect[%d]",GetInt(killerid,"MemberPos"));
						new resp = dini_Int(dfile,member);
						dini_IntSet(dfile,member,resp+2);
					}
					else
					{
						new resp = dini_Int(dfile,"OwnerRespect");
						dini_IntSet(dfile,"OwnerRespect",resp+2);
					}
					if(strlen(Gang[GetInt(killerid,"Member")][AudioStream]) > 0)
					{
					    if(!IsPlayerPlayMusic(playerid))
					    {
					        PlayAudioStreamForPlayer(playerid,Gang[GetInt(killerid,"Member")][AudioStream]);
					        SetTimerEx("StopAudio",10000,false,"i",playerid);
					    }
					}
				}
			}
		}
	}
	return 1;
}
//============================================================================//

forward StopAudio(playerid);

public StopAudio(playerid)
{
	StopAudioStreamForPlayer(playerid);
}

public OnDialogResponse(playerid,dialogid,response,listitem,inputtext[])
{
	if(dialogid == GANG)
	{
	    if(response)
	    {
			if(GetClickText(inputtext,"Seznam èlenù"))
			{
                new gid = GetPVarInt(playerid,"GangID");
				format(dfile,sizeof(dfile),GANG_FILE,gid);
                new DIALOG_MEMBERS[2000],member[50],member2[50],member3[50];
				format(str,sizeof(str),"{%s}%s\t"w"Boss\t{%s}+%d bodù\t{%s}%d RS\n",Gang[gid][GColor],dini_Get(dfile,"Owner"),Gang[gid][GColor],dini_Int(dfile,"OwnerBank"),Gang[gid][GColor],dini_Int(dfile,"OwnerRespect"));
				strcat(DIALOG_MEMBERS,str);
				for(new i; i < MAX_MEMBERS; i ++)
				{
				    format(member,sizeof(member),"Member[%d]",i);
				    format(member2,sizeof(member2),"MemberBank[%d]",i);
				    format(member3,sizeof(member3),"MemberRespect[%d]",i);
				    if(dini_Int(dfile,member) != -1)
				    {
						format(str,sizeof(str),"{%s}%s\t"w"Èlen\t{%s}+%d bodù\t{%s}%d RS\n",Gang[gid][GColor],dini_Get(dfile,member),Gang[gid][GColor],dini_Int(dfile,member2),Gang[gid][GColor],dini_Int(dfile,member3));
						strcat(DIALOG_MEMBERS,str);
					}
				}
				format(str,sizeof(str),"Seznam èlenù gangu: {%s}%s",Gang[gid][GColor],Gang[gid][GName]);
				SPD(playerid,0,DIALOG_STYLE_TABLIST,str,DIALOG_MEMBERS,"Zavøít","");
			}
			else if(GetClickText(inputtext,"Pøejmenovat Gang"))
			{
                new gid = GetPVarInt(playerid,"GangID");
				format(str,sizeof(str),"Zadejte nový název gangu\nAktualní název: {%s}%s",Gang[gid][GColor],Gang[gid][GName]);
				SPD(playerid,GANG+1,DIALOG_STYLE_INPUT,"Název gangu",str,"Zmìnit","Zavøít");
			}
			else if(GetClickText(inputtext,"Zmìnit barvu gangu"))
			{
				new DIALOG_COLORS[1000];
				for(new i; i < sizeof(Colors); i ++)
				{
					format(str,sizeof(str),"{%s}%s\n",Colors[i][ColorCode],Colors[i][ColorName]);
					strcat(DIALOG_COLORS,str);
				}
				strcat(DIALOG_COLORS,"Vlastní barva");
				SPD(playerid,GANG+2,DIALOG_STYLE_LIST,"Barva gangu",DIALOG_COLORS,"Zmìnit","Zavøít");
			}
			else if(GetClickText(inputtext,"Upravit popis gangu"))
			{
			    SPD(playerid,GANG+16,DIALOG_STYLE_INPUT,"Popis Gangu","Zadejte popis gangu [ Maximální délka je "r"50 znakù "dc"]","Zadat","Zrušit");
			}
			else if(GetClickText(inputtext,"Nastavit povinný skin Gangu"))
			{
                new gid = GetPVarInt(playerid,"GangID");
				if(Gang[gid][GSkin] == -1)
				{
					format(str,sizeof(str),"Zadejte nový skin gangu [ "g"0 - 311 "dc"]\nAktuální skin: "w"Nenastaven");
				}
				else
				{
					format(str,sizeof(str),"Zadejte nový skin gangu [ "g"0 - 311 "dc"]\nAktuální skin: "w"%d\n"dc"Pro odnastavení skinu zadejte "g"-1",Gang[gid][GSkin]);
				}
				SPD(playerid,GANG+3,DIALOG_STYLE_INPUT,"Skin gangu",str,"Zmìnit","Zavøít");
			}
			else if(GetClickText(inputtext,"Pozvat èleny"))
			{
	            new gid = GetPVarInt(playerid,"GangID");
				format(dfile,sizeof(dfile),GANG_FILE,gid);
				new member[50],slots;
				for(new i; i < MAX_MEMBERS; i ++)
			    {
					format(member,sizeof(member),"Member[%d]",i);
				    if(dini_Int(dfile,member) != -1)
			        {
			            slots++;
					}
			    }
			    if(slots == 15) return SM(playerid,"Gang už je plný");
				SPD(playerid,GANG+4,DIALOG_STYLE_INPUT,"Pozvat èleny","Zadejte ID hráèe, kterého si pøejete pozvat do gangu","Pozvat","Zavøít");
			}
			else if(GetClickText(inputtext,"Nastavit spawn u gangu") || GetClickText(inputtext,"Nastavit spawn u povolání"))
			{
				if(GetPlayerSpawn(playerid) != SPAWN_TYPE_GANG)
				{
				    SetPlayerSpawn(playerid,SPAWN_TYPE_GANG);
				    SM(playerid,"Spawn nastaven: "dc"u gangu");
				}
				else
				{
				    SetPlayerSpawn(playerid,SPAWN_TYPE_NONE);
					SM(playerid,"Spawn nastaven: "dc"u povolání");
				}
			}
			else if(GetClickText(inputtext,"Vložit body"))
			{
			    //SM(playerid,"Aktuálnì nelze vkládat do gangu body");
	            new gid = GetPVarInt(playerid,"GangID");
			    format(str,sizeof(str),"Zadejte poèet bodù, které si pøejte "g"vložit "dc"do gangu\nAktuální bank gangu je: "g"%d bodù",Gang[gid][GBank]);
			    SPD(playerid,GANG+6,DIALOG_STYLE_INPUT,"Vložit body",str,"Vložit","Zavøít");
			}
			else if(GetClickText(inputtext,"Vybrat body"))
			{
	            new gid = GetPVarInt(playerid,"GangID");
			    format(str,sizeof(str),"Zadejte poèet bodù, kterou si pøejte "r"vybrat "dc"z gangu\nAktuální bank gangu je: "g"%d bodù",Gang[gid][GBank]);
			    SPD(playerid,GANG+20,DIALOG_STYLE_INPUT,"Vybrat body",str,"Vybrat","Zavøít");
			}
			else if(GetClickText(inputtext,"Nastavit titul gangu"))
			{
	            new gid = GetPVarInt(playerid,"GangID");
				format(dfile,sizeof(dfile),"UnNamed/%s.save",Jmeno(playerid));
				if(fexist(dfile))
				{
				    dini_Set(dfile,"Titul",Gang[gid][GName]);
				    dini_Set(dfile,"BarvaTitulu",Gang[gid][GColor]);
				    format(str,sizeof(str),"Titul zmìnìn na gang titul {%s}%s",Gang[gid][GColor],Gang[gid][GName]);
				    SM(playerid,str);
				}
				else
				{
				    SM(playerid,"Zmìna titulu selhala [ Soubor neexistuje ]");
				}
			}
			else if(GetClickText(inputtext,"Gang Garáž"))
			{
	            new gid = GetPVarInt(playerid,"GangID");
				new DIALOG_GARAGE[1000];
				for(new i; i < MAX_SLOTS; i ++)
				{
				    if(i < Gang[gid][GSlots])
				    {
						format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",gid,i);
						if(fexist(dfile))
						{
							format(str,sizeof(str),"Slot [ {%s}%d "w"]: {%s}%s\n",Gang[gid][GColor],i+1,Gang[gid][GColor],GetVehicleName(dini_Int(dfile,"Model")));
							strcat(DIALOG_GARAGE,str);
						}
						else
						{
						    format(str,sizeof(str),"Slot [ {%s}%d "w"]: {898989}Volný Slot\n",Gang[gid][GColor],i+1);
							strcat(DIALOG_GARAGE,str);
						}
					}
				}
				strcat(DIALOG_GARAGE,"Respawnout gang garáž");
				SPD(playerid,GANG+9,DIALOG_STYLE_LIST,"Gang Garáž",DIALOG_GARAGE,"Vybrat","Zavøít");
			}
			else if(GetClickText(inputtext,"Vyhodit èlena"))
			{
               	new gid = GetPVarInt(playerid,"GangID");
				format(dfile,sizeof(dfile),GANG_FILE,gid);
                new DIALOG_MEMBERS[2000],member[50],member2[50],member3[50];
				for(new i; i < MAX_MEMBERS; i ++)
				{
				    format(member,sizeof(member),"Member[%d]",i);
				    format(member2,sizeof(member2),"MemberBank[%d]",i);
				    format(member3,sizeof(member3),"MemberRespect[%d]",i);
				    if(dini_Int(dfile,member) != -1)
				    {
						format(str,sizeof(str),"{%s}%s\t"w"Èlen\t{%s}+%d bodù\t{%s}%d RS\n",Gang[gid][GColor],dini_Get(dfile,member),Gang[gid][GColor],dini_Int(dfile,member2),Gang[gid][GColor],dini_Int(dfile,member3));
						strcat(DIALOG_MEMBERS,str);
					}
					else
					{
					    strcat(DIALOG_MEMBERS," \n");
					}
				}
				SPD(playerid,GANG+8,DIALOG_STYLE_TABLIST,"Vyhodit èlena",DIALOG_MEMBERS,"Vyhodit","Zavøít");
			}
			else if(GetClickText(inputtext,"Nastavit èlenské pravomoce"))
			{
			    new gid = GetPVarInt(playerid,"GangID");
			    new DIALOG_MEMBERS[2000],members[50];
				format(dfile,sizeof(dfile),GANG_FILE,gid);
			    for(new i; i < MAX_MEMBERS; i ++)
			    {
					format(members,sizeof(members),"Member[%d]",i);
					if(dini_Int(dfile,members) == -1)
					{
					    strcat(DIALOG_MEMBERS," \n");
					}
					else
					{
					    format(str,sizeof(str),"%s\n",dini_Get(dfile,members));
					    strcat(DIALOG_MEMBERS,str);
					}
			    }
			    SPD(playerid,GANG+7,DIALOG_STYLE_LIST,"Nastavit èlenské pravomoce",DIALOG_MEMBERS,"Vybrat","Zavøít");
			}
			else if(GetClickText(inputtext,"Zrušit gang"))
			{
			    new gid = GetPVarInt(playerid,"GangID");
				format(str,sizeof(str),"Opravdu si pøejte zrušit gang {%s}%s"dc"?\n"dc"Vrátí se vám pouze "g"%d bodù "dc"z celkové hodnoty "g"%d bodù",Gang[gid][GColor],Gang[gid][GName],Gang[gid][GBank],Gang[gid][GBank]);
				SPD(playerid,GANG+15,DIALOG_STYLE_MSGBOX,"Zrušit Gang",str,"Ano","Ne");
			}
			else if(GetClickText(inputtext,"Opustit gang"))
			{
	            new gid = GetPVarInt(playerid,"GangID");
				format(dfile,sizeof(dfile),GANG_FILE,gid);
				format(str,sizeof(str),"Opustil si gang {%s}%s",Gang[gid][GColor],Gang[gid][GName]);
				SM(playerid,str);
				for(new c; c < sizeof(Zones); c ++)
				{
				    GangZoneHideForPlayer(playerid,ZoneID[c]);
				}
				new member[50];
				format(member,sizeof(member),"Member[%d]",GetInt(playerid,"MemberPos"));
				dini_IntSet(dfile,member,-1);
				format(member,sizeof(member),"MemberSpawn[%d]",GetInt(playerid,"MemberPos"));
				dini_IntSet(dfile,member,0);
				format(member,sizeof(member),"MemberRespect[%d]",GetInt(playerid,"MemberPos"));
				dini_IntSet(dfile,member,0);
				format(member,sizeof(member),"MemberBank[%d]",GetInt(playerid,"MemberPos"));
				dini_IntSet(dfile,member,0);
				for(new x; x < sizeof(Functions); x ++)
				{
					format(member,sizeof(member),"MemberFunction[%d](%d)",GetInt(playerid,"MemberPos"),x);
					dini_IntSet(dfile,member,0);
				}
				SetInt(playerid,"Member",0);
				Member[playerid] = 0;
				SetInt(playerid,"MemberPos",0);
				SetInt(playerid,"MemberSpawn",0);
				SetPlayerTeam(playerid,255);
				Delete3DTextLabel(Text[playerid]);
				format(str,sizeof(str),"Èlen {%s}%s "w"opustil gang",Gang[gid][GColor],Jmeno(playerid));
				SendGangMessage(gid,str);
				CallRemoteFunction("SetDefaultTitul","i",playerid);
				SetPlayerSpawn(playerid,SPAWN_TYPE_NONE);
			}
			else
			{
			    return 1;
			}
	    }
	    return 1;
	}
	if(dialogid == GANG+1)
	{
	    if(response)
	    {
            new gid = GetPVarInt(playerid,"GangID");
			format(dfile,sizeof(dfile),GANG_FILE,gid);
	        if(strlen(inputtext) < 3 || strlen(inputtext) > 18) return SPD(playerid,GANG+1,DIALOG_STYLE_INPUT,"Název gangu","Zadal jstse neplatnou délku názvu","Zmìnit","Zavøít");
			for(new i; i < sizeof(BlockedNames); i ++)
			{
			    if(strfind(inputtext,BlockedNames[i],true) != -1) return SPD(playerid,GANG+1,DIALOG_STYLE_INPUT,"Název gangu","Zadal jste nepovolený název gangu","Zmìnit","Zavøít");
			}
        	dini_Set(dfile,"Name",inputtext);
        	dini_Set(dfile,"SpecialName",inputtext);
			format(dfile,sizeof(dfile),"UnNamed/%s.save",Jmeno(playerid));
			if(fexist(dfile))
			{
			    if(strcmp(DOF2_GetString(dfile,"Prefix"),Gang[gid][GName],true) == 0)
			    {
					CallRemoteFunction("SetPlayerTitul","i",playerid,inputtext,"FFFFFF","");
			    }
			}
			for(new i; i < MAX_MEMBERS; i ++)
			{
			    new member[50],fajl[50];
				format(member,sizeof(member),"Member[%d]",i);
				format(dfile,sizeof(dfile),GANG_FILE,gid);
				format(fajl,sizeof(fajl),"UnNamed/%s.save",dini_Get(dfile,member));
				if(fexist(fajl))
				{
					if(dini_Int(dfile,member) != -1)
					{
						if(strcmp(DOF2_GetString(fajl,"Prefix"),Gang[gid][GName],true) == 0)
						{
							CallRemoteFunction("SetPlayerTitul","i",playerid,inputtext,"FFFFFF","");
						}
					}
				}
			}
        	format(str,sizeof(str),inputtext);
        	Gang[gid][GName] = str;
        	Gang[gid][GSName] = str;
			UpdateGangText(gid);
		    format(str,sizeof(str),"Gang název zmìnìn na {%s}%s",Gang[gid][GColor],Gang[gid][GName]);
		    SM(playerid,str);
		    new query[200];
		    mysql_format(mysql,query,sizeof(query),"UPDATE `Gangs` SET `Name`='%e' WHERE `GangID`=%d",inputtext,gid);
		    mysql_query(mysql,query,false);
		    for(new i; i <= GetPlayerPoolSize(); i ++)
		    {
				if(IPC(i) && !IsPlayerNPC(i))
				{
			        if(GetInt(i,"Member") == gid)
			        {
						UpdateGangTitle(i);
			        }
				}
		    }
		}
	    return 1;
	}
	if(dialogid == GANG+2)
	{
		if(response)
		{
		    if(GetClickText(inputtext,"Vlastní barva"))
		    {
				SPD(playerid,GANG+19,DIALOG_STYLE_INPUT,"Zmìna barvy","Zadejte kód barvy (napø. {00FF00}00FF00 "dc"je {00FF00}zelená"dc")","Zadat","Zavøít");
		    }
		    else
		    {
 	            new gid = GetPVarInt(playerid,"GangID");
	            format(dfile,sizeof(dfile),GANG_FILE,gid);
	            format(str,sizeof(str),"%s",Colors[listitem][ColorCode]);
	        	dini_Set(dfile,"Color",str);
	        	Gang[gid][GColor] = str;
				UpdateGangText(gid);
			    format(str,sizeof(str),"Gang barva zmìnìn na {%s}%s",Colors[listitem][ColorCode],Colors[listitem][ColorName]);
			    SM(playerid,str);
			    for(new x; x < sizeof(Zones); x ++)
			    {
			        if(Zones[x][ZoneGang] == gid)
			        {
			            UpdateGangZoneColor(x);
			        }
			    }
			    for(new i; i <= GetPlayerPoolSize(); i ++)
			    {
			        if(GetInt(i,"Member") == gid)
			        {
						UpdateGangTitle(i);
			        }
			    }
			}
		}
		return 1;
	}
	if(dialogid == GANG+3)
	{
		if(response)
		{
            new gid = GetPVarInt(playerid,"GangID"),skinid;
            if(sscanf(inputtext,"i",skinid)) return SPD(playerid,GANG+3,DIALOG_STYLE_INPUT,"Skin gangu","Zadejte nový skin gangu","Zmìnit","Zavøít");
			if(skinid < -1 || skinid > 311) return SPD(playerid,GANG+3,DIALOG_STYLE_INPUT,"Skin gangu","Chybnì zadané data [ "g"0 - 311 "dc"]\nPro odnastavení skinu zadejte "g"-1","Zmìnit","Zavøít");
			Gang[gid][GSkin] = skinid;
			format(dfile,sizeof(dfile),GANG_FILE,gid);
			dini_IntSet(dfile,"Skin",skinid);
			if(skinid > -1)
			{
				format(str,sizeof(str),"Gang skin zmìnìn na "g"%d",skinid);
				SM(playerid,str);
			}
			else
			{
				SM(playerid,"Gang Skin "g"odnastaven");
			}
		}
		return 1;
	}
	if(dialogid == GANG+4)
	{
	    if(response)
	    {
            new gid = GetPVarInt(playerid,"GangID"),id;
			if(sscanf(inputtext,"i",id)) return SPD(playerid,GANG+4,DIALOG_STYLE_INPUT,"Pozvat èleny","Zadejte ID hráèe, kterého si pøejete pozvat do gangu","Pozvat","Zavøít");
			if(!IPC(id) || IsPlayerNPC(id)) return SPD(playerid,GANG+4,DIALOG_STYLE_INPUT,"Pozvat èleny","Hráè s tímto ID není pøipojen","Pozvat","Zavøít");
			if(id == playerid) return SPD(playerid,GANG+4,DIALOG_STYLE_INPUT,"Pozvat èleny","Nemùžete pozvat sám sebe","Pozvat","Zavøít");
			if(IsPlayerHasBlockedGangInvites(playerid)) return SPD(playerid,GANG+4,DIALOG_STYLE_INPUT,"Pozvat èleny","Hráè má bloknuté pozvánky do gangu","Pozvat","Zavøít");
			if(GetInt(id,"MaybeMember") > 0) return SPD(playerid,GANG+4,DIALOG_STYLE_INPUT,"Pozvat èleny","Tento hráè má nevyøízenou žádost","Pozvat","Zavøít");
			format(str,sizeof(str),"Hráè "r"%s "dc"(ID: "r"%d"dc") je èlenem gangu {%s}%s",Jmeno(id),id,Gang[GetInt(id,"Member")][GColor],Gang[GetInt(id,"Member")][GName]);
			if(GetInt(id,"Member") > 0) return SPD(playerid,GANG+4,DIALOG_STYLE_INPUT,"Pozvat èleny",str,"Pozvat","Zavøít");
			format(str,sizeof(str),"Poslal si pozvánku do gangu hráèi "r"%s",Jmeno(id));
			SM(playerid,str);
			SetInt(id,"MaybeMember",gid);
			format(str,sizeof(str),"%s gangu "w"%s "dc"ti poslal pozvánku do gangu {%s}%s ",GangHodnost(playerid),Jmeno(playerid),Gang[gid][GColor],Gang[gid][GName]);
			SPD(id,GANG+5,DIALOG_STYLE_MSGBOX,"Pozvánka do gangu",str,"Pøíjmout","Zrušit");
	    }
		return 1;
	}
	if(dialogid == GANG+5)
	{
	    if(response)
	    {
			printf("%s | %d",Jmeno(playerid),GANG+5);
			format(dfile,sizeof(dfile),GANG_FILE,GetInt(playerid,"MaybeMember"));
			new member[50],slots;
	        for(new i; i < MAX_MEMBERS; i ++)
	        {
				format(member,sizeof(member),"Member[%d]",i);
				if(dini_Int(dfile,member) == -1)
				{
				    dini_Set(dfile,member,Jmeno(playerid));
				    SetInt(playerid,"MemberPos",i);
					format(member,sizeof(member),"MemberSpawn[%d]",i);
					dini_IntSet(dfile,member,1);
				    break;
				}
				else
				{
					slots++;
					continue;
				}
	        }
	        if(slots == MAX_MEMBERS)
	        {
		        SetInt(playerid,"MaybeMember",0);
				SM(playerid,"Gang už je plný");
				return 1;
	        }
			SetPlayerSpawn(playerid,SPAWN_TYPE_GANG);
	        format(str,sizeof(str),"Pøijmul si pozvánku do gangu {%s}%s",Gang[GetInt(playerid,"MaybeMember")][GColor],Gang[GetInt(playerid,"MaybeMember")][GName]);
	        SM(playerid,str);
	        for(new i; i <= GetPlayerPoolSize(); i ++)
	        {
	            if(GetInt(i,"Member") == GetInt(playerid,"MaybeMember"))
	            {
					format(str,sizeof(str),"Hráè "r"%s "w"pøijal pozvánku do gangu. Stává se novým èlenem",Jmeno(playerid));
					SM(i,str);
			    }
	        }
		    SetInt(playerid,"Member",GetInt(playerid,"MaybeMember"));
		    Member[playerid] = GetInt(playerid,"MeybeMember");
	        SetInt(playerid,"MaybeMember",0);
			for(new c; c < sizeof(Zones); c ++)
			{
			    GangZoneShowForPlayer(playerid,ZoneID[c],GetZoneColor(c));
			}
			format(str,sizeof(str),"{%s}%s",Gang[GetInt(playerid,"Member")][GColor],Gang[GetInt(playerid,"Member")][GName]);
			Text[playerid] = Create3DTextLabel(str,bila,0,0,0,50,-1,true);
			Attach3DTextLabelToPlayer(Text[playerid],playerid,0,0,0.5);
   			SetPlayerTeam(playerid,GetInt(playerid,"Member"));
			SetInt(playerid,"MemberSpawn",1);
		}
	    else
	    {
	        for(new i; i <= GetPlayerPoolSize(); i ++)
	        {
	            if(GetInt(i,"Member") == GetInt(playerid,"MaybeMember"))
	            {
					format(str,sizeof(str),"Hráè "r"%s "w"odmítl pozvánku do gangu.",Jmeno(playerid));
					SM(i,str);
			    }
	        }
	        format(str,sizeof(str),"Zamítnul si pozvánku do gangu {%s}%s",Gang[GetInt(playerid,"MaybeMember")][GColor],Gang[GetInt(playerid,"MaybeMember")][GName]);
	        SM(playerid,str);
	        SetInt(playerid,"MaybeMember",0);
	    }
	    return 1;
	}
	if(dialogid == GANG+6)
	{
	    if(response)
	    {
	        new gid = GetPVarInt(playerid,"GangID"),cash;
	        if(sscanf(inputtext,"i",cash)) return SPD(playerid,GANG+6,DIALOG_STYLE_INPUT,"Vložit body","Zadejte èástku, kterou si pøejete vložit do gangu","Vložit","Zavøít");
			if(cash > CallRemoteFunction("GetPoints","i",playerid)) return SPD(playerid,GANG+6,DIALOG_STYLE_INPUT,"Vložit body","Tolik bodù u sebe nemáte","Vložit","Zavøít");
			if(cash < 1 || cash > 999999999) return SPD(playerid,GANG+6,DIALOG_STYLE_INPUT,"Vložit body","Zadal jste pøíliš velkou/malou sumu","Vložit","Zavøít");
			if(Gang[gid][GBank] + cash > 999999999) return SPD(playerid,GANG+6,DIALOG_STYLE_INPUT,"Vložít bodù","Tolik bodù se do gangu nevejde","Vložit","Zavøít");
			format(dfile,sizeof(dfile),GANG_FILE,gid);
			if(GetInt(playerid,"Owner") > 0)
			{
				dini_IntSet(dfile,"OwnerBank",dini_Int(dfile,"OwnerBank")+cash);
			}
			else
			{
				new member[50];
				format(member,sizeof(member),"MemberBank[%d]",GetInt(playerid,"MemberPos"));
				dini_IntSet(dfile,member,dini_Int(dfile,member)+cash);
			}
			GivePlayerPoints(playerid,-cash);
			Gang[gid][GBank] += cash;
			dini_IntSet(dfile,"Bank",Gang[gid][GBank]);
			DOF2_SaveFile();
			UpdateGangText(gid);
		    format(str,sizeof(str),"%s {%s}%s "w"vložil do gangu "g"%d bodù",GangHodnost(playerid),Gang[gid][GColor],Jmeno(playerid),cash);
		    SendGangMessage(gid,str);
		    format(str,sizeof(str),"Bank je nyní: "g"%d bodù",Gang[gid][GBank]);
		    SendGangMessage(gid,str);
		}
	    return 1;
	}
	if(dialogid == GANG+7)
	{
	    if(response)
	    {
	        new gid = GetPVarInt(playerid,"GangID");
	        new DIALOG_FUNCTIONS[1000],member[50];
	        if(strlen(inputtext) < 3) return SM(playerid,"Vybral si prázdný slot");
	        for(new i; i < sizeof(Functions); i ++)
	        {
	            format(member,sizeof(member),"MemberFunction[%d](%d)",listitem,i);
	            if(dini_Int(dfile,member) == 0)
	            {
					format(str,sizeof(str),""r"%s\n",Functions[i]);
					strcat(DIALOG_FUNCTIONS,str);
	            }
	            else
	            {
					format(str,sizeof(str),""g"%s\n",Functions[i]);
					strcat(DIALOG_FUNCTIONS,str);
	            }
	        }
	        SetPVarInt(playerid,"ClickedPlayer",listitem);
	        SetPVarString(playerid,"ClickedPlayerName",inputtext);
	        format(str,sizeof(str),"Nastavit èlenské pravomoce hráèi {%s}%s",Gang[gid][GColor],inputtext);
	        SPD(playerid,GANG+14,DIALOG_STYLE_LIST,str,DIALOG_FUNCTIONS,"Vybrat","Zavøít");
	    }
	    return 1;
	}
	if(dialogid == GANG+8)
	{
	    if(response)
	    {
            new gid = GetPVarInt(playerid,"GangID"),member[50];
			format(dfile,sizeof(dfile),GANG_FILE,gid);
			format(member,sizeof(member),"Member[%d]",listitem);
			if(dini_Int(dfile,member) == -1) return SM(playerid,"V tomto slotu není žádný èlen");
			for(new i; i <= GetPlayerPoolSize(); i ++)
			{
				if(GetInt(i,"Member") == gid && GetInt(i,"MemberPos") == listitem && GetInt(i,"Owner") == 0)
				{
				    SetInt(i,"Member",0);
				    Member[i] = 0;
				    SetInt(i,"MemberPos",0);
				    format(str,sizeof(str),"Byl si vyhozen z gangu {%s}%s",Gang[gid][GColor],Gang[gid][GName]);
				    SM(i,str);
				    Delete3DTextLabel(Text[i]);
				    SetPlayerTeam(i,255);
				    SetPlayerSpawn(playerid,SPAWN_TYPE_NONE);
					for(new c; c < sizeof(Zones); c ++)
					{
					    GangZoneHideForPlayer(playerid,ZoneID[c]);
					}
				}
			}
			format(member,sizeof(member),"Member[%d]",listitem);
			dini_IntSet(dfile,member,-1);
			format(member,sizeof(member),"MemberSpawn[%d]",listitem);
			dini_IntSet(dfile,member,0);
			format(member,sizeof(member),"MemberRespect[%d]",listitem);
			dini_IntSet(dfile,member,0);
			format(member,sizeof(member),"MemberBank[%d]",listitem);
			dini_IntSet(dfile,member,0);
			for(new x; x < sizeof(Functions); x ++)
			{
				format(member,sizeof(member),"MemberFunction[%d](%d)",listitem,x);
				dini_IntSet(dfile,member,0);
			}
			format(str,sizeof(str),"Vyhodil si hráèe {%s}%s "w"z gangu",Gang[gid][GColor],inputtext);
			SM(playerid,str);
			format(dfile,sizeof(dfile),"UnNamed/%s.save",inputtext);
			CallRemoteFunction("SetDefaultTitul","i",playerid);
			format(str,sizeof(str),"Èlen {%s}%s"w" byl vyhozen z gangu",Gang[gid][GColor],inputtext);
			SendGangMessage(gid,str);
		}
	    return 1;
	}
	if(dialogid == GANG+9)
	{
	    if(response)
	    {
            new gid = GetPVarInt(playerid,"GangID");
			if(GetClickText(inputtext,"Respawnout gang garáž"))
			{
			    format(str,sizeof(str),"%s gangu {%s}%s "w"respawnul prázdná gang vozidla",GangHodnost(playerid),Gang[gid][GColor],Jmeno(playerid));
			    SendGangMessage(gid,str);
			    for(new i; i < MAX_SLOTS; i ++)
			    {
			        if(IsVehicleEmpty(SavedCar[gid][i]))
			        {
			            SpawnCar(gid,i);
			        }
			    }
			    return 1;
			}
			if(SavedCar[gid][listitem] > 0)
			{
				new DIALOG_GARAGE[300];
				new price = GetVehiclePrice(ParkInfo[gid][listitem][Model]);
				strcat(DIALOG_GARAGE,"Respawnout vozidlo\n");
				strcat(DIALOG_GARAGE,"Uložit tuning\n");
				strcat(DIALOG_GARAGE,"Pøeparkovat vozidlo\n");
				strcat(DIALOG_GARAGE,"Pøelakovat vozidlo\n");
				switch(ParkInfo[gid][listitem][Model])
				{
				    case 534,535,536,558,559,560,561,562,565,567,575,576:
				    {
						strcat(DIALOG_GARAGE,"Zmìnit PaintJob\n");
					}
				}
				format(str,sizeof(str),"Prodat vozidlo za "g"%d bodù\n",price/2);
				strcat(DIALOG_GARAGE,str);
			 	SPD(playerid,GANG+10,DIALOG_STYLE_LIST,"Gang Garáž",DIALOG_GARAGE,"Vybrat","Zavøít");
			}
			else
			{
			 	SPD(playerid,GANG+10,DIALOG_STYLE_LIST,"Gang Garáž","Koupit Vozidlo","Vybrat","Zavøít");
			}
			SetPVarInt(playerid,"GarageSlotID",listitem);
	    }
	    return 1;
	}
	if(dialogid == GANG+10)
	{
		if(response)
		{
			if(GetClickText(inputtext,"Koupit vozidlo"))
			{
                ShowGarageCategories(playerid);
			}
			else if(GetClickText(inputtext,"Respawnout vozidlo"))
			{
				new slot = GetPVarInt(playerid,"GarageSlotID");
   				new gid = GetPVarInt(playerid,"GangID");
				if(!IsVehicleEmpty(SavedCar[gid][slot])) return SM(playerid,"Ve vozidle nìkdo sedí");
				SpawnCar(gid,slot);
				format(str,sizeof(str),"%s gangu {%s}%s "w"respawnul gang vozidlo {%s}%s",GangHodnost(playerid),Gang[gid][GColor],Jmeno(playerid),Gang[gid][GColor],GetVehicleName(ParkInfo[gid][slot][Model]));
				SendGangMessage(gid,str);
			}
			else if(GetClickText(inputtext,"Pøeparkovat vozidlo"))
			{
				new slot = GetPVarInt(playerid,"GarageSlotID"),gid = GetPVarInt(playerid,"GangID");
				format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",gid,slot);
				if(!fexist(dfile)) return SM(playerid,"Vyskytla se chyba");
				new Float:X,Float:Y,Float:Z,Float:A;
				GetVehiclePos(SavedCar[gid][slot],X,Y,Z);
				GetVehicleZAngle(SavedCar[gid][slot],A);
				if(GetVehicleDistanceFromPoint(SavedCar[gid][slot],Gang[gid][GX],Gang[gid][GY],Gang[gid][GZ]) > 80.0) return SM(playerid,"Vozidlo je pøíliš vzdálené od gangu");
				ParkInfo[gid][slot][pX] = X;
				ParkInfo[gid][slot][pY] = Y;
				ParkInfo[gid][slot][pZ] = Z;
				ParkInfo[gid][slot][pA] = A;
				dini_FloatSet(dfile,"X",ParkInfo[gid][slot][pX]);
				dini_FloatSet(dfile,"Y",ParkInfo[gid][slot][pY]);
				dini_FloatSet(dfile,"Z",ParkInfo[gid][slot][pZ]);
				dini_FloatSet(dfile,"A",ParkInfo[gid][slot][pA]);
				format(str,sizeof(str),"Vozidlo "r"%s "w"úspìšnì pøeparkováno",GetVehicleName(ParkInfo[gid][slot][Model]));
				SM(playerid,str);
			}
			else if(GetClickText(inputtext,"Uložit tuning"))
			{
				new slot = GetPVarInt(playerid,"GarageSlotID");
   				new gid = GetPVarInt(playerid,"GangID");
				format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",gid,slot);
				if(!fexist(dfile)) return SM(playerid,"Vyskytla se chyba");
				new car = SavedCar[gid][slot];
				ParkInfo[gid][slot][Model] = GetVehicleModel(car);
				ParkInfo[gid][slot][TuneSlot0] = GetVehicleComponentInSlot(car,CARMODTYPE_SPOILER);
				ParkInfo[gid][slot][TuneSlot1] = GetVehicleComponentInSlot(car,CARMODTYPE_HOOD);
				ParkInfo[gid][slot][TuneSlot2] = GetVehicleComponentInSlot(car,CARMODTYPE_ROOF);
				ParkInfo[gid][slot][TuneSlot3] = GetVehicleComponentInSlot(car,CARMODTYPE_SIDESKIRT);
				ParkInfo[gid][slot][TuneSlot4] = GetVehicleComponentInSlot(car,CARMODTYPE_LAMPS);
				ParkInfo[gid][slot][TuneSlot5] = GetVehicleComponentInSlot(car,CARMODTYPE_NITRO);
				ParkInfo[gid][slot][TuneSlot6] = GetVehicleComponentInSlot(car,CARMODTYPE_EXHAUST);
				ParkInfo[gid][slot][TuneSlot7] = GetVehicleComponentInSlot(car,CARMODTYPE_WHEELS);
				ParkInfo[gid][slot][TuneSlot8] = GetVehicleComponentInSlot(car,CARMODTYPE_STEREO);
				ParkInfo[gid][slot][TuneSlot9] = GetVehicleComponentInSlot(car,CARMODTYPE_HYDRAULICS);
				ParkInfo[gid][slot][TuneSlot10] = GetVehicleComponentInSlot(car,CARMODTYPE_FRONT_BUMPER);
				ParkInfo[gid][slot][TuneSlot11] = GetVehicleComponentInSlot(car,CARMODTYPE_REAR_BUMPER);
				ParkInfo[gid][slot][TuneSlot12] = GetVehicleComponentInSlot(car,CARMODTYPE_VENT_RIGHT);
				ParkInfo[gid][slot][TuneSlot13] = GetVehicleComponentInSlot(car,CARMODTYPE_VENT_LEFT);
				dini_IntSet(dfile,"Model",GetVehicleModel(car));
				dini_IntSet(dfile,"Color1",ParkInfo[gid][slot][Color1]);
				dini_IntSet(dfile,"Color2",ParkInfo[gid][slot][Color2]);
				dini_IntSet(dfile,"PaintJob",ParkInfo[gid][slot][PaintJob]);
				dini_IntSet(dfile,"TuneSlot0",ParkInfo[gid][slot][TuneSlot0]);
				dini_IntSet(dfile,"TuneSlot1",ParkInfo[gid][slot][TuneSlot1]);
				dini_IntSet(dfile,"TuneSlot2",ParkInfo[gid][slot][TuneSlot2]);
				dini_IntSet(dfile,"TuneSlot3",ParkInfo[gid][slot][TuneSlot3]);
				dini_IntSet(dfile,"TuneSlot4",ParkInfo[gid][slot][TuneSlot4]);
				dini_IntSet(dfile,"TuneSlot5",ParkInfo[gid][slot][TuneSlot5]);
				dini_IntSet(dfile,"TuneSlot6",ParkInfo[gid][slot][TuneSlot6]);
				dini_IntSet(dfile,"TuneSlot7",ParkInfo[gid][slot][TuneSlot7]);
				dini_IntSet(dfile,"TuneSlot8",ParkInfo[gid][slot][TuneSlot8]);
				dini_IntSet(dfile,"TuneSlot9",ParkInfo[gid][slot][TuneSlot9]);
				dini_IntSet(dfile,"TuneSlot10",ParkInfo[gid][slot][TuneSlot10]);
				dini_IntSet(dfile,"TuneSlot11",ParkInfo[gid][slot][TuneSlot11]);
				dini_IntSet(dfile,"TuneSlot12",ParkInfo[gid][slot][TuneSlot12]);
				dini_IntSet(dfile,"TuneSlot13",ParkInfo[gid][slot][TuneSlot13]);
				SpawnCar(gid,slot);
				format(str,sizeof(str),"Tuning vozidla "r"%s "w"úspìšnì uložen",GetVehicleName(ParkInfo[gid][slot][Model]));
				SM(playerid,str);
			}
			else if(GetClickText(inputtext,"Pøelakovat vozidlo"))
			{
			    SPD(playerid,GANG+17,DIALOG_STYLE_INPUT,"Pøelakovat Vozidlo","Zadejte ID barvy","Zadat","Zavøít");
			}
			else if(GetClickText(inputtext,"Zmìnit PaintJob"))
			{
			    SPD(playerid,GANG+18,DIALOG_STYLE_LIST,"Zmìnit PaintJob","PaintJob 1\nPaintJob 2\nPaintJob 3\nOdstranit PaintJob","Vybrat","Zavøít");
			}
			else if(GetClickText(inputtext,"Prodat vozidlo"))
			{
				new slot = GetPVarInt(playerid,"GarageSlotID");
   				new gid = GetPVarInt(playerid,"GangID"),price = GetVehiclePrice(ParkInfo[gid][slot][Model])/2;
			    format(str,sizeof(str),"Opravdu si pøejete prodat Gang vozidlo "r"%s "dc"(Slot: "g"%d"dc") za "g"%d bodù"dc"?",GetVehicleName(ParkInfo[gid][slot][Model]),slot+1,price);
				SPD(playerid,GANG+12,DIALOG_STYLE_MSGBOX,"Gang Garáž",str,"Ano","Ne");
			}
		}
		return 1;
	}
	if(dialogid == GANG+11)
	{
	    if(response)
	    {
			new gid = GetPVarInt(playerid,"GangID"),Cache:cache,query[250],category = GetPVarInt(playerid,"CategoryID");
			mysql_format(mysql,query,sizeof(query),"SELECT * FROM `GarageVehicles` WHERE `Kategorie`=%d ORDER BY `Price` DESC",category);
			cache = mysql_query(mysql,query);
			new price = cache_get_field_content_int(listitem,"Price",mysql),modelid = cache_get_field_content_int(listitem,"Model",mysql);
			cache_delete(cache,mysql);
	        if(Gang[gid][GBank] < price) return SM(playerid,"Váš gang nemá dostateèné body");
			new slot = GetPVarInt(playerid,"GarageSlotID");
	        Gang[gid][GBank] += -price;
			format(dfile,sizeof(dfile),GANG_FILE,gid);
			UpdateGangText(gid);
		    dini_IntSet(dfile,"Bank",Gang[gid][GBank]);
			DOF2_SaveFile();
			new rand = random(128);
			SavedCar[gid][slot] = 0;
			new SLX[50],SLY[50],SLZ[50],SLA[50];
			format(SLX,sizeof(SLX),"SlotX[%d]",slot+1);
			format(SLY,sizeof(SLY),"SlotY[%d]",slot+1);
			format(SLZ,sizeof(SLZ),"SlotZ[%d]",slot+1);
			format(SLA,sizeof(SLA),"SlotA[%d]",slot+1);
			SavedCar[gid][slot] = CreateVehicle(modelid,dini_Float(dfile,SLX),dini_Float(dfile,SLY),dini_Float(dfile,SLZ),dini_Float(dfile,SLA),rand,rand,-1,0);
			format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",gid,slot);
			GetVehiclePos(SavedCar[gid][slot],ParkInfo[gid][slot][pX],ParkInfo[gid][slot][pY],ParkInfo[gid][slot][pZ]);
			GetVehicleZAngle(SavedCar[gid][slot],ParkInfo[gid][slot][pA]);
			ParkInfo[gid][slot][Color1] = rand;
			ParkInfo[gid][slot][Color2] = rand;
			if(!fexist(dfile))
			{
			    dini_Create(dfile);
				dini_IntSet(dfile,"Model",modelid);
				dini_FloatSet(dfile,"X",ParkInfo[gid][slot][pX]);
				dini_FloatSet(dfile,"Y",ParkInfo[gid][slot][pY]);
				dini_FloatSet(dfile,"Z",ParkInfo[gid][slot][pZ]);
				dini_FloatSet(dfile,"A",ParkInfo[gid][slot][pA]);
				dini_IntSet(dfile,"Color1",ParkInfo[gid][slot][Color1]);
				dini_IntSet(dfile,"Color2",ParkInfo[gid][slot][Color2]);
				dini_IntSet(dfile,"PaintJob",3);
			}
			ParkInfo[gid][slot][PaintJob] = 3;
			ParkInfo[gid][slot][Model] = modelid;
			format(str,sizeof(str),"Vozidlo "r"%s "w"úspìšnì zakoupeno za "g"%d bodù",GetVehicleName(modelid),price);
			SM(playerid,str);
			format(str,sizeof(str),"%s gangu {%s}%s "w"koupil nové gang vozidlo "r"%s",GangHodnost(playerid),Gang[gid][GColor],Jmeno(playerid),GetVehicleName(modelid));
			SendGangMessage(gid,str);
	    }
	    else ShowGarageCategories(playerid);
	    return 1;
	}
	if(dialogid == GANG+12)
	{
	    if(response)
	    {
			new slot = GetPVarInt(playerid,"GarageSlotID");
			new gid = GetPVarInt(playerid,"GangID");
			format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",gid,slot);
			if(fexist(dfile))
			{
			    fremove(dfile);
			    new model = ParkInfo[gid][slot][Model],price = GetVehiclePrice(model)/2;
				Gang[gid][GBank] += price;
				DOF2_SaveFile();
				format(dfile,sizeof(dfile),GANG_FILE,gid);
				UpdateGangText(gid);
			    dini_IntSet(dfile,"Bank",Gang[gid][GBank]);
				format(str,sizeof(str),"Vozidlo "g"%s "w"úspìšnì prodáno za "g"%d bodù",GetVehicleName(ParkInfo[gid][slot][Model]),price);
				SM(playerid,str);
			    DestroyVehicle(SavedCar[gid][slot]);
				SavedCar[gid][slot] = 0;
			    ParkInfo[gid][slot][pX] = 0;
			    ParkInfo[gid][slot][pY] = 0;
			    ParkInfo[gid][slot][pZ] = 0;
			    ParkInfo[gid][slot][pA] = 0;
			    ParkInfo[gid][slot][Model] = 0;
			    ParkInfo[gid][slot][Color1] = 0;
			    ParkInfo[gid][slot][Color2] = 0;
			    ParkInfo[gid][slot][PaintJob] = 0;
			    ParkInfo[gid][slot][TuneSlot0] = 0;
			    ParkInfo[gid][slot][TuneSlot1] = 0;
			    ParkInfo[gid][slot][TuneSlot2] = 0;
			    ParkInfo[gid][slot][TuneSlot3] = 0;
			    ParkInfo[gid][slot][TuneSlot4] = 0;
			    ParkInfo[gid][slot][TuneSlot5] = 0;
			    ParkInfo[gid][slot][TuneSlot6] = 0;
			    ParkInfo[gid][slot][TuneSlot7] = 0;
			    ParkInfo[gid][slot][TuneSlot8] = 0;
			    ParkInfo[gid][slot][TuneSlot9] = 0;
			    ParkInfo[gid][slot][TuneSlot10] = 0;
			    ParkInfo[gid][slot][TuneSlot11] = 0;
			    ParkInfo[gid][slot][TuneSlot12] = 0;
			    ParkInfo[gid][slot][TuneSlot13] = 0;
				format(str,sizeof(str),"%s gangu {%s}%s "w"prodal gang vozidlo "r"%s",GangHodnost(playerid),Gang[gid][GColor],Jmeno(playerid),GetVehicleName(model));
				SendGangMessage(gid,str);
    		}
	    }
	    return 1;
	}
	if(dialogid == GANG+13)
	{
	    if(response)
	    {
			new rows,fields,Cache:cache;
			cache = mysql_query(mysql,"SELECT * FROM  `Gangs` ORDER BY `Respect` DESC, `Bank` DESC");
			cache_get_data(rows,fields,mysql);
			new i = cache_get_field_content_int(listitem,"GangID",mysql);
			cache_delete(cache,mysql);
		    new DIALOG_G_INFO[2000];
			format(dfile,sizeof(dfile),GANG_FILE,i);
			if(dini_Int(dfile,"Owner") == -1)
			{
		    	format(str,sizeof(str),"{%s}Gang Info:\t                  \t                  \n"w"Boss:\t{%s}Nikdo\n"w"Respect:\t{%s}%d\n"w"Bank:\t"g"%d bodù\n"w"Popis:\t{%s}%s",Gang[i][GColor],Gang[i][GColor],Gang[i][GColor],Gang[i][GRespect],Gang[i][GBank],Gang[i][GColor],Gang[i][GPopis]);
			}
			else
			{
		    	format(str,sizeof(str),"{%s}Gang Info:\t                  \t                  \n"w"Boss:\t{%s}%s\n"w"Respect:\t{%s}%d\n"w"Bank:\t"g"%d bodù\n"w"Popis:\t{%s}%s",Gang[i][GColor],Gang[i][GColor],dini_Get(dfile,"Owner"),Gang[i][GColor],Gang[i][GRespect],Gang[i][GBank],Gang[i][GColor],Gang[i][GPopis]);
			}
			strcat(DIALOG_G_INFO,str);
		    format(str,sizeof(str),"\n\n{%s}Èlenové:\n",Gang[i][GColor]);
		    strcat(DIALOG_G_INFO,str);
			if(dini_Int(dfile,"Owner") != -1)
			{
				format(str,sizeof(str),""w"%s [ {%s}Boss "w"]\t{%s}%d Bodù\t{%s}%d RS\n",dini_Get(dfile,"Owner"),Gang[i][GColor],Gang[i][GColor],dini_Int(dfile,"OwnerBank"),Gang[i][GColor],dini_Int(dfile,"OwnerRespect"));
			    strcat(DIALOG_G_INFO,str);
			}
			new member[50],member2[50];
			for(new x; x < MAX_MEMBERS; x ++)
			{
			    format(str,sizeof(str),"Member[%d]",x);
			    format(member,sizeof(member),"MemberRespect[%d]",x);
			    format(member2,sizeof(member2),"MemberBank[%d]",x);
			    if(dini_Int(dfile,str) != -1)
			    {
					format(str,sizeof(str),""w"%s\t{%s}%d Bodù\t{%s}%d RS\n",dini_Get(dfile,str),Gang[i][GColor],dini_Int(dfile,member2),Gang[i][GColor],dini_Int(dfile,member));
      				strcat(DIALOG_G_INFO,str);
			    }
			}
		    format(str,sizeof(str),"\n\n{%s}Vozový park:\n",Gang[i][GColor]);
			strcat(DIALOG_G_INFO,str);
			for(new x; x < MAX_SLOTS; x ++)
			{
			    if(x < Gang[i][GSlots])
			    {
					format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",i,x);
					if(!fexist(dfile))
					{
					    format(str,sizeof(str),"Slot [ {%s}%d "w"]\t{898989}Volný slot\n",Gang[i][GColor],x+1);
					    strcat(DIALOG_G_INFO,str);
					}
					else
					{
					    format(str,sizeof(str),"Slot [ {%s}%d "w"]\t{%s}%s\n",Gang[i][GColor],x+1,Gang[i][GColor],GetVehicleName(dini_Int(dfile,"Model")));
					    strcat(DIALOG_G_INFO,str);
					}
			    }
			}
		    format(str,sizeof(str),"{%s}%s",Gang[i][GColor],Gang[i][GName]);
		    SPD(playerid,0,DIALOG_STYLE_TABLIST,str,DIALOG_G_INFO,"Zavøít","");
	    }
	    return 1;
	}
	if(dialogid == GANG+14)
	{
	    if(response)
	    {
	        new gid = GetPVarInt(playerid,"GangID"),member[50],member2[50], player = GetPVarInt(playerid,"ClickedPlayer");
			format(dfile,sizeof(dfile),GANG_FILE,gid);
			format(member,sizeof(member),"MemberFunction[%d](%d)",player,listitem);
			format(member2,sizeof(member2),"Member[%d]",player);
			if(dini_Int(dfile,member) == 0)
			{
			    dini_IntSet(dfile,member,1);
			    format(str,sizeof(str),"Nastavil si èlenu {%s}%s "w"pravomoc: {%s}%s",Gang[gid][GColor],dini_Get(dfile,member2),Gang[gid][GColor],Functions[listitem]);
			    SM(playerid,str);
			}
			else
			{
			    dini_IntSet(dfile,member,0);
			    format(str,sizeof(str),"Odnastavil si èlenu {%s}%s "w"pravomoc: {%s}%s",Gang[gid][GColor],dini_Get(dfile,member2),Gang[gid][GColor],Functions[listitem]);
			    SM(playerid,str);
			}
	        new DIALOG_FUNCTIONS[500];
	        for(new i; i < sizeof(Functions); i ++)
	        {
	            format(member,sizeof(member),"MemberFunction[%d](%d)",player,i);
	            if(dini_Int(dfile,member) == 0)
	            {
					format(str,sizeof(str),""r"%s\n",Functions[i]);
					strcat(DIALOG_FUNCTIONS,str);
	            }
	            else
	            {
					format(str,sizeof(str),""g"%s\n",Functions[i]);
					strcat(DIALOG_FUNCTIONS,str);
	            }
	        }
			new name[24];
	        GetPVarString(playerid,"ClickedPlayerName",name,sizeof(name));
	        format(str,sizeof(str),"Nastavit èlenské pravomoce hráèi {%s}%s",Gang[gid][GColor],name);
	        SPD(playerid,GANG+14,DIALOG_STYLE_LIST,str,DIALOG_FUNCTIONS,"Vybrat","Zavøít");
	    }
	    return 1;
	}
	if(dialogid == GANG+15)
	{
	    if(response)
	    {
	        new gid = GetPVarInt(playerid,"GangID");
			format(dfile,sizeof(dfile),GANG_FILE,gid);
			for(new i; i <= GetPlayerPoolSize(); i ++)
			{
			    if(GetInt(i,"Member") == gid)
			    {
			        SetInt(i,"Owner",0);
			        SetInt(i,"Member",0);
					Member[i] = 0;
					gOwner[i] = 0;
			        SetInt(i,"MemberPos",0);
			        SetInt(i,"MemberSpawn",0);
					Delete3DTextLabel(Text[i]);
			        SetPlayerTeam(i,255);
					for(new c; c < sizeof(Zones); c ++)
					{
					    GangZoneHideForPlayer(i,ZoneID[c]);
					}
					if(i != playerid)
					{
						format(str,sizeof(str),"%s "r"%s "w"zrušil gang {%s}%s"w", byl si propuštìn",GangHodnost(playerid),Jmeno(playerid),Gang[gid][GColor],Gang[gid][GName]);
					}
					else
					{
						format(str,sizeof(str),"Zrušil si gang {%s}%s"w", èlenové byli propuštìni, bylo ti vráceno %d bodù",Gang[gid][GColor],Gang[gid][GName],Gang[gid][GBank]);
					}
					SM(i,str);
			    }
			}
			GivePlayerPoints(playerid,Gang[gid][GBank]);
			for(new c; c < sizeof(Zones); c ++)
			{
			    GangZoneHideForPlayer(playerid,ZoneID[c]);
			}
			for(new x; x < sizeof(Zones); x ++)
			{
			    if(Zones[x][ZoneGang] == gid)
			    {
			        ChangeZoneOwner(x,-1);
			    }
			}
			CheckPlayerDrazbaGang(playerid,gid);
			dini_Set(dfile,"Name","Volný Gang");
			format(str,sizeof(str),"Volný Gang");
			Gang[gid][GName] = str;
			format(str,sizeof(str),"");
			Gang[gid][GSName] = str;
			Gang[gid][GRespect] = 0;
			format(str,sizeof(str),"0000FF");
			Gang[gid][GColor] = str;
			Gang[gid][GBank] = 0;
			format(str,sizeof(str),"-");
			dini_Set(dfile,"Popis","-");
			Gang[gid][GPopis] = str;
			Gang[gid][GSkin] = -1;
			dini_Set(dfile,"Color","0000FF");
			dini_IntSet(dfile,"Bank",0);
			dini_IntSet(dfile,"Skin",-1);
			dini_IntSet(dfile,"Respect",0);
			dini_IntSet(dfile,"Owner",-1);
			dini_IntSet(dfile,"OwnerSpawn",0);
			dini_IntSet(dfile,"OwnerBank",0);
			dini_IntSet(dfile,"OwnerRespect",0);
			dini_Set(dfile,"SpecialName","");
			new member[50];
			for(new i; i < MAX_MEMBERS; i ++)
			{
				format(member,sizeof(member),"Member[%d]",i);
				if(dini_Int(dfile,"Member") != -1)
				{
					format(dfile,sizeof(dfile),"UnNamed/%s.save",dini_Get(dfile,member));
					dini_Set(dfile,"Titul","VIP");
					dini_Set(dfile,"BarvaTitulu","FFFFFF");
				}
				format(dfile,sizeof(dfile),GANG_FILE,gid);
				dini_IntSet(dfile,member,-1);
				format(member,sizeof(member),"MemberSpawn[%d]",i);
				dini_IntSet(dfile,member,0);
				format(member,sizeof(member),"MemberRespect[%d]",i);
				dini_IntSet(dfile,member,0);
				format(member,sizeof(member),"MemberBank[%d]",i);
				dini_IntSet(dfile,member,0);
				for(new x; x < sizeof(Functions); x ++)
				{
					format(member,sizeof(member),"MemberFunction[%d](%d)",i,x);
					dini_IntSet(dfile,member,0);
				}
			}
		    format(str,sizeof(str),"Název: "b"Volný Gang\n"w"Boss: "r"Nikdo\n"w"Cena: "g"%d bodù",GANG_PRICE);
		    UpdateDynamic3DTextLabelText(Gang[gid][GText],bila,str);
			format(str,sizeof(str),"Hráè "g"%s "w"zrušil gang (%d)",Jmeno(playerid),gid);
			printEx(str);
		}
	}
	if(dialogid == GANG+16)
	{
	    if(response)
	    {
			new gid = GetPVarInt(playerid,"GangID");
			if(strlen(inputtext) > 50) return SPD(playerid,GANG+16,DIALOG_STYLE_INPUT,"Popis Gangu","Zadejte popis gangu [ Maximální délka je "r"50 znakù "dc"]","Zadat","Zrušit");
			if(strlen(inputtext) < 3) return SPD(playerid,GANG+16,DIALOG_STYLE_INPUT,"Popis Gangu","Zadejte popis gangu [ Minimální délka je "r"3 znaky "dc"]","Zadat","Zrušit");
			format(dfile,sizeof(dfile),GANG_FILE,gid);
			format(str,sizeof(str),inputtext);
			Gang[gid][GPopis] = str;
			dini_Set(dfile,"Popis",str);
			UpdateGangText(gid);
			format(str,sizeof(str),"Popis gangu upraven:\n{%s}%s",Gang[gid][GColor],inputtext);
			SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Popis gangu",str,"Zavøít","");
	    }
	    return 1;
	}
	if(dialogid == GANG+17)
	{
	    if(response)
	    {
			new slot = GetPVarInt(playerid,"GarageSlotID"),color1,color2;
			new gid = GetPVarInt(playerid,"GangID");
			if(SavedCar[gid][slot] == 0) return SM(playerid,"V slotu není žádné vozidlo");
			if(!sscanf(inputtext,"ii",color1,color2))
			{
			    if(color1 < 0 || color2 < 0) return SPD(playerid,GANG+17,DIALOG_STYLE_INPUT,"Pøelakovat vozidlo","Neplatné ID barvy","Zadat","Zavøít");
			    ParkInfo[gid][slot][Color1] = color1;
			    ParkInfo[gid][slot][Color2] = color2;
			}
			else if(!sscanf(inputtext,"i",color1))
			{
			    if(color1 < 0 || color2 < 0) return SPD(playerid,GANG+17,DIALOG_STYLE_INPUT,"Pøelakovat vozidlo","Neplatné ID barvy","Zadat","Zavøít");
			    ParkInfo[gid][slot][Color1] = color1;
			    ParkInfo[gid][slot][Color2] = 1;
			}
			else return SPD(playerid,GANG+17,DIALOG_STYLE_INPUT,"Pøelakovat vozidlo","Zadejte ID barvy","Zadat","Zavøít");
   			format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",gid,slot);
			if(!fexist(dfile)) return SM(playerid,"Vyskytla se chyba");
			dini_IntSet(dfile,"Color1",ParkInfo[gid][slot][Color1]);
			dini_IntSet(dfile,"Color2",ParkInfo[gid][slot][Color2]);
			ChangeVehicleColor(SavedCar[gid][slot],color1,color2);
			format(str,sizeof(str),"Barva zmìnìna [ Barva1: {%s}%d "w"| Barva2: {%s}%d "w"]",Gang[gid][GColor],color1,Gang[gid][GColor],color2);
			SM(playerid,str);
	    }
	    return 1;
	}
	if(dialogid == GANG+18)
	{
		if(response)
		{
			new slot = GetPVarInt(playerid,"GarageSlotID");
			new gid = GetPVarInt(playerid,"GangID");
   			format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",gid,slot);
			if(!fexist(dfile)) return SM(playerid,"Vyskytla se chyba");
			ParkInfo[gid][slot][PaintJob] = listitem;
			dini_IntSet(dfile,"PaintJob",ParkInfo[gid][slot][PaintJob]);
			if(listitem >= 0 && listitem < 3)
			{
				SM(playerid,"PaintJob zmìnìn");
			}
			else
			{
			    SM(playerid,"PaintJob odebrán");
			}
			ChangeVehiclePaintjob(SavedCar[gid][slot],listitem);
		}
		return 1;
	}
	if(dialogid == GANG+19)
	{
	    if(response)
	    {
	        new color,input[10];
			if(strlen(inputtext) < 6 || strlen(inputtext) > 6) return SPD(playerid,GANG+19,DIALOG_STYLE_INPUT,"Zmìna barvy","Zadejte kód barvy (napø. {00FF00}00FF00 "dc"je {00FF00}zelená"dc")\n\n"r"Chybnì zadaný kód","Zadat","Zavøít");
			format(input,sizeof(input),"%sFF",inputtext);
			if(sscanf(input,"x",color)) return SPD(playerid,GANG+19,DIALOG_STYLE_INPUT,"Zmìna barvy","Zadejte kód barvy (napø. {00FF00}00FF00 "dc"je {00FF00}zelená"dc")\n\n"r"Chybnì zadaný kód barvy","Zadat","Zavøít");
			if(color == 0) return SPD(playerid,GANG+19,DIALOG_STYLE_INPUT,"Zmìna barvy","Zadejte kód barvy (napø. {00FF00}00FF00 "dc"je {00FF00}zelená"dc")\n\n"r"Chybnì zadaný kód barvy","Zadat","Zavøít");
            new gid = GetPVarInt(playerid,"GangID");
            format(dfile,sizeof(dfile),GANG_FILE,gid);
            format(str,sizeof(str),"%06x",color >>> 8);
        	dini_Set(dfile,"Color",str);
        	Gang[gid][GColor] = str;
			UpdateGangText(gid);
		    format(str,sizeof(str),"Gang barva zmìnìn na {%06x}[ TUTO ]",color >>> 8);
		    SM(playerid,str);
		    for(new x; x < sizeof(Zones); x ++)
		    {
		        if(Zones[x][ZoneGang] == gid)
		        {
		            UpdateGangZoneColor(x);
		        }
		    }
		    for(new i; i <= GetPlayerPoolSize(); i ++)
		    {
		        if(GetInt(i,"Member") == gid)
		        {
					UpdateGangTitle(i);
		        }
		    }
   	    }
	    return 1;
	}
	if(dialogid == GANG+20)
	{
	    if(response)
	    {
	        new gid = GetPVarInt(playerid,"GangID"),cash;
	        if(sscanf(inputtext,"i",cash)) return SPD(playerid,GANG+20,DIALOG_STYLE_INPUT,"Vybrat body","Zadejte poèet bodù, který si pøejete "r"vybrat "dc"z gangu","Vložit","Zavøít");
			if(Gang[gid][GBank] < cash || Gang[gid][GBank] <= 0 || cash <= 0) return SPD(playerid,GANG+20,DIALOG_STYLE_INPUT,"Vybrat body","Tolik bodù v gangu nemáte","Vložit","Zavøít");
			if(cash < 1 || cash > 999999999) return SPD(playerid,GANG+20,DIALOG_STYLE_INPUT,"Vybrat body","Zadal jste pøíliš velkou/malou sumu","Vložit","Zavøít");
			format(dfile,sizeof(dfile),GANG_FILE,gid);
			if(GetInt(playerid,"Owner") > 0)
			{
				dini_IntSet(dfile,"OwnerBank",dini_Int(dfile,"OwnerBank")-cash);
			}
			else
			{
				new member[50];
				format(member,sizeof(member),"MemberBank[%d]",GetInt(playerid,"MemberPos"));
				dini_IntSet(dfile,member,dini_Int(dfile,member)-cash);
			}
			Gang[gid][GBank] -= cash;
			dini_IntSet(dfile,"Bank",Gang[gid][GBank]);
			DOF2_SaveFile();
			UpdateGangText(gid);
		    format(str,sizeof(str),"%s {%s}%s "w"vybral z gangu "g"%d bodù",GangHodnost(playerid),Gang[gid][GColor],Jmeno(playerid),cash);
		    SendGangMessage(gid,str);
		    format(str,sizeof(str),"Bank je nyní: "g"%d bodù",Gang[gid][GBank]);
		    SendGangMessage(gid,str);
		    GivePlayerPoints(playerid,cash);
		}
	    return 1;
	}
	if(dialogid == GANG+21)
	{
	    if(response)
	    {
	        new id = GetPVarInt(playerid,"LastID"),file[50];
	        if(!strlen(inputtext)) return SPD(playerid,GANG+21,DIALOG_STYLE_INPUT,Gang[id][GName],"Zadejte specialní název gangu","Nastavit","Zavøít");
			format(Gang[id][GSName],254,"%s",inputtext);
			format(file,sizeof(file),GANG_FILE,id);
			if(!fexist(dfile)) return SM(playerid,"Chyba: Soubor neexistuje");
			DOF2_SetString(dfile,"SpecialName",Gang[id][GSName]);
			DOF2_SaveFile();
			format(str,sizeof(str),"Speciální název gangu %s nastaven na %s",Gang[id][GName],inputtext);
			SPD(playerid,0,DIALOG_STYLE_MSGBOX,Gang[id][GSName],str,"Zavøít","");
			for(new i; i <= GetPlayerPoolSize(); i ++)
			    if(IPC(i))
			        if(GetPlayerGangMember(i) == id)
			            UpdateGangTitle(i);

	    }
	    return 1;
	}
	if(dialogid == GANG+22)
	{
	    if(response)
	    {
			new Cache:cache,query[250],DIALOG[2000],vehs;
			mysql_format(mysql,query,sizeof(query),"SELECT * FROM `GarageVehicles` WHERE `Kategorie`=%d ORDER BY `Price` DESC",listitem);
			cache = mysql_query(mysql,query);
			for(new i; i < cache_get_row_count(mysql); i ++)
			{
			    vehs ++;
			    format(str,sizeof(str),"%s\t{ffb15e}%d bodù\n",GetVehicleName(cache_get_field_content_int(i,"Model")),cache_get_field_content_int(i,"Price"));
			    strcat(DIALOG,str);
			}
			SetPVarInt(playerid,"CategoryID",listitem);
			if(vehs) SPD(playerid,GANG+11,DIALOG_STYLE_TABLIST,"Koupit vozidlo",DIALOG,"Vybrat","Zpìt");
			else SPD(playerid,0,DIALOG_STYLE_MSGBOX,"Koupit vozidlo","V této kategorii nejsou žádná vozidla","Zavøít","");
			cache_delete(cache,mysql);
	    }
	    return 1;
	}
	return 0;
}

forward SetGangMemberPos(playerid);

public SetGangMemberPos(playerid)
{
	if(GetPlayerGangMember(playerid) != -1)
	{
		SetPlayerPos(playerid,Gang[GetInt(playerid,"Member")][GX],Gang[GetInt(playerid,"Member")][GY],Gang[GetInt(playerid,"Member")][GZ]);
	}
	return 1;
}

forward GangChat(playerid,text[]);

public GangChat(playerid,text[])
{
	new gid = GetInt(playerid,"Member");
	if(gid > 0)
	{
	    format(str,sizeof(str),"{%s}[ Gang Chat | "w"%s: {%s}] "w"%s(%d): %s",Gang[gid][GColor],Gang[gid][GName],Gang[gid][GColor],Jmeno(playerid),playerid,text[1]);
		printEx(str);
	    format(str,sizeof(str),"{%s}[ Gang Chat ] "w"%s(%d): {%s}%s",Gang[gid][GColor],Jmeno(playerid),playerid,Gang[gid][GColor],text[1]);
		for(new i; i <= GetPlayerPoolSize(); i ++)
		{
		    if(IPC(i) && !IsPlayerNPC(i))
		    {
			    if(gid == GetInt(i,"Member"))
				{
				    SCM(i,bila,str);
				}
			}
		}
	    return 0;
	}
	return 1;
}

function ChangeGangOwner(gid,owner[])
{
	format(str,sizeof(str),"{adadad}Zmìna majitele gangu %s (%d) | %s -> %s |",Gang[gid][GName],gid,Gang[gid][Owner],owner);
	printEx(str);
	new id = GetPlayerIdFromName(Gang[gid][Owner]);
	if(IPC(id) && !IsPlayerNPC(id))
	{
	    SetInt(id,"Owner",0);
	    SetInt(id,"Member",0);
		for(new c; c < sizeof(Zones); c ++)
		{
		    GangZoneHideForPlayer(id,ZoneID[c]);
		}
		Delete3DTextLabel(Text[id]);
	}
	format(Gang[gid][Owner],24,owner);
	format(dfile,sizeof(dfile),GANG_FILE,gid);
	dini_Set(dfile,"Owner",owner);
	dini_IntSet(dfile,"OwnerSpawn",0);
	dini_IntSet(dfile,"OwnerBank",0);
	dini_IntSet(dfile,"OwnerRespect",0);
	dini_Set(dfile,"SpecialName","");
	id = GetPlayerIdFromName(owner);
	if(IPC(id) && !IsPlayerNPC(id))
	{
	    SetInt(id,"Owner",gid);
	    SetInt(id,"Member",gid);
		if(strlen(Gang[gid][GSName]) == 0)
		{
			format(str,sizeof(str),"{%s}%s",Gang[gid][GColor],Gang[gid][GName]);
		}
		else
		{
			format(str,sizeof(str),"{%s}%s",Gang[gid][GColor],Gang[gid][GSName]);
		}
		Text[id] = Create3DTextLabel(str,bila,0,0,0,50,-1,true);
		Attach3DTextLabelToPlayer(Text[id],id,0,0,0.5);
		SetPlayerTeam(id,gid);
		for(new c; c < sizeof(Zones); c ++)
		{
		    GangZoneShowForPlayer(id,ZoneID[c],GetZoneColor(c));
		}
	}
	UpdateGangText(gid);
	return 1;
}

function GetMaxGangs()
{
	return MAX_GANGS;
}

function NavigateToGang(playerid,id)
{
	return SetPlayerNavigation(playerid,Gang[id][GX],Gang[id][GY],Gang[id][GZ]);
}

function GetGangPos(id,Float:X,Float:Y,Float:Z)
{
	X = Gang[id][GX];
	Y = Gang[id][GY];
	Z = Gang[id][GZ];
}

function IsPlayerInGangWar(playerid)
{
	return GetPVarInt(playerid,"InWarState");
}

stock GetGangRealID(id)
{
	new rows,fields,Cache:cache;
	cache = mysql_query(mysql,"SELECT * FROM  `Gangs` ORDER BY `Respect` DESC, `Bank` DESC");
	cache_get_data(rows,fields,mysql);
	new gid = cache_get_field_content_int(id-1,"GangID",mysql);
	cache_delete(cache,mysql);
	format(dfile,sizeof(dfile),"GangSystem/Gang[%d].ini",gid);
	if(fexist(dfile)) return gid;
	return -1;
}

stock IsPlayerInDuel(playerid)
{
	return CallRemoteFunction("IsPlayerInDuel","i",playerid);
}

stock IsPlayerOnEvent(playerid)
{
	return CallRemoteFunction("IsPlayerOnEvent","i",playerid);
}

stock GetVehiclePrice(modelid)
{
    new price,query[300],Cache:cache;
    mysql_format(mysql,query,sizeof(query),"SELECT * FROM `GarageVehicles` WHERE `Model`=%d AND `Elite`=0 LIMIT 1",modelid);
	cache = mysql_query(mysql,query);
	if(cache_get_row_count(mysql) == 1)
	{
	    price = cache_get_field_content_int(0,"Price",mysql);
	}
	cache_delete(cache,mysql);
	return price;
}


stock ShowGarageCategories(playerid)
{
	new DIALOG[sizeof(GarageCategories)*30];
	for(new i; i < sizeof(GarageCategories); i ++)
	{
	    format(str,sizeof(str),"%s\n",GarageCategories[i][0]);
	    strcat(DIALOG,str);
	}
	SPD(playerid,GANG+22,DIALOG_STYLE_LIST,"Koupit vozidlo",DIALOG,"Vybrat","Zavøít");
	return 1;
}

stock GetPlayerKillerID(playerid)
{
	return CallRemoteFunction("GetPlayerKillerID","i",playerid);
}

stock SetPlayerSkinEx(playerid,skinid)
{
	return CallRemoteFunction("SetPlayerSkinEx","ii",playerid,skinid);
}

stock CheckPlayerDrazbaGang(playerid,gid)
{
	if(GetPlayerDrazbaStatus(playerid) == 1)
	{
	    if(GetPlayerDrazbaType(playerid) == 5)
	    {
		    if(gid == GetPlayerDrazbaItem(playerid))
		    {
		        ResetPlayerDrazba(playerid);
		        SM(playerid,"Gang, který dražíte už nevlastníte, dražba byla zrušena");
		    }
		}
	}
	return 1;
}

stock ResetPlayerDrazba(playerid)
{
	return CallRemoteFunction("ResetPlayerDrazba","i",playerid);
}

stock GetPlayerDrazbaItem(playerid)
{
	return CallRemoteFunction("GetPlayerDrazbaItem","i",playerid);
}

stock GetPlayerDrazbaStatus(playerid)
{
	return CallRemoteFunction("GetPlayerDrazbaStatus","i",playerid);
}

stock GetPlayerDrazbaType(playerid)
{
	return CallRemoteFunction("GetPlayerDrazbaType","i",playerid);
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

stock SetPlayerCameraAtPos(playerid,Float:X,Float:Y,Float:Z)
{
	return CallRemoteFunction("SetPlayerCameraAtPos","ifff",playerid,X,Y,Z);
}

stock SetPlayerNavigation(playerid,Float:X,Float:Y,Float:Z)
{
	return CallRemoteFunction("SetPlayerNavigation","ifff",playerid,X,Y,Z);
}

stock GetPoints(playerid)
{
	return CallRemoteFunction("GetPoints","i",playerid);
}

stock IsPlayerHasBlockedGangInvites(playerid)
{
	return CallRemoteFunction("IsPlayerHasBlockedGangInvites","i",playerid);
}

stock IsPlayerInDM(playerid)
{
	return CallRemoteFunction("IsPlayerInDM","i",playerid);
}

stock IsPlayerWorking(playerid)
{
	return CallRemoteFunction("IsPlayerWorking","i",playerid);
}

stock UpdateGangZoneColor(zoneid)
{
	for(new i; i <= GetPlayerPoolSize(); i ++)
	{
	    if(IsPlayerInGang(i))
	    {
	        GangZoneHideForPlayer(i,ZoneID[zoneid]);
	        GangZoneShowForPlayer(i,ZoneID[zoneid],GetZoneColor(zoneid));
	    }
	}
	return 1;
}

stock GetZoneOwner(zoneid)
{
	return Zones[zoneid][ZoneGang];
}

forward GetPlayerGangMember(playerid);

public GetPlayerGangMember(playerid)
{
	new gang;
	if(GetPlayerGang(playerid) > 0) gang = GetPlayerGang(playerid);
	else if(GetPlayerBoss(playerid) > 0) gang = GetPlayerBoss(playerid);
	else gang = -1;
	return gang;
}

stock IsPlayerInZone(playerid,zoneid)
{
	if(IsPlayerInArea(playerid,Zones[zoneid][ZoneMIX],Zones[zoneid][ZoneMIY],Zones[zoneid][ZoneMXX],Zones[zoneid][ZoneMXY])) return 1;
	return 0;
}

stock GetPlayerZone(playerid)
{
	new zone = -1;
	for(new i; i < sizeof(Zones); i ++)
	{
		if(IsPlayerInZone(playerid,i))
		{
		    zone = i;
		    break;
		}
	}
	return zone;
}

stock GetPlayersInZone(zoneid)
{
	new count;
	for(new i; i <= GetPlayerPoolSize(); i ++)
	{
		if(IsPlayerInGang(i))
		{
			if(IsPlayerInZone(playerid,zoneid))
			{
				count++;
			}
		}
	}
	return count;
}

stock GetGangPlayersInZone(zoneid,gid)
{
	new count;
	for(new i; i <= GetPlayerPoolSize(); i ++)
	{
		if(GetPlayerGangMember(i) == gid)
		{
			if(IsPlayerInZone(i,zoneid))
			{
				count++;
			}
		}
	}
	return count;
}

stock ChangeZoneOwner(zoneid,gid)
{
	new query[100];
	mysql_format(mysql,query,sizeof(query),"UPDATE `GangZones` SET `GangID`=%d WHERE `ZoneID`=%d",gid,zoneid);
	mysql_query(mysql,query,false);
	Zones[zoneid][ZoneGang] = gid;
	for(new i; i <= GetPlayerPoolSize(); i ++)
	{
		if(IsPlayerInGang(i))
		{
			GangZoneHideForPlayer(i,zoneid);
			GangZoneShowForPlayer(i,zoneid,GetZoneColor(zoneid));
		}
	}
	return 1;
}

stock GetZoneColor(zoneid)
{
	new color;
	if(Zones[zoneid][ZoneGang] != -1)
	{
		color = GetGangColor(Zones[zoneid][ZoneGang]);
	}
	else
	{
	    color = 0xADADAD90;
	}
	return color;
}

stock printEx(text[])
{
	return CallRemoteFunction("printEx","s",text);
}

stock GetPlayerSpawn(playerid)
{
	return CallRemoteFunction("GetPlayerSpawn","i",playerid);
}

stock SetPlayerSpawn(playerid,spawntype)
{
	return CallRemoteFunction("SetPlayerSpawn","ii",playerid,spawntype);
}


stock SaveGangs()
{
	for(new i = 1; i < MAX_GANGS; i ++)
	{
		new query[300],rows,fields;
		format(dfile,sizeof(dfile),GANG_FILE,i);
		mysql_format(mysql,query,sizeof(query),"SELECT * FROM `Gangs` WHERE `GangID` = %d",i);
		new Cache:cache = mysql_query(mysql,query,true);
		cache_get_data(rows,fields,mysql);
		if(!rows)
		{
		    mysql_format(mysql,query,sizeof(query),"INSERT INTO `Gangs` (`GangID`) VALUES ('%d')",i);
		    mysql_query(mysql,query,false);
		}
		mysql_format(mysql,query,sizeof(query),"UPDATE `Gangs` SET\
											 `Owner` = '%e', `Bank` = %d, `Respect` = %d, `Name` = '%e', `Popis` = '%e',\
						  					 `Color` = '%e', `OwnerBank` = %d, `OwnerRespect` = %d WHERE `GangID` = %d",\
											 dini_Get(dfile,"Owner"),Gang[i][GBank],Gang[i][GRespect],Gang[i][GName],Gang[i][GPopis],\
											 Gang[i][GColor],dini_Int(dfile,"OwnerBank"),dini_Int(dfile,"OwnerRespect"),i);
		mysql_query(mysql,query,false);
		cache_delete(cache,mysql);
		for(new x; x < MAX_MEMBERS; x ++)
		{
			mysql_format(mysql,query,sizeof(query),"SELECT * FROM `GangMembers` WHERE `GangID`= %d AND `MemberID` = %d",i,x);
			cache = mysql_query(mysql,query,true);
			cache_get_data(rows,fields,mysql);
			if(!rows)
			{
			    mysql_format(mysql,query,sizeof(query),"INSERT INTO `GangMembers` (`GangID`,`MemberID`) VALUES ('%d','%d')",i,x);
			    mysql_query(mysql,query,false);
			}
			new member1[70],member2[50],member3[50];
			format(member1,sizeof(member1),"Member[%d]",x);
			format(member2,sizeof(member2),"MemberRespect[%d]",x);
			format(member3,sizeof(member3),"MemberBank[%d]",x);
			mysql_format(mysql,query,sizeof(query),"UPDATE `GangMembers` SET `Nick` = '%s', `Respect` = %d, `Bank` = %d WHERE `MemberID` = %d AND `GangID` = %d",dini_Get(dfile,member1),dini_Get(dfile,member2),dini_Get(dfile,member3),x,i);
			mysql_query(mysql,query,false);
			cache_delete(cache,mysql);
		}
		for(new x; x < MAX_SLOTS; x ++)
		{
			mysql_format(mysql,query,sizeof(query),"SELECT * FROM `GangGarages` WHERE `GangID` = %d AND `SlotID` = %d",i,x);
			cache = mysql_query(mysql,query,true);
			cache_get_data(rows,fields,mysql);
			if(!rows)
			{
			    mysql_format(mysql,query,sizeof(query),"INSERT INTO `GangGarages` (`GangID`, `SlotID`) VALUES ('%d','%d')",i,x);
			    mysql_query(mysql,query,false);
			}
			mysql_format(mysql,query,sizeof(query),"UPDATE `GangGarages` SET `Model` = %d WHERE `SlotID` = %d AND `GangID` = %d",ParkInfo[i][x][Model],x,i);
			mysql_query(mysql,query,false);
			cache_delete(cache,mysql);
		}
	}
	return 1;
}

forward GetPlayerGang(playerid);
forward GetPlayerBoss(playerid);
forward GetPlayerMemberPos(playerid);
forward SetGangTeam(playerid,team);

stock IsPlayerInGang(playerid)
{
	new gang;
	if(GetPlayerGang(playerid) > 0) gang = 1;
	else if(GetPlayerBoss(playerid) > 0) gang = 1;
	else gang = 0;
	return gang;
}

public SetGangTeam(playerid,team)
{
	return SetPlayerTeam(playerid,team);
}

public GetPlayerGang(playerid)
{
	return GetInt(playerid,"Member");
}
public GetPlayerBoss(playerid)
{
	return GetInt(playerid,"Owner");
}
public GetPlayerMemberPos(playerid)
{
	return GetInt(playerid,"MemberPos");
}
//============================================================================//
stock IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY)
{
	new Float:X, Float:Y, Float:Z;

	GetPlayerPos(playerid, X, Y, Z);
	if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY) {
		return 1;
	}
	return 0;
}
//============================================================================//
stock IsPlayerPlayMusic(playerid)
{
	return CallRemoteFunction("IsPlayerPlayMusic","i",playerid);
}
//============================================================================//
stock GetGangColor(gang)
{
	new string[12],color;
	format(string,sizeof(string),"0x%s50",Gang[gang][GColor]);
	color = HexToInt(string);
	return color;
}
//============================================================================//
stock GetClickText(text[],what[])
{
	if(strfind(text,what,true) != -1) return 1;
	return 0;
}
//============================================================================//
stock GivePlayerPoints(playerid,Float:points,bool:drazba = false)
{
	return CallRemoteFunction("GivePlayerPoints","ifi",playerid,points,drazba);
}
//============================================================================//
stock UpdateGangTitle(playerid,text[] = "")
{
	new gid = GetInt(playerid,"Member"),strr[256];
	if(!strlen(text))
	{
		if(strlen(Gang[gid][GSName]) == 0)
		{
			format(strr,sizeof(strr),"{%s}%s",Gang[gid][GColor],Gang[gid][GName]);
		}
		else
		{
			format(strr,sizeof(strr),"{%s}%s",Gang[gid][GColor],Gang[gid][GSName]);
		}
	}
	else format(strr,sizeof(strr),"{%s}%s",Gang[gid][GColor],text);
	Update3DTextLabelText(Text[playerid],bila,strr);
	return 1;
}
//============================================================================//
stock GiveGangRS(gang,rs)
{
	Gang[gang][GRespect] += rs;
	if(Gang[gang][GRespect] < 0) Gang[gang][GRespect] = 0;
	format(dfile,sizeof(dfile),GANG_FILE,gang);
	dini_IntSet(dfile,"Respect",Gang[gang][GRespect]);
	UpdateGangText(gang);
	return 1;
}
//============================================================================//
forward UpdateGangText(gang);
public UpdateGangText(gang)
{
	new way[50];
	format(way,sizeof(way),GANG_FILE,gang);
	if(strlen(Gang[gang][GSName]) == 0)
	{
    	format(str,sizeof(str),"Název: {%s}%s\n"w"Boss: {0055FF}%s\n"w"Respect: "r"%d\n"w"Bank: "g"%d bodù",Gang[gang][GColor],Gang[gang][GName],dini_Get(way,"Owner"),Gang[gang][GRespect],Gang[gang][GBank]);
	}
	else
	{
    	format(str,sizeof(str),"Název: {%s}%s\n"w"Boss: {0055FF}%s\n"w"Respect: "r"%d\n"w"Bank: "g"%d bodù",Gang[gang][GColor],Gang[gang][GSName],dini_Get(way,"Owner"),Gang[gang][GRespect],Gang[gang][GBank]);
	}
	UpdateDynamic3DTextLabelText(Gang[gang][GText],bila,str);
	return 1;
}
//============================================================================//

//============================================================================//
stock CreateGang(Float:X,Float:Y,Float:Z)
{
	if(gangid < MAX_GANGS)
	{
		gangid++;
	    format(dfile,sizeof(dfile),GANG_FILE,gangid);
	    if(!fexist(dfile))
	    {
	        dini_Create(dfile);
	        dini_FloatSet(dfile,"X",X);
	        dini_FloatSet(dfile,"Y",Y);
	        dini_FloatSet(dfile,"Z",Z);
	        dini_IntSet(dfile,"Bank",0);
	        dini_IntSet(dfile,"Respect",0);
	        dini_IntSet(dfile,"Owner",-1);
	        dini_Set(dfile,"Name","Volný Gang");
	        dini_Set(dfile,"Color","0000FF");
	        dini_Set(dfile,"Popis","Gang na prodej");
			dini_IntSet(dfile,"Skin",-1);
			dini_IntSet(dfile,"OwnerSpawn",0);
			dini_IntSet(dfile,"OwnerRespect",0);
			dini_IntSet(dfile,"OwnerBank",0);
			for(new i; i < MAX_MEMBERS; i ++)
			{
			    format(str,sizeof(str),"Member[%d]",i);
			    dini_IntSet(dfile,str,-1);
			    format(str,sizeof(str),"MemberSpawn[%d]",i);
			    dini_IntSet(dfile,str,0);
			    format(str,sizeof(str),"MemberRespect[%d]",i);
			    dini_IntSet(dfile,str,0);
			    format(str,sizeof(str),"MemberBank[%d]",i);
			    dini_IntSet(dfile,str,0);
			    for(new x; x < sizeof(Functions); x ++)
			    {
			    	format(str,sizeof(str),"MemberFunction[%d](%d)",i,x);
				    dini_IntSet(dfile,str,0);
				}
			}
		}
		Gang[gangid][GX] = X;
		Gang[gangid][GY] = Y;
		Gang[gangid][GZ] = Z;
		format(Gang[gangid][Owner],24,dini_Get(dfile,"Owner"));
		Gang[gangid][GSlots] = dini_Int(dfile,"Slots");
		Gang[gangid][GRespect] = dini_Int(dfile,"Respect");
		Gang[gangid][GSkin] = dini_Int(dfile,"Skin");
		Gang[gangid][GName] = dini_Get(dfile,"Name");
		Gang[gangid][GBank] = dini_Int(dfile,"Bank");
		Gang[gangid][GColor] = dini_Get(dfile,"Color");
		Gang[gangid][GSName] = dini_Get(dfile,"SpecialName");
		Gang[gangid][GPopis] = dini_Get(dfile,"Popis");
		Gang[gangid][Audio] = dini_Int(dfile,"Audio");
		Gang[gangid][AudioStream] = dini_Get(dfile,"AudioStream");
		Gang[gangid][GPickup] = CreateDynamicPickup(1314,23,X,Y,Z,0,0);
		Gang[gangid][GMapIcon] = CreateDynamicMapIcon(X,Y,Z,23,0,0,0,-1);
		LoadGarageData(gangid);
		for(new x; x < MAX_SLOTS; x ++)
		{
			format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",gangid,x);
			if(fexist(dfile))
			{
			    SpawnCar(gangid,x);
			}
		}
	    format(dfile,sizeof(dfile),GANG_FILE,gangid);
		if(dini_Int(dfile,"Owner") == -1)
		{
		    format(str,sizeof(str),"Název: "b"Volný Gang\n"w"Boss: "r"Nikdo\n"w"Cena: "g"%d bodù",GANG_PRICE);
		    Gang[gangid][GText] = CreateDynamic3DTextLabel(str,bila,X,Y,Z,50,0,true);
		}
		else
		{
			if(strlen(Gang[gangid][GSName]) == 0)
			{
		    	format(str,sizeof(str),"Název: {%s}%s\n"w"Boss: {0055FF}%s\n"w"Respect: "r"%d\n"w"Bank: "g"%d bodù",Gang[gangid][GColor],Gang[gangid][GName],dini_Get(dfile,"Owner"),Gang[gangid][GRespect],Gang[gangid][GBank]);
			}
			else
			{
		    	format(str,sizeof(str),"Název: {%s}%s\n"w"Boss: {0055FF}%s\n"w"Respect: "r"%d\n"w"Bank: "g"%d bodù",Gang[gangid][GColor],Gang[gangid][GSName],dini_Get(dfile,"Owner"),Gang[gangid][GRespect],Gang[gangid][GBank]);
			}
			Gang[gangid][GText] = CreateDynamic3DTextLabel(str,bila,X,Y,Z,50,0,true);
		}
	}
	else
	{
		printf("Byl prekrocen limit gangu (%d), gang nebyl vytvoren",gangid+1);
	}
	return 1;
}
//============================================================================//
stock GangHodnost(playerid)
{
	new Name[24+1];
	if(GetInt(playerid,"Owner") > 0) Name = "Boss";
	else if(GetInt(playerid,"Member")) Name = "Èlen";
	else Name = "Chyba";
	return Name;
}
//============================================================================//
stock IsVehicleEmpty(vehicleid)
{
 	for(new i; i <= GetPlayerPoolSize(); i++)
  	{
    	if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == vehicleid) return 0;
  	}
  	return 1;
}
//============================================================================//
stock SendGangMessage(gang,text[])
{
	format(str,sizeof(str),"{%s}[ Gang System ] "w"%s{%s}.",Gang[gang][GColor],text,Gang[gang][GColor]);
	for(new i; i <= GetPlayerPoolSize(); i++)
	{
		if(IsPlayerConnected(i))
		{
			if(gang == GetInt(i,"Member"))
			{
				SCM(i,0xFFFFFFFF,str);
			}
		}
	}
	return 1;
}
//============================================================================//
stock AddGangRespect(gang,amount)
{
	new fajl[50];
	Gang[gang][GRespect] += amount;
	format(fajl,sizeof(fajl),GANG_FILE,gang);
	dini_IntSet(fajl,"Respect",Gang[gang][GRespect]);
	UpdateGangText(gang);
	return 1;
}
//============================================================================//
stock LoadGarageData(gang)
{
	for(new i; i < MAX_SLOTS; i ++)
	{
		format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",gang,i);
		if(fexist(dfile))
		{
		    ParkInfo[gang][i][pX] = dini_Float(dfile,"X");
		    ParkInfo[gang][i][pY] = dini_Float(dfile,"Y");
		    ParkInfo[gang][i][pZ] = dini_Float(dfile,"Z");
		    ParkInfo[gang][i][pA] = dini_Float(dfile,"A");
		    ParkInfo[gang][i][Model] = dini_Int(dfile,"Model");
		    ParkInfo[gang][i][Color1] = dini_Int(dfile,"Color1");
		    ParkInfo[gang][i][Color2] = dini_Int(dfile,"Color2");
		    ParkInfo[gang][i][PaintJob] = dini_Int(dfile,"PaintJob");
		    ParkInfo[gang][i][TuneSlot0] = dini_Int(dfile,"TuneSlot0");
		    ParkInfo[gang][i][TuneSlot1] = dini_Int(dfile,"TuneSlot1");
		    ParkInfo[gang][i][TuneSlot2] = dini_Int(dfile,"TuneSlot2");
		    ParkInfo[gang][i][TuneSlot3] = dini_Int(dfile,"TuneSlot3");
		    ParkInfo[gang][i][TuneSlot4] = dini_Int(dfile,"TuneSlot4");
		    ParkInfo[gang][i][TuneSlot5] = dini_Int(dfile,"TuneSlot5");
		    ParkInfo[gang][i][TuneSlot6] = dini_Int(dfile,"TuneSlot6");
		    ParkInfo[gang][i][TuneSlot7] = dini_Int(dfile,"TuneSlot7");
		    ParkInfo[gang][i][TuneSlot8] = dini_Int(dfile,"TuneSlot8");
		    ParkInfo[gang][i][TuneSlot9] = dini_Int(dfile,"TuneSlot9");
		    ParkInfo[gang][i][TuneSlot10] = dini_Int(dfile,"TuneSlot10");
		    ParkInfo[gang][i][TuneSlot11] = dini_Int(dfile,"TuneSlot11");
		    ParkInfo[gang][i][TuneSlot12] = dini_Int(dfile,"TuneSlot12");
		    ParkInfo[gang][i][TuneSlot13] = dini_Int(dfile,"TuneSlot13");
		}
	}
	return 1;
}
//============================================================================//
stock SpawnCar(gang,slot)
{
 	format(dfile,sizeof(dfile),"GangSystem/Vehicles/Gang%d[%d].txt",gang,slot);
	if(fexist(dfile))
	{
		DestroyVehicle(SavedCar[gang][slot]);
	    SavedCar[gang][slot] = 0;
		SavedCar[gang][slot] = CreateVehicle(ParkInfo[gang][slot][Model],ParkInfo[gang][slot][pX],ParkInfo[gang][slot][pY],ParkInfo[gang][slot][pZ],ParkInfo[gang][slot][pA],ParkInfo[gang][slot][Color1],ParkInfo[gang][slot][Color2],180);
		ChangeVehiclePaintjob(SavedCar[gang][slot],ParkInfo[gang][slot][PaintJob]);
		if(ParkInfo[gang][slot][TuneSlot0] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot0]);
		if(ParkInfo[gang][slot][TuneSlot1] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot1]);
		if(ParkInfo[gang][slot][TuneSlot2] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot2]);
		if(ParkInfo[gang][slot][TuneSlot3] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot3]);
		if(ParkInfo[gang][slot][TuneSlot4] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot4]);
		if(ParkInfo[gang][slot][TuneSlot5] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot5]);
		if(ParkInfo[gang][slot][TuneSlot6] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot6]);
		if(ParkInfo[gang][slot][TuneSlot7] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot7]);
		if(ParkInfo[gang][slot][TuneSlot8] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot8]);
		if(ParkInfo[gang][slot][TuneSlot9] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot9]);
		if(ParkInfo[gang][slot][TuneSlot10] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot10]);
		if(ParkInfo[gang][slot][TuneSlot11] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot11]);
		if(ParkInfo[gang][slot][TuneSlot12] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot12]);
		if(ParkInfo[gang][slot][TuneSlot13] != 0) AddVehicleComponent(SavedCar[gang][slot],ParkInfo[gang][slot][TuneSlot13]);
	}
	return 1;
}
//============================================================================//
stock SM(playerid,msg[])
{
	if(GetInt(playerid,"Member") != 0)
	{
		format(str,sizeof(str),"{%s}[ Gang System ] "w"%s{%s}.",Gang[GetInt(playerid,"Member")][GColor],msg,Gang[GetInt(playerid,"Member")][GColor]);
	}
	else
	{
		format(str,sizeof(str),"[ Gang System ] "w"%s{0055FF}.",msg);
	}
	SCM(playerid,0x0055FFFF,str);
	return 1;
}


stock CreateInfoTD(playerid)
{
	Textdraw0[playerid] = CreatePlayerTextDraw(playerid, 20.400028, 208.071105, "_");
	PlayerTextDrawLetterSize(playerid, Textdraw0[playerid], 0.239197, 1.191822);
	PlayerTextDrawTextSize(playerid, Textdraw0[playerid], 164.400161, 126.933250);
	PlayerTextDrawAlignment(playerid, Textdraw0[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw0[playerid], -1);
	PlayerTextDrawUseBox(playerid, Textdraw0[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw0[playerid], 120);
	PlayerTextDrawSetShadow(playerid, Textdraw0[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw0[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, Textdraw0[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw0[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw0[playerid], 1);

	return 1;
}

stock CreateInfoBox(playerid,text[],time = 5)
{
	PlayerTextDrawHide(playerid,InfoBox[playerid]);
	format(str,sizeof(str),"~w~%s",text);
	PlayerTextDrawSetString(playerid,InfoBox[playerid],str);
	PlayerTextDrawShow(playerid,InfoBox[playerid]);
	SetTimerEx("HideInfoBox",time*1000,false,"i",playerid);
	return 1;
}

forward HideInfoBox(playerid);

public HideInfoBox(playerid)
{
	PlayerTextDrawHide(playerid,InfoBox[playerid]);
}

stock CInfoBox(playerid,text[],time = 5)
{
/*	if(ShowedInfoBox[playerid] == false)
	{
		PlayerTextDrawHide(playerid,Textdraw0[playerid]);
		PlayerTextDrawSetString(playerid,Textdraw0[playerid],text);
		PlayerTextDrawShow(playerid,Textdraw0[playerid]);
		SetTimerEx("TDHide",time*1000,false,"i",playerid);

		ShowedInfoBox[playerid] = true;
	}
*/
	return CallRemoteFunction("CreateInfoBox","isi",playerid,text,time);
}
forward TDHide(playerid);

public TDHide(playerid)
{
	PlayerTextDrawHide(playerid,Textdraw0[playerid]);
	ShowedInfoBox[playerid] = false;
	return 1;
}

