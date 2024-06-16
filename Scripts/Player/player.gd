extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -400.0
var speedmult = 1.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if GameConstants.Instance.IsPlayingGame == false: return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("sprint"):
		speedmult = 1.2
	else:
		speedmult = 1.0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * speedmult
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * speedmult)

	move_and_slide()
