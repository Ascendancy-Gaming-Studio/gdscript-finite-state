extends Node


signal character_score_changed


var _character_score := 0: set=set_character_score, get=get_character_score


func set_character_score(new_score: int) -> void:
	if _character_score == new_score:
		return

	_character_score = new_score
	emit_signal("character_score_changed")


func get_character_score() -> int:
	return _character_score
