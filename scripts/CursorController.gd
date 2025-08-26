extends Node

# Cursor Controller für WoW Launcher
# Verwaltet Mausbewegungen und Klicks

# Cursor Referenzen
@onready var launcher = get_parent()
@onready var main_panel = launcher.get_node("MainPanel")

# Cursor States
var is_hovering = false
var last_mouse_position = Vector2.ZERO
var cursor_texture = null

func _ready():
	# Initialisiere Cursor
	setup_cursor()
	connect_signals()

func setup_cursor():
	# Lade Cursor-Textur
	cursor_texture = load("res://assets/images/wow.ico")
	if cursor_texture:
		Input.set_custom_mouse_cursor(cursor_texture)

func connect_signals():
	# Verbinde Maus-Signale
	if main_panel:
		main_panel.mouse_entered.connect(_on_panel_mouse_entered)
		main_panel.mouse_exited.connect(_on_panel_mouse_exited)

func _input(event):
	# Verarbeite Maus-Eingaben
	if event is InputEventMouseMotion:
		handle_mouse_motion(event)
	elif event is InputEventMouseButton:
		handle_mouse_click(event)

func handle_mouse_motion(event: InputEventMouseMotion):
	# Verarbeite Mausbewegung
	last_mouse_position = event.position
	
	# Prüfe Hover-States für Buttons
	check_button_hover(event.position)

func handle_mouse_click(event: InputEventMouseButton):
	# Verarbeite Mausklicks
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		handle_left_click(event.position)

func check_button_hover(mouse_pos: Vector2):
	# Prüfe welche Buttons gehovered werden
	var buttons = [
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/RepairButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/PlayButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/DownloadButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/SettingsButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/QuitButton")
	]
	
	for button in buttons:
		if button and button.get_global_rect().has_point(mouse_pos):
			# Button wird gehovered
			on_button_hover(button, true)
		else:
			# Button wird nicht mehr gehovered
			on_button_hover(button, false)

func on_button_hover(button: Button, hovering: bool):
	# Reagiere auf Button-Hover
	if hovering:
		# Zeige Tooltip
		show_tooltip(button)
	else:
		# Verstecke Tooltip
		hide_tooltip()

func handle_left_click(mouse_pos: Vector2):
	# Verarbeite Linksklick
	var buttons = [
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/RepairButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/PlayButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/DownloadButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/SettingsButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/QuitButton")
	]
	
	for button in buttons:
		if button and button.get_global_rect().has_point(mouse_pos):
			# Button wurde geklickt
			on_button_click(button)
			break

func on_button_click(button: Button):
	# Reagiere auf Button-Klick
	# Der eigentliche Klick wird über die Button-Signale verarbeitet
	# Hier können zusätzliche Effekte hinzugefügt werden
	
	# Spiele Klick-Sound
	play_click_sound()
	
	# Visueller Feedback
	button.modulate = Color(0.8, 0.8, 0.8, 1.0)
	await get_tree().create_timer(0.1).timeout
	button.modulate = Color.WHITE

func show_tooltip(button: Button):
	# Zeige Tooltip für Button
	var tooltip_text = get_button_tooltip(button)
	if tooltip_text:
		# Hier würde ein Tooltip-System implementiert werden
		print("Tooltip: ", tooltip_text)

func hide_tooltip():
	# Verstecke Tooltip
	pass

func get_button_tooltip(button: Button) -> String:
	# Gibt Tooltip-Text für Button zurück
	match button.name:
		"RepairButton":
			return "Repair game files"
		"PlayButton":
			return "Launch World of Warcraft"
		"DownloadButton":
			return "Download game updates"
		"SettingsButton":
			return "Open settings"
		"QuitButton":
			return "Exit launcher"
		_:
			return ""

func play_click_sound():
	# Spiele Klick-Sound
	var audio_player = AudioStreamPlayer.new()
	launcher.add_child(audio_player)
	
	# Hier würde ein Klick-Sound geladen werden
	# var click_sound = load("res://assets/sounds/click.wav")
	# if click_sound:
	#     audio_player.stream = click_sound
	#     audio_player.play()
	
	# Entferne AudioPlayer nach kurzer Zeit
	await get_tree().create_timer(0.1).timeout
	audio_player.queue_free()

func _on_panel_mouse_entered():
	# Maus ist im Panel-Bereich
	is_hovering = true

func _on_panel_mouse_exited():
	# Maus hat Panel-Bereich verlassen
	is_hovering = false
	hide_tooltip()

# Cursor Animation (optional)
func animate_cursor():
	# Optional: Cursor-Animation
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.5)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5)extends Node

# Cursor Controller für WoW Launcher
# Verwaltet Mausbewegungen und Klicks

# Cursor Referenzen
@onready var launcher = get_parent()
@onready var main_panel = launcher.get_node("MainPanel")

# Cursor States
var is_hovering = false
var last_mouse_position = Vector2.ZERO
var cursor_texture = null

func _ready():
	# Initialisiere Cursor
	setup_cursor()
	connect_signals()

func setup_cursor():
	# Lade Cursor-Textur
	cursor_texture = load("res://assets/images/wow.ico")
	if cursor_texture:
		Input.set_custom_mouse_cursor(cursor_texture)

func connect_signals():
	# Verbinde Maus-Signale
	if main_panel:
		main_panel.mouse_entered.connect(_on_panel_mouse_entered)
		main_panel.mouse_exited.connect(_on_panel_mouse_exited)

func _input(event):
	# Verarbeite Maus-Eingaben
	if event is InputEventMouseMotion:
		handle_mouse_motion(event)
	elif event is InputEventMouseButton:
		handle_mouse_click(event)

func handle_mouse_motion(event: InputEventMouseMotion):
	# Verarbeite Mausbewegung
	last_mouse_position = event.position
	
	# Prüfe Hover-States für Buttons
	check_button_hover(event.position)

func handle_mouse_click(event: InputEventMouseButton):
	# Verarbeite Mausklicks
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		handle_left_click(event.position)

func check_button_hover(mouse_pos: Vector2):
	# Prüfe welche Buttons gehovered werden
	var buttons = [
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/RepairButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/PlayButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/DownloadButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/SettingsButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/QuitButton")
	]
	
	for button in buttons:
		if button and button.get_global_rect().has_point(mouse_pos):
			# Button wird gehovered
			on_button_hover(button, true)
		else:
			# Button wird nicht mehr gehovered
			on_button_hover(button, false)

func on_button_hover(button: Button, hovering: bool):
	# Reagiere auf Button-Hover
	if hovering:
		# Zeige Tooltip
		show_tooltip(button)
	else:
		# Verstecke Tooltip
		hide_tooltip()

func handle_left_click(mouse_pos: Vector2):
	# Verarbeite Linksklick
	var buttons = [
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/RepairButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/PlayButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/DownloadButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/SettingsButton"),
		launcher.get_node("MainPanel/VBoxContainer/ButtonArea/QuitButton")
	]
	
	for button in buttons:
		if button and button.get_global_rect().has_point(mouse_pos):
			# Button wurde geklickt
			on_button_click(button)
			break

func on_button_click(button: Button):
	# Reagiere auf Button-Klick
	# Der eigentliche Klick wird über die Button-Signale verarbeitet
	# Hier können zusätzliche Effekte hinzugefügt werden
	
	# Spiele Klick-Sound
	play_click_sound()
	
	# Visueller Feedback
	button.modulate = Color(0.8, 0.8, 0.8, 1.0)
	await get_tree().create_timer(0.1).timeout
	button.modulate = Color.WHITE

func show_tooltip(button: Button):
	# Zeige Tooltip für Button
	var tooltip_text = get_button_tooltip(button)
	if tooltip_text:
		# Hier würde ein Tooltip-System implementiert werden
		print("Tooltip: ", tooltip_text)

func hide_tooltip():
	# Verstecke Tooltip
	pass

func get_button_tooltip(button: Button) -> String:
	# Gibt Tooltip-Text für Button zurück
	match button.name:
		"RepairButton":
			return "Repair game files"
		"PlayButton":
			return "Launch World of Warcraft"
		"DownloadButton":
			return "Download game updates"
		"SettingsButton":
			return "Open settings"
		"QuitButton":
			return "Exit launcher"
		_:
			return ""

func play_click_sound():
	# Spiele Klick-Sound
	var audio_player = AudioStreamPlayer.new()
	launcher.add_child(audio_player)
	
	# Hier würde ein Klick-Sound geladen werden
	# var click_sound = load("res://assets/sounds/click.wav")
	# if click_sound:
	#     audio_player.stream = click_sound
	#     audio_player.play()
	
	# Entferne AudioPlayer nach kurzer Zeit
	await get_tree().create_timer(0.1).timeout
	audio_player.queue_free()

func _on_panel_mouse_entered():
	# Maus ist im Panel-Bereich
	is_hovering = true

func _on_panel_mouse_exited():
	# Maus hat Panel-Bereich verlassen
	is_hovering = false
	hide_tooltip()

# Cursor Animation (optional)
func animate_cursor():
	# Optional: Cursor-Animation
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.5)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5)