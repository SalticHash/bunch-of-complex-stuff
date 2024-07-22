if (keyboard_check_pressed(ord("K"))) {
    selectingMode = !selectingMode
}
if (keyboard_check(ord("P"))) {
    cx = round(mouse_x)
    cy = round(mouse_y)
    cursorNotice = fstring("{cx}, {cy}")
}