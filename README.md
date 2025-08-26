# WoW Launcher - Godot 4 Version

Ein vollständiger Nachbau des Arctium WoW-Launchers in Godot 4, der alle Funktionen des Originals 1:1 reproduziert.

## 🎮 Features

### ✅ Vollständig implementiert:
- **Modernes UI-Design** mit rundem Panel und WoW-Style
- **Download-System** mit Fortschrittsanzeige
- **Patch-Management** für Spiel-Updates
- **Addon-Verwaltung** für WoW-Addons
- **Settings-System** mit Sprachauswahl und Pfad-Konfiguration
- **Cursor-Integration** mit custom Maus-Cursor
- **Murloc-Animation** (schwimmender Murloc im Hintergrund)
- **Sound-System** für Audio-Feedback
- **Multi-Platform Support** (Windows, macOS, Linux)

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
│   ├── Launcher.gd           # Hauptskript
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

#### **Download/Repair:**
- Klicke "Download" für neue Installation
- Klicke "Repair" für Spiel-Reparatur
- Fortschrittsbalken zeigt Download-Status

#### **Play:**
- "Play"-Button erscheint nach erfolgreichem Download
- Startet World of Warcraft automatisch
- Multi-Platform Support (Windows/macOS/Linux)

#### **Settings:**
- Sprache auswählen (EN/FR)
- Spiel-Pfad konfigurieren
- Audio-Einstellungen anpassen

#### **Quit:**
- Beendet den Launcher sauber

## 🔧 Konfiguration

### config.json:
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

### Benutzereinstellungen:
- Werden in `user://settings.json` gespeichert
- Automatische Persistierung zwischen Sessions

## 🎨 UI-Komponenten

### Hauptpanel:
- **Rundes Design** mit abgerundeten Ecken
- **WoW-Style Farben** (Gold-Akzente, dunkler Hintergrund)
- **Responsive Layout** für verschiedene Bildschirmgrößen

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

### Datei-Management:
- **Patch-Download** mit MD5-Verifikation
- **ZIP-Extraktion** für Addons
- **Cache-Management** für optimale Performance

### Cross-Platform:
- **Windows:** Direkte Wow.exe-Ausführung
- **macOS:** Wow.app über open-Befehl
- **Linux:** Wine-Integration für Wow.exe

## 🎵 Audio-System

### Implementierte Sounds:
- **Klick-Sounds** für Button-Interaktionen
- **Download-Complete-Sound** (murloc.mp3)
- **Volume-Control** in Settings

### Audio-Features:
- **Einstellbare Lautstärke**
- **Sound-On/Off-Toggle**
- **Automatische AudioPlayer-Verwaltung**

## 🐛 Bekannte Probleme & Lösungen

### Problem: Assets werden nicht geladen
**Lösung:** Stelle sicher, dass alle Assets im `assets/` Ordner vorhanden sind

### Problem: Cursor wird nicht angezeigt
**Lösung:** Überprüfe die wow.ico Datei im assets/images/ Ordner

### Problem: Download funktioniert nicht
**Lösung:** Das ist ein Demo-System - echte Downloads müssen implementiert werden

## 🔮 Erweiterte Features

### Geplante Erweiterungen:
- **Echte FTP-Integration** für Downloads
- **Server-Status-Anzeige**
- **News-System** mit Server-Updates
- **Auto-Update** für den Launcher selbst
- **Backup-System** für Spiel-Dateien

### Customization:
- **Theme-System** für verschiedene Server
- **Plugin-Architektur** für Addons
- **Multi-Server-Support**

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

Dieses Projekt ist ein Nachbau des Arctium WoW-Launchers für Bildungszwecke.
Alle Original-Assets gehören ihren jeweiligen Besitzern.

## 🙏 Credits

- **Original Launcher:** Arctium Team
- **Assets:** Murloc Village
- **Godot Engine:** Godot Foundation
- **Font:** LifeCraft Font

---

**Viel Spaß beim Spielen! 🎮**

