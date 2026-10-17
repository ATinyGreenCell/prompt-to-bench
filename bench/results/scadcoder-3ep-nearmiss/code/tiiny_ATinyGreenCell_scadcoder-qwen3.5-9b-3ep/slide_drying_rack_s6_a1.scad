// Drying rack for microscope slides - a solid block with a row of parallel slots open at the
// top, so slides standing on their long edge drop in and are supported below. NOVEL general part.
//

slides   = 10;
slide_l  = 75;
slide_w  = 25;
slide_t  = 1;
base_l   = 90;
base_w   = 45;
base_h   = 20;
slot_l   = 77;
slot_w   = 1.6;
slot_d   = 10;
slot_gap = 3.5;

$fn = 48;

slot_s = slide_l + 2 * slot_gap;                 // open slot length so the inner wall is 0.8 mm clear of the
                                                 // slide edges (slide length 75 mm, gap 3.5 mm)

difference() {
    translate([-base_l / 2, -base_w / 2, 0]) cube([base_l, base_w, base_h]);
    for (y = [-(base_w / 2 - slot_s / 2) / 2 + i * slot_gap | i = [0 : slides - 1]])
        translate([0, y, 0]) difference() {
            cube([slot_s, base_w, base_h]);                                     // cutting block
            translate([0, 0, -1]) cube([slot_s, slot_w, base_h + 2]);           // slot - open at the top
        }
}