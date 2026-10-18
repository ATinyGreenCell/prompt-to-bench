// Funnel - a straight spout topped with a cone, open at both ends.
// Print orientation: spout pointing down, wide rim at the top.
//

// ---------- Parameters ----------
spout_d        = 10;    // spout outer diameter
spout_bore     = 6.8;   // spout bore diameter (wall 1.6 mm)
spout_length   = 20;    // spout length (z = 0 to z = 20)
cone_top_d     = 60;    // cone rim outer diameter at z = 50
cone_height    = 30;    // cone height (z = 20 to z = 50)
wall           = 1.6;   // wall thickness everywhere
eps            = 0.5;   // cutter overshoot past faces
$fn            = 96;    // curve resolution

// Derived
cone_bottom_d = spout_d;                       // cone starts at spout diameter
spout_r       = spout_d / 2;
bore_r        = spout_bore / 2;
cone_r_top    = cone_top_d / 2;
cone_r_bot    = cone_bottom_d / 2;

// ---------- Model ----------
difference() {
    union() {
        // Straight spout: z = 0 to 20
        cylinder(r = spout_r, h = spout_length);

        // Cone: z = 20 to 50, diameter grows from 10 to 60 mm
        translate([0, 0, spout_length])
            cylinder(r1 = cone_r_bot, r2 = cone_r_top, h = cone_height);
    }

    // Through-bore: a single bore runs the full length (z = 0 to 50),
    // so liquid flows straight through spout and cone.
    translate([0, 0, -eps])
        cylinder(r = bore_r, h = spout_length + cone_height + 2 * eps);
}