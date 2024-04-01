extends Area2D


@export var score := 0
@export var fx: PackedScene


@onready var state_machine := find_child("*state_machine*") as StateMachine


func _ready() -> void:
	GameManager.connect("character_score_changed", _on_character_score_changed)


func _on_body_entered(_body: CharacterBody2D) -> void:
	state_machine.handle_change_state("update_score")


# Notificaçao da pontuaçao do jogador.
func _on_character_score_changed() -> void:
	print("A pontuaçao atual do jogador e: ", GameManager.get_character_score())
