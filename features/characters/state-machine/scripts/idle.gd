extends CharacterState


func _process(delta: float) -> void:
	super._process(delta)

	if get_input().get("can_change_to_fall").call():
		return state_machine.handle_change_state("fall")

	if get_input().get("can_change_to_jump").call():
		return state_machine.handle_change_state("jump")

	if get_input().get("can_change_to_run").call():
		return state_machine.handle_change_state("run")


func _physics_process(delta: float) -> void:
	handle_apply_gravity(delta)
	get_character().velocity.x = move_toward(get_character().velocity.x, 0, state_machine.get_node("run").get("move_speed"))
	get_character().move_and_slide()
