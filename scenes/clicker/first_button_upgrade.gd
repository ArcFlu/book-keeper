extends TextureButton

@export var first_upgrade_label: Label  # Label containing placeholders
@onready var first_upgrade_animation = $AnimatedSprite2D

func _ready() -> void:
	# Ensure first_upgrade key exists
	if not GameState.data.has("first_upgrade"):
		GameState.data["first_upgrade"] = {
			"click_multiplier": 1,
			"price": 10
		}
	update_label_text()
	update_button_state()

func _process(delta: float) -> void:
	update_button_state()

func _on_button_pressed() -> void:
	first_upgrade_animation.play("button_press")
	var upgrade_data = GameState.data["first_upgrade"]
	if GameState.data["pages"] >= upgrade_data["price"]:
		# Deduct pages
		GameState.data["pages"] -= upgrade_data["price"]

		# Increase the main click multiplier
		GameState.data["button_upgrade"] += upgrade_data["click_multiplier"]

		# Increase upgrade price
		upgrade_data["price"] = int(upgrade_data["price"] * 1.5)

		# Save game state
		GameState.save()

		# Refresh label
		update_label_text()
		update_button_state()

func update_label_text() -> void:
	if first_upgrade_label:
		var text = first_upgrade_label.text
		var upgrade_data = GameState.data["first_upgrade"]

		# Replace placeholders with actual values
		text = text.replace("<click_multiplier_value>", str(upgrade_data["click_multiplier"]))
		text = text.replace("<price_value>", str(upgrade_data["price"]))

		first_upgrade_label.text = text

func update_button_state() -> void:
	var upgrade_data = GameState.data["first_upgrade"]
	disabled = GameState.data["pages"] < upgrade_data["price"]
