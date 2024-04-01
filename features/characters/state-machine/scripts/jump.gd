extends CharacterState


@export var jump_velocity := 250.0


func _process(delta: float) -> void:
	super._process(delta)

	if get_input().get("can_change_to_fall").call():
		return state_machine.handle_change_state("fall")


func _physics_process(delta: float) -> void:
	handle_apply_gravity(delta)
	get_character().velocity.y = -jump_velocity
	get_character().move_and_slide()
