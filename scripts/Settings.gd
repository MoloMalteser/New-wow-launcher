extends Window

# Settings Fenster für WoW Launcher
# Verwaltet Launcher-Einstellungen und Game-Launcher-Konfiguration

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
	"volume": 50.0,
	"server_config": "127.0.0.1:8085",
	"default_game_version": "retail",
	"auto_clear_cache": true,
	"dev_mode": false
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
	
	# Erweitere UI um Game-Launcher-Einstellungen
	setup_game_launcher_ui()

func setup_game_launcher_ui():
	# Füge Game-Launcher-spezifische Einstellungen hinzu
	var game_launcher_section = VBoxContainer.new()
	game_launcher_section.name = "GameLauncherSection"
	
	var game_launcher_label = Label.new()
	game_launcher_label.text = "Game Launcher Settings:"
	game_launcher_label.add_theme_color_override("font_color", Color(0.827, 0.702, 0.349, 1))
	game_launcher_section.add_child(game_launcher_label)
	
	# Server Configuration
	var server_label = Label.new()
	server_label.text = "Default Server:"
	server_label.add_theme_color_override("font_color", Color(0.827, 0.702, 0.349, 1))
	game_launcher_section.add_child(server_label)
	
	var server_input = LineEdit.new()
	server_input.placeholder_text = "127.0.0.1:8085"
	server_input.add_theme_color_override("font_color", Color(0.827, 0.702, 0.349, 1))
	server_input.add_theme_color_override("caret_color", Color(0.827, 0.702, 0.349, 1))
	game_launcher_section.add_child(server_input)
	
	# Default Game Version
	var version_label = Label.new()
	version_label.text = "Default Game Version:"
	version_label.add_theme_color_override("font_color", Color(0.827, 0.702, 0.349, 1))
	game_launcher_section.add_child(version_label)
	
	var version_option = OptionButton.new()
	version_option.add_item("Retail", 0)
	version_option.add_item("Classic BC/WotLK", 1)
	version_option.add_item("Classic Era", 2)
	version_option.add_theme_color_override("font_color", Color(0.827, 0.702, 0.349, 1))
	game_launcher_section.add_child(version_option)
	
	# Auto Clear Cache
	var cache_checkbox = CheckBox.new()
	cache_checkbox.text = "Auto Clear Cache"
	cache_checkbox.add_theme_color_override("font_color", Color(0.827, 0.702, 0.349, 1))
	game_launcher_section.add_child(cache_checkbox)
	
	# Dev Mode
	var dev_checkbox = CheckBox.new()
	dev_checkbox.text = "Enable Dev Mode (for local servers)"
	dev_checkbox.add_theme_color_override("font_color", Color(0.827, 0.702, 0.349, 1))
	game_launcher_section.add_child(dev_checkbox)
	
	# Füge Section zum Hauptcontainer hinzu
	var main_container = $VBoxContainer
	main_container.add_child(game_launcher_section)
	
	# Füge Separator hinzu
	var separator = HSeparator.new()
	main_container.add_child(separator)

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
	
	# Game-Launcher-Einstellungen
	var server_input = $VBoxContainer/GameLauncherSection.get_child(2)  # Server Input
	if server_input:
		server_input.text = settings.get("server_config", "127.0.0.1:8085")
	
	var version_option = $VBoxContainer/GameLauncherSection.get_child(4)  # Version Option
	if version_option:
		match settings.get("default_game_version", "retail"):
			"retail":
				version_option.selected = 0
			"classic":
				version_option.selected = 1
			"classic_era":
				version_option.selected = 2
	
	var cache_checkbox = $VBoxContainer/GameLauncherSection.get_child(5)  # Cache Checkbox
	if cache_checkbox:
		cache_checkbox.button_pressed = settings.get("auto_clear_cache", true)
	
	var dev_checkbox = $VBoxContainer/GameLauncherSection.get_child(6)  # Dev Checkbox
	if dev_checkbox:
		dev_checkbox.button_pressed = settings.get("dev_mode", false)

func save_settings():
	# Speichere Einstellungen
	settings.language = "enUS" if language_option.selected == 0 else "frFR"
	settings.game_path = game_path_input.text
	settings.sound_enabled = sound_enabled.button_pressed
	settings.volume = volume_slider.value
	
	# Game-Launcher-Einstellungen
	var server_input = $VBoxContainer/GameLauncherSection.get_child(2)
	if server_input:
		settings.server_config = server_input.text
	
	var version_option = $VBoxContainer/GameLauncherSection.get_child(4)
	if version_option:
		match version_option.selected:
			0: settings.default_game_version = "retail"
			1: settings.default_game_version = "classic"
			2: settings.default_game_version = "classic_era"
	
	var cache_checkbox = $VBoxContainer/GameLauncherSection.get_child(5)
	if cache_checkbox:
		settings.auto_clear_cache = cache_checkbox.button_pressed
	
	var dev_checkbox = $VBoxContainer/GameLauncherSection.get_child(6)
	if dev_checkbox:
		settings.dev_mode = dev_checkbox.button_pressed
	
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

func get_server_config() -> String:
	return settings.get("server_config", "127.0.0.1:8085")

func get_default_game_version() -> String:
	return settings.get("default_game_version", "retail")

func is_auto_clear_cache() -> bool:
	return settings.get("auto_clear_cache", true)

func is_dev_mode() -> bool:
	return settings.get("dev_mode", false)