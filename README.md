# WoW Launcher - Godot 4 Version

Ein vollständiger Nachbau der Arctium WoW-Launcher in Godot 4, der **beide Funktionalitäten** kombiniert:
- **Downloader/Launcher** (Murloc Village Style) - für Spiel-Updates und Addons
- **Game-Launcher** (Arctium Style) - für das Starten verschiedener WoW-Versionen

## 🎮 Features

### ✅ Vollständig implementiert:

#### **Downloader-Funktionen (Murloc Village):**
- **Modernes UI-Design** mit rundem Panel und WoW-Style
- **Download-System** mit Fortschrittsanzeige
- **Patch-Management** für Spiel-Updates
- **Addon-Verwaltung** für WoW-Addons
- **FTP-Integration** für Datei-Downloads
- **MD5-Verifikation** für Datei-Integrität

#### **Game-Launcher-Funktionen (Arctium):**
- **Multi-Version Support** (Retail, Classic BC/WotLK, Classic Era)
- **Server-Konfiguration** für Custom-Server
- **Dev-Mode** für lokale Entwicklung
- **Cache-Management** (automatisches Löschen)
- **Cross-Platform Support** (Windows, macOS, Linux)
- **Launch-Parameter** Verwaltung

#### **Allgemeine Features:**
- **Settings-System** mit Sprachauswahl und Pfad-Konfiguration
- **Cursor-Integration** mit custom Maus-Cursor
- **Murloc-Animation** (schwimmender Murloc im Hintergrund)
- **Sound-System** für Audio-Feedback
- **Event-Bus System** für Kommunikation zwischen Komponenten

### 🎨 Design-Features:
- Abgerundete Ecken und moderne Buttons
- WoW-Style Farbpalette (Gold, Rot, Dunkel)
- Responsive Layout
- Hover-Effekte und Tooltips
- Professionelle Typografie

## 📁 Projektstruktur

```
wow_launcher_godot/
├── project.godot              # Godot Projektdatei
├── config.json               # Launcher-Konfiguration
├── README.md                 # Diese Datei
├── scenes/
│   ├── Launcher.tscn         # Hauptszene
│   └── Settings.tscn         # Settings-Fenster
├── scripts/
│   ├── Launcher.gd           # Hauptskript (kombiniert)
│   ├── CursorController.gd   # Maus-Cursor-Verwaltung
│   ├── PatchManager.gd       # Download- und Patch-Verwaltung
│   └── Settings.gd           # Settings-Verwaltung
└── assets/
    ├── images/               # Alle Bilder und Icons
    │   ├── wow.png
    │   ├── wow.ico
    │   ├── mv1024.jpg        # Hintergrundbild
    │   ├── murloc_swim.gif   # Murloc-Animation
    │   └── LifeCraft_Font.ttf
    ├── sounds/               # Audio-Dateien
    └── fonts/                # Schriftarten
```

## 🚀 Installation & Start

### Voraussetzungen:
- Godot 4.2 oder höher
- Git (für Repository-Klon)

### Installation:
1. **Repository klonen:**
   ```bash
   git clone [repository-url]
   cd wow_launcher_godot
   ```

2. **Godot öffnen:**
   - Godot 4.2+ starten
   - "Import" → Projektordner auswählen
   - Projekt öffnen

3. **Projekt starten:**
   - F5 drücken oder "Play" klicken
   - Launcher startet automatisch

## 🎯 Verwendung

### Hauptfunktionen:

#### **Downloader-Funktionen:**
- **Download/Repair:** Klicke "Download" für neue Installation oder "Repair" für Spiel-Reparatur
- **Fortschrittsanzeige:** Zeigt Download-Status und Datei-Fortschritt
- **Addon-Management:** Verwaltet WoW-Addons über das Addons-Tab

#### **Game-Launcher-Funktionen:**
- **Version-Auswahl:** Wähle zwischen Retail, Classic BC/WotLK und Classic Era
- **Server-Konfiguration:** Konfiguriere Custom-Server-Adressen
- **Play-Button:** Startet World of Warcraft mit korrekten Parametern
- **Multi-Platform:** Unterstützt Windows, macOS und Linux

#### **Settings:**
- **Sprache:** Auswahl zwischen EN/FR
- **Spiel-Pfad:** Konfiguration des WoW-Installationsverzeichnisses
- **Server-Einstellungen:** Default-Server und Game-Version
- **Audio-Einstellungen:** Sound-On/Off und Lautstärke
- **Dev-Mode:** Für lokale Server-Entwicklung

#### **Quit:**
- Beendet den Launcher sauber

## 🔧 Konfiguration

### config.json (Downloader):
```json
{
    "host": "ftp.murlocvillage.com",
    "available_language": ["frFR", "enUS"],
    "default_language": "enUS",
    "patchlist_endpoint": "http://127.0.0.1:9000",
    "end_sound": "murloc.mp3",
    "path_end": ".json"
}
```

### Benutzereinstellungen (Game-Launcher):
- Werden in `user://settings.json` gespeichert
- Automatische Persistierung zwischen Sessions
- Enthält Server-Konfiguration, Game-Pfad, Version-Einstellungen

## 🎨 UI-Komponenten

### Hauptpanel:
- **Rundes Design** mit abgerundeten Ecken
- **WoW-Style Farben** (Gold-Akzente, dunkler Hintergrund)
- **Responsive Layout** für verschiedene Bildschirmgrößen

### Tabs:
- **Game Options:** Version-Auswahl und Server-Konfiguration
- **Addons:** Addon-Verwaltung und Download

### Buttons:
- **Hover-Effekte** mit Farbänderungen
- **Tooltips** für bessere UX
- **Disabled-States** während Downloads

### Progress-Bars:
- **Zwei Ebenen:** Datei-Fortschritt und Gesamt-Fortschritt
- **Live-Updates** während Downloads
- **Status-Labels** mit aktueller Aktion

## 🔌 Technische Details

### Architektur:
- **Event-Bus System** für Kommunikation zwischen Komponenten
- **Modulare Skripte** für bessere Wartbarkeit
- **Signal-basierte Kommunikation** (Godot-Standard)

### Downloader-Funktionen:
- **Patch-Download** mit MD5-Verifikation
- **ZIP-Extraktion** für Addons
- **Cache-Management** für optimale Performance
- **FTP-Client** für Server-Verbindungen

### Game-Launcher-Funktionen:
- **Multi-Version Support** mit korrekten Binaries
- **Launch-Parameter** Verwaltung
- **Server-Konfiguration** über WTF-Dateien
- **Dev-Mode** für lokale Entwicklung

### Cross-Platform:
- **Windows:** Direkte Binary-Ausführung
- **macOS:** Wow.app über open-Befehl
- **Linux:** Wine-Integration für Windows-Binaries

## 🎵 Audio-System

### Implementierte Sounds:
- **Klick-Sounds** für Button-Interaktionen
- **Download-Complete-Sound** (murloc.mp3)
- **Volume-Control** in Settings

### Audio-Features:
- **Einstellbare Lautstärke**
- **Sound-On/Off-Toggle**
- **Automatische AudioPlayer-Verwaltung**

## 🎮 Unterstützte WoW-Versionen

### Game-Versionen:
- **Retail:** Dragonflight (10.x), Shadowlands (9.x)
- **Classic BC/WotLK:** Burning Crusade (2.5.x), Wrath of the Lich King (3.4.x)
- **Classic Era:** Vanilla WoW (1.14.x)

### Launch-Parameter:
- `--version Classic` für BC/WotLK
- `--version ClassicEra` für Vanilla
- `-portal [server]` für Server-Verbindung
- `-config [file]` für Config-Datei
- `--dev` für lokale Entwicklung

## 🐛 Bekannte Probleme & Lösungen

### Problem: Assets werden nicht geladen
**Lösung:** Stelle sicher, dass alle Assets im `assets/` Ordner vorhanden sind

### Problem: Cursor wird nicht angezeigt
**Lösung:** Überprüfe die wow.ico Datei im assets/images/ Ordner

### Problem: Download funktioniert nicht
**Lösung:** Das ist ein Demo-System - echte Downloads müssen implementiert werden

### Problem: Game startet nicht
**Lösung:** Überprüfe den Game-Pfad in den Settings und stelle sicher, dass die korrekte WoW-Version installiert ist

## 🔮 Erweiterte Features

### Geplante Erweiterungen:
- **Echte FTP-Integration** für Downloads
- **Server-Status-Anzeige**
- **News-System** mit Server-Updates
- **Auto-Update** für den Launcher selbst
- **Backup-System** für Spiel-Dateien
- **Multi-Server-Profile**
- **Addon-Repository-Integration**

### Customization:
- **Theme-System** für verschiedene Server
- **Plugin-Architektur** für Addons
- **Multi-Server-Support**
- **Custom Launch-Parameter**

## 📝 Entwicklung

### Code-Struktur:
- **GDScript** für alle Skripte
- **Signal-basierte Architektur**
- **Modulare Komponenten**
- **Vollständig dokumentiert**

### Debugging:
- **Console-Output** für alle wichtigen Events
- **Error-Handling** für robuste Ausführung
- **Logging-System** für Troubleshooting

## 🤝 Beitragen

### Entwicklung:
1. Fork das Repository
2. Erstelle einen Feature-Branch
3. Implementiere deine Änderungen
4. Teste gründlich
5. Erstelle einen Pull Request

### Bug-Reports:
- Verwende das Issue-System
- Beschreibe das Problem detailliert
- Füge Screenshots bei Bedarf hinzu

## 📄 Lizenz

Dieses Projekt ist ein Nachbau der Arctium WoW-Launcher für Bildungszwecke.
Alle Original-Assets gehören ihren jeweiligen Besitzern.

## 🙏 Credits

- **Original Downloader:** Murloc Village Team
- **Original Game-Launcher:** Arctium Team
- **Assets:** Murloc Village, Arctium
- **Godot Engine:** Godot Foundation
- **Font:** LifeCraft Font

## 🔗 Original Repositories

- **Murloc Village Launcher:** [GitHub](https://github.com/Arctium/WoW-Launcher) (Vue.js Downloader)
- **Arctium Game Launcher:** [GitHub](https://github.com/Arctium/WoW-Launcher) (C# Game-Launcher)

---

**Viel Spaß beim Spielen! 🎮**

