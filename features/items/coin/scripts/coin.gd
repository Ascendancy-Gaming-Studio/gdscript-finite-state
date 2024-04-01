extends Area2D


@export var score := 0
@export var fx: PackedScene


@onready var state_machine := find_child("*state_machine*") as StateMachine


func _on_body_entered(_body: CharacterBody2D) -> void:
	state_machine.handle_change_state("spawn")
