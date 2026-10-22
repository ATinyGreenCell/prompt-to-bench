// Small lab funnel, printed upright (wide opening at top).
// All dimensions in millimetres.

// --- Named dimensions (measured with calipers) ---
spout_od   = 10;   // spout outer diameter
spout_id   = 6.8;  // spout inner (bore) diameter  (10 - 2*1.6)
spout_h    = 20;   // straight spout height (z = 0 .. 20)
cone_h     = 30;   // cone height (z = 20 .. 50)
cone_rim_od= 60;   // cone outer diameter at rim (z = 50)
cone_rim_id= 56.8; // cone inner diameter at rim (60 - 2*1.6)
wall       = 1.6;  // uniform wall thickness

// Derived radii (outer / inner)
spout_or  = spout_od   / 2;   // 5
spout_ir  = spout_id   / 2;   // 3.4
cone_top_or = cone_rim_od / 2; // 30
cone_top_ir = cone_rim_id / 2; // 28.4

// Smooth curved surfaces
$fn = 64;

// ---- Outer solid: straight spout + widening cone (both solid) ----
module outer() { union() {
    // Straight spout, z = 0 .. 20
    cylinder(h = spout_h, r = spout_or, $fn = $fn);

    // Cone, z = 20 .. 50, widening from spout OD to rim OD
    translate([0, 0, spout_h])
        cylinder(h = cone_h, r1 = spout_or, r2 = cone_top_or, $fn = $fn);
} }

// ---- Inner cavity: straight bore + widening bore (open top & bottom) ----
// Each bore is extended 1 mm past the faces it cuts so no faces are coplanar.
module cavity() { union() {
    // Straight bore, z = -1 .. 21  (1 mm past bottom, 1 mm into cone)
    cylinder(h = spout_h + 2, r = spout_ir, $fn = $fn);

    // Cone bore, z = 19 .. 51  (1 mm into spout, 1 mm past rim)
    translate([0, 0, spout_h - 1])
        cylinder(h = cone_h + 2, r1 = spout_ir, r2 = cone_top_ir, $fn = $fn);
} }

// ---- Funnel = outer minus cavity ----
difference() {
    outer();
    cavity();
}