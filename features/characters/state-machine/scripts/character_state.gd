class_name CharacterState extends State


const DIRECTION_UP := {
	"move_up": [
		KEY_W,
		KEY_UP,
	]
}
const DIRECTION_DOWN := {
	"move_down": [
		KEY_S,
		KEY_DOWN,
	]
}
const DIRECTION_LEFT := {
	"move_left": [
		KEY_A,
		KEY_LEFT,
	]
}
const DIRECTION_RIGHT := {
	"move_right": [
		KEY_D,
		KEY_RIGHT,
	],
}
const JUMP := {
	"jump": [
		KEY_SPACE,
	]
}
const INPUT_MAP := [
	DIRECTION_UP,
	DIRECTION_DOWN,
	DIRECTION_LEFT,
	DIRECTION_RIGHT,
	JUMP,
]


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
	var input_key: InputEventKey

	for i in range(INPUT_MAP.size()):
		var action_key: String = INPUT_MAP[i].keys().front()
		var action_value: Array = INPUT_MAP[i].values().front()

		if action_key.is_empty():
			continue

		# Define a nomenclatura da açao.
		if not InputMap.has_action(action_key):
			InputMap.add_action(action_key)

		if action_value.is_empty():
			continue


		# Percorre todos os atalhos pre-definidos.
		for keycode in action_value:
			input_key = InputEventKey.new()
			input_key.keycode = keycode

			# Ignora a açao se o atalho ja existir.
			if InputMap.action_has_event(action_key, input_key):
				continue


			# registra o atalho.
			InputMap.action_add_event(action_key, input_key)


# Retorna as validaçoes para as alteraçoes de estado ocorrerem.
# Importante retornar uma funçao para que a verificaçao aconteça em tempo real.
func get_input() -> Dictionary:
	return {
		"can_change_to_idle": func() -> bool:
			return not input_direction.x and get_character().is_on_floor(),

		"can_change_to_run": func() -> bool:
			return input_direction.x and get_character().is_on_floor(),

		"can_change_to_jump": func() -> bool:
			return Input.is_action_just_pressed(JUMP.keys().front()) and get_character().is_on_floor(),

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
