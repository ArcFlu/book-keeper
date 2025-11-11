class_name PrototypeClicker
extends Control

@export var label: Label
@onready var turn_page_animation = $TurnPageButton/AnimatedSprite2D

var game_state := {
	"pages": 0,
	"button_upgrade": 1
}

# Track last press time
var last_press_time := 0.0
var default_speed := 1.0
var min_speed := 0.5
var max_speed := 3.0

func _ready() -> void:
	load_game_state()
	update_label_text()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game_state()
	elif what == NOTIFICATION_PREDELETE:
		save_game_state()

func add_pages() -> void:
	game_state["pages"] += 1 * game_state["button_upgrade"]
	update_label_text()
	save_game_state()

func update_label_text() -> void:
	label.text = "Pages: %d" % game_state["pages"]

func save_game_state() -> void:
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(game_state))
		file.close()

func load_game_state() -> void:
	if FileAccess.file_exists("user://save.json"):
		var file = FileAccess.open("user://save.json", FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		var result = JSON.parse_string(content)
		if typeof(result) == TYPE_DICTIONARY:
			game_state = result

func _on_button_pressed() -> void:
	add_pages()

	# Calculate speed based on how quickly the button is pressed
	var current_time = Time.get_ticks_msec() / 1000.0  # convert ms to seconds
	var delta = current_time - last_press_time

	# Faster clicks -> higher animation speed
	var speed = default_speed
	if last_press_time > 0:
		speed = clamp(1.0 / delta, min_speed, max_speed)

	last_press_time = current_time

	# Set the animation speed and play
	turn_page_animation.speed_scale = speed
	turn_page_animation.play("PageFlip")
