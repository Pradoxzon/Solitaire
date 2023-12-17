extends Node


@export var stock_pile: Stock
@export var talon_pile: Talon
@export var foundations: Array[Foundation]
@export var tableau_piles: Array[TableauPile]

var is_talon_selected: bool
var selected_tableau: TableauPile = null


# Called when the node enters the scene tree for the first time.
func _ready():
	stock_pile.visible = false
	talon_pile.visible = false
	is_talon_selected = false
	for f in foundations:
		f.visible = false
	for t in tableau_piles:
		t.visible = false
	$Title.text = "Solitaire!\nHit 'New Game'"


func _on_new_game():
	$Title.visible = false
	stock_pile.visible = true
	stock_pile.reset_cards()
	talon_pile.visible = true
	for f in foundations:
		f.visible = true
		f.reset_cards()
	for t in tableau_piles:
		t.reset_cards()
	$Deck.reset_cards()
	$Deck.show_cards()
	var cards: Array[Card] = $Deck.shuffle()
	for i in range(tableau_piles.size()):
		for j in range(i, tableau_piles.size()):
			tableau_piles[j].add_card(cards.pop_front())
	for t in tableau_piles:
		t.visible = true
		t.show_last_card()
	stock_pile.add_cards(cards)


func game_over():
	$Title.text = "Congratulations,\nYou Won!"
	$Title.visible = true
	stock_pile.visible = false
	talon_pile.visible = false
	for f in foundations:
		f.visible = false
	for t in tableau_piles:
		t.visible = false
	$Deck.hide_cards()


func check_game_over():
	for f in foundations:
		if not f.is_full():
			return
	if not stock_pile.is_empty() and talon_pile.is_empty():
		return
	game_over()


func reset_talon_selection() -> void:
	is_talon_selected = false
	talon_pile.show_selected_card(false)


func reset_tableau_selection() -> void:
	if selected_tableau != null:
		selected_tableau.deselect_cards()
		selected_tableau = null


func _on_stock_pile_clicked() -> void:
	reset_talon_selection()
	reset_tableau_selection()
	if not stock_pile.is_empty():
		talon_pile.add_cards(stock_pile.draw())
	else:
		stock_pile.add_cards(talon_pile.pop_all_cards())


func _on_talon_pile_clicked() -> void:
	reset_tableau_selection()
	if not talon_pile.is_empty():
		is_talon_selected = true
		talon_pile.show_selected_card(true)


func _on_foundation_clicked(foundation: Foundation) -> void:
	if not is_talon_selected and selected_tableau == null:
		return
	elif is_talon_selected:
		reset_talon_selection()
		if foundation.try_add_card(talon_pile.get_last_card()):
			talon_pile.pop_last_card()
			check_game_over()
	elif selected_tableau != null and selected_tableau.is_back_card_selected():
		var card: Card = selected_tableau.get_selected_cards()[0]
		if foundation.try_add_card(card):
			selected_tableau.pop_selected_cards(false)
			check_game_over()
	reset_tableau_selection()

	


func _on_tableau_pile_clicked(tableau_pile: TableauPile) -> void:
#	print("Tableau pile clicked :: ", tableau_pile.name, " :: ", tableau_pile.get_selected_cards(), " :: ", tableau_pile.is_back_card_selected())
	var is_last_card: bool = tableau_pile.is_back_card_selected()
	var has_selected_cards: bool = tableau_pile.has_selected_cards()
	if is_talon_selected:
		reset_talon_selection()
		tableau_pile.deselect_cards()
		if (is_last_card or tableau_pile.is_empty()) and tableau_pile.is_valid_next_card(talon_pile.get_last_card()):
			tableau_pile.add_card(talon_pile.pop_last_card())
	# X 1. No other selection, flipped card -> no new selection
	# X 2. No other selection, clicked faceup cards -> new selection
	# X 3. Other selection, flipped card -> reset selection, no new selection
	# X 4. Other selection, clicked faceup cards -> check for move or replace selection
	elif selected_tableau == tableau_pile:
		reset_tableau_selection()
	elif not has_selected_cards:
		if tableau_pile.is_empty() and selected_tableau != null:
			if tableau_pile.try_add_cards(selected_tableau.get_selected_cards()):
				selected_tableau.pop_selected_cards()
		reset_tableau_selection()
	elif selected_tableau == null:
		selected_tableau = tableau_pile
	else:
		if is_last_card:
			if tableau_pile.try_add_cards(selected_tableau.get_selected_cards()):
				selected_tableau.pop_selected_cards()
			tableau_pile.deselect_cards()
			reset_tableau_selection()
		else:
			reset_tableau_selection()
			selected_tableau = tableau_pile
