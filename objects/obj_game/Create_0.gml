border = 32;
border_top = 64;
snake_size = 8;
food_size = 8;
hor_squares = (room_width - border - border) / 8
ver_squares = (room_height - border - border_top) / 8

dead = false
jormungar = false
BASE_SPEED_COUNTER = 2
BASE_POWERUP_COUNTER = game_get_speed(gamespeed_fps) / BASE_SPEED_COUNTER
speed_counter = BASE_SPEED_COUNTER
powerup_counter = 0
paused = false

FOOD_NORMAL = "normal"
FOOD_SUPER = "super"
FOOD_LONG = "long"
FOOD_GHOST = "ghost"

function food_to_color(f) {
    switch(f){
        case FOOD_NORMAL: return c_white
        case FOOD_SUPER: return c_fuchsia
        case FOOD_LONG: return c_aqua 
        case FOOD_GHOST: return c_silver
    }
}

snake_food_mode = FOOD_NORMAL

color = c_yellow
dir = [1, 0]
snakes = [[0,0, color], [0, 1, color], [1,1, color], [2,1, color], [3,1, color], [4,1,color]]
food = [[4, 4, FOOD_NORMAL]]

score = 0

// audio_play_sound(vibe, 1, true)

function print_text(text) {
    draw_set_colour(c_white)
    draw_set_halign(fa_center);
    draw_text(room_width / 2, 16, text)
    draw_set_halign(fa_left);
}

function get_food_xy(f) {
    return [f[0] * food_size + border, f[1] * food_size + border_top]
}

function make_food() { 
    var food_type = FOOD_NORMAL
    
    if random(9) >= 6 {
        food_type = choose(FOOD_SUPER, FOOD_LONG, FOOD_GHOST)
    }
    
    var f = [irandom_range(0, hor_squares - 1), irandom_range(0, ver_squares - 1), food_type]
    
    array_push(food, f)
}

function check_food_collisions() {
    for(var i = 0; i < array_length(food); i++) {
       var f = food[i]
       if head[0] == f[0] and head[1] == f[1] {
           color = c_yellow 
           score += 1
           snake_food_mode = f[2]
           
           if snake_food_mode == FOOD_SUPER {
               score *= 2
               color = c_fuchsia
           } else if snake_food_mode == FOOD_GHOST {
               color = c_silver
               powerup_counter = BASE_POWERUP_COUNTER
           } else if snake_food_mode == FOOD_LONG {
               color = c_aqua
               powerup_counter = BASE_POWERUP_COUNTER
           }
           
           array_delete(food, i, 1)
           
           if array_length(food) == 0 { 
            repeat(1) { 
                make_food()
            }
           }
           return true;
       }
    }
    
    return false;
}

function move_snake() {
    head = array_last(snakes)
    
    var new_head = [
        (head[0] + dir[0] + hor_squares) % hor_squares, 
        (head[1] + dir[1] + ver_squares) % ver_squares,
        color
    ]
    
    array_push(snakes, new_head)
    
    if powerup_counter <= 0 and (snake_food_mode == FOOD_GHOST or snake_food_mode == FOOD_LONG) {
        snake_food_mode = FOOD_NORMAL;
        color = c_yellow
    } else {
        powerup_counter -= 1;
    }
    
    if snake_food_mode == FOOD_LONG {
        score += 1;
    }
    
    var ate_food = check_food_collisions()
    
    if !ate_food and snake_food_mode != FOOD_LONG { 
        array_shift(snakes)
    }
}

function check_collision() {
    head = array_last(snakes)
    tail = array_first(snakes)
    
    if head[0] == tail[0] and head[1] == tail[1] {
        jormungar = true
        return
    }
    for(var i = 0; i < array_length(snakes) - 1; i++) {
        if head[0] == snakes[i][0] and head[1] == snakes[i][1] { 
            if snake_food_mode != FOOD_GHOST and snakes[i][2] != c_silver {
               dead = true;
               return
            } else {
                score += 5;
            }
        }
    }
}