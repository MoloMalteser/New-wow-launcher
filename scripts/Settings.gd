extends Window

# Settings Fenster für WoW Launcher
# Verwaltet Launcher-Einstellungen

# UI Referenzen
@onready var language_option = $VBoxContainer/LanguageSection/LanguageOption
@onready var game_path_input = $VBoxContainer/GameSection/GamePathContainer/GamePathInput
@onready var browse_button = $VBoxContainer/GameSection/GamePathContainer/BrowseButton
@onready var sound_enabled = $VBoxContainer/AudioSection/SoundEnabled
@onready var volume_slider = $VBoxContainer/AudioSection/VolumeSlider
@onready var save_button = $VBoxContainer/ButtonContainer/SaveButton
@onready var cancel_button = $VBoxContainer/ButtonContainer/CancelButton

# Einstellungen
var settings = {
	"language": "enUS",
	"game_path": "",
	"sound_enabled": true,
	"volume": 50.0
}

func _ready():
	# Initialisiere UI
	setup_ui()
	setup_connections()
	load_settings()

func setup_ui():
	# Setze initiale UI-Werte
	language_option.add_item("English (US)", 0)
	language_option.add_item("Français (FR)", 1)
	
	# Setze Standardwerte
	language_option.selected = 0
	sound_enabled.button_pressed = true
	volume_slider.value = 50.0

func setup_connections():
	# Verbinde Button-Signale
	browse_button.pressed.connect(_on_browse_button_pressed)
	save_button.pressed.connect(_on_save_button_pressed)
	cancel_button.pressed.connect(_on_cancel_button_pressed)
	
	# Verbinde Window-Signale
	close_requested.connect(_on_close_requested)

func load_settings():
	# Lade gespeicherte Einstellungen
	var settings_file = FileAccess.open("user://settings.json", FileAccess.READ)
	if settings_file:
		var json_string = settings_file.get_as_text()
		var loaded_settings = JSON.parse_string(json_string)
		if loaded_settings:
			settings = loaded_settings
			apply_settings_to_ui()
		settings_file.close()

func apply_settings_to_ui():
	# Wende Einstellungen auf UI an
	match settings.language:
		"enUS":
			language_option.selected = 0
		"frFR":
			language_option.selected = 1
	
	game_path_input.text = settings.get("game_path", "")
	sound_enabled.button_pressed = settings.get("sound_enabled", true)
	volume_slider.value = settings.get("volume", 50.0)

func save_settings():
	# Speichere Einstellungen
	settings.language = "enUS" if language_option.selected == 0 else "frFR"
	settings.game_path = game_path_input.text
	settings.sound_enabled = sound_enabled.button_pressed
	settings.volume = volume_slider.value
	
	var settings_file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	if settings_file:
		settings_file.store_string(JSON.stringify(settings))
		settings_file.close()

# Button Event Handler
func _on_browse_button_pressed():
	# Öffne Datei-Dialog für Spiel-Pfad
	var file_dialog = FileDialog.new()
	add_child(file_dialog)
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.title = "Select World of Warcraft Directory"
	
	file_dialog.dir_selected.connect(_on_game_path_selected)
	file_dialog.popup_centered()

func _on_game_path_selected(path: String):
	game_path_input.text = path

func _on_save_button_pressed():
	save_settings()
	hide()

func _on_cancel_button_pressed():
	hide()

func _on_close_requested():
	hide()

# Öffentliche Funktionen
func show_settings():
	# Zeige Settings-Fenster
	popup_centered()

func get_game_path() -> String:
	return settings.get("game_path", "")

func is_sound_enabled() -> bool:
	return settings.get("sound_enabled", true)

func get_volume() -> float:
	return settings.get("volume", 50.0)

func get_language() -> String:
	return settings.get("language", "enUS")