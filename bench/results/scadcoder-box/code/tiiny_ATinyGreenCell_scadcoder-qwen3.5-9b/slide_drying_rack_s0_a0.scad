// Slide drying rack - a solid rectangular base with a row of parallel slots for standing
// microscope slides upright on their long edge. NOVEL part: a simple slot rack, not a
// parameterised grid.
//

length   = 90;
width    = 45;
height   = 20;
slots    = 10;
slot_w   = 1.6;
slot_d   = 10;
pitch    = 3.5;

$fn = 48;

top_w = width;
blow  = 0.5;                 // wall above the deepest slot

difference() {
    cube([length, width, height]);
    for (i = [0 : slots - 1])
        translate([length / 2 - (slot_w + pitch) * (slots - 1) / 2, width / 2 - (slot_w + pitch) / 2, 0])
            translate([0, 0, -1]) cube([length, slot_w + 2 * blow, slot_d]);   // open the slot through the block
}