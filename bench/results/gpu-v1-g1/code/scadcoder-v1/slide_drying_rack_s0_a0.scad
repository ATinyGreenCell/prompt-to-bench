// Slide drying rack - a solid base block with a row of parallel slots standing up on their long
// edge, for drying 10 x 75 mm microscope slides. NOVEL general part.
//

slides = 10;
base_l = 90;
base_w = 45;
base_h = 20;
slot_l = 77;
slot_w = 1.6;
slot_d = 10;
pitch   = 3.5;

$fn = 48;

margin = slot_w / 2 + pitch / 2 + 0.5;
w      = base_w - 2 * margin;

difference() {
    cube([base_l, base_w, base_h]);
    for (i = [0 : slides - 1])
        translate([0, margin + i * pitch, 0]) cube([slot_l, slot_w, slot_d]);
}