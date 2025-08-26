extends Control

# WoW Launcher Hauptskript
# Kombiniert Downloader (Murloc Village) und Game-Launcher (Arctium) Funktionalität

# UI Referenzen
@onready var file_progress = $MainPanel/VBoxContainer/ProgressArea/FileProgress
@onready var file_label = $MainPanel/VBoxContainer/ProgressArea/FileLabel
@onready var total_progress = $MainPanel/VBoxContainer/ProgressArea/TotalProgress
@onready var total_label = $MainPanel/VBoxContainer/ProgressArea/TotalLabel
@onready var repair_button = $MainPanel/VBoxContainer/ButtonArea/RepairButton
@onready var play_button = $MainPanel/VBoxContainer/ButtonArea/PlayButton
@onready var download_button = $MainPanel/VBoxContainer/ButtonArea/DownloadButton
@onready var settings_button = $MainPanel/VBoxContainer/ButtonArea/SettingsButton
@onready var quit_button = $MainPanel/VBoxContainer/ButtonArea/QuitButton
@onready var swimming_murloc = $SwimmingMurloc
@onready var content_area = $MainPanel/VBoxContainer/ContentArea

# Konfiguration
var config = {
	"host": "ftp.murlocvillage.com",
	"available_language": ["frFR", "enUS"],
	"default_language": "enUS",
	"patchlist_endpoint": "http://127.0.0.1:9000",
	"end_sound": "murloc.mp3",
	"path_end": ".json"
}

# Game Launcher Konfiguration
var game_config = {
	"supported_versions": {
		"retail": {"name": "Retail", "binary": "Wow.exe", "folder": "_retail_", "min_build": 37862},
		"classic": {"name": "Classic BC/WotLK", "binary": "WowClassic.exe", "folder": "_classic_", "min_build": 39926},
		"classic_era": {"name": "Classic Era", "binary": "WowClassic.exe", "folder": "_classic_era_", "min_build": 40347}
	},
	"default_version": "retail",
	"game_path": "",
	"config_file": "Config.wtf"
}

# Status Variablen
var download_in_progress = false
var can_play = false
var version = "1.0.0"
var current_game_version = "retail"

# Patch Manager
var patch_manager = null

func _ready():
	# Initialisiere UI
	setup_ui()
	setup_connections()
	load_config()
	check_game_status()
	start_murloc_animation()
	setup_game_options()

func setup_ui():
	# Setze initiale UI-States
	file_progress.value = 0
	total_progress.value = 0
	file_label.text = "Ready"
	total_label.text = "Total: 0%"
	
	# Verstecke Play Button initial
	play_button.visible = false
	download_button.visible = true

func setup_connections():
	# Verbinde Button-Signale
	repair_button.pressed.connect(_on_repair_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	download_button.pressed.connect(_on_download_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func load_config():
	# Lade Konfiguration aus Datei
	var config_file = FileAccess.open("res://config.json", FileAccess.READ)
	if config_file:
		var json_string = config_file.get_as_text()
		config = JSON.parse_string(json_string)
		config_file.close()

func check_game_status():
	# Prüfe ob das Spiel aktuell ist
	can_play = is_game_up_to_date()
	update_play_button_visibility()

func is_game_up_to_date() -> bool:
	# Prüfe ob die Spiel-Dateien vorhanden sind
	var game_info = game_config.supported_versions[current_game_version]
	var game_path = get_game_path()
	var binary_path = game_path.path_join(game_info.binary)
	
	return FileAccess.file_exists(binary_path)

func update_play_button_visibility():
	play_button.visible = can_play
	download_button.visible = not can_play

func start_murloc_animation():
	# Starte die schwimmende Murloc-Animation
	if swimming_murloc:
		# Lade Murloc GIF als Animation
		var murloc_texture = load("res://assets/images/murloc_swim.gif")
		if murloc_texture:
			swimming_murloc.texture = murloc_texture
			# Starte Animation
			_animate_murloc()

func _animate_murloc():
	# Erstelle Tween für Murloc-Animation
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(swimming_murloc, "position:x", 1200, 10.0)
	tween.tween_property(swimming_murloc, "position:x", -200, 0.0)

func setup_game_options():
	# Erstelle Game Options UI
	var game_options_panel = content_area.get_node("Game Options/GameOptionsPanel/GameOptionsContent")
	
	# Version Selector
	var version_label = Label.new()
	version_label.text = "Game Version:"
	version_label.add_theme_color_override("font_color", Color(0.827, 0.702, 0.349, 1))
	game_options_panel.add_child(version_label)
	
	var version_option = OptionButton.new()
	version_option.add_item("Retail (Dragonflight/Shadowlands)", 0)
	version_option.add_item("Classic BC/WotLK", 1)
	version_option.add_item("Classic Era", 2)
	version_option.selected = 0
	version_option.item_selected.connect(_on_version_selected)
	game_options_panel.add_child(version_option)
	
	# Server Configuration
	var server_label = Label.new()
	server_label.text = "Server Configuration:"
	server_label.add_theme_color_override("font_color", Color(0.827, 0.702, 0.349, 1))
	game_options_panel.add_child(server_label)
	
	var server_input = LineEdit.new()
	server_input.placeholder_text = "Enter server address (e.g., 127.0.0.1:8085)"
	server_input.add_theme_color_override("font_color", Color(0.827, 0.702, 0.349, 1))
	server_input.add_theme_color_override("caret_color", Color(0.827, 0.702, 0.349, 1))
	game_options_panel.add_child(server_input)

# Button Event Handler
func _on_repair_button_pressed():
	if not download_in_progress:
		start_download(true)

func _on_play_button_pressed():
	if can_play:
		launch_game()

func _on_download_button_pressed():
	if not download_in_progress:
		start_download(false)

func _on_settings_button_pressed():
	open_settings()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_version_selected(index: int):
	# Ändere Game Version
	match index:
		0: current_game_version = "retail"
		1: current_game_version = "classic"
		2: current_game_version = "classic_era"
	
	check_game_status()

# Download Funktionen
func start_download(repair: bool):
	download_in_progress = true
	update_button_states()
	
	# Simuliere Download-Prozess
	simulate_download(repair)

func simulate_download(repair: bool):
	# Simuliere Download-Fortschritt
	var download_steps = [
		"Connecting to server...",
		"Checking files...",
		"Downloading patches...",
		"Downloading addons...",
		"Installing updates...",
		"Cleaning cache...",
		"Complete!"
	]
	
	var current_step = 0
	var progress = 0.0
	
	for step in download_steps:
		file_label.text = step
		file_progress.value = progress
		
		# Simuliere Fortschritt für jeden Schritt
		for i in range(10):
			await get_tree().create_timer(0.1).timeout
			progress += 1.0
			file_progress.value = progress
			total_progress.value = (current_step * 10 + i) * 100.0 / (download_steps.size() * 10)
			total_label.text = "Total: " + str(int(total_progress.value)) + "%"
		
		current_step += 1
	
	# Download abgeschlossen
	download_in_progress = false
	can_play = true
	update_play_button_visibility()
	update_button_states()
	
	# Spiele End-Sound
	play_end_sound()

func update_button_states():
	repair_button.disabled = download_in_progress
	play_button.disabled = download_in_progress
	download_button.disabled = download_in_progress
	settings_button.disabled = download_in_progress

# Game Launch Funktionen (Arctium Launcher Funktionalität)
func launch_game():
	# Starte World of Warcraft mit Arctium Launcher Funktionalität
	var game_info = game_config.supported_versions[current_game_version]
	var game_path = get_game_path()
	var binary_path = game_path.path_join(game_info.binary)
	
	if not FileAccess.file_exists(binary_path):
		print("Game binary not found: ", binary_path)
		return
	
	# Erstelle Launch-Parameter
	var launch_args = []
	
	# Füge Server-Konfiguration hinzu
	var server_config = get_server_config()
	if server_config:
		launch_args.append("-portal")
		launch_args.append(server_config)
	
	# Füge Version-Parameter hinzu
	match current_game_version:
		"classic":
			launch_args.append("--version")
			launch_args.append("Classic")
		"classic_era":
			launch_args.append("--version")
			launch_args.append("ClassicEra")
	
	# Füge Config-Parameter hinzu
	launch_args.append("-config")
	launch_args.append(game_config.config_file)
	
	# Starte das Spiel
	var os_name = OS.get_name()
	
	match os_name:
		"Windows":
			# Windows: Starte direkt
			OS.execute(binary_path, launch_args, false)
		"macOS":
			# macOS: Starte über open
			var args = [binary_path] + launch_args
			OS.execute("open", args, false)
		"Linux":
			# Linux: Wine
			var args = [binary_path] + launch_args
			OS.execute("wine", args, false)
		_:
			print("Unsupported platform: ", os_name)

func get_game_path() -> String:
	# Bestimme Spiel-Pfad
	var game_info = game_config.supported_versions[current_game_version]
	var base_path = game_config.game_path
	
	if base_path.is_empty():
		# Verwende aktuelles Verzeichnis
		base_path = OS.get_executable_path().get_base_dir()
	
	return base_path.path_join(game_info.folder)

func get_server_config() -> String:
	# Hole Server-Konfiguration aus UI oder Settings
	# Hier würde die Server-Konfiguration aus dem UI gelesen werden
	return "127.0.0.1:8085"  # Default für lokale Entwicklung

func open_settings():
	# Öffne Einstellungsfenster
	print("Opening settings...")
	# Hier würde das Settings-Fenster geöffnet werden

func play_end_sound():
	# Spiele End-Sound
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	
	var sound_file = load("res://assets/sounds/" + config.end_sound)
	if sound_file:
		audio_player.stream = sound_file
		audio_player.play()
		
		# Entferne AudioPlayer nach dem Abspielen
		await audio_player.finished
		audio_player.queue_free()

# Event Bus System (wie im Original)
signal file_percent_updated(percent: float)
signal total_percent_updated(percent: float)
signal file_path_updated(path: String)

func _on_file_percent_updated(percent: float):
	file_progress.value = percent

func _on_total_percent_updated(percent: float):
	total_progress.value = percent
	total_label.text = "Total: " + str(int(percent)) + "%"

func _on_file_path_updated(path: String):
	file_label.text = path