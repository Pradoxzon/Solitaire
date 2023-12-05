extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$StockPile.visible = false
	$TalonPile.visible = false


func _on_new_game():
	$Title.visible = false
	$StockPile.visible = true
	$TalonPile.visible = true
	$Deck.reset_cards()
	$Deck.show_cards()
	$StockPile.add_cards($Deck.shuffle())


func _on_game_over():
	$Title.visible = true
	$StockPile.visible = false
	$TalonPile.visible = false
	$Deck.hide_cards()


func _on_deck_card_clicked(card: Card):
	pass
#	card.flip()
#	print(
#		"Main :: Detected a card click :: ", card.suite, "-", card.card_num,
#		" :: is red? ", card.is_red(), " :: is black? ", card.is_black(),
#		" :: showing front? ", card.showing_front)


func _on_stock_pile_clicked() -> void:
	if not $StockPile.is_empty():
		$TalonPile.add_cards($StockPile.draw())
	else:
		$StockPile.add_cards($TalonPile.pop_all_cards())


func _on_talon_pile_clicked() -> void:
	print("Talon pile clicked.")
