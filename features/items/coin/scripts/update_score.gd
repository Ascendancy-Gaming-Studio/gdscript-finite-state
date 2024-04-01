extends CharacterState


func _process(delta: float) -> void:
	super._process(delta)

	GameManager.set_character_score(GameManager.get_character_score() + owner.get("score"))
	state_machine.handle_change_state("spawn")
