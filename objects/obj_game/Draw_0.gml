draw_set_colour(color)
draw_rectangle(border, border_top, room_width - border, room_height - border, true)

for(var i = 0; i < array_length(snakes); i++) {
    var snake_x = snakes[i][0] * snake_size + border;
    var snake_y = snakes[i][1] * snake_size + border_top;
    draw_set_colour(snakes[i][2])
    draw_rectangle(snake_x, snake_y, snake_x + snake_size, snake_y + snake_size, false)
}

var foodxy = get_food_xy()
draw_set_colour(c_white)
if food[2] == FOOD_SUPER {
    draw_set_colour(c_fuchsia)
} else if food[2] == FOOD_LONG {
    draw_set_colour(c_aqua)
} else if food[2] == FOOD_GHOST {
    draw_set_colour(c_silver)
}

draw_rectangle(foodxy[0], foodxy[1], foodxy[0] + food_size, foodxy[1] + food_size, food[2] == FOOD_GHOST)

var score_string = string(score)

if jormungar {
    score_string = "Jörmungandr"
}
draw_set_colour(color)
draw_text(border, 16, "SCORE: " + string(score_string));

if dead {
    draw_set_colour(c_white)
    draw_set_halign(fa_center);
    draw_text(room_width / 2, 16, "PRESS [ENTER] TO RESTART")
    draw_set_halign(fa_left);
}

if paused {
    draw_set_colour(c_white)
    draw_set_halign(fa_center);
    draw_text(room_width / 2, 16, "PRESS [ESC] TO CONTINUE")
    draw_set_halign(fa_left);
}
