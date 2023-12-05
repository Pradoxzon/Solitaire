class_name Talon
extends Area2D


signal talon_clicked

var cards: Array[Card]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func add_cards(cards_to_add: Array[Card]) -> void:
#	print("Talon :: Adding ", cards_to_add.size(), " cards to pile.")
	if cards.size() > 0:
		cards.back().visible = false
	for card in cards_to_add:
		card.position = self.position
		card.visible = false
		if not card.showing_front:
			card.flip()
	cards.append_array(cards_to_add)
	if cards.size() > 0:
		cards.back().visible = true


func is_empty() -> bool:
	return cards.size() <= 0


func get_last_card() -> Card:
	return cards.back()


func pop_last_card() -> Card:
	return cards.pop_back()


func pop_all_cards() -> Array[Card]:
	var all_cards = cards.duplicate(true)
	cards.clear()
	return all_cards


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		talon_clicked.emit()
