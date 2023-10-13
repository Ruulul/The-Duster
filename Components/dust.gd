extends Node2D

signal update(new_dust: int)

var dust: int = 0

func _ready():
	update.connect(func (new_dust):
		$VBoxContainer/Label.text = 'Collected dust: %s' % new_dust
	)
	update.emit(dust)

func add(increase):
	dust += increase
	update.emit(dust)

func remove(decrease):
	dust -= decrease
	update.emit(dust)

func maybe_remove(decrease):
	if dust - decrease >= 0:
		dust -= decrease
		update.emit(dust)
