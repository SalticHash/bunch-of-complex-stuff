event_inherited();

delay = 1;
reset = false;

execute = function() {
    image_blend = c_white

    // If its counting down, and it has reset off, dont disturb it.
    if (alarm[0] != -1 && reset == false)
        return
    
    if (delay <= 0)
        alarm[0] = 1
    else
        alarm[0] = (delay * room_speed)
}