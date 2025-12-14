// FRENZY ALARM
if dead or jormungar { return }

food = array_filter(food, function(v, i) { return v[2] != FOOD_FEAST })

reset_snake_mode()
