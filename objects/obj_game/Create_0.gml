border = 32;
border_top = 64;
snake_size = 8;
food_size = 8;
hor_squares = (room_width - border - border) / 8
ver_squares = (room_height - border - border_top) / 8

dead = false
jormungar = false
paused = false

BASE_SPEED_COUNTER = 2
BASE_POWERUP_COUNTER = game_get_speed(gamespeed_fps) * 2
BASE_FRENZY_COUNTER = game_get_speed(gamespeed_fps) * 9

speed_counter = BASE_SPEED_COUNTER
powerup_counter = 0
frenzy_counter = 0

FOOD_NORMAL = "normal"
FOOD_SUPER = "super"
FOOD_LONG = "long"
FOOD_GHOST = "ghost"
FOOD_FRENZY = "frenzy"
FOOD_FEAST = "feast"

snake_food_mode = FOOD_NORMAL
color = c_yellow
dir = [1, 0]

snakes = [[0,0, color], [0, 1, color], [1,1, color], [2,1, color], [3,1, color], [4,1,color]]
food = [[4, 4, FOOD_NORMAL]]
score = 0
_score_before_jormungar = 0

function food_to_color(f) {
    switch(f){
        case FOOD_NORMAL: return c_white
        case FOOD_SUPER: return c_fuchsia
        case FOOD_LONG: return c_aqua 
        case FOOD_GHOST: return c_silver
        case FOOD_FRENZY: return c_maroon
        case FOOD_FEAST: return c_maroon
    }
}

function state_is_powerup() {
    return snake_food_mode == FOOD_GHOST or snake_food_mode == FOOD_LONG;
}

function state_is_frenzy() {
    return snake_food_mode == FOOD_FRENZY or snake_food_mode == FOOD_FEAST;
}

function reset_snake_mode() {
    snake_food_mode = FOOD_NORMAL;
    color = c_yellow
}

function print_text(text, col) {
    draw_set_colour(col ?? c_white)
    draw_set_halign(fa_center);
    draw_text(room_width / 2, 16, text)
    draw_set_halign(fa_left);
}

function get_food_xy(f) {
    return [f[0] * food_size + border, f[1] * food_size + border_top]
}

function make_food(type) {
    var food_type = FOOD_NORMAL
    
    if type != undefined {
        food_type = type
    } else {
        if random(10) >= 8 {
            food_type = choose(FOOD_SUPER, FOOD_LONG, FOOD_GHOST, FOOD_FRENZY)
        }
    }
    
    var f = [irandom_range(1, hor_squares - 2), irandom_range(1, ver_squares - 2), food_type]
    
    array_push(food, f)
}

function process_food_effects() {
    if snake_food_mode == FOOD_SUPER {
        score *= 2
        color = c_fuchsia
    } else if snake_food_mode == FOOD_GHOST {
        color = c_silver
        powerup_counter = BASE_POWERUP_COUNTER
    } else if snake_food_mode == FOOD_LONG {
        color = c_aqua
        powerup_counter = BASE_POWERUP_COUNTER
    } else if snake_food_mode == FOOD_FRENZY {
        color = c_maroon
        repeat(5) {
            make_food(FOOD_FEAST)
        }
        frenzy_counter = BASE_FRENZY_COUNTER
    } else if snake_food_mode == FOOD_FEAST {
        color = c_maroon
        frenzy_counter += game_get_speed(gamespeed_fps)
    }
}

function check_food_collisions() {
    for(var i = 0; i < array_length(food); i++) {
        var food_collision = head[0] == food[i][0] and head[1] == food[i][1];
        if food_collision {
            color = c_yellow;
            score += 1
            snake_food_mode = food[i][2]
        
            process_food_effects()
            array_delete(food, i, 1)
           
            if array_length(food) == 0 {
                if frenzy_counter > 0 {
                   // feast successful
                   snake_food_mode = FOOD_NORMAL
                   score *= 10
                   frenzy_counter = 0
               } 
               make_food()
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
        if not jormungar { 
            _score_before_jormungar = score
        }
        jormungar = true
        score *= 100;
        return
    }
    for(var i = 0; i < array_length(snakes) - 1; i++) {
        if head[0] == snakes[i][0] and head[1] == snakes[i][1] { 
            if snake_food_mode != FOOD_GHOST and snakes[i][2] != c_silver {
               dead = true;
                frenzy_counter = 0
               return
            } else {
                score += 5;
            }
        }
    }
}