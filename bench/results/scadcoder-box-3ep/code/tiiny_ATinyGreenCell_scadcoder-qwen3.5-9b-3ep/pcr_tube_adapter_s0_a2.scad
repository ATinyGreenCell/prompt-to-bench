// Adapter sleeve - a collar with a sleeve body that lines a 1.5 mL tube rack hole to hold a
// 0.2 mL PCR tube, with a through bore. NOVEL general part (a generic tube adapter).
//

top_d     = 13;
body_d    = 10.8;
wall      = 1.5;
tube_d    = 6.2;
collar_h  = 1.5;
body_h    = 21.5 - 1.5;

$fn = 72;

collar_t = 1.5;
body_t   = wall;

difference() {
    union() {
        cylinder(h = collar_h, d = top_d);                 // collar lying on the bed
        cylinder(h = body_h, d = body_d);                   // sleeve body above
    }
    translate([0, 0, -1]) cylinder(h = collar_h + body_h + 2, d = tube_d);  // through bore
}