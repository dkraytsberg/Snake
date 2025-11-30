draw_set_colour(color)
draw_rectangle(border, border_top, room_width - border, room_height - border, true)
draw_set_font(snake_font)

for(var i = 0; i < array_length(snakes); i++) {
    var snake_x = snakes[i][0] * snake_size + border;
    var snake_y = snakes[i][1] * snake_size + border_top;
    draw_set_colour(snakes[i][2])
    draw_rectangle(snake_x, snake_y, snake_x + snake_size, snake_y + snake_size, snakes[i][2] == c_silver)
}


for (var i = 0; i < array_length(food); i++) { 
    var f = food[i]
    var foodxy = [f[0] * food_size + border, f[1] * food_size + border_top]
    draw_set_colour(food_to_color(f[2]))
    var is_outline = f[2] == FOOD_GHOST or f[2] == FOOD_FEAST
    draw_rectangle(foodxy[0], foodxy[1], foodxy[0] + food_size, foodxy[1] + food_size, is_outline)
}

var score_string = string(score)

if jormungar {
    print_text("Jormungandr " + string(_score_before_jormungar))
}
draw_set_colour(color)
draw_text(border, 16, "SCORE: " + string(score_string));

if dead {
    print_text("PRESS [ENTER] TO RESTART")
}

if paused {
    print_text("PRESS [ESC] TO CONTINUE")
}

if frenzy_counter > 0 {
    var frenzy_digit = ceil(frenzy_counter / game_get_speed(gamespeed_fps))
    print_text("FRENZY! " + string(frenzy_digit), color)
}
