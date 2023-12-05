class_name Stock
extends Area2D


signal stock_clicked

var cards: Array[Card]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func add_cards(cards_to_add: Array[Card]) -> void:
#	print("Stock :: Adding ", cards_to_add.size(), " cards to pile.")
	for card in cards_to_add:
		card.position = self.position
		card.visible = true
		if card.showing_front:
			card.flip()
	cards.append_array(cards_to_add)


func is_empty() -> bool:
	return cards.size() <= 0


func draw(amount: int = 1) -> Array[Card]:
	var drawn_cards: Array[Card]
	for i in range(min(amount, cards.size())):
		drawn_cards.append(cards.pop_front())
	return drawn_cards


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		stock_clicked.emit()
