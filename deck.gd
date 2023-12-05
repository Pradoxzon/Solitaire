class_name Deck
extends Node


signal card_clicked(card: Card)

@export var number_of_decks: int = 1
var card_node: PackedScene = load("res://card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_cards(number_of_decks)
	hide_cards()


func setup_cards(num_decks: int = 1) -> void:
	for i in range(max(num_decks, 1)):
		create_cards()


func create_cards() -> void:
	for suite in CardSuites.Suites:
		for card_num in CardSuites.CardNums:
			var card = card_node.instantiate()
			card.suite = suite
			card.card_num = card_num
			card.connect("card_clicked", _on_card_clicked)
			add_child(card)


func hide_cards() -> void:
	for card in get_tree().get_nodes_in_group("cards"):
		card.visible = false


func show_cards() -> void:
	for card in get_tree().get_nodes_in_group("cards"):
		card.visible = true


func shuffle() -> Array[Card]:
	randomize()
	var all_card_nodes = get_tree().get_nodes_in_group("cards")
	var all_cards: Array[Card]
	for node in all_card_nodes:
		all_cards.append(node.get_card())
	all_cards.shuffle()
	return all_cards


func reset_cards() -> void:
	get_tree().call_group("cards", "reset_card")


func display() -> void:
	var x = 100
	var y = 100
	var row_count = 0
	for card in shuffle():
		card.position = Vector2(x, y)
		x += 150
		row_count += 1
		if row_count >= 13:
			x = 100
			y += 200
			row_count = 0


func _on_card_clicked(card) -> void:
	card_clicked.emit(card)
