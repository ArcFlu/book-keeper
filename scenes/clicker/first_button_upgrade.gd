extends TextureButton

@onready var label: Label = $"../FirstUpgradeLabel"
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var label_template: String = ""

# Reference to the upgrade type for this button
var upgrade_type: int = GameState.UpgradeType.FIRST_UPGRADE

func _ready() -> void:
	GameState.load()
	GameState.connect("data_changed", Callable(self, "_on_game_state_changed"))
	label_template = label.text
	update_label()
	update_state()

func _on_button_pressed() -> void:
	anim.play("button_press")
	var u: Dictionary = GameState.get_upgrade(upgrade_type)
	if GameState.spend_pages(u["price"]):
		GameState.update_upgrade(upgrade_type)
func _on_game_state_changed(key: String, value: Variant) -> void:
	if key in ["pages", "upgrades"]:
		update_label()
		update_state()

func update_label() -> void:
	var u: Dictionary = GameState.get_value("upgrades", {}).get(upgrade_type, {"click_multiplier": 1, "price": 10})
	label.text = label_template\
		.replace("<click_multiplier_value>", str(u["click_multiplier"]))\
		.replace("<price_value>", str(u["price"]))

func update_state() -> void:
	var u: Dictionary = GameState.get_value("upgrades", {}).get(upgrade_type, {"click_multiplier": 1, "price": 10})
	var can_afford: bool = GameState.get_value("pages", 0) >= u["price"]
	disabled = not can_afford
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if can_afford else Control.CURSOR_FORBIDDEN
	modulate = Color(1, 1, 1, 1) if can_afford else Color(0.5, 0.5, 0.5, 1)  # full color or greyed out
