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

var cross_texture = preload("res://assets/cross-v1.png")
var green_texture = preload("res://assets/banner-green-v1.png")
var red_texture = preload("res://assets/banner-red-v1.png")
var collision_shape = preload("res://src/entity/collsision_rectangle.tres")
var banner_shape = preload("res://src/entity/collision_banner.tres")

@export var obstacle_type: EntityType = EntityType.WALL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match obstacle_type:
		EntityType.OBSTACLE:
			$Sprite2D.texture = cross_texture
			$CollisionShape2D.shape = collision_shape
		EntityType.SPEED_VERTICAL:
			$Sprite2D.texture = red_texture
			$CollisionShape2D.shape = banner_shape
		EntityType.SPEED_HORIZONTAL:
			$Sprite2D.texture = green_texture
			$CollisionShape2D.shape = banner_shape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# player가 다시 돌아올수도 있으니까 지우면 안됨.
	# 즉 player가 다시는 안돌아온다는 보장이 있어야하는데 어렵네.
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		match obstacle_type:
			EntityType.OBSTACLE:
				print("장애물과 충돌!")
				call_deferred("game_over")
			EntityType.SPEED_VERTICAL:
				print("수직 속도 증가 아이템 획득!")
				body.increase_vertical_speed()
				queue_free()
			EntityType.SPEED_HORIZONTAL:
				print("수평 속도 증가 아이템 획득!")
				body.increase_horizontal_speed()
				queue_free()

func game_over() -> void:
		get_tree().change_scene_to_file("res://src/ending.tscn")
