-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb2+deb7u8
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 02, 2019 at 05:21 PM
-- Server version: 5.5.53
-- PHP Version: 5.4.45-0+deb7u5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `dgsamp`
--

-- --------------------------------------------------------

--
-- Table structure for table `Accounts`
--

CREATE TABLE IF NOT EXISTS `Accounts` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) CHARACTER SET utf8 NOT NULL,
  `IP` varchar(16) CHARACTER SET utf8 NOT NULL,
  `Created` int(11) NOT NULL,
  `Updated` int(11) NOT NULL,
  `GPCI` varchar(129) NOT NULL DEFAULT '-',
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=51697 ;

-- --------------------------------------------------------

--
-- Table structure for table `Achievements`
--

CREATE TABLE IF NOT EXISTS `Achievements` (
  `Nick` varchar(24) NOT NULL,
  `Status` text DEFAULT NULL,
  UNIQUE KEY `Nick` (`Nick`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Addons`
--

CREATE TABLE IF NOT EXISTS `Addons` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NICK` varchar(24) NOT NULL,
  `SLOT` int(11) NOT NULL,
  `ADDON_ID` int(11) DEFAULT NULL,
  `ADDON_MODEL` int(11) DEFAULT NULL,
  `X` float DEFAULT NULL,
  `Y` float DEFAULT NULL,
  `Z` float DEFAULT NULL,
  `RX` float DEFAULT NULL,
  `RY` float DEFAULT NULL,
  `RZ` float DEFAULT NULL,
  `SX` float DEFAULT NULL,
  `SY` float DEFAULT NULL,
  `SZ` float DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=861 ;

-- --------------------------------------------------------

--
-- Table structure for table `Bans`
--

CREATE TABLE IF NOT EXISTS `Bans` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `IP` varchar(16) NOT NULL,
  `Admin` varchar(24) NOT NULL,
  `Sign` varchar(24) NOT NULL DEFAULT 'unknown',
  `Reason` text NOT NULL,
  `Start` int(11) DEFAULT NULL,
  `End` int(11) DEFAULT NULL,
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=66 ;

-- --------------------------------------------------------

--
-- Table structure for table `Chat_buffer`
--

CREATE TABLE IF NOT EXISTS `Chat_buffer` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MSG` varchar(144) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `ADDITION` varchar(144) NOT NULL,
  `USER` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '-1',
  `SHOWED` int(1) NOT NULL DEFAULT '0',
  `TYPE` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=1954 ;

-- --------------------------------------------------------

--
-- Table structure for table `Codes`
--

CREATE TABLE IF NOT EXISTS `Codes` (
  `CODE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `CODE` varchar(50) NOT NULL,
  `CODE_TIME` int(10) NOT NULL,
  `CODE_BODY` int(11) DEFAULT NULL,
  `CODE_VIP` int(11) DEFAULT NULL,
  `CODE_XP` int(11) DEFAULT NULL,
  `CODE_VEHICLE` int(11) DEFAULT NULL,
  `CODE_TITUL` varchar(50) DEFAULT NULL,
  `CODE_AUTHOR` varchar(30) NOT NULL,
  `CODE_PICKER` varchar(30) DEFAULT NULL,
  `CODE_TIME_PICK` int(10) DEFAULT NULL,
  PRIMARY KEY (`CODE_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=378 ;

-- --------------------------------------------------------

--
-- Table structure for table `DGS_Records`
--

CREATE TABLE IF NOT EXISTS `DGS_Records` (
  `DGS_REC_ID` int(11) NOT NULL AUTO_INCREMENT,
  `DGS_REC_USER` varchar(32) NOT NULL,
  `DGS_REC_IP` varchar(30) NOT NULL,
  `DGS_REC_TIME` int(10) NOT NULL,
  `DGS_REC` text NOT NULL,
  PRIMARY KEY (`DGS_REC_ID`),
  UNIQUE KEY `DGS_REC_ID` (`DGS_REC_ID`),
  KEY `DGS_REC_ID_2` (`DGS_REC_ID`),
  KEY `DGS_REC_ID_3` (`DGS_REC_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=373 ;

-- --------------------------------------------------------

--
-- Table structure for table `Dotazy`
--

CREATE TABLE IF NOT EXISTS `Dotazy` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `Time` int(11) NOT NULL,
  `Dotaz` text NOT NULL,
  `Odpoved` text DEFAULT NULL,
  `Odpovezeno` int(11) DEFAULT 0,
  `Odpovedel` varchar(24) DEFAULT NULL,
  `Readed` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=6792 ;

-- --------------------------------------------------------

--
-- Table structure for table `EliteProps`
--

CREATE TABLE IF NOT EXISTS `EliteProps` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(32)  NOT NULL,
  `ElitePropID` int(11) NOT NULL,
  `Level` int(2) NOT NULL DEFAULT '1',
  `Earnings` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `GameAchievs`
--

CREATE TABLE IF NOT EXISTS `GameAchievs` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `AchievID` int(11) NOT NULL,
  `Date` varchar(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=19725 ;

-- --------------------------------------------------------

--
-- Table structure for table `GangGarages`
--

CREATE TABLE IF NOT EXISTS `GangGarages` (
  `GangID` int(11) NOT NULL,
  `SlotID` int(11) NOT NULL,
  `Model` int(11) DEFAULT NULL,
  UNIQUE KEY `GangID` (`GangID`,`SlotID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

-- --------------------------------------------------------

--
-- Table structure for table `GangMembers`
--

CREATE TABLE IF NOT EXISTS `GangMembers` (
  `GangID` int(11) NOT NULL,
  `MemberID` int(11) NOT NULL,
  `Nick` varchar(24) DEFAULT NULL,
  `Bank` int(11) DEFAULT NULL,
  `Respect` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Gangs`
--

CREATE TABLE IF NOT EXISTS `Gangs` (
  `GangID` int(11) NOT NULL,
  `Owner` varchar(255) DEFAULT NULL,
  `Bank` int(11) DEFAULT NULL,
  `Respect` int(11) DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Popis` varchar(256) DEFAULT NULL,
  `Color` varchar(255) DEFAULT NULL,
  `OwnerBank` int(11) DEFAULT NULL,
  `OwnerRespect` int(11) DEFAULT NULL,
  `OwnerLastActivity` int(11) DEFAULT NULL,
  `X` float DEFAULT NULL,
  `Y` float DEFAULT NULL,
  `Z` float DEFAULT NULL,
  UNIQUE KEY `ID_2` (`GangID`),
  KEY `ID` (`GangID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

-- --------------------------------------------------------

--
-- Table structure for table `GangZones`
--

CREATE TABLE IF NOT EXISTS `GangZones` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ZoneID` int(11) NOT NULL,
  `GangID` int(11) NOT NULL DEFAULT '-1',
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=285 ;

-- --------------------------------------------------------

--
-- Table structure for table `GarageVehicles`
--

CREATE TABLE IF NOT EXISTS `GarageVehicles` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Model` int(11) DEFAULT NULL,
  `Price` int(11) NOT NULL DEFAULT '0',
  `Kategorie` int(11) NOT NULL,
  `Elite` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=117 ;

-- --------------------------------------------------------

--
-- Table structure for table `Gifts`
--

CREATE TABLE IF NOT EXISTS `Gifts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) CHARACTER SET latin1 NOT NULL,
  `gift_id` int(11) NOT NULL,
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `Houses`
--

CREATE TABLE IF NOT EXISTS `Houses` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Owner` varchar(24) NOT NULL,
  `Name` varchar(64) NOT NULL,
  `Password` varchar(30) DEFAULT NULL,
  `Interior` int(11) NOT NULL,
  `Price` int(11) NOT NULL DEFAULT '0',
  `NeedHours` int(11) NOT NULL DEFAULT '10',
  `OwnerActivity` int(11) DEFAULT NULL,
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=1208 ;

-- --------------------------------------------------------

--
-- Table structure for table `Interiors`
--

CREATE TABLE IF NOT EXISTS `Interiors` (
  `ID` int(11) NOT NULL,
  `IntID` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `IntExit` int(11) NOT NULL DEFAULT '-1',
  `MapIcon` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Inzeraty`
--

CREATE TABLE IF NOT EXISTS `Inzeraty` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NICK` varchar(24) NOT NULL,
  `TEXT` varchar(128) NOT NULL,
  `DATE` int(11) NOT NULL,
  `ENDS` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `LoginLog`
--

CREATE TABLE IF NOT EXISTS `LoginLog` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `IP` varchar(16) NOT NULL,
  `Text` varchar(50) NOT NULL,
  `Time` int(11) NOT NULL,
  `Played` int(11) DEFAULT NULL,
  `AFK` int(11) DEFAULT NULL,
  `Events` int(11) DEFAULT NULL,
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=711721 ;

-- --------------------------------------------------------

--
-- Table structure for table `Maps`
--

CREATE TABLE IF NOT EXISTS `Maps` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MapID` int(11) NOT NULL,
  `Name` varchar(24) NOT NULL,
  `Autor` varchar(24) NOT NULL,
  `AutoLoad` int(11) DEFAULT 0,
  `VW` int(11) NOT NULL DEFAULT '-1',
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=129 ;

-- --------------------------------------------------------

--
-- Table structure for table `MapsObjects`
--

CREATE TABLE IF NOT EXISTS `MapsObjects` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MapID` int(11) NOT NULL,
  `ObjectID` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `rX` float NOT NULL,
  `rY` float NOT NULL,
  `rZ` float NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=7689 ;

-- --------------------------------------------------------

--
-- Table structure for table `Music`
--

CREATE TABLE IF NOT EXISTS `Music` (
  `MUSIC_ID` int(11) NOT NULL AUTO_INCREMENT,
  `MUSIC_NAME` text NOT NULL,
  `MUSIC_URL` text NOT NULL,
  `MUSIC_TIME` int(50) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  `MUSIC_HIDE` int(11) DEFAULT NULL,
  `MUSIC_PLAYED` int(11) DEFAULT NULL,
  `MUSIC_LENGHT` int(11) NOT NULL,
  `MUSIC_PINNED` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`MUSIC_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=151 ;

-- --------------------------------------------------------

--
-- Table structure for table `News`
--

CREATE TABLE IF NOT EXISTS `News` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATE` varchar(30) NOT NULL,
  `TEXT` text NOT NULL,
  `BUILD` float NOT NULL,
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=27 ;

--
-- Dumping data for table `News`
--

INSERT INTO `News` (`ID`, `DATE`, `TEXT`, `BUILD`) VALUES
(1, '18.6.2016', '• Přidány doplňky (/doplnky)\n• Přidán Walk of Fame (/chodnikslavy), na kterém se nachází elitní hráči.\n• Přidáno oznámení při vykrádání nemovitosti (pokud vám někdo bude vykrádat nemovitost,\n  zobrazí se Vám zpráva v chatu)', 1),
(2, '2.7.2016', '• Přidán příkaz /novinky\r\n• Při opuštění duelu/sumo zápasu/závodů atd. Vás to vrátí na pozici kde jste zadal příkaz pro připojení.\r\n• Upraveny odměny za mise\r\n• Přidána možnost označit hráče v chatu pomocí @ID', 2),
(3, '11.7.2016', '• Přidána možnost vystavit nemovitost nebo dům na prodej\r\n• Vylepšena Anti Spawn Kill ochrana\r\n• Přidány záložní trezory /trezor,  do těchto trezorů se peníze dostanou, z prodeje domu či nemovitosti\r\n• Přidány oznámení /oznameni\r\n• Přidána možnost nahlásit hráče (/report)\r\n• Přidána možnost si zakoupit na vozidlo pancíř (pouze u koupených vozidel /garaz)\r\n• Přidány nové těžší Achievementy', 3),
(4, '15.7.2016', '• Přidán příkaz /houseloc (Zobrazí pozici domu)\r\n• Přidán nový event (Special Derby)\r\n• /sc lze použít i bez povolení, stačí mít premium účet\r\n• Přidány inzeráty (/inzerat)', 4),
(5, '18.7.2016-20.7.2016', '• Vyznačení hráčů pro misi (policista - zločinci, zdravotník - ranění)\n• Přidáno možnost si vypnout opravu přes NUM 8 a flip přes NUM 4\n• Přidán automatický AFK režim (při 30 minutách neaktivity budete vyhozen za neaktivitu)\n• Přidány nové tunírny (by Domm)\n• Přidána odměna v podobě XPček za odehraný čas (pouze nonstop, každých 30 minut)', 5),
(6, '30.7.2016-5.8.2016 ', '• Přidán příkaz /zhulit\n• Přidáno více marihuanových polí\n• Přidán stánek s marihuanou na warpu /farma\n• Přidány hodnosti k vybraným povoláním.\n• Přidán příkaz /gangloc (Označí gang na mapě)\n• Předělán drop zbraní z hráče po smrti.\n• Přidán příkaz /pustitzbrane', 6),
(7, '8.8.2016', '• Přidány pozice k závodům\n• Přidán hitsound do /nastaveni\n• Přidán DeathMatch {00FF00}Minigun Madness, Area 51\n{FFFFFF}• Omezen počet hlášek (jedna hláška za 2 sekundy)', 7),
(8, '9.8.2016 - 12.8.2016', '• Přidána a dokončena dražba\n• Odebrány vozidla při gang válce\n• Přidány identifikační čísla u nemovitostí\n• Přidán příkaz /houseview (nastaví kameru na dům)\n• Přidán příkaz /propertyview (nastavní kameru na nemovitost)\n• Přidán příkaz /propertyloc (ožnačí nemovitost na mapě)\n• Přidán příkaz /gangview (nastaví kameru na gang)\n• Přidán příkaz /gangloc (označí gang na mapě)', 8),
(9, '22.8.2016', '• Přidány doplňky (/doplnky)\n• Přidán Walk of Fame (/chodnikslavy), na kterém se nachází elitní hráči.\n• Přidáno oznámení při vykrádání nemovitosti (pokud vám někdo bude vykrádat nemovitost,\n  zobrazí se Vám zpráva v chatu)', 9),
(10, '24.12.2016', 'Právě probíhají vánoční akce:\r\n• Sleva 50 % na vozidla\r\n• Sleva 30 % na doplňky\r\n• Sleva 35 % na body\r\n• 100 % XP Boost pro každého hned po napojení na server\r\n• Výdělky nemovitostí se navýšíly o 100% za hodinu', 10),
(11, '17.4.2017', '• Přidáno speciální vozidla: {00FF00}Wildfire XN1, Wildfire XN2, Thunder ZX1, Thunder ZX2, Comet XR1{FFFFFF}\r\n• Upraveno kupování vozidel v garáži (Nově roztříděno do kategorii)\r\n• Přidáno nad nick upozornění, pokud se hráč účastní gang waru\r\n• Přidána hodnost "Legenda", která je možnost získat po dosažení 1000 hodin a 100. levelu nebo vám ji udělí administrátor.\r\n  Výhody: {FFFF00}zlatý titul Legenda, Warp block 12 warpů za minutu, /odpocet 1 - 10 sekund, zvýrazený nick na /chodnikslavy', 11),
(12, '21.5.2017', '• Přidáno 5 nových speciálních vozidel Bull serie: {00FF00}Bull ZX1, Bull BX1, Bull XN1, Bull RX1, Bull XZ1\r\n{FFFFFF}• Kompletně předělán duel systém {00FF00}(přidáno více kol, a místností)\r\n{FFFFFF}• Přidán příkaz /mytime pro vip hráče\r\n• Upraven event Special Derby\r\n', 12),
(13, '3.8.2017', '• Přidány 3 nová speciální vozidla {00FF00}Bull CX1, Cheetah ZX1, Bull 420\r\n{FFFFFF}• Přidáno 40 nových stuntů /stunt (*id)\r\n• Přidány 4 nové achievementy: {FFFF00}Stunter Noob, Stunter Amateur, Stunt Master, Stunter Elite\r\n{FFFFFF}• Přidán příkaz {00FF00}/myweather {FFFFFF}pro VIP hráče, příkaz nastaví vlastní počasí', 13),
(14, '4.8.2017', '• Přidáno 10 nových těžkých stuntů {00FF00}/stunt\r\n{FFFFFF}• Přidáno stránkování do {0077FF}/achiev{FFFFFF}\r\n• Pokud dosáhnete nového levelu zobrazí se to v textdraw chatu,\r\n  pokud dosáhnete kulatého levelu (končíci na 0) zobrazí se to v chatu\r\n• Přidáno do {0077FF}/tops {FFFFFF}"Nejvíce dokončených stuntů"\r\n• Přidány nové gang zony v Los Santos', 14),
(15, '10.8.2017', '• Přidán nový systém trestných bodů více info {00FF00}/help - Trestné body{FFFFFF}\r\n• Aktualizováno help\r\n• Přidáno 6 nových stuntů\r\n• Zjednodušen {00FF00}/inzerat{FFFFFF}, přidáno automatické připomenutí\r\n• Přidány 3 nové hlášky {00FF00}/cg, /np, /facepalm{FFFFFF}', 15),
(16, '11.8.2017', '• Přidáno 9 nových stuntů\r\n• Přidána možnost editovat doplněk\r\n• Přidány kategorie a další vozidla do gang garáže (kupování vozidel)\r\n• Přidána možnost přeparkovat gang vozidlo', 16),
(17, '15.8.2017', '• Přidán hod mincí, hodit si můžete příkazem {00FF00}/mince{FFFFFF}\r\n• Přidán hod kostkou, kostou si hodíte příkazem {00FF00}/kostka{FFFFFF}\r\n• Upraven příkaz {00FF00}/warpy{FFFFFF}\r\n• Přidána navigace, tu aktivujete příkazem {00FF00}/gps{FFFFFF}\r\n• Přidán příkaz {00FF00}/pjobs{FFFFFF}, který zobrazí povolání online hráčů\r\n• Přidány 4 nové stunty', 17),
(18, '2.9.2017', '• Přidán nový event PUBG na motivy hry Playerunknown''s Battlegrounds,\r\n  event navrh a pomohl vytvořit hráč {00FF00}...RazoR...{FFFFFF}\r\n• Přidán příkaz {00FF00}/muteplayer{FFFFFF}, tímto příkazem si umlčíte hráče v chatu (neuvidíte jeho zprávy)\r\n• Přidán příkaz {00FF00}/muteplayers{FFFFFF}, tímto příkazem zobrazíte seznam hráčů, kteří si vás umlčeli,\r\n  nebo hráče které jste si umlčeli vy\r\n• Přidána možnost si bloknout výzvy na hod kostkou, možnost najdete v {FF0000}/nastaveni {FFFFFF}\r\n• Přidány výbavy, můžete si nastavit až 5 výbav, z toho 1 je spawn výbava.\r\n  Do výbav si můžete nastavit zbraně a dle potřeby je načítat,\r\n  výbavy zobrazíte příkazem {00FF00}/vybava{FFFFFF} (pouze pro VIP hráče)\r\n• Přidána 4 nová speciální vozidla ({00FF00}Infernus Bull-RX, Bullet Bull-ZX, Quad-R, NRG-R{FFFFFF})', 18),
(19, '9.9.2017', '• Přidán proAFKovaný čas v {00FF00}/info, /logprihlaseni{FFFFFF}\r\n• Přejmenováno vozidlo Bullet Bull-ZX na Bullet-R\r\n• Změněn typ dialogu u {00FF00}/info', 18.1),
(20, '5.10.2017', '• Vyhazování za AFK sníženo na 15 minut\n• Opravena chyba ukládání AFK v /logprihlaseni\n• XP Booster neplatí pro XP od administrátora', 18.2),
(21, '22.12.2017', '• Upravená kamera při připojení na server\r\n• Upraven event Team DeathMatch a DeathMatch\r\n• Přidána tombola, vylosování probíhá každý den v 18:00 -> {00FF00}/tombola\r\n{FFFFFF}• Přidán nový event GunGame\r\n• Přidána možnost zápisného k závodům', 19),
(22, '3.3.2018', '• Aktualizace na nového klienta 0.3.DL\r\n• Přidány nové skiny k zakoupení v {00FF00}/shop{FFFFFF}\r\n• Přidán E-Mail do {00FF00}/nastaveni{FFFFFF}, slouží případném obnovení zapomenutého hesla,\r\n  bez něj zapomenuté heslo neobnovíte!\r\n• Přidány automatické eventy každých 30 minut (pokud je na serveru 15 a více hráčů)', 20),
(23, '15.7.2018', '• Odstraněny nové skiny z důvodu přechodu na starší verzi SA:MP, utracené body vráceny\r\n• Odstraněno automatické hide a příkaz /unhide\r\n• Příkaz /hide je nyní omezen na čas a za poplatek', 20.1),
(24, '1.9.2018', '• Nové nemovitosti {00FF00}"Výrobny zbraní"{FFFFFF}, každý hráč může vlastnit jednu, více informací {00FF00}/help - Výrobna zbraní{FFFFFF}\r\n• Přidána kasa k nemovitosti, každá nemovitost má kasu, do kteŕe se vejde nějaké množství peněz (podle levelu kasy)\r\n• Přidán příkaz {00FF00}/bvgoto {FFFFFF}a {00FF00}/bkostka {FFFFFF}(bloknutí /vgoto a /kostka od určitého hráče)\r\n• Přidány /doplnky do /shop\r\n• Přidán příkaz {00FF00}/vozidla {FFFFFF}(pro zjištění cen vozidel pokud máte plnou garáž)\r\n• /help doplněn o Minci a Kostku a výrobnu zbraní\r\n• Upraven způsob vylepšování nemovitostí, upraven maximální level na 20\r\n• Upraveny výdělky u misí podle nových levelů (max. 40 levelů)\r\n• Skóre v TAB upraveno z množství peněz na množšství bodů\r\n• Opravena chyba @ID (nyní už to neodkazuje při dlouhém textu na ID 0)\r\n• Opraveno GPS (při vybrání hasiče někdy označovalo SBS)\r\n• Upraveno zaměstnání Právník, přidána /taxa (účtování za vysouzení)', 21),
(25, '21.11.2018', '• Přidány denní výzvy ({00FF00}/daily{FFFFFF})\r\n• Za vyhrané postřehy se nově dávají místo peněz body\r\n• Přidáno speciální vozidlo Dýně', 21.1),
(26, '12.3.2019', '• Přidáno násobení odměna za postřeh v případě výhry za sebou (až x5)', 21.2);

-- --------------------------------------------------------

--
-- Table structure for table `Notifications`
--

CREATE TABLE IF NOT EXISTS `Notifications` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Date` int(11) NOT NULL,
  `Nick` varchar(24) NOT NULL,
  `Nadpis` varchar(50) NOT NULL,
  `Text` text NOT NULL,
  `Readed` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=16381 ;

-- --------------------------------------------------------

--
-- Table structure for table `OnlineUsers`
--

CREATE TABLE IF NOT EXISTS `OnlineUsers` (
  `ID` int(11) NOT NULL,
  `Nick` varchar(24) NOT NULL,
  `IP` varchar(16) NOT NULL,
  `X` float DEFAULT NULL,
  `Y` float DEFAULT NULL,
  `Z` float DEFAULT NULL,
  `Money` int(11) DEFAULT NULL,
  `Points` float DEFAULT NULL,
  `Vehicle` int(11) DEFAULT NULL,
  `Skin` int(11) DEFAULT NULL,
  `Connect` int(11) DEFAULT NULL,
  `Country` varchar(50) DEFAULT NULL,
  `GPCI` varchar(128) DEFAULT NULL,
  `old_X` float DEFAULT '0',
  `old_Y` float DEFAULT '0',
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Packages`
--

CREATE TABLE IF NOT EXISTS `Packages` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Finded` int(11) DEFAULT 0,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=165 ;

-- --------------------------------------------------------

--
-- Table structure for table `PlayerPackages`
--

CREATE TABLE IF NOT EXISTS `PlayerPackages` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `PackageID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=646 ;

-- --------------------------------------------------------

--
-- Table structure for table `PMLog`
--

CREATE TABLE IF NOT EXISTS `PMLog` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PM_TIME` int(11) NOT NULL,
  `PM_SENDER` varchar(24) NOT NULL,
  `PM_RECEIVER` varchar(24) NOT NULL,
  `PM_TEXT` varchar(144) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=1250522 ;

-- --------------------------------------------------------

--
-- Table structure for table `Positions`
--

CREATE TABLE IF NOT EXISTS `Positions` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Name` varchar(24) NOT NULL,
  `Nick` varchar(24) NOT NULL,
  `VW` int(11) NOT NULL,
  `INTERIOR` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=39 ;

-- --------------------------------------------------------

--
-- Table structure for table `Prestupky`
--

CREATE TABLE IF NOT EXISTS `Prestupky` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `IP` varchar(16) NOT NULL,
  `Type` int(11) NOT NULL,
  `Admin` varchar(24) NOT NULL,
  `Sign` varchar(24) NOT NULL DEFAULT 'unknown',
  `Reason` text NOT NULL,
  `Time` int(11) NOT NULL,
  `EndTime` int(11) NOT NULL,
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=18755 ;

-- --------------------------------------------------------

--
-- Table structure for table `Properties`
--

CREATE TABLE IF NOT EXISTS `Properties` (
  `PropertyID` int(11) NOT NULL,
  `Owner` varchar(24) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Level` int(11) NOT NULL,
  `Earnings` int(11) NOT NULL,
  UNIQUE KEY `PropertyID` (`PropertyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Reports`
--

CREATE TABLE IF NOT EXISTS `Reports` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `Duvod` text NOT NULL,
  `Reporter` varchar(24) NOT NULL,
  `Date` int(11) NOT NULL,
  `Status` int(11) NOT NULL DEFAULT '0',
  `Solved` varchar(24) NOT NULL DEFAULT '-',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=2598 ;

-- --------------------------------------------------------

--
-- Table structure for table `ServerLog`
--

CREATE TABLE IF NOT EXISTS `ServerLog` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Time` int(11) DEFAULT NULL,
  `Text` text,
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=23988540 ;

-- --------------------------------------------------------

--
-- Table structure for table `ServerVehicles`
--

CREATE TABLE IF NOT EXISTS `ServerVehicles` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ModelID` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `A` float NOT NULL,
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=641 ;

--
-- Dumping data for table `ServerVehicles`
--


INSERT INTO `ServerVehicles` (`ID`, `ModelID`, `X`, `Y`, `Z`, `A`) VALUES
(1, 576, 2356.42, -1160.61, 27.127, 272.942),
(2, 576, 2346, -1160.59, 26.888, 270.448),
(3, 536, 2217.45, -1161.15, 25.464, 90.072),
(4, 535, 2228.77, -1170.07, 25.504, 268.497),
(5, 567, 2490.48, -1682.35, 13.209, 266.728),
(6, 536, 2486.59, -1655.34, 13.071, 91.16),
(7, 534, 1879.34, -2021.65, 13.115, 178.56),
(8, 535, 1885.38, -2034.16, 13.153, 13.084),
(9, 534, 1926.12, -1788.89, 13.111, 269.814),
(10, 535, 1794.71, -1932.13, 13.15, 178.532),
(11, 536, 2055.86, -1904.09, 13.284, 356.7),
(12, 567, 2188.59, -1908.81, 13.412, 359.607),
(13, 576, 2329.75, -1987.22, 13.158, 1.401),
(14, 534, 2530.18, -2012.18, 13.277, 83.76),
(15, 535, 2489.17, -1953.43, 13.188, 179.744),
(16, 536, 2513.23, -1784.34, 13.286, 264.475),
(17, 567, 2263.82, -1751.23, 13.253, 268.499),
(18, 576, 2173.01, -1676.31, 14.686, 317.421),
(19, 534, 2019.4, -1648.73, 13.278, 89.158),
(20, 535, 2111.93, -1782.41, 13.15, 179.934),
(21, 536, 1997.39, -1118.81, 26.511, 221.05),
(22, 576, 2123.36, -1142.13, 24.528, 342.755),
(23, 534, 2030.2, -965.795, 40.452, 195.777),
(24, 535, 2270.01, -1041.99, 50.489, 141.974),
(25, 536, 2453.93, -1020.03, 59.236, 175.803),
(26, 567, 2601.3, -1062.26, 69.456, 26.345),
(27, 534, 2503.38, -960.725, 82.003, 175.706),
(28, 535, 2659.67, -1131.08, 65.212, 91.823),
(29, 536, 2827.34, -1181.31, 24.78, 260.913),
(31, 534, 2783.22, -1250.07, 47.389, 178.743),
(32, 535, 2585.69, -1411.97, 24.878, 85.533),
(33, 536, 2537.37, -1474.98, 23.752, 268.803),
(34, 567, 2391.32, -1487.07, 23.696, 89.307),
(35, 576, 2337.34, -1370.63, 23.613, 174.044),
(36, 534, 2270.86, -1434.09, 23.554, 357.903),
(37, 535, 2137.85, -1370.95, 24.189, 181.873),
(38, 536, 1997.22, -1275.29, 23.558, 359.655),
(39, 567, 2745.72, -1463.85, 30.326, 359.981),
(41, 534, 2859.33, -1912.17, 10.656, 7.001),
(42, 535, 2562.52, -1244.52, 46.309, 183.636),
(43, 536, 2299.16, -1636.24, 14.42, 201.389),
(44, 536, 2756.72, -1962.74, 13.284, 0.072),
(45, 567, 2129.41, -1483.61, 23.669, 357.33),
(46, 451, 487.405, -1511.26, 20.055, 5.387),
(47, 451, 653.84, -1657.23, 14.303, 90.766),
(48, 429, 639.947, -1547.24, 14.889, 358.446),
(49, 402, 625.469, -1304.7, 14.176, 177.95),
(50, 541, 732.441, -1189.34, 19.448, 321.433),
(51, 451, 1051.53, -1298.21, 13.287, 179.561),
(52, 471, 1065.43, -1162.15, 23.688, 2.67),
(53, 411, 1252.83, -1152.97, 23.372, 270.804),
(54, 451, 1334.07, -1061.82, 27.84, 266.759),
(55, 451, 1180.17, -913.481, 42.951, 188.576),
(56, 429, 957.921, -961.074, 38.997, 102.613),
(57, 402, 1108.09, -1025.81, 31.765, 187.252),
(58, 541, 953.242, -1381.08, 12.969, 181.209),
(59, 451, 815.082, -1408.83, 13.134, 269.509),
(60, 471, 781.813, -1622.94, 13.359, 272.8),
(61, 471, 992.411, -1883.81, 10.863, 158.088),
(62, 471, 650.022, -1881.95, 3.97, 131.889),
(63, 471, 306.187, -1872.82, 2.341, 184.785),
(65, 451, 458.798, -1811.04, 5.254, 88.17),
(66, 451, 169.986, -1547.22, 11.866, 328.714),
(67, 429, 892.873, -1668.98, 13.23, 1.015),
(68, 402, 1098.71, -1758.04, 13.184, 272.152),
(69, 541, 1125.96, -1559.52, 13.335, 182.773),
(70, 451, 1032.78, -1506.76, 13.378, 308.813),
(71, 423, 379.187, -2046.17, 7.852, 57.342),
(72, 471, 1283.84, -1612.33, 13.514, 269.016),
(73, 411, 1358.07, -1752.09, 13.096, 358.467),
(74, 451, 1713.82, -1069.58, 23.611, 179.539),
(75, 451, 1558.11, -1012.28, 23.611, 184.605),
(76, 429, 1326, -1450.13, 13.167, 278.733),
(77, 402, 1467.66, -1235.74, 13.466, 92.308),
(79, 451, 1248.44, -2032.4, 59.593, 269.765),
(80, 411, 1549.3, -2360.62, 13.281, 181.474),
(81, 451, 1395.42, -2208, 13.247, 0.902),
(82, 451, 1574.01, -1879.36, 13.251, 272.588),
(83, 429, 1766.09, -1702.81, 13.151, 89.657),
(84, 402, 1730.16, -1276.99, 13.385, 137.6),
(85, 541, 1279.01, -1378.39, 12.894, 359.933),
(90, 429, 568.652, -1132.13, 50.284, 209.62),
(91, 541, 1028.86, -810.345, 101.477, 16.769),
(92, 443, 2616.09, -2229.28, 13.894, 270.277),
(93, 515, 2488.32, -2671.12, 14.657, 86.304),
(94, 446, 2490.05, -2268.25, -0.433, 90.431),
(95, 446, 2355.96, -2531.54, -0.25, 1.897),
(96, 406, 2206.57, -2523.04, 15.096, 269.604),
(97, 525, 2232.69, -2227.97, 13.429, 314.705),
(98, 443, 2322.71, -2073.36, 14.189, 273.846),
(99, 515, 2102.58, -2074.62, 14.58, 210.966),
(100, 423, 380.098, -2040.3, 7.856, 53.585),
(101, 515, 2497.03, -2619.11, 14.657, 92.054),
(102, 515, 2497.97, -2609.89, 14.666, 91.318),
(103, 515, 2497.81, -2604.39, 14.669, 90.705),
(104, 435, 2461.73, -2593.12, 14.288, 271.316),
(105, 435, 2463.87, -2584.58, 14.124, 273.689),
(106, 435, 2506.88, -2630.36, 14.278, 94.63),
(107, 431, 1080.19, -1772.71, 13.445, 269.332),
(108, 431, 1081.12, -1766.31, 13.463, 270.371),
(109, 431, 1080.39, -1760.94, 13.473, 269.969),
(110, 408, 2281.74, -2316.4, 14.08, 225.072),
(111, 408, 2272.37, -2325.79, 14.08, 225.072),
(112, 525, 2785.35, -1834.66, 9.713, 222.924),
(113, 525, 2781.31, -1837.88, 9.67, 213.878),
(114, 525, 2776.54, -1839.71, 9.649, 199.473),
(115, 490, 758.068, -1337.81, 13.586, 266.809),
(116, 490, 781.449, -1340.65, 13.596, 186.251),
(117, 420, 2148.39, -1171.09, 23.601, 89.425),
(118, 420, 2160.99, -1178.17, 23.599, 90.616),
(119, 420, 2148.77, -1161.8, 23.604, 269.34),
(120, 409, 2431.54, -1222.91, 25.057, 90.364),
(121, 510, 1946.73, -1381.13, 18.179, 131.302),
(122, 510, 1876.98, -1403.57, 13.174, 346.029),
(123, 510, 1905.31, -1443.33, 13.116, 233.343),
(124, 510, 1969.43, -1444.64, 13.136, 23.202),
(125, 522, 1970.99, -1426.06, 13.122, 88.005),
(126, 522, 1914.22, -1408.21, 13.115, 14.158),
(128, 560, 1281.47, -828.656, 82.847, 84.668),
(639, 525, 1941.51, 2176.03, 10.694, 91.962),
(130, 406, 2686.62, -1672.55, 10.094, 177.108),
(131, 556, 2657.75, -1697.1, 9.693, 271.129),
(132, 443, 2790.79, -2400.31, 14.07, 88.321),
(133, 406, 2596.74, -2424.94, 14.992, 44.414),
(134, 579, 2752.61, -2396.77, 13.63, 108.84),
(135, 579, 2752.35, -2423.19, 13.629, 18.841),
(136, 515, 2745.87, -2390.52, 14.661, 83.475),
(137, 416, 2032.71, -1436.21, 17.365, 359.926),
(138, 416, 2012.03, -1415.3, 17.141, 267.315),
(139, 416, 1179.17, -1308.6, 13.929, 266.141),
(140, 407, 1749.75, -1457.29, 13.776, 270.425),
(141, 490, 1569.91, -1709.94, 6.021, 178.08),
(142, 596, 1547.42, -1610.65, 13.104, 273.221),
(143, 427, 1603.01, -1696.27, 6.036, 269.385),
(144, 596, 1536.03, -1673.83, 13.103, 1.097),
(145, 485, 1975.6, -2181.5, 13.207, 177.355),
(146, 485, 1981.27, -2181.66, 13.205, 180.189),
(147, 519, 1455.93, -2453.21, 14.474, 187.888),
(148, 519, 1953.71, -2639.21, 14.469, 16.185),
(149, 513, 2062.16, -2551.97, 14.078, 30.715),
(150, 513, 1906.76, -2448.96, 14.915, 185.565),
(151, 487, 1972.72, -2306.74, 13.705, 180.618),
(152, 411, 1693.76, -2249.86, 13.11, 88.116),
(153, 576, 1672.6, -2249.98, 12.996, 91.261),
(155, 569, 1701.66, -1953.66, 15.099, 89.816),
(156, 569, 1701.66, -1953.66, 15.099, 89.816),
(157, 569, 1701.66, -1953.66, 15.099, 89.816),
(158, 579, -213.664, 2595.31, 62.638, 359.451),
(159, 463, -275.996, 2719.58, 62.154, 178.117),
(160, 463, -172.786, 2720.21, 62.02, 90.603),
(161, 579, -771.032, 2752.38, 45.672, 208.618),
(162, 463, -1399.53, 2628.29, 55.326, 87.426),
(163, 402, -1596.19, 2686.35, 54.782, 176.716),
(164, 416, -1522.31, 2525.45, 55.862, 1.092),
(165, 471, -1934.78, 2376.91, 49.281, 291.905),
(168, 487, -2227.43, 2326.9, 7.723, 181.223),
(169, 541, -2304.14, 2418.35, 4.651, 134.91),
(170, 541, -1808.62, 2043.36, 8.632, 298.302),
(171, 468, -1043.37, 1555.42, 32.936, 141.544),
(172, 579, -866.388, 1566.41, 24.722, 267.78),
(173, 510, -765.448, 1604.69, 26.723, 83.056),
(174, 521, -722.109, 1438.23, 18.044, 126.353),
(175, 556, -705.127, 963.534, 12.808, 118.927),
(176, 515, -355.703, 1156.07, 20.746, 251.637),
(177, 579, -215.304, 1215.02, 19.673, 177.817),
(178, 463, -143.123, 1113.13, 19.29, 228.89),
(179, 468, 42.381, 1219.86, 18.744, 170.767),
(180, 468, 114.249, 1066.3, 13.481, 178.195),
(181, 468, -1482.37, 1878.26, 32.302, 8.967),
(182, 579, -91.664, 1339.35, 10.476, 7.996),
(183, 579, 590.534, 1222.98, 11.658, 237.813),
(184, 468, 603.416, 1650.85, 6.662, 60.138),
(185, 471, 802.576, 1683.28, 4.762, 330.669),
(186, 471, 2519.51, -19.532, 26.161, 2.349),
(187, 468, -1431.05, -955.455, 200.603, 93.335),
(188, 579, -1040.07, -1077.19, 129.197, 183.334),
(189, 515, -1299.59, 2707.95, 51.082, 183.77),
(190, 435, -1539.94, -2747.6, 49.553, 168.908),
(635, 483, -1108.65, -1620.63, 76.36, 268.64),
(192, 579, -1108.47, -1644.21, 76.08, 267.535),
(193, 579, -1108.49, -1654.1, 76.085, 251.414),
(194, 562, -2161.36, 366.866, 34.98, 267.31),
(195, 561, -2160.32, 453.117, 34.985, 270.73),
(196, 560, -2429.58, 320.729, 34.877, 239.969),
(197, 558, -2453.55, 139.628, 34.591, 221.902),
(198, 559, -2460.66, -23.905, 32.461, 89.215),
(199, 565, -2484.97, -195.478, 25.246, 109.879),
(200, 561, -2773.96, -312.022, 6.853, 0.542),
(201, 579, -2751.81, -282.729, 6.966, 180.141),
(202, 562, -2796.29, -136.809, 6.848, 270.717),
(203, 560, -2626.77, -55.184, 4.041, 358.139),
(204, 558, -2679.37, -22.77, 3.964, 0.59),
(205, 559, -2616.31, 134.363, 3.992, 90.604),
(206, 565, -2796.53, 181.065, 6.811, 271.821),
(207, 561, -2668.43, 267.761, 4.15, 181.77),
(208, 562, -2675.2, 369.952, 4.05, 266.793),
(209, 560, -2869.91, 472.369, 4.586, 269.478),
(210, 559, -2879.54, 740.76, 29.465, 99.923),
(211, 558, -2671.82, 824.239, 49.615, 178.772),
(212, 565, -2538.45, 746.464, 31.824, 272.633),
(213, 561, -2371.4, 707.13, 34.983, 92.356),
(214, 560, -2416.86, 528.523, 29.635, 241.106),
(215, 562, -2460.55, 740.888, 34.677, 182.737),
(216, 559, -2398.92, 881.21, 45.102, 89.736),
(217, 565, -2197.07, 930.943, 73.298, 357.307),
(218, 558, -2276.53, 912.084, 66.277, 176.255),
(219, 560, -2569.15, 990.718, 77.978, 181.896),
(220, 561, -2571.84, 1148.47, 55.54, 157.516),
(221, 556, -1770.66, 1204.54, 25.5, 89.833),
(222, 565, -1943, 1193.62, 45.035, 357.763),
(223, 562, -2047.83, 901.358, 53.283, 331.829),
(224, 558, -1799.9, 822.989, 24.521, 357.319),
(225, 560, -1519.41, 925.806, 6.891, 356.396),
(226, 565, -1752.35, 954.709, 24.363, 88.701),
(227, 559, -2048.25, 1108.55, 52.945, 152.423),
(228, 562, -1704.58, 409.664, 6.838, 40.264),
(230, 515, -1726.67, 47.763, 4.571, 208.106),
(231, 443, -1576.98, 120.806, 4.157, 334.474),
(232, 579, -1872.64, -859.034, 31.958, 88.235),
(233, 565, -2149.15, -952.974, 31.645, 88.303),
(234, 446, -1574.58, 1263.43, -0.31, 270.255),
(235, 446, -1720.76, 1435.81, -0.442, 0.205),
(236, 446, -2931.07, 1233.24, -0.16, 53.542),
(237, 446, -1448.48, 1507.07, -0.471, 82.051),
(238, 560, -1944.62, 1325.78, 6.917, 284.293),
(243, 515, -1650.16, 436.992, 8.196, 252.341),
(244, 435, -1668.31, 438.124, 8.206, 274.057),
(245, 408, -1730.11, 137.177, 4.109, 88.412),
(246, 408, -1730.26, 131.657, 4.109, 88.412),
(247, 515, -1719.95, 51.242, 4.568, 207.727),
(248, 435, -1733.9, 61.222, 4.182, 203.421),
(249, 435, -1727.55, 64.351, 4.196, 212.351),
(252, 420, -1852.51, -130.609, 11.684, 92.651),
(253, 420, -1854.07, -141.626, 11.68, 82.169),
(254, 560, -1821.96, -181.983, 9.102, 36.866),
(255, 560, -1824.55, -151.535, 9.104, 183.25),
(256, 560, -1817.74, -167.875, 9.102, 173.097),
(257, 561, -2206.45, 637.073, 49.314, 71.4),
(258, 561, -2188.38, 644.714, 49.313, 100.287),
(259, 561, -2204.57, 644.881, 49.315, 109.733),
(260, 431, -1991.17, 160.048, 27.673, 0.379),
(261, 431, -1991.89, 145.542, 27.64, 0.604),
(262, 560, -1652.11, 1311.4, 6.909, 134.145),
(263, 560, -1715.42, 1348.18, 7.051, 77.933),
(264, 560, -1640.37, 1412.2, 7.09, 158.614),
(265, 525, -2104.35, -377.806, 35.205, 87.587),
(266, 525, -2093.21, -378.302, 35.202, 89.058),
(267, 525, -2081.49, -378.114, 35.206, 88.611),
(268, 494, -2133.07, -419.608, 35.231, 292.312),
(269, 556, -2170.06, -404.771, 35.711, 318.988),
(270, 556, -2196, -395.957, 35.688, 207.933),
(271, 565, -2019.74, -93.935, 34.881, 89.093),
(272, 565, -2030.14, -93.935, 34.881, 87.395),
(273, 520, -1455.99, 501.59, 19.212, 269.428),
(274, 520, -1414.82, 516.444, 19.106, 269.359),
(277, 521, -1952.73, 300.224, 40.61, 131.629),
(278, 559, -1989.68, 270.659, 34.832, 268.028),
(279, 560, -1991, 259.973, 34.885, 264.953),
(280, 562, -1986.27, 300.826, 34.834, 86.869),
(285, 451, -1658.69, 1214.57, 13.376, 311.764),
(286, 411, -1659.1, 1212.91, 20.883, 316.513),
(287, 541, -1658.36, 1211.91, 6.884, 287.533),
(288, 423, -2755.02, -311.67, 7.064, 8.141),
(289, 423, -2750.6, -309.154, 7.059, 49.521),
(290, 451, -2394.56, -596.502, 132.355, 125.747),
(291, 451, -2411.65, -585.536, 132.354, 214.455),
(292, 451, -2401.14, -586.935, 132.356, 301.07),
(294, 522, -1653.07, 532.256, 38, 304.747),
(295, 522, -1656.74, 529.574, 37.997, 304.523),
(296, 522, -1659.7, 527.883, 38.005, 307.686),
(297, 522, -1663.38, 525.844, 38.042, 294.841),
(298, 579, -1540.77, 478.94, 7.18, 269.846),
(299, 443, -1527.22, 452.776, 7.624, 0.058),
(300, 432, -1235.86, 443.717, 7.201, 64.464),
(301, 425, -1306.79, 496.364, 18.803, 305.628),
(302, 407, -2043.29, 55.72, 28.631, 268.262),
(303, 407, -2059.2, 77.292, 28.627, 178.617),
(304, 416, -2635.39, 621.66, 14.602, 87.176),
(305, 416, -2656.02, 621.589, 14.603, 90.073),
(306, 416, -2668, 590.877, 14.603, 269.372),
(307, 597, -1605.94, 720.921, 11.824, 267.718),
(308, 597, -1588.24, 673.725, 6.957, 2.121),
(309, 597, -1612.34, 673.749, 6.955, 179.18),
(310, 597, -1604.78, 651.014, 6.953, 178.946),
(311, 446, -1476.45, 693.184, -0.317, 172.176),
(312, 427, -1612.78, 734.032, -5.11, 2.27),
(313, 427, -1596.89, 748.856, -5.111, 178.998),
(314, 523, -1612.69, 750.637, -5.671, 179.699),
(315, 497, -1678.25, 705.131, 30.799, 93.184),
(316, 490, -1616.92, 693.248, -5.112, 356.117),
(317, 490, -1573.48, 705.742, -5.199, 92.464),
(318, 541, -2681.74, 1261.28, 55.188, 180.579),
(319, 446, -1110.36, 330.696, -0.577, 311.08),
(320, 446, -1154.16, -490.486, -0.41, 322.523),
(321, 561, -1418.86, -297.459, 13.962, 50.928),
(322, 562, -1429.18, -288.771, 13.809, 57.253),
(323, 513, -1361.06, -490.572, 15.542, 207.767),
(324, 513, -1434.96, -532.18, 15.524, 204.383),
(325, 513, -1609.95, -618.162, 14.669, 278.849),
(326, 513, -1573.33, -604.621, 14.718, 282.853),
(327, 519, -1331.15, -263.004, 15.084, 312.989),
(328, 519, -1366.17, -225.43, 15.083, 312.989),
(329, 485, -1527.96, -452.834, 5.695, 328.038),
(330, 485, -1566.19, -420.168, 5.756, 328.017),
(331, 487, -1223.22, -11.92, 14.325, 42.122),
(332, 487, -1186.1, 24.292, 14.325, 49.068),
(333, 519, -1498.37, -190.423, 15.497, 332.208),
(334, 560, -1824.94, -13.341, 14.918, 327.597),
(335, 560, -1735.73, 1012.08, 17.387, 267.766),
(336, 409, -2612.61, 1401.8, 6.916, 201.152),
(337, 409, -2629.57, 1379.54, 6.953, 269.435),
(339, 569, -1943.22, 159.909, 27.225, 357.246),
(340, 569, -1943.22, 159.909, 27.225, 357.246),
(341, 569, -1943.22, 159.909, 27.225, 357.246),
(342, 579, 2380.22, 75.913, 27.021, 92.596),
(343, 468, 2207.67, 110.809, 27.163, 88.846),
(344, 463, 2254.81, -124.671, 26.858, 176.223),
(345, 510, 1927.58, 176.122, 36.89, 82.201),
(346, 579, 1387.6, 265.29, 19.499, 69.592),
(347, 468, 1277.53, 171.593, 19.731, 323.712),
(348, 471, 1219.78, 295.303, 19.035, 59.515),
(350, 515, 798.16, -616.176, 17.392, 1.961),
(351, 468, 668.211, -545.144, 15.998, 266.706),
(352, 490, 626.54, -600.622, 16.909, 309.766),
(353, 471, 683.049, -442.944, 15.817, 104.793),
(354, 579, 243.022, -294.385, 1.51, 277.118),
(355, 515, 69.03, -253.657, 2.586, 320.911),
(356, 468, 182.945, -6.984, 1.244, 359.796),
(357, 463, 362.711, -93.897, 0.903, 271.131),
(358, 402, -75.662, -4.78, 2.95, 164.26),
(359, 579, -478.441, -61.128, 60.265, 76.521),
(360, 468, -539.228, -472.186, 25.187, 180.549),
(363, 471, -371.015, -1437.49, 25.208, 270.081),
(364, 579, -942.014, -524.559, 25.906, 308.556),
(365, 471, -845.097, -1956.1, 13.828, 300.592),
(366, 468, -1417.78, -1576.33, 101.422, 358.561),
(367, 406, -1907.02, -1724.63, 23.282, 134.263),
(368, 408, -1889.04, -1742.53, 22.292, 125.135),
(369, 579, -2331.07, -1636.78, 483.639, 98.935),
(370, 468, -2048.77, -2522.51, 30.294, 118.3),
(371, 515, -1950.28, -2449.46, 31.644, 179.397),
(372, 579, -2201.09, -2430.71, 30.56, 53.018),
(373, 463, -2194.21, -2265.34, 30.165, 133.144),
(374, 471, -1223.47, -2629.41, 9.503, 248.321),
(375, 471, -1362.41, -2144.4, 26.453, 237.139),
(376, 579, -1204.12, 1813.06, 41.634, 45.186),
(377, 515, -1530.24, -2752.91, 49.556, 172.87),
(378, 435, -1291.64, 2714.06, 51.071, 186.079),
(379, 409, 701.651, 1947.18, 5.339, 180.366),
(380, 406, 548.046, 853.499, -41.051, 257.6),
(381, 406, 675.461, 895.083, -38.687, 97.326),
(382, 577, -46.214, 2501.8, 17.68, 269.053),
(383, 487, 365.555, 2537.99, 17.135, 181.976),
(384, 513, 326.742, 2539.28, 15.858, 177.427),
(385, 513, 291.701, 2540.86, 15.858, 177.427),
(386, 539, -2214.56, 2422.38, 1.857, 0.835),
(387, 539, -2231.83, 2440.74, 1.85, 290.643),
(388, 446, -2243.11, 2442.18, -0.536, 229.444),
(389, 446, -2213.95, 2413.65, -0.636, 37.621),
(390, 579, -1276.73, 2495.81, 86.952, 40.223),
(391, 579, -1307.27, 2520.35, 87.303, 240.619),
(392, 579, -1328.78, 2540.21, 86.396, 213.625),
(393, 487, -1321.72, 2513.58, 92.702, 175.266),
(394, 579, 270.703, 1946.05, 17.63, 306.006),
(395, 579, 281.023, 1946.95, 17.638, 317.388),
(396, 579, 271.83, 1965.33, 17.634, 230.786),
(397, 579, 282.399, 1964.46, 17.637, 222.269),
(398, 443, 276.645, 1983.66, 18.078, 268.358),
(399, 443, 276.944, 1994.1, 18.078, 268.358),
(400, 432, 275.089, 2018.06, 17.657, 271.506),
(401, 432, 274.812, 2028.58, 17.657, 271.506),
(402, 520, 302.364, 2049.95, 18.37, 181.36),
(403, 520, 315.173, 2051.67, 18.359, 179.507),
(406, 451, -268.268, 1544.59, 75.067, 134.304),
(407, 425, 338.532, 1944.8, 20.8, 91.925),
(408, 425, 338.133, 1976.7, 20.8, 92.013),
(409, 490, -1399.9, 2650.07, 55.875, 90.325),
(410, 490, 224.205, 1908.63, 17.824, 124.838),
(411, 490, 197.551, 1905.64, 17.829, 247.523),
(412, 490, 130.064, 1928.68, 19.394, 173.962),
(413, 427, 143.874, 1928.21, 19.329, 181.004),
(419, 464, -957.463, 2453.63, 46.62, 11.152),
(421, 446, -929.606, 2644.97, 40.051, 132.297),
(423, 411, 2075.38, 1145.08, 10.399, 357.977),
(424, 451, 2038.98, 1182.06, 10.376, 178.606),
(425, 541, 2119.89, 1398.48, 10.437, 359.11),
(426, 451, 2039.86, 1334.27, 10.379, 179.481),
(427, 429, 2039.22, 1352.47, 10.351, 178.605),
(428, 402, 2039.63, 1546.1, 10.504, 177.16),
(429, 411, 2074.54, 1481.81, 10.399, 358.203),
(430, 562, 2075.64, 1595.14, 10.332, 358.533),
(431, 560, 2039.73, 1695.96, 10.377, 182.607),
(432, 558, 2099.13, 1820.92, 10.302, 155.133),
(433, 451, 2119.65, 1922.34, 10.379, 179.407),
(434, 451, 2172.13, 1984.99, 10.658, 89.152),
(435, 451, 2102.98, 2043.16, 10.525, 91.038),
(436, 559, 2155.19, 2118.94, 10.328, 359.98),
(437, 411, 2119.99, 2189.41, 10.399, 181.92),
(438, 561, 2155.25, 2197.41, 10.485, 0.32),
(439, 565, 2009.71, 2455.66, 10.445, 87.924),
(440, 429, 1969.5, 2410.83, 10.5, 181.785),
(441, 579, 2048.23, 688.977, 11.21, 0.664),
(442, 565, 2353, 698.371, 10.909, 359.913),
(443, 451, 2622.93, 730.651, 10.527, 181.467),
(444, 402, 2843.65, 897.349, 10.59, 358.43),
(445, 443, 2842.19, 994.728, 11.406, 177.932),
(446, 541, 2636.36, 1076.03, 10.445, 91.695),
(447, 558, 2551.11, 1238.94, 10.451, 1.982),
(448, 562, 2486.61, 1409.29, 10.516, 0.29),
(449, 471, 2488.6, 1534.71, 10.653, 226.743),
(450, 559, 2476.23, 1658.06, 10.476, 1.345),
(451, 521, 2395.82, 1629.54, 10.387, 181.85),
(452, 411, 2599.73, 1703.81, 10.547, 270.984),
(453, 451, 2591.42, 1859.51, 10.649, 89.615),
(454, 560, 2453.92, 1991.64, 10.526, 358.851),
(455, 402, 2609.74, 2262.88, 10.651, 271.495),
(456, 429, 2565.46, 2275.31, 10.5, 88.149),
(457, 451, 2531.5, 2501.47, 10.524, 271.61),
(458, 443, 2523.9, 2816.16, 11.423, 178.968),
(634, 541, 1548.1, -1445.21, 13.087, 270.138),
(460, 558, 2167.41, 2724.28, 10.451, 269.014),
(461, 565, 2028.08, 2730.93, 10.447, 272.902),
(462, 562, 1888.29, 2616.4, 10.48, 182.01),
(463, 559, 1592.03, 2745.08, 10.476, 179.1),
(464, 411, 1639.93, 2577.47, 10.554, 179.878),
(465, 451, 1494.07, 2540.3, 10.527, 89.177),
(466, 541, 1433.53, 2608.14, 10.297, 88.678),
(468, 429, 1283, 2571.39, 10.5, 271.039),
(469, 451, 1264.58, 2695.9, 10.524, 1.939),
(470, 451, 1135.63, 2268.35, 16.557, 271.845),
(471, 559, 991.925, 2350.89, 10.926, 270.612),
(472, 522, 994.242, 1885.43, 10.648, 272.413),
(473, 443, 1047.87, 2167.33, 11.476, 174.648),
(474, 541, 1106.51, 1935.48, 10.445, 91.051),
(475, 562, 1030.15, 1216.04, 10.48, 232.541),
(476, 521, 1470.91, 1057.43, 10.371, 91.448),
(477, 443, 1395.76, 1116.01, 11.366, 3.835),
(478, 515, 1547.43, 1022.8, 11.846, 267.592),
(479, 406, 1747.05, 1056.77, 12.26, 267.47),
(480, 443, 1713.38, 924.71, 11.288, 61.542),
(481, 558, 1413.79, 704.771, 10.45, 269.779),
(482, 451, 1682.35, 1286.94, 10.524, 178.16),
(483, 429, 1730.41, 1815.23, 10.499, 272.408),
(484, 521, 1612.41, 2199.17, 10.371, 267.119),
(485, 402, 1542.15, 2132.15, 11.108, 89.674),
(486, 560, 1548.08, 2338.79, 10.527, 0.303),
(487, 515, 1636.47, 2332, 11.837, 270.957),
(488, 443, 1901.08, 2308.03, 11.389, 177.194),
(489, 416, 1873.49, 2244.22, 10.969, 177.065),
(490, 411, 1583.41, 1964.75, 10.543, 358.499),
(491, 558, 1373.59, 1903.89, 10.781, 272.876),
(492, 429, 1117.66, 2070.07, 10.5, 181.501),
(493, 541, 1340.99, 2242.98, 10.445, 92.466),
(494, 560, 1731.38, 1945.54, 10.52, 88.761),
(495, 451, 1691.12, 2202.57, 10.525, 179.407),
(496, 451, 2223.84, 1285.52, 10.51, 178.654),
(497, 562, 2460.46, 925.241, 10.48, 267.724),
(498, 402, 2270.47, 2229.25, 10.583, 270.13),
(499, 521, 1166.28, 1213.96, 10.391, 225.638),
(500, 522, 2142.48, 1009.44, 10.394, 87.614),
(501, 446, 2354.77, 518.745, -0.743, 266.464),
(502, 446, 1624.38, 566.571, -0.445, 92.011),
(505, 409, 2129.16, 2356.89, 10.472, 90.356),
(506, 409, 2034.45, 1919.58, 11.978, 178.169),
(507, 409, 2176, 1675.7, 10.62, 357.855),
(508, 409, 2039.03, 1008.03, 10.471, 177.648),
(509, 409, 2423.41, 1124.93, 10.474, 181.169),
(510, 522, 1942.32, 2201.17, 10.391, 271.079),
(511, 522, 2090.26, 1354.05, 10.396, 266.878),
(512, 560, 2246.91, 2050.57, 10.525, 91.086),
(513, 560, 2235.11, 2043.08, 10.526, 91.499),
(514, 490, 2247.42, 2038.65, 10.949, 268.185),
(515, 409, 2552.77, 1028.05, 10.62, 178.404),
(516, 409, 2511.81, 2132.76, 10.472, 269.65),
(517, 504, 1078.86, 1727.53, 10.612, 357.584),
(518, 494, 1093.6, 1727.54, 10.716, 358.469),
(519, 556, 1060.08, 1726.89, 11.169, 357.918),
(520, 406, 1040.84, 1729.3, 11.47, 358.814),
(521, 423, 2285.93, 591.917, 7.802, 91.462),
(522, 423, 2277.62, 581.492, 7.802, 353.247),
(526, 490, 2765.81, 1271.55, 10.802, 270.954),
(527, 490, 2778.35, 1295.02, 10.802, 179.401),
(528, 487, 2801.69, 1278.13, 11.047, 38.297),
(529, 431, 1503.06, 2199.63, 10.92, 180.465),
(530, 431, 1496.38, 2200.51, 10.92, 181.049),
(531, 451, 2352.54, 1459.03, 42.521, 90.477),
(532, 451, 2302.28, 1433.57, 42.527, 269.539),
(533, 451, 2302.71, 1472.8, 42.527, 90.262),
(534, 519, 1329.75, 1602.58, 11.742, 268.51),
(535, 519, 1569.27, 1473.5, 12.947, 63.184),
(536, 519, 1574.9, 1423.16, 11.795, 105.376),
(537, 513, 1553.89, 1629.01, 11.37, 137.917),
(538, 513, 1570.13, 1543.87, 11.37, 89.948),
(539, 487, 1615.52, 1546.3, 11.116, 16.001),
(540, 487, 1636.6, 1553.73, 10.933, 0.217),
(541, 513, 1303.87, 1322.09, 12.189, 268.468),
(542, 513, 1305.02, 1361.52, 12.194, 267.957),
(543, 560, 1325.57, 1279.79, 10.634, 0.008),
(544, 485, 1316.07, 1278.42, 10.475, 0.516),
(545, 485, 1704.65, 1620.31, 10.029, 141.023),
(546, 485, 1709.81, 1585.58, 10.207, 79.332),
(547, 560, 1711.03, 1591.8, 10.154, 73.612),
(548, 519, 1346.97, 1489.73, 12.179, 273.045),
(549, 577, 1587.31, 1192.59, 10.719, 175.585),
(550, 561, 1881.64, 960.215, 10.695, 269.143),
(551, 561, 1890.29, 948.148, 10.695, 2.387),
(552, 561, 1918.39, 949.755, 10.688, 0.17),
(553, 560, 2173.59, 1697.41, 10.695, 62.662),
(554, 560, 2165.64, 1701.52, 10.695, 63.536),
(555, 560, 2157.72, 1705.55, 10.695, 61.232),
(556, 407, 1763.38, 2076.83, 11.054, 182.597),
(557, 407, 1750.84, 2075.96, 11.056, 178.959),
(558, 420, 2179.7, 1810.84, 10.6, 358.784),
(559, 420, 2188.63, 1821.8, 10.599, 358.368),
(560, 420, 2195.3, 1810.35, 10.597, 181.349),
(561, 515, 2216.92, 1865.18, 11.848, 140.978),
(562, 435, 2230.51, 1873.96, 11.834, 129.51),
(563, 515, 968.94, 2146.4, 11.834, 178.735),
(564, 515, 993.993, 2148.44, 11.843, 179.143),
(565, 515, 978.816, 2145.91, 11.828, 179.379),
(566, 435, 994.707, 2169.64, 11.839, 179.346),
(567, 435, 969.79, 2172.11, 11.836, 179.933),
(568, 435, 976.235, 2174.25, 11.841, 177.29),
(569, 408, 1447.55, 974.744, 11.349, 358.807),
(570, 408, 1437.57, 974.951, 11.349, 358.807),
(571, 416, 1617.88, 1849.81, 10.943, 0.097),
(572, 416, 1609.86, 1849.97, 10.97, 0.025),
(573, 416, 1592.82, 1849.8, 10.969, 0.57),
(574, 598, 2256.45, 2459.67, 10.54, 3.38),
(575, 598, 2269.45, 2459.74, 10.568, 177.902),
(576, 598, 2269.05, 2443.46, 10.555, 3.369),
(577, 598, 2290.77, 2477.21, 10.543, 180.445),
(578, 523, 2251.7, 2476.86, 10.408, 357.384),
(579, 427, 2298, 2460.28, 3.38, 269.986),
(580, 427, 2298.54, 2451.97, 3.405, 269.606),
(581, 490, 2281.42, 2474.05, 3.417, 183.415),
(582, 490, 2267.99, 2474.76, 3.422, 358.961),
(583, 411, 2240.11, 2476.06, 3.043, 90.704),
(584, 411, 2239.81, 2442.47, 2.994, 89.308),
(585, 451, 2315.12, 2469.56, 2.979, 91.163),
(586, 497, 2263.72, 2387.64, 19.835, 0.004),
(587, 497, 2245.26, 2387.64, 19.732, 0.004),
(588, 523, 2278.13, 2418.04, 10.241, 88.606),
(589, 598, 2284.75, 2417.94, 10.516, 91.147),
(590, 427, 2311.93, 2444.51, 10.952, 139.55),
(591, 606, 1707.88, 1663.65, 10.629, 189.834),
(592, 606, 1708.78, 1658.43, 10.471, 189.834),
(593, 606, 1709.74, 1652.93, 10.304, 189.834),
(594, 606, 1710.94, 1646, 10.095, 189.834),
(595, 606, 1713.18, 1633.08, 9.704, 189.834),
(597, 569, 2864.75, 1255.69, 12.349, 180),
(598, 569, 2864.75, 1255.69, 12.349, 180),
(599, 569, 2864.75, 1255.69, 12.349, 180),
(638, 525, 1941.66, 2171.97, 10.7, 90.905),
(601, 423, 1590.97, 1822.67, 10.842, 272.74),
(602, 510, 1621.81, 1819.03, 10.427, 2.519),
(603, 463, 1616.98, 1832.6, 10.36, 1.083),
(604, 471, 1606.42, 1832.65, 10.6, 181.767),
(605, 558, 1597.91, 1831.91, 10.616, 359.227),
(606, 443, 1708.73, 1491.17, 11.355, 338.722),
(609, 556, 1676.21, 1425.88, 11.153, 295.368),
(610, 525, 1704.93, 1432.13, 10.552, 173.937),
(611, 471, 1689.12, 1438.78, 10.248, 277.446),
(612, 510, 1689.54, 1460.02, 10.377, 269.83),
(613, 510, 1705.56, 1439.47, 10.499, 175.297),
(614, 411, -1682.46, -162.523, 13.996, 223.486),
(615, 411, -1671.37, -197.095, 13.804, 10.3),
(616, 411, -1681.4, -190.851, 13.927, 316.099),
(617, 411, -1684.43, -177.725, 13.852, 228.048),
(618, 411, 1466.74, 1794.28, 10.54, 178.879),
(619, 411, 1475.98, 1795.3, 10.54, 179.553),
(620, 411, 1485.8, 1791.15, 10.54, 184.79),
(621, 411, 1405.6, -2503.08, 13.282, 269.861),
(622, 411, 1405.05, -2493.78, 13.282, 266.878),
(623, 411, 1413.2, -2481.29, 13.282, 270.611),
(624, 416, -2571.74, 657.766, 14.602, 268.679),
(625, 416, -2572.49, 647.486, 14.603, 270.35),
(626, 416, -2572.02, 642.805, 14.607, 269.548),
(627, 416, -2546.38, 658.437, 14.609, 88.642),
(628, 416, -2545.48, 653.089, 14.609, 88.979),
(629, 416, -2546.23, 647.639, 14.609, 87.757),
(630, 416, -2546.6, 642.76, 14.604, 90.381),
(631, 416, -2572.08, 632.38, 14.609, 268.66),
(632, 416, -2546.56, 637.814, 14.602, 89.752),
(633, 416, -2546.48, 632.963, 14.602, 91.153),
(640, 565, -2064.4, -83.618, 34.827, 359.571);

-- --------------------------------------------------------

--
-- Table structure for table `Skins`
--

CREATE TABLE IF NOT EXISTS `Skins` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `SkinID` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=94 ;

-- --------------------------------------------------------

--
-- Table structure for table `Soutez`
--

CREATE TABLE IF NOT EXISTS `Soutez` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nazev` varchar(50) NOT NULL,
  `Text` text NOT NULL,
  `Odmena` int(10) NOT NULL,
  `OdmenaXP` int(10) NOT NULL,
  `Start` int(10) NOT NULL,
  `End` int(10) NOT NULL,
  `Active` int(1) NOT NULL,
  `MultipleChoices` int(1) DEFAULT NULL,
  `ChoicePrice` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=18 ;

-- --------------------------------------------------------

--
-- Table structure for table `SoutezOdpovedi`
--

CREATE TABLE IF NOT EXISTS `SoutezOdpovedi` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` text NOT NULL,
  `Odpoved` text NOT NULL,
  `Soutez` int(11) NOT NULL,
  `Cas` int(10) NOT NULL,
  `Win` int(1) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=896 ;

-- --------------------------------------------------------

--
-- Table structure for table `SpecialProperties`
--

CREATE TABLE IF NOT EXISTS `SpecialProperties` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `PropID` int(11) NOT NULL,
  `Supplies` int(11) DEFAULT 50,
  `Stock` int(11) DEFAULT 0,
  `Earning` int(11) DEFAULT 0,
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=239 ;

-- --------------------------------------------------------

--
-- Table structure for table `Stunts`
--

CREATE TABLE IF NOT EXISTS `Stunts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `StuntID` int(11) NOT NULL,
  `StuntCompleted` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=43850 ;

-- --------------------------------------------------------

--
-- Table structure for table `Tombola`
--

CREATE TABLE IF NOT EXISTS `Tombola` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `Price` float NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Table structure for table `TombolaWins`
--

CREATE TABLE IF NOT EXISTS `TombolaWins` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `Vyhra` float NOT NULL,
  `Los` int(11) NOT NULL,
  `Time` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=654 ;

-- --------------------------------------------------------

--
-- Table structure for table `TrestneBody`
--

CREATE TABLE IF NOT EXISTS `TrestneBody` (
  `trest_id` int(11) NOT NULL AUTO_INCREMENT,
  `hrac` varchar(32) NOT NULL,
  `reason` varchar(256) NOT NULL,
  `admin` varchar(32) NOT NULL,
  `time` int(10) NOT NULL,
  `tb` int(11) NOT NULL,
  `tb_z` int(11) NOT NULL COMMENT 'Záloha trestných bodů pro jejich případné obnovení.',
  `showed` int(1) DEFAULT 0,
  PRIMARY KEY (`trest_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=5793 ;

-- --------------------------------------------------------

--
-- Table structure for table `UserControl`
--

CREATE TABLE IF NOT EXISTS `UserControl` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(32) NOT NULL COMMENT 'Orientační Nick',
  `IP` varchar(256) NOT NULL COMMENT 'Orientační IP',
  `GPCI` text NOT NULL,
  `Date` int(10) NOT NULL,
  `Status` int(1) NOT NULL COMMENT '0 = ok | 1 = info | 2 = warning | 3 = critical',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=15 ;

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE IF NOT EXISTS `Users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `Hodnost` varchar(50) DEFAULT NULL,
  `Points` int(11) DEFAULT NULL,
  `Kills` int(11) DEFAULT NULL,
  `Deaths` int(11) DEFAULT NULL,
  `Events` int(11) DEFAULT NULL,
  `Duels` int(11) DEFAULT NULL,
  `Dailys` int(11) DEFAULT NULL,
  `DMKills` int(11) DEFAULT NULL,
  `DMDeaths` int(11) DEFAULT NULL,
  `DMScore` int(11) DEFAULT NULL,
  `Sumos` int(11) DEFAULT NULL,
  `Postrehu` int(11) DEFAULT NULL,
  `Races` int(11) DEFAULT NULL,
  `Hours` int(11) DEFAULT NULL,
  `Minutes` int(11) DEFAULT NULL,
  `Missions` int(11) DEFAULT NULL,
  `Stunts` int(11) DEFAULT NULL,
  `Skin` int(11) DEFAULT NULL,
  `Wanted` int(11) DEFAULT NULL,
  `Level` int(11) DEFAULT NULL,
  `Create` int(11) NOT NULL,
  `LastActivity` int(11) DEFAULT NULL,
  `LastConnect` int(11) NOT NULL,
  `ActivityPoints` int(11) DEFAULT NULL,
  `Titul` varchar(30) DEFAULT NULL,
  `Donate` int(11) DEFAULT NULL,
  `Robbed` int(11) DEFAULT NULL,
  `Marihuana` int(11) DEFAULT NULL,
  `MinceWin` int(11) DEFAULT NULL,
  `MinceLose` int(11) DEFAULT NULL,
  `AFK` int(11) DEFAULT NULL,
  `IP` varchar(16) NOT NULL,
  `AntiNickCopy` varchar(24) NOT NULL,
  `GPCI` varchar(128) NOT NULL,
  `Password` text DEFAULT NULL,
  `Legend` int(11) DEFAULT NULL,
  `Dovolena` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=24468 ;

-- --------------------------------------------------------

--
-- Table structure for table `UserTituls`
--

CREATE TABLE IF NOT EXISTS `UserTituls` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `Titul` varchar(30) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=384 ;

-- --------------------------------------------------------

--
-- Table structure for table `Vybava`
--

CREATE TABLE IF NOT EXISTS `Vybava` (
  `vybava_id` int(11) NOT NULL AUTO_INCREMENT,
  `nick` varchar(32)  NOT NULL,
  `vybava` int(11) NOT NULL,
  `vybava_nazev` varchar(24) NOT NULL,
  `slot0` int(2) DEFAULT NULL,
  `slot1` int(2) DEFAULT NULL,
  `slot2` int(2) DEFAULT NULL,
  `slot3` int(2) DEFAULT NULL,
  `slot4` int(2) DEFAULT NULL,
  `slot5` int(2) DEFAULT NULL,
  `slot6` int(2) DEFAULT NULL,
  `slot7` int(2) DEFAULT NULL,
  `slot8` int(2) DEFAULT NULL,
  `slot9` int(2) DEFAULT NULL,
  `slot10` int(2) DEFAULT NULL,
  `slot11` int(2) DEFAULT NULL,
  `slot12` int(2) DEFAULT NULL,
  PRIMARY KEY (`vybava_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=9401 ;

-- --------------------------------------------------------

--
-- Table structure for table `Vyhry`
--

CREATE TABLE IF NOT EXISTS `Vyhry` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Nick` varchar(24) NOT NULL,
  `Time` int(11) NOT NULL,
  `Event` text NOT NULL,
  `Admin` varchar(24) NOT NULL,
  `Odmena` text NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=16072 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
