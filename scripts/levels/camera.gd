extends Camera2D
class_name CameraPlayer


var shake_amount := 0.0
var default_offset := offset
var shaking := false

onready var tween := get_node('tween')
onready var shake_timer: Timer = get_node('shake_timer')


func _process(delta: float) -> void:
  if shaking:
    offset = Vector2(
      rand_range(
        -shake_amount, shake_amount), 
      rand_range(-shake_amount, shake_amount)
    ) * delta + default_offset
  

func shake(shake_strong: float, shake_duration: float = 0.4, shake_limit: float = 100) -> void:
  shake_amount += shake_strong
  
  if shake_amount > shake_limit:
    shake_amount = shake_limit
    
  shaking = true
  shake_timer.wait_time = shake_duration
  shake_timer.start()


func _on_shake_timer_timeout() -> void:
  shake_amount = 0
  shaking = false
  tween.interpolate_property(self, 'offset', offset, default_offset, 0.1, tween.TRANS_QUAD, tween.EASE_IN_OUT)
  tween.start()
