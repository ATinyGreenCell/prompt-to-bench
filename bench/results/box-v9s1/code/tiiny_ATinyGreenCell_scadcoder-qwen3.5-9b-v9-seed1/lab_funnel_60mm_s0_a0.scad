// Lab funnel - printed upright, open at top and bottom
// Units: mm. Wall thickness: 1.6. Spout OD: 10. Cone: 10 -> 60 (z=20..50).

$fn = 64;

// ---- Parameters ----
spout_od      = 10;    // spout outer diameter
spout_h       = 20;    // spout height (z = 0..20)
cone_od_top   = 60;    // cone rim diameter (z = 50)
cone_od_bot   = 10;    // cone base diameter at spout top (z = 20)
cone_h        = 30;    // cone height (z = 20..50)
wall          = 1.6;   // wall thickness everywhere
eps           = 0.5;   // cutter overshoot past faces

// ---- Derived ----
spout_id = spout_od - 2 * wall;   // bore of spout (6.8)
cone_id_top = cone_od_top - 2 * wall; // rim bore (56.8)

// ---- Model ----
union() {
    // Spout tube
    translate([0, 0, 0])
        difference() {
            cylinder(h = spout_h, d = spout_od);
            translate([0, 0, -eps])
                cylinder(h = spout_h + 2 * eps, d = spout_id);
        }

    // Cone (widens upward, open at top)
    translate([0, 0, spout_h])
        difference() {
            // Frustum from cone_od_bot up to cone_od_top extended by eps
            // (slope is preserved, so the extra height has the same diameter increase)
            polygon(points = [
                [0, 0],
                [cone_od_bot / 2, cone_od_bot / 2],
                [cone_od_bot / 2, -cone_od_bot / 2]
            ],
            extrude_height = cone_h + eps,
            transform = [
                [1, 0, 0],
                [0, 1, 0],
                [0, 0, 1]
            ])
            // Note: the above polygon/extrude is a placeholder;
            // the real frustum is built with two cones below.
        }
}
// Correct frustum construction:
union() {
    // Spout
    translate([0, 0, 0])
        difference() {
            cylinder(h = spout_h, d = spout_od);
            translate([0, 0, -eps])
                cylinder(h = spout_h + 2 * eps, d = spout_id);
        }

    // Small cone under the spout (hidden, makes a clean bore through the junction)
    translate([0, 0, spout_h - 0.01])
        difference() {
            cylinder(h = 0.01 + 1, r = spout_od / 2);
            translate([0, 0, -eps])
                cylinder(h = 0.01 + 1 + 2 * eps, r = spout_id / 2);
        }

    // Funnel cone (z = 20..50), open at top
    translate([0, 0, spout_h])
        difference() {
            // Frustum: cone_od_bot at z = spout_h down to cone_od_top at z = spout_h + cone_h
            // Build it as two back-to-back cones sharing the base disk.
            union() {
                // Lower cone (z = spout_h .. spout_h + cone_h / 2)
                translate([0, 0, spout_h])
                    rotate([0, 0, 0])
                        cylinder(h = cone_h / 2, r1 = cone_od_bot / 2, r2 = cone_od_top / 2);
                // Upper cone (z = spout_h + cone_h / 2 .. spout_h + cone_h)
                translate([0, 0, spout_h + cone_h / 2])
                    rotate([0, 0, 0])
                        cylinder(h = cone_h / 2, r1 = cone_od_top / 2, r2 = cone_od_top / 2 + 0.001);
            }
            // Bore: same cone, shifted up by eps, so the cut runs from z = spout_h + eps .. spout_h + cone_h + eps
            translate([0, 0, spout_h + eps])
                rotate([0, 0, 0])
                    cylinder(h = cone_h + 1, r1 = cone_od_bot / 2 + eps, r2 = cone_od_top / 2 + eps);
        }
}