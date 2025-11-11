class_name PrototypeClicker
extends Control

@export var label: Label
@onready var turn_page_animation = $TurnPageButton/AnimatedSprite2D

# Track last press time
var last_press_time := 0.0
var default_speed := 1.0
var min_speed := 0.5
var max_speed := 3.0

func _ready() -> void:
	GameState.load()
	update_label_text()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		GameState.save()
	elif what == NOTIFICATION_PREDELETE:
		GameState.save()

func add_pages() -> void:
	GameState.data["pages"] += 1 * GameState.data["first_upgrade"]["click_multiplier"]
	update_label_text()
	GameState.save()

func update_label_text() -> void:
	label.text = "Pages: %d" % GameState.data["pages"]

func _on_button_pressed() -> void:
	add_pages()

	# Calculate speed based on how quickly the button is pressed
	var current_time = Time.get_ticks_msec() / 1000.0  # convert ms to seconds
	var delta = current_time - last_press_time

	var speed = default_speed
	if last_press_time > 0:
		speed = clamp(1.0 / delta, min_speed, max_speed)

	last_press_time = current_time

	turn_page_animation.speed_scale = speed
	turn_page_animation.play("PageFlip")
