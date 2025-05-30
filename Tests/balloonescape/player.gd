extends Area2D
signal hit

@export var speed = 400
@export var maxRotationRight = 25
@export var maxRotationLeft = -25
@export var speedRotation = 90
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta):
	var velocity : Vector2 = Vector2.ZERO
	var rotation_degrees_calculated : float = rotation_degrees
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		rotation_degrees_calculated += speedRotation * delta
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		rotation_degrees_calculated -= speedRotation * delta
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	velocity.y += gravity
	
	if !rotation_degrees_calculated != rotation_degrees && rotation_degrees_calculated > 0:
		rotation_degrees_calculated -= (speedRotation / 3) * delta
		if rotation_degrees_calculated < 0:
			rotation_degrees_calculated = 0
	if !rotation_degrees_calculated != rotation_degrees && rotation_degrees_calculated < 0:
		rotation_degrees_calculated += (speedRotation / 3) * delta
		if rotation_degrees_calculated > 0:
			rotation_degrees_calculated = 0
	
	if rotation_degrees_calculated > maxRotationRight:
		rotation_degrees_calculated = maxRotationRight
	if rotation_degrees_calculated < maxRotationLeft:
		rotation_degrees_calculated = maxRotationLeft
	
	rotation_degrees = rotation_degrees_calculated
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body: Node2D):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
