// Adapter sleeve - a collar with a sleeve body that lines a 1.5 mL tube rack hole to hold a
// 0.2 mL PCR tube, with a through bore. NOVEL general part (a generic tube adapter).
//

top_d     = 13;
body_d    = 10.8;
collar_t  = 1.5;
body_h    = 21.5;
bore_d    = 6.2;

$fn = 72;

top   = top_d / 2;
body  = body_d / 2;
base  = top_d / 2;

difference() {
    union() {
        cylinder(h = collar_t, d = top_d);                 // collar on the bed
        cylinder(h = body_h, d = body_d);                   // sleeve body
    }
    translate([0, 0, -1]) cylinder(h = body_h + 2, d = bore_d);   // through bore
    translate([0, 0, base + 1]) cylinder(h = body_h - 2 * (base + 1), d = base);  // inner wall above the collar
}