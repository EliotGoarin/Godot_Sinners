extends ProgressBar


@onready var damagebar: ProgressBar = $Damagebar
@onready var timer: Timer = $Timer

var health = 0 : set = _set_health

func init_health(_health):
	health = _health
	max_value = _health
	value = _health
	damagebar.max_value = _health
	damagebar.value = _health	
	damagebar.max_value = _health
	
func _set_health (new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health<=0:
		queue_free()
		
	if health<prev_health:
		timer.start()
	else:
		damagebar.value = health
	

func _on_timer_timeout() -> void:
	damagebar.value = health
