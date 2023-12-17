class_name Card
extends Node2D


@export var suite: String = CardSuites.Suites[0]
@export var card_num: String = CardSuites.CardNums[0]

signal card_clicked(card)

var front_texture: Texture2D
var showing_front: bool = false
var check_input: bool = false
var mouse_inside: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	front_texture = load("res://Art/" + self.to_string() + ".png")
	$Front.texture = front_texture
	$Front.visible = showing_front
	$Back.visible = not showing_front
	$SelectedIndicator.visible = false


func _input(event: InputEvent) -> void:
	if check_input and mouse_inside and event.is_action_pressed("click"):
#		print("Card: ", self, " ate an input event")
		card_clicked.emit(self)
		get_viewport().set_input_as_handled()


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


func checks_input(card_checks_input: bool) -> void:
	check_input = card_checks_input


func is_red() -> bool:
	return suite in ["Diamonds", "Hearts"]


func is_black() -> bool:
	return suite in ["Clubs", "Spades"]


func selected(is_selected: bool) -> void:
	$SelectedIndicator.visible = is_selected


func _to_string() -> String:
	return suite + "-" + card_num


#func _on_input_event(_viewport, event, _shape_idx) -> void:
#	#print("Card: " + suite + "-" + card_num + " Encountered iput event: " + event.get_class())
#	if event.is_action_pressed("click"):
#		print("Card: ", self, " detected a click.")
#		card_clicked.emit(self)
#		get_viewport().set_input_as_handled()


func _on_mouse_entered() -> void:
	mouse_inside = true


func _on_mouse_exited() -> void:
	mouse_inside = false
