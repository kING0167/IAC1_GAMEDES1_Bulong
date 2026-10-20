
extends Area2D

signal hit

@export var speed = 400
@export var mouse_follow_speed = 5.0

var screen_size


func _ready():
	screen_size = get_viewport_rect().size
	hide()



func _process(delta):
	var velocity = Vector2.ZERO

	# WASD movement
	if Input.is_key_pressed(KEY_D):
		velocity.x += 1
	if Input.is_key_pressed(KEY_A):
		velocity.x -= 1
	if Input.is_key_pressed(KEY_S):
		velocity.y += 1
	if Input.is_key_pressed(KEY_W):
		velocity.y -= 1

	if velocity.length() > 0:
		# Keyboard movement
		velocity = velocity.normalized() * speed
		position += velocity * delta
	else:
		# Follow mouse
		var target = get_global_mouse_position()
		var difference = target - global_position

		if difference.length() > 5:
			velocity = difference.normalized() * speed
			global_position = global_position.move_toward(
				target,
				speed * delta
			)

	# Keep player inside screen
	position = position.clamp(Vector2.ZERO, screen_size)

	# Play animation according to movement direction
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			$AnimatedSprite2D.animation = "lakad"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.animation = "taas"
			$AnimatedSprite2D.flip_v = velocity.y > 0

		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()



func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.set_deferred("disabled", false)
