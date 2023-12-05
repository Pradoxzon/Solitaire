class_name Card
extends Node2D


@export var suite: String = CardSuites.Suites[0]
@export var card_num: String = CardSuites.CardNums[0]

signal card_clicked(card)

var front_texture: Texture2D
var showing_front: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	front_texture = load("res://Art/" + self.to_string() + ".png")
	$Front.texture = front_texture
	$Front.visible = showing_front
	$Back.visible = not showing_front


func get_card() -> Card:
	return self


func flip() -> void:
	showing_front = not showing_front
	#print("Card: " + suite + "-" + card_num + " flipped, showing front: ", showing_front)
	$Front.visible = showing_front
	$Back.visible = not showing_front


func reset_card() -> void:
	if showing_front:
		flip()


func is_red() -> bool:
	return suite in ["Diamonds", "Hearts"]


func is_black() -> bool:
	return suite in ["Clubs", "Spades"]


func _to_string() -> String:
	return suite + "-" + card_num


func _on_input_event(_viewport, event, _shape_idx) -> void:
	#print("Card: " + suite + "-" + card_num + " Encountered iput event: " + event.get_class())
	if event.is_action_pressed("click"):
		#print("Card: " + suite + "-" + card_num + " detected a click.")
		card_clicked.emit(self)
