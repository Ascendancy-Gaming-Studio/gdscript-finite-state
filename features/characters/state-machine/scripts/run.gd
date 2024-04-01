extends CharacterState


@export var move_speed := 150.0


func _process(delta: float) -> void:
	super._process(delta)

	if get_input().get("can_change_to_fall").call():
		return state_machine.handle_change_state("fall")

	if get_input().get("can_change_to_jump").call():
		return state_machine.handle_change_state("jump")

	if get_input().get("can_change_to_idle").call():
		return state_machine.handle_change_state("idle")


func _physics_process(delta: float) -> void:
	handle_apply_gravity(delta)
	get_character().velocity.x = input_direction.x * move_speed
	get_character().move_and_slide()
