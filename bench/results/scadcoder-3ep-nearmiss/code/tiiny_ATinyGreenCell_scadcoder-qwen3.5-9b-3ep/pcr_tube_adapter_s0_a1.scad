// Adapter sleeve - a collar with a sleeve body that lines a 1.5 mL tube rack hole to hold a
// 0.2 mL PCR tube, with a through bore. NOVEL general part (a generic tube adapter).
//

top_d     = 13;
body_d    = 10.8;
collar_t  = 1.5;
body_h    = 21.5 - 1.5;
bore_d    = 6.2;

$fn = 72;

top = cylinder(h = collar_t, d = top_d);
body = cylinder(h = body_h, d = body_d);
bore = translate([0, 0, -1]) cylinder(h = collar_t + body_h + 1, d = bore_d);

difference() {
    union(top, body);
    bore;
}