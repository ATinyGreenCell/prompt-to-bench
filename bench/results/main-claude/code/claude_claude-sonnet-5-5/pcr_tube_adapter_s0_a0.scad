// PCR tube adapter sleeve (printed upside down, collar on bed)
$fn = 96;

collar_d      = 13;    // collar outer diameter
collar_h      = 1.5;   // collar thickness (z = 0 to 1.5)
body_d        = 10.8;  // sleeve body outer diameter
total_h       = 21.5;  // overall height
bore_d        = 6.2;   // through bore diameter
cut_margin    = 0.5;   // extra length of cutting cylinder past each face

difference() {
    union() {
        // collar on the bed
        cylinder(d = collar_d, h = collar_h);
        // sleeve body rising from the collar
        cylinder(d = body_d, h = total_h);
    }
    // straight through bore, open at both ends
    translate([0, 0, -cut_margin])
        cylinder(d = bore_d, h = total_h + 2 * cut_margin);
}