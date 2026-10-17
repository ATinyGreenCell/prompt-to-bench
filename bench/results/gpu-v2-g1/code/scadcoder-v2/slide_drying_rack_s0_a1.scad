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

slot_y = slide_w + pitch;                 // centre-to-centre in Y
total_y = slot_y * slides + pitch;       // bounding box in Y if the slots were a solid comb
margin_y = (base_w - total_y) / 2;
start_y = base_w / 2 - total_y / 2 + margin_y;

difference() {
    translate([base_l / 2, base_w / 2, 0]) cube([base_l, base_w, base_h]);
    for (i = [0 : slides - 1])
        translate([base_l / 2, start_y + i * slot_y, -1])
            cube([slot_l, slot_w, base_h - slot_d]);
}