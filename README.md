# UnNamed 2.0 – Herní mód pro DreamGaming server  
**Autor módu:** DeLeTe  
**Verze:** 2.0  
**Licence:** [GPL](https://www.gnu.org/licenses/gpl-3.0.html) – open-source, přispívat lze dle pokynů v `CONTRIBUTING.md`

---

## 🧩 Úvod
Tento herní mód je určen pro SA-MP servery ve verzi 0.3.7 a novější, mód původne určen pro **DreamGaming** server.

---

## 🚀 První spuštění

1. **Otevři soubor:**  
   `filterscripts/UnNamed.pwn`

2. **Uprav připojení k databázi:**  
   Nahraď údaje podle konfigurace tvého serveru:

   ```pawn
   #define host      "localhost"
   #define user      "root"
   #define db        "unsamp"
   #define db_pass   ""
   ```

3. **Nastav údaje o serveru:**

   ```pawn
   #define SRV_WEB      "example.com"
   #define SRV_MAIL     "example@example.com"
   #define SRV_INSTA    "instagram.com/server_ig"
   #define SRV_FB       "facebook.com/server_fb"
   #define SRV_DISCORD  "discord.gg/server_discord"
   #define SRV_NAME     "Example"
   ```

4. **Naimportuj SQL databázi:**  
   Nahraj soubor `unsamp.sql` do své databáze.

5. **Spusť server:**  
   - Windows: `samp-server.exe`  
   - Linux: Spustit binárku serveru podle OS

6. **Nastavení práv admina:**  
   Použij příkaz:
   ```
   /setadmin [ID] [LEVEL] [HODNOST]
   ```
   - `LEVEL` je v rozsahu 0–6

---

## 🤝 Přispívání
Projekt je open-source. Přispět můžeš úpravami nebo rozšiřováním kódu dle instrukcí v souboru [`CONTRIBUTING.md`](CONTRIBUTING.md).