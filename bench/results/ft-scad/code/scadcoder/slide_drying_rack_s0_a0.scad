// Microscope slide drying rack - a solid base with 10 parallel slots cutting into the top face,
// for standing up microscope slides so they tip-rack. NOVEL general part.
//

slide  = 75;
long   = 25;
base   = 20;
length = 90;
width  = 45;
slot_l = 77;
slot_h = 1.6;
slot_d = 10;
y_pitch= 3.5;

$fn = 48;

slot_m = 2;                 // slot margin
clearance = 1;
pad      = slot_h + clearance;

base_t = slot_d + pad * 2;
slot_y = width / 2;

difference() {
    cube([length, width, base_t]);
    for (y = [-(width / 2) + slot_y - y_pitch / 2 : y_pitch : (width / 2) - slot_y + y_pitch / 2])
        translate([-slot_m, y, pad]) linear_extrude(slot_d + 2 * slot_m) rectangle(l = slot_l, h = slot_h);
}