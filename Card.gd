extends TextureButton

class_name Card

signal click_card(card)

var properties: Dictionary = {
	card_type = null,
	hp = 100,
	damage = 42
}

enum State {
	ACTIVE = 1,
	INACTIVE = -1
}

func init(card_type: String, hp: int, damage: int):
	properties.card_type = card_type
	properties.hp = hp
	properties.damage = damage
	
	var texture = ImageTexture.new()
	var image = Image.new()
	
	if card_type == "RED":
		image.load("res://assets/red.png")
	else:
		image.load("res://assets/yellow.png")
	
	var image_size = image.get_size()
	texture.create_from_image(image)
	texture_normal = texture
	set_size(image_size)

func _ready():
	var size = get_size()
	$Icon.position = Vector2(size.x/2, size.y/2.3)
	$Icon.scale = Vector2(0.7, 0.7)
	
	$Hp.set_position(Vector2(25, size.y/1.4))
	$Damage.set_position(Vector2(25, size.y/1.2))
	update_labels()
	
	Globals.connect("card_hit", self, "on_card_hit")

func _process(delta):
	# Add some animation...
	#if disabled:
	#	$Icon.rotate(delta)
	pass

func _pressed():
	var card_num = get_position_in_parent()
	#print("Card number ", card_num, ": ", properties)
	
	set_pos_by_state(State.ACTIVE)
	set_all_disabled(true)
	Globals.emit_signal("card_click", self)

func set_all_disabled(disabled: bool, card: Card = self):
	for c in card.get_parent().get_children():
		c = c as Card
		c.disabled = disabled

func set_pos_by_state(state: int, card: Card = self):
	var position = card.get_position()
	card.set_position(Vector2(position.x, position.y-(20*state)))

func on_card_hit(from: Card, to: Card):
	if self != to:
		return
	set_all_disabled(false, from)
	set_all_disabled(false, to)
	set_pos_by_state(State.INACTIVE, from)
	set_pos_by_state(State.INACTIVE, to)
	
	var damage = from.properties.damage
	properties.hp -= damage
	update_labels()
	
	if properties.hp <= 0:
		queue_free()

func update_labels():
	$Hp.text = "HP: " + str(properties.hp)
	$Damage.text = "HP: " + str(properties.damage)
