// Drying rack for microscope slides - a solid base block with a row of parallel slots open at the
// top, so slides standing on their long edge are half immersed in water and dry upright. NOVEL
// general part (a generic "slide rack" rather than any one lab's part).
//

slides   = 10;
slide_w  = 75;
slide_h  = 25;
slide_t  = 1;
base_l   = 90;
base_w   = 45;
base_h   = 20;
slot_l   = 77;
slot_w   = 1.6;
slot_d   = 10;
pitch    = 3.5;

$fn = 48;

slot_w_eff = slot_w + 0.5;   // open the cut so it doesn't bridge between pixels

difference() {
    translate([-base_l / 2, -base_w / 2, 0]) cube([base_l, base_w, base_h]);
    for (i = [0 : slides - 1])
        translate([0, -base_w / 2 - pitch / 2 + i * pitch, 0])
            cube([slot_l, slot_w_eff, slot_d]);
}