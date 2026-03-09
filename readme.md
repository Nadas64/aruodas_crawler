
## Kas?

Iš **m.aruodas.lt** paieškos URL su pridėtais filtrais randa geriausius nekilnojamo turto pasiūlymus kvadratinio metro kainos toje gatvėje atžvilgiu. Pasirinktą kiekį top kandidatų įrašo į **deals_top3.txt**. Dabartinis kainos.csv turi Vilniaus butų duomenis, galima susikurti individualų reference savo reikmėms naudojantis **aruodas_scrapper.py**. Akivaizdus trūkumas - pavieniai skelbimai tariamoje gatvėje; kadangi **Kainos.csv** talpina ir rajoną galima būtų parašyti algoritmą, kuris išfiltruotų netikslumus.

---

![Example](example.gif)

---

## Gauti .exe
1) Įdiegti priklausomybes ir Playwright Chromium:
```powershell
python -m pip install -r requirements.txt
python -m playwright install chromium
```

Sukompiliuoti C++ analizatorių:
```bash
g++ -O2 -std=c++17 -o aruodas_analyze.exe aruodas_analyzer.cpp
```

Supakuoti programą (PyInstaller, PowerShell):
```powershell
pyinstaller --onedir --name aruodas_app --icon app.ico `
  --add-binary "aruodas_analyze.exe;." `
  --add-data "kainos.csv;." `
  --add-data "$env:LOCALAPPDATA\ms-playwright;ms-playwright" `
  aruodas_app.py
```

---

## Kaip veikia ☝️🤓

- **aruodas_app.py**: paima `URL` ir `TOP N`, suformuoja argumentus ir kviečia `aruodas_search.main(...)`.
- **aruodas_search.py**:
  - per **Playwright** atidaro vieną naršyklės langą ir greitai pereina per „Kitas“ puslapius;
  - blokuoja `image/font/media`, kad greičiau krautų;
  - iš kiekvieno skelbimo ištraukia: `price_eur`, `eur_per_m2`, `rooms`, `area_m2`, `irengtas`, `location`, `street`;
  - naujus įrašus **appendina** į `kainos.csv` (jei įjungta `--append-to-market`);
  - surinktus skelbimus perduoda C++ analizatoriui per **STDIN** kaip CSV.
- **aruodas_analyze.exe** (C++):
  - perskaito `kainos.csv`, sugrupuoja pagal raktą (`location | street` arba tik `street` su `--street-only`);
  - kiekvienai gatvei su `n >= --min-street-n` suskaičiuoja **medianą €/m²**;
  - kiekvienam naujam skelbimui skaičiuoja `deal = street_median / listing_eur_per_m2`;
  - išrenka **TOP N** (`--top`) ir išrašo į `deals_top3.txt`.
