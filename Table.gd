extends Node2D

onready var Card: PackedScene = preload("res://Card.tscn")
onready var window_size: Vector2 = OS.get_real_window_size()
onready var cell_size = Vector2(window_size.x/5, window_size.y/2)

var selected_cards: Array = []

func _ready():
	create_cards($TopRow, "RED")
	create_cards($BottomRow, "YELLOW")
	Globals.connect("card_click", self, "on_card_click")

func create_cards(placeholder: Node2D, card_type: String):
	for i in range(5):
		var card: Card = Card.instance()
		var hp = int(rand_range(50, 150))
		var damage = int(rand_range(10, 30))
		card.init(card_type, hp, damage)
		
		var card_size = card.get_size()
		var pos = Vector2()
		pos.x = cell_size.x*i + ((cell_size.x - card_size.x) / 2)
		pos.y = cell_size.y/2 - ((cell_size.y - card_size.y) / 2)
		if placeholder == $BottomRow:
			pos.y += cell_size.y
		
		card.set_position(pos)
		placeholder.add_child(card)

func on_card_click(card: Card):
	selected_cards.push_back(card)
	if selected_cards.size() == 2:
		var t = Timer.new()
		t.set_wait_time(0.5)
		t.set_one_shot(true)
		add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		Globals.emit_signal("card_hit", selected_cards[0], selected_cards[1])
		selected_cards.clear()

