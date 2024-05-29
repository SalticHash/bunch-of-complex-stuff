event_inherited();

delay = 1;

execute = function() {
    if (delay == 0)
        alarm[0] = 1
    else
        alarm[0] = (delay * room_speed)
}