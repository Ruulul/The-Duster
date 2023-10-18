extends Node2D

signal update(new_dust: int)

var dust: int = 0
var max_dust: int = 100

func _ready():
	update.connect(func (new_dust):
		$VBoxContainer/Label.text = 'Dust: %s' % new_dust
	)
	update.emit(dust)

func add(increase: int) -> void:
	dust += increase
	update.emit(dust)

func maybe_add(increase: int) -> void:
	if dust + increase <= max_dust:
		dust += increase
		update.emit(dust)

func remove(decrease: int) -> void:
	dust -= decrease
	update.emit(dust)

func maybe_remove(decrease: int) -> void:
	if dust - decrease >= 0:
		dust -= decrease
		update.emit(dust)

func is_full() -> bool:
	return not dust <= max_dust
