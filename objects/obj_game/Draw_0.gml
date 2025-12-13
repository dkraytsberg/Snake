function _draw_border() {
    draw_rectangle(border, border_top, room_width - border, room_height - border, true)
}

function __draw_top_text(text, hindex, vindex, top_pad = 0, left_pad = 0) {
    var halign; var tx;
    if hindex <= 0 { 
        halign = fa_left 
        tx = border
    } else if hindex == 1 { 
        halign = fa_center
        tx = room_width / 2
    } else if hindex >= 2 { 
        halign = fa_right
        tx = room_width - border
    }
    
    var prev_halign = draw_get_halign()
    draw_set_halign(halign)
    draw_text(left_pad + tx, top_pad + 8 + vindex * font_size_line_height, text)
    draw_set_halign(prev_halign)
}

function __draw_body_text(text, hindex, vindex) {
    __draw_top_text(text, hindex, vindex, border_top)
}

function _draw_center_text(text, vindex) {
    __draw_top_text(text, 1, vindex, border_top)
}

function _draw_highscore_text(text, vindex) {
    __draw_top_text(text, 0, vindex, border_top, border * 5)
}

function _draw_score(scr) {
    __draw_top_text(scr, 0, 0)
}

function _draw_status(status) {
    __draw_top_text(status, 1, 1)
}

function _draw_fps(status) {
    __draw_top_text(status, 2, 2)
}

function _draw_mode(mode) {
    __draw_top_text(mode, 2, 0)
}

function _draw_highscore(scr) {
    __draw_top_text(scr, 2, 2)
}



draw_set_font(snake_font)
draw_set_halign(fa_left);
draw_set_valign(fa_top); 
draw_set_colour(c_white)


if _room == ROOM_GAME {
    draw_set_colour(color)
    _draw_border()
    
    _draw_fps(game_get_speed(gamespeed_fps))
   
    if not paused {
        // Draw Snake
        for(var i = 0; i < array_length(snakes); i++) {
           var s = snakes[i]
           var snake_x = s[0] * snake_size + border;
           var snake_y = s[1] * snake_size + border_top;
           draw_set_colour(food_to_snake_color(s[2]))
           var is_outline = s[2] == FOOD_GHOST
           draw_rectangle(snake_x, snake_y, snake_x + snake_size, snake_y + snake_size, is_outline)
       }
       
       // Draw Food
       for (var i = 0; i < array_length(food); i++) { 
           var f = food[i]
           var foodxy = [f[0] * food_size + border, f[1] * food_size + border_top]
           draw_set_colour(food_to_color(f[2]))
           var is_outline = f[2] == FOOD_GHOST or f[2] == FOOD_FEAST
           draw_rectangle(foodxy[0], foodxy[1], foodxy[0] + food_size, foodxy[1] + food_size, is_outline)
       }
    }
   
    draw_set_colour(color)
    _draw_score("SCORE: " + string(score))
    
    if score > highscore_value(1) {
        _draw_highscore("NEW HIGH SCORE!")
    }
   
    if jormungar {
        _draw_status("Jormungandr " + string(score_before_jormungar))
    } else if dead {
        _draw_status("DEAD! [R] TO RESTART [Q] TO EXIT")
    } else if paused {
        draw_set_color(c_white)
        _draw_status("--PAUSED--")
        draw_set_halign(fa_center);
        _draw_center_text("PRESS [enter] TO CONTINUE", 11)
        _draw_center_text("PRESS [Q] TO QUIT", 13)
        draw_set_halign(fa_left);
        draw_set_color(color)
    } else if frenzy_counter > 0 {
        var frenzy_digit = ceil(frenzy_counter / game_get_speed(gamespeed_fps))
        _draw_status("FRENZY! " + string(frenzy_digit))
    } else if snake_food_mode == FOOD_FEAST_SUCCESS {
        _draw_status("SUCCESS!")
    } else if snake_food_mode == FOOD_GHOST {
        _draw_status("GHOST MODE")
    }
    
    var mode_str = ""
    if mode_pure { mode_str += " PURE" } 
    if mode_multi { mode_str += " MULTI!" }
    if mode_turbo { mode_str += " TURBO!" } 
    if mode_rush { mode_str += " RUSH!" }
    if mode_str != "" { _draw_mode(mode_str) }

}

if _room == ROOM_MENU {
    draw_set_colour(c_white)
    _draw_border()
    
    draw_set_font(snake_font_large)
    _draw_center_text("SNAKE", 6)
    
    draw_set_font(snake_font)
    _draw_center_text("PRESS [enter] TO START", 11)
    _draw_center_text("[M] MODE SELECT", 13)
    _draw_center_text("[H] HIGHSCORES", 14)
    _draw_center_text("[I] INFO", 15)
    _draw_center_text("PRESS [Q] TO QUIT", 18)
}

if _room == ROOM_MODE_SELECT {
    draw_set_colour(c_white);
    _draw_border();
    draw_set_halign(fa_center);
    
    var pure_mode_text = "OFF"; if mode_pure then pure_mode_text = "ON ";
    var turbo_mode_text = "OFF"; if mode_turbo then turbo_mode_text = "ON ";
    var rush_mode_text = "OFF"; if mode_rush then rush_mode_text = "ON ";
    var multi_mode_text = "OFF"; if mode_multi then multi_mode_text = "ON ";
    
    _draw_center_text("MODE SELECT", 1)
    _draw_center_text("[P]  PURE MODE   " + pure_mode_text, 5);
    _draw_center_text("[T]  TURBO!      " + turbo_mode_text, 6);
    _draw_center_text("[R]  POWER RUSH  " + rush_mode_text, 7);
    _draw_center_text("[M]  MULTI-FOOD  " + multi_mode_text, 8);
    _draw_center_text("PRESS [enter] TO START", 11)
    _draw_center_text("PRESS [ESC] TO GO BACK", 18)
}

if _room == ROOM_INFO {
    draw_set_colour(c_white)
    _draw_border()
    _draw_center_text("PRESS [ESC] TO GO BACK", 18)
    
    var foods = [ FOOD_NORMAL, FOOD_SUPER, FOOD_LONG, FOOD_GHOST, FOOD_FRENZY, FOOD_FEAST ]
    
    draw_set_halign(fa_center);
    for (var i = 0; i < array_length(foods); i++) {
        draw_set_colour(food_to_color(foods[i]))
        var fx = border + (room_width / 10)
        var fy = border_top + (room_width / 10) + (food_size * i * 3)
        var fx2 = fx + (food_size * 2)
        var fy2 = fy + (food_size * 2)
        var is_outline = foods[i] == FOOD_GHOST or foods[i] == FOOD_FEAST
        draw_rectangle(fx, fy, fx2, fy2, is_outline)
        draw_set_halign(fa_left);
        draw_text(fx2 + food_size, fy, food_to_info(foods[i]))
    }
}


if _room == ROOM_SCRATCH {
    _draw_border()
    _draw_score("SCORE: 1231231")
    _draw_status("--PAUSED--")
    _draw_mode("TURBO!")
}

if _room == ROOM_HIGHSCORE {
    _draw_border()
    _draw_center_text("High Scores", 1)
    
    for(var i = 1; i <= 5; i++) {
        _draw_highscore_text(string(i) + ". " + string(highscore_value(i)), 4 + i)
    }
    
    _draw_center_text("PRESS [ESC] TO GO BACK", 18)
}


