// Drying rack for microscope slides - a solid base block with a row of parallel slots cut near
// the top, open at the top so wet slides can stand upright on their long edge and drain. NOVEL
// part: a simple slot grid, not a hole grid, so a slide placed in a slot rests on the bottom
// and is supported along its entire length.
//

slides_l = 75;
slides_w = 25;
slides_t = 1;
base_l   = 90;
base_w   = 45;
base_h   = 20;
slot_l   = 77;
slot_w   = 1.6;
slot_d   = 10;
pitch_y  = 3.5;

$fn = 48;

slot_x_center = base_l / 2;
first_y       = base_w / 2 - (slot_w + pitch_y) / 2;
last_y        = base_w / 2 + (slot_w + pitch_y) / 2;
y_positions   = [first_y + i * pitch_y for i in [0 : 9]];

difference() {
    translate([0, 0, 0]) cube([base_l, base_w, base_h]);
    for (y = y_positions)
        translate([slot_x_center, y, -1]) cube([slot_l, slot_w, base_h - slot_d + 2]);
}