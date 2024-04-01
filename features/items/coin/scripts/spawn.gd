extends State


@onready var spawn := owner.get_node_or_null("spawn") as Marker2D


func _process(delta: float) -> void:
	super._process(delta)
	handle_spawn_scene_effect()
	handle_change_sprite_visible(owner.get_node_or_null("sprite"))
	handle_change_collision_disabled(owner.get_node_or_null("collision"))
	await handle_animated_sprite_initialization(spawn.get_children().front())
	await handle_animation_player_initialization(spawn.get_children().front())
	state_machine.handle_change_state("dispose")


func handle_spawn_scene_effect() -> void:
	if not owner.get("fx").can_instantiate():
		return


	_spawn_scene_effect()


func handle_animation_player_initialization(node: Node) -> Variant:
	if not node:
		return

	if not node.get_node_or_null("animation_player") is AnimationPlayer:
		return


	return _animation_player_initialization(node)


func handle_animated_sprite_initialization(node: Node) -> Variant:
	if not node:
		return

	if not node.get_node_or_null("animated_sprite") is AnimatedSprite2D:
		return


	return _animated_sprite_initialization(node)


func handle_change_sprite_visible(sprite: Sprite2D) -> void:
	if not sprite:
		return


	_change_sprite_visible(sprite)


func handle_change_collision_disabled(collision: CollisionPolygon2D) -> void:
	if not collision:
		return


	_change_collision_disabled(collision)


func _spawn_scene_effect() -> void:
	spawn.add_child(owner.get("fx").instantiate())


func _change_sprite_visible(sprite: Sprite2D) -> void:
	sprite.set_visible(false)


func _change_collision_disabled(collision: CollisionPolygon2D) -> void:
	collision.set_disabled(true)


func _animation_player_initialization(node: Node) -> Signal:
	return node.get_node_or_null("animated_sprite").animation_finished


func _animated_sprite_initialization(node: Node) -> Signal:
	return node.get_node_or_null("animated_sprite").animation_finished
