extends Building

@export var money_per_ore : int = 1
@onready var shipment_cooldown : Timer = $Timer
@onready var gm = $"../.."

func _on_delivery() -> void:
	try_launch()
		
func try_launch():
	if shipment_cooldown.is_stopped():
		launch()
	else:
		shipment_cooldown.start()

func launch():
	$launchAnimation.visible = true
	$launchAnimation.play("launch")
	gm.stored["money"] += stored["ore"] * money_per_ore
	gm.stored = gm.stored
	#make_generated_particle(stored["ore"], "money")
	stored["ore"] = 0

func _on_launch_animation_animation_finished() -> void:
	$launchAnimation.visible = false

func _on_timer_timeout() -> void:
	launch()
	
const RESOURCE_GENERATED = preload("res://Prefabs/UI/resource_generated.tscn")
const resource_sprites = {
	"ore" : "res://Art/ore.png",
	"money" : "res://Art/money.png"
}
func make_generated_particle(_change : int, _sprite : String):
	var inst = STORAGE_UI.instantiate()
	add_child(inst)
	#inst.get_node("Label").text = "+"+ str(change)
	#inst.get_node("TextureRect").texture = load(resource_sprites[sprite])
	inst.refresh()
