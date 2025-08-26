extends Control

# WoW Launcher Hauptskript
# Nachbau des Arctium WoW-Launchers in Godot 4

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

# Konfiguration
var config = {
	"host": "ftp.murlocvillage.com",
	"available_language": ["frFR", "enUS"],
	"default_language": "enUS",
	"patchlist_endpoint": "http://127.0.0.1:9000",
	"end_sound": "murloc.mp3",
	"path_end": ".json"
}

# Status Variablen
var download_in_progress = false
var can_play = false
var version = "1.0.0"

# Patch Manager
var patch_manager = null

func _ready():
	# Initialisiere UI
	setup_ui()
	setup_connections()
	load_config()
	check_game_status()
	start_murloc_animation()

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
	# Simuliere Spielstatus-Prüfung
	# In der echten Implementierung würde hier die Datei-Prüfung stattfinden
	return false

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

func launch_game():
	# Starte World of Warcraft
	var os_name = OS.get_name()
	
	match os_name:
		"Windows":
			# Windows: Starte Wow.exe
			OS.execute("Wow.exe", [], false)
		"macOS":
			# macOS: Starte Wow.app
			OS.execute("open", ["Wow.app"], false)
		"Linux":
			# Linux: Wine Wow.exe
			OS.execute("wine", ["Wow.exe"], false)
		_:
			print("Unsupported platform: ", os_name)

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