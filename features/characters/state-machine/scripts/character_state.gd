class_name CharacterState extends State


var input_vector := Vector2.ZERO
var input_direction := Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var _character := owner as CharacterBody2D: get=get_character


func get_character() -> CharacterBody2D:
	return _character


func _ready() -> void:
	super._ready()

	# Inicializaçao na definiçao de açoes de entrada do jogador.
	_register_input_actions()


func _process(delta: float) -> void:
	super._process(delta)

	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Vetor de duas dimensoes.
	input_direction = input_vector.normalized()

	# Vetor de tres dimensoes.
	#input_direction = (character.transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()


func _register_input_actions() -> void:
	const input_map := {
		"move_left": [KEY_A, KEY_LEFT],
		"move_right": [KEY_D, KEY_RIGHT],
		"move_up": [KEY_W, KEY_UP],
		"move_down": [KEY_S, KEY_DOWN],
		"jump": [ KEY_SPACE ],
	}
	var input_key: InputEventKey


	for action in input_map:
		if not InputMap.has_action(action):
			InputMap.add_action(action)

		if not input_map.get(action) is Array:
			continue

		if input_map.get(action).is_empty():
			continue


		for keycode in input_map[action]:
			input_key = InputEventKey.new()
			input_key.keycode = keycode

			if InputMap.action_has_event(action, input_key):
				continue


			InputMap.action_add_event(action, input_key)


# Retorna as validaçoes para as alteraçoes de estado ocorrerem.
# Importante retornar uma funçao para que a verificaçao aconteça em tempo real.
func get_input() -> Dictionary:
	return {
		"can_change_to_idle": func() -> bool:
			return not input_direction.x and get_character().is_on_floor(),

		"can_change_to_run": func() -> bool:
			return input_direction.x and get_character().is_on_floor(),

		"can_change_to_jump": func() -> bool:
			return Input.is_action_just_pressed("jump") and get_character().is_on_floor(),

		"can_change_to_fall": func() -> bool:
			return abs(get_character().velocity.y) >= state_machine.get_shared_property("jump", "jump_velocity")
	}


# Logica para aplicaçao da gravidade.
func handle_apply_gravity(delta: float) -> void:
	if get_character().is_on_floor():
		return


	_apply_gravity(delta)


func _apply_gravity(delta: float) -> void:
	get_character().velocity.y += gravity * delta
