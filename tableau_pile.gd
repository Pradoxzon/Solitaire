class_name TableauPile
extends Area2D


signal tableau_pile_clicked(tableau_pile: TableauPile)

var cards: Array[Card] = []
var selected_cards: Array[Card] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func reset_cards() -> void:
	for c in cards:
		c.disconnect("card_clicked", _on_card_clicked)
		c.selected(false)
		c.checks_input(false)
	cards.clear()


func add_card(card: Card) -> void:
	var pos: Vector2 = get_global_pos() + Vector2(0, 50 * cards.size())
	card.position = pos
	cards.append(card)
	card.move_to_front()
	card.connect("card_clicked", _on_card_clicked)
	card.checks_input(true)


func try_add_cards(new_cards: Array[Card]) -> bool:
	if new_cards.size() == 0:
		return false
	if not is_valid_next_card(new_cards[0]):
		return false
	for card in new_cards:
		add_card(card)
	return true


func show_last_card() -> void:
	var card: Card = cards.back()
	if not card.showing_front:
		card.flip()


func is_valid_next_card(card: Card) -> bool:
	return card.card_num == next_card_num() and (cards.is_empty() or are_opposite_suites(card, cards.back()))


func are_opposite_suites(card1: Card, card2: Card) -> bool:
	return (card1.is_black() and card2.is_red()) or (card1.is_red() and card2.is_black())


func next_card_num() -> String:
	if cards.is_empty():
		return CardSuites.CardNums.back()
	var top_card_num_index: int = CardSuites.CardNums.find(cards.back().card_num)
	return CardSuites.CardNums[max(1, top_card_num_index - 1)]


func is_empty() -> bool:
	return cards.size() == 0


func get_global_pos() -> Vector2:
	return get_parent().position + self.position


func get_selected_cards() -> Array[Card]:
	return selected_cards


func pop_selected_cards(cards_check_input: bool = true) -> Array[Card]:
	var popped_cards: Array[Card] = selected_cards.duplicate(true)
	for c in popped_cards:
		c.selected(false)
		c.checks_input(cards_check_input)
		c.disconnect("card_clicked", _on_card_clicked)
		cards.remove_at(cards.find(c))
	deselect_cards()
	return popped_cards


func has_selected_cards() -> bool:
	return selected_cards.size() > 0


func is_back_card_selected() -> bool:
	if selected_cards.size() != 1:
		return false
	else:
		return selected_cards[0] == cards.back()


func deselect_cards() -> void:
	for c in selected_cards:
		c.selected(false)
	selected_cards.clear()


func _on_card_clicked(card: Card) -> void:
	deselect_cards()
	if not card.showing_front and card == cards.back():
		card.flip()
		tableau_pile_clicked.emit(self)
	elif card.showing_front:
		selected_cards = cards.slice(cards.find(card))
		for c in selected_cards:
			c.selected(true)
		tableau_pile_clicked.emit(self)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		tableau_pile_clicked.emit(self)
