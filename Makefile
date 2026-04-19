SHELL := cmd

PY := py -3
APP := aruodas_app
APP_PY := aruodas_app.py
CPP := aruodas_analyzer.cpp
ANALYZER := aruodas_analyze.exe
CSV := kainos.csv
ICON := app.ico
PW := $(LOCALAPPDATA)\ms-playwright

all: exe

exe:
	if not exist "$(APP_PY)" (echo Nerastas $(APP_PY) & exit /b 1)
	if not exist "$(CPP)" (echo Nerastas $(CPP) & exit /b 1)
	if not exist "$(CSV)" (echo Nerastas $(CSV) & exit /b 1)
	$(PY) -m pip install -r requirements.txt
	$(PY) -m pip install pyinstaller
	$(PY) -m playwright install chromium
	g++ -O2 -std=c++17 -o "$(ANALYZER)" "$(CPP)"
	$(PY) -m PyInstaller --onedir --name "$(APP)" --icon "$(ICON)" --add-binary "$(ANALYZER);." --add-data "$(CSV);." --add-data "$(PW);ms-playwright" "$(APP_PY)"

clean:
	if exist build rmdir /s /q build
	if exist dist rmdir /s /q dist
	if exist "$(APP).spec" del /q "$(APP).spec"
	if exist "$(ANALYZER)" del /q "$(ANALYZER)"
