class_name Foundation
extends Area2D


signal foundation_clicked(foundation: Foundation)

var cards: Array[Card] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func reset_cards() -> void:
	cards.clear()


func try_add_card(card: Card) -> bool:
	if not card.showing_front or is_full():
#		print("Cant add to foundation :: ", card.showing_front, " :: ", is_full())
		return false
	if is_empty() and card.card_num == CardSuites.CardNums[0]:
		cards.append(card)
		card.position = get_global_pos()
		card.move_to_front()
		return true
	elif not is_empty() and card.card_num == get_next_card_num() and card.suite == cards[0].suite:
		cards[0].visible = false
		cards.append(card)
		card.position = get_global_pos()
		card.move_to_front()
		return true
	print("Can't add to foundation :: card - ", card.to_string(), " :: next - ", get_next_card_num())
	return false


func is_empty() -> bool:
	return cards.size() <= 0


func is_full() -> bool:
	return cards.size() == CardSuites.CardNums.size() and cards.back().card_num == CardSuites.CardNums.back()


func get_next_card_num() -> String:
	if is_empty():
		return CardSuites.CardNums[0]
	elif is_full():
		return ""
	else:
		var current_index: int = CardSuites.CardNums.find(cards.back().card_num)
		return CardSuites.CardNums[min(current_index + 1, CardSuites.CardNums.size() - 1)]


func get_global_pos() -> Vector2:
	return get_parent().position + self.position


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		foundation_clicked.emit(self)
