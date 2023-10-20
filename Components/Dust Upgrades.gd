extends MenuButton

@export var duster: Duster
var stats = {
	speed = 0,
	cleaning_speed = 1,
	cleaning_radius = 2,
}
var bias = {
	cleaning_speed = 10,
	speed = 20,
	cleaning_radius = 40
}
var base = {
	cleaning_speed = 3,
	speed = 4,
	cleaning_radius = 5
}
var labels = {
	speed = 'Speed',
	cleaning_speed = 'Rate',
	cleaning_radius = 'Radius'
}
func cost (value, stat):
	return base[stat] ** value + bias[stat]

func _ready():
	var popup = get_popup()
	Dust.update.connect(func (dust):
		text = "Dust: %s" % dust
		for stat in stats.keys():
			var cost = cost(duster[stat], stat)
			popup.set_item_disabled(stats[stat], dust < cost)
			popup.set_item_text(stats[stat], '%s: %s dust' % [labels[stat], cost])
				
	)
	popup.id_pressed.connect(func (id):
		if popup.is_item_disabled(id): return
		var stat = stats.find_key(id)
		Dust.remove(cost(duster[stat], stat))
		duster[stat] += 1
	)

func _process(delta):
	pass
