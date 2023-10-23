extends Button
@export var generator: BuildingGenerator
var goal = 0.8
@onready var timer = $Timer

func _ready():
	timer.timeout.connect(func ():
		var ground = generator.map.get_used_cells(Building.RoomMapLayers.Ground).size()
		var dirt = generator.map.get_used_cells(Building.RoomMapLayers.Dirt)\
		.reduce(func (acc, coord):
				return acc + (Dust.dirt_levels.find(
					generator.map.get_cell_alternative_tile(Building.RoomMapLayers.Dirt, coord)
				) + 1)
		, 0) / float(Dust.dirt_levels.size())
		var cleared = 1 - float(dirt) / float(ground)

		text = 'Cleared area: %.2f%%' % (cleared * 100)
		if cleared >= goal:
			text = 'Go to the next building!'
			disabled = false
		else:
			disabled = true
	)
	pressed.connect(func ():
		if not disabled:
			Dust.reset()
			generator.generate()
	)
