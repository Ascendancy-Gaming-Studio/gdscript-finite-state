extends State


func _process(delta: float) -> void:
	super._process(delta)
	handle_dispose_coin()


func handle_dispose_coin() -> void:
	_dispose_coin()


func _dispose_coin() -> void:
	owner.queue_free()
