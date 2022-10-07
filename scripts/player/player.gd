extends CharacterBase


var jumps := 0
export var max_jumps := 2


func _process(delta: float) -> void:
  match state:
    STATE_MACHINE.IDLE: _state_idle(delta)
    STATE_MACHINE.WALK: _state_walk(delta)
    STATE_MACHINE.JUMP: _state_jump(delta)
    STATE_MACHINE.JUMP_2: _state_jump_2(delta)
    STATE_MACHINE.FALL: _state_fall(delta)
    STATE_MACHINE.ATTACK_1: _state_attack_1(delta)
    STATE_MACHINE.ATTACK_2: _state_attack_2(delta)


func _state_idle(delta: float) -> void:
  _set_animation('idle')
  _apply_gravity(delta)
  _stop_movement()
  
  if enter_state:
    jumps = 0
  
  if direction:
    _enter_state(STATE_MACHINE.WALK)  
  elif Input.is_action_just_pressed('ui_jump'):
    _enter_state(STATE_MACHINE.JUMP)
  elif Input.is_action_just_pressed('ui_attack'):
    _enter_state(STATE_MACHINE.ATTACK_1)
  

func _state_walk(delta: float) -> void:
  _set_animation('walk')
  _apply_gravity(delta)
  _move_and_slide(delta)
  _set_flip()
  
  if not direction:
    _enter_state(STATE_MACHINE.IDLE)
  elif Input.is_action_just_pressed('ui_jump'):
    _enter_state(STATE_MACHINE.JUMP_2)
  elif Input.is_action_just_pressed('ui_attack'):
    _enter_state(STATE_MACHINE.ATTACK_1)


func _state_jump(delta: float) -> void:
  _set_animation('jump')
  _apply_gravity(delta)
  _set_flip()
  _move_and_slide(delta)
  
  if enter_state:
    enter_state = false
    motion.y = -jump_force
    jumps += 1
    
  if motion.y > 0:
    _enter_state(STATE_MACHINE.FALL)
    
  if Input.is_action_just_pressed('ui_jump') and jumps < max_jumps:
    _enter_state(STATE_MACHINE.JUMP_2)


func _state_jump_2(delta: float) -> void:
  _set_animation('jump_2')
  _apply_gravity(delta)
  _set_flip()
  _move_and_slide(delta)
  
  if enter_state:
    enter_state = false
    motion.y = -jump_force
    jumps += 1
  
  if motion.y > 0:
    _enter_state(STATE_MACHINE.FALL)
    
  if Input.is_action_just_pressed('ui_jump') and jumps < max_jumps:
    jumps += 1
    motion.y = -jump_force
    

func _state_fall(delta: float) -> void:
  _set_animation('fall')
  _apply_gravity(delta)
  _set_flip()
  _move_and_slide(delta)
  
  if is_on_floor():
    _enter_state(STATE_MACHINE.IDLE)
    
  if Input.is_action_just_pressed('ui_jump') and jumps < max_jumps:
    _enter_state(STATE_MACHINE.JUMP_2)


func _state_attack_1(_delta: float) -> void:
  _set_animation('attack_1')
  _stop_movement()
  
  if enter_state:
    enter_state = false
    attack_timer.start()
    
  if Input.is_action_just_pressed('ui_attack'):
    attack_timer.stop()
    _enter_state(STATE_MACHINE.ATTACK_2)


func _state_attack_2(_delta: float) -> void:
  _set_animation('attack_2')
  _stop_movement()
  
  if enter_state:
    enter_state = false
    attack_timer.start()


func _on_attack_timer_timeout() -> void:
  _enter_state(STATE_MACHINE.IDLE)
