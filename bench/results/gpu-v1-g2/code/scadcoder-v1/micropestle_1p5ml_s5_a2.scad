// Pestle for a microcentrifuge tube - a cylindrical handle with a conical section and a
// rounded tip, with circumferential grip grooves. NOVEL general part.
//

handle_d = 8;
cone     = 0.7;          // cone taper: diameter reduces by this fraction over the cone height
tip_d    = 3;
grooves  = 4;
groove_w = 2;
groove_d = 1;
tube_b   = 16.4;         // e.g. a 1.5 mL tube (inner diameter ~16 mm) - the pestle tip passes through

$fn = 64;

ch   = 45;
cone_h = 62 - 45;
tip_h = tip_d / 2 + 1;   // embed the sphere tip 1 mm past the cone tip

difference() {
    union() {
        cylinder(h = ch, d = handle_d);
        translate([0, 0, ch]) cylinder(h = cone_h, d1 = handle_d, d2 = handle_d * cone);
        translate([0, 0, ch + cone_h]) sphere(d = tip_d);
    }
    for (z = [10, 15, 20, 25])
        translate([0, 0, z]) rotate([0, 90, 0]) cylinder(h = groove_w, d = groove_d * 2);
    // optional: pass the tip through a tube - uncomment if you want a clear wall clearance
    // translate([0, 0, ch + cone_h - 1]) cylinder(h = tip_h + 2, d = tube_b);
}