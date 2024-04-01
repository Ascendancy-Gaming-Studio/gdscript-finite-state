extends CharacterState


func _process(delta: float) -> void:
	super._process(delta)

	if get_input().get("can_change_to_idle").call():
		return state_machine.handle_change_state("idle")

	if get_input().get("can_change_to_run").call():
		return state_machine.handle_change_state("run")


func _physics_process(delta: float) -> void:
	handle_apply_gravity(delta)
	get_character().move_and_slide()
