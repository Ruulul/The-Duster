extends Node2D

var room_value = 50
var count = 0

signal update(new_coins)

func _ready():
	update.connect(
		func (new_value):
			$CanvasLayer/Label.text = 'Coins: %s' % count
	)

func add(value):
	count += value
	update.emit(count)
func remove(value):
	count -= value
	update.emit(count)

func on_new_building(rooms_finished_building):
	add(rooms_finished_building * room_value)
