class_name BookkeeperClicker
extends Control

@export var label: Label
@onready var anim: AnimatedSprite2D = $TurnPageButton/AnimatedSprite2D
var last_press_time: float = 0.0

# Reference to the upgrade type that affects click multiplier
var upgrade_type: int = GameState.UpgradeType.FIRST_UPGRADE

func _ready() -> void:
	GameState.load()
	GameState.connect("data_changed", Callable(self, "_on_game_state_changed"))
	update_label()

func _on_button_pressed() -> void:
	var mult: int = GameState.get_upgrade(upgrade_type)["click_multiplier"]
	GameState.add_pages(mult)
	play_turn_anim()

func _on_game_state_changed(key: String, value: Variant) -> void:
	if key == "pages":
		update_label()

func update_label() -> void:
	label.text = "Pages: %d" % GameState.get_value("pages", 0)

func play_turn_anim() -> void:
	var now = Time.get_ticks_msec() / 1000.0
	var delta = now - last_press_time
	var speed = clamp(1.0 / max(delta, 0.001), 0.5, 3.0)
	last_press_time = now
	anim.speed_scale = speed
	anim.play("PageFlip")
