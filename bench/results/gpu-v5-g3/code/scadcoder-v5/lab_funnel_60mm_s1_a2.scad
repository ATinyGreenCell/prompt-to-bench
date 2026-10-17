// Funnel - printed upright, wide opening at top, open bottom and spout through
// Units: mm. Teaches a cone + spout with uniform wall thickness.
//

spout_d     = 10;   // spout outer diameter
spout_bore  = 6.8;  // spout bore (10 - 2*1.6)
spout_h     = 20;   // spout height (z = 0 to 20)
cone_top_d  = 60;   // cone rim outer diameter (z = 50)
cone_h      = 30;   // cone height (z = 20 to 50)
wall        = 1.6;  // wall thickness everywhere
eps         = 0.5;  // cutter overshoot

$fn = 64;

// Cone inner diameter at its start (z = 20), bore open through
cone_in_d = spout_d - 2*wall;   // 6.8 mm, matches bore

difference() {
    union() {
        // Spout: cylinder z = 0..20
        cylinder(d = spout_d, h = spout_h);
        // Cone: linear_extrude from a 6.8 mm disk at z = 20 up to 60 mm at z = 50
        translate([0, 0, spout_h])
            linear_extrude(height = cone_h)
                cylinder(d = cone_top_d, h = cone_h + 0.01); // tiny overlap for clean union
    }
    // Through-bore: one cylinder from z = 0 to z = 50.01
    translate([0, 0, -eps])
        cylinder(d = spout_bore, h = spout_h + cone_h + 2*eps);
}