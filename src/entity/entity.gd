extends Area2D
class_name Entity

var on_screen = false

enum EntityType {
	WALL,
	OBSTACLE,
	SPEED_VERTICAL,
	SPEED_HORIZONTAL,
	LIFE
}

@export var obstacle_type: EntityType = EntityType.WALL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if on_screen:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player hit")
