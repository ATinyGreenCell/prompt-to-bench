// Drying rack for microscope slides - a solid base block with a row of parallel slots cut near
// the top, open at the top so wet slides standing on their long edge drain by capillary action.
// NOVEL general part (a generic "slide dryer" could apply to many labs).
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
pitch    = 3.5;

$fn = 48;

slot_h = base_h - slot_d + 0.01;                 // so the slot face is just below the top face

difference() {
    translate([-base_l / 2, base_w / 2, 0]) cube([base_l, base_w, base_h]);
    for (y = [-base_w / 2 + pitch / 2 : pitch : base_w / 2 - pitch / 2])
        translate([0, y, 0])
            difference() {
                translate([0, slot_w / 2, 0]) cube([slot_l, slot_w, base_h]);                 // remove a through-length strip
                translate([0, slot_w / 2, 0]) cube([slot_l, slot_w, slot_h]);                 // fill the lower part, leaving an open-top slot
            }
}