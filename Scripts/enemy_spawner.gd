extends Node2D

@onready var enemy = preload("res://Prefabs/enemy.tscn")
@onready var enemies: Node2D = $"../Enemies"

const wavesJSON = "res://Data/waves.json"
var waveData : Array
var enemy_total : int = 0

func _ready() -> void:
	var file = FileAccess.open(wavesJSON, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	var json = JSON.new()
	var _error = json.parse(json_text)
	var data = json.get_data()
	waveData = data["waves"]
	#$Timer.stop() # temporary just spawn 1 and stop
	
	for waveIndex in waveData.size():
		if wave_is_active():
			pass
		print(waveData[0].enemies)
		await play_wave(waveIndex)

func play_wave(index : int):
	for group in waveData[index].enemies:
		for _enemy in group:
			for i in group[_enemy]:
				spawn_enemy()
	await wait(waveData[index].delay)

func spawn_enemy():
	var e = enemy.instantiate()
	e.global_position = global_position
	enemies.add_child(e)

func wave_is_active() -> int:
	return enemies.get_children().size() > 0

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
