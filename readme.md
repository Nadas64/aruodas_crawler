# ARUODAS CRAWLER

## Ką daro?

Iš **m.aruodas.lt** paieškos URL su pridėtais filtrais randa geriausius nekilnojamo turto pasiūlymus kvadratinio metro kainos toje gatvėje atžvilgiu. Pasirinktą kiekį top kandidatų įrašo į **deals_top3.txt**. Dabartinis **kainos.csv** turi Vilniaus butų duomenis, o savo reference galima susikurti naudojant **aruodas_search.py** su `--scrape-only`. Akivaizdus trūkumas - pavieniai skelbimai tariamoje gatvėje; kadangi **kainos.csv** talpina ir rajoną, ateityje galima būtų parašyti algoritmą, kuris išfiltruotų netikslumus.

---

![Example](example.gif)

---

```

Supakuoti programą (PyInstaller, PowerShell):
```powershell
    mingw32-make

    mingw32-make run
```

---

## Kaip veikia

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
