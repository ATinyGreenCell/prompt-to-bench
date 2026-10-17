// Adapter sleeve - a collar with a sleeve body that lines a 1.5 mL tube rack hole to
// hold a 0.2 mL PCR tube. Printed upside down: the collar lies on the bed and the
// sleeve body rises from it. A through-bore opens at both ends.
//

collar_d  = 13;
collar_h  = 1.5;
body_od   = 10.8;
body_h    = 21.5;
bore      = 6.2;

$fn = 72;

collar_t = 2;

difference() {
    union() {
        cylinder(h = collar_h, d = collar_d);
        cylinder(h = body_h, d = body_od);
    }
    translate([0, 0, -1]) cylinder(h = body_h + 2, d = bore);
    translate([0, 0, body_h + 0.5]) cylinder(h = collar_t + 0.5, d = bore);
}