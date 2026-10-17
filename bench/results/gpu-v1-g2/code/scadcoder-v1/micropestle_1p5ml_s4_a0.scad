// Pestle for a microcentrifuge tube - a cylindrical handle with a conical section and a
// rounded tip, with circumferential grip grooves. NOVEL general part.
//

handle_d = 8;
cone     = 0.6;          // cone taper: diameter reduces by this many mm per mm of height
tip      = 3;
grooves  = 4;
groove_w = 2;
groove_d = 1;
tube_b   = 16.4;         // e.g. a 1.5 mL microcentrifuge tube (inner diameter ~16 mm)

$fn = 64;

ch  = min(handle_d, tube_b - 2 * wall);                 // handle diameter that clears the tube
cd  = ch * cone;                                        // cone top diameter
cg  = min(cd, tip);                                    // groove section diameter (keep it round)
sp  = min(tip, wall + groove_d);                       // tip sphere radius, clear the tube wall
L   = 45 + (ch - cg) / cone + sp;                       // overall length

difference() {
    union() {
        cylinder(h = 45, d = ch);                       // handle
        translate([0, 0, 45]) cylinder(h = (ch - cg) / cone, d1 = ch, d2 = cg);                 // cone
        translate([0, 0, 45 + (ch - cg) / cone]) sphere(d = 2 * sp);                            // rounded tip
    }
    for (z = [10, 15, 20, 25])
        translate([0, 0, z]) rotate([0, 90, 0]) cylinder(h = ch + 2, d = groove_w, z = groove_d);   // circumferential grooves
}