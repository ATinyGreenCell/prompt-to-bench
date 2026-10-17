// Adapter sleeve - a collar with a sleeve body that lines a 1.5 mL tube rack hole to hold a
// 0.2 mL PCR tube. Printed upside down so the collar lies on the bed and the sleeve rises up.
// NOVEL general part.

collar_d  = 13;
collar_h  = 1.5;
body_d    = 10.8;
body_h    = 21.5;
bore      = 6.2;

$fn = 72;

collar_t = 1.5;

difference() {
    union() {
        cylinder(h = collar_h, d = collar_d);
        cylinder(h = body_h, d = body_d);
    }
    translate([0, 0, -1]) cylinder(h = body_h + 2, d = bore);
}