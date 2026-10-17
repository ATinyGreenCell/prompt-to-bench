// Adapter sleeve - a collar with a tube sleeve below, boring through, to adapt a smaller tube
// to a larger rack hole. NOVEL general part.
//

collar_d   = 13;
collar_h   = 1.5;
sleeve_d   = 10.8;
sleeve_h   = 21.5;
bore_d     = 6.2;

$fn = 72;

t = min(bore_d / 2 - 1, 2);          // wall thickness for the sleeve

difference() {
    union() {
        cylinder(h = collar_h, d = collar_d);                 // collar (contact the rack)
        cylinder(h = sleeve_h, d = sleeve_d);                 // sleeve body
    }
    translate([0, 0, -1]) cylinder(h = sleeve_h + 2, d = bore_d);   // through-bore
}