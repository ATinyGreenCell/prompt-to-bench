// Small lab funnel, printed upright (wide opening at top), open top and bottom.
// All dimensions in millimetres.

// ---- Named dimensions (measured with calipers) ----
spout_od   = 10;   // spout outer diameter
spout_h    = 20;   // spout height (z = 0 to z = 20)
cone_od    = 60;   // cone outer diameter at the rim (z = 50)
cone_h     = 30;   // cone height (z = 20 to z = 50)
wall       = 1.6;  // uniform wall thickness

// Derived inner (bore) diameters
spout_id   = spout_od - 2 * wall;   // 6.8 mm spout bore
cone_id    = cone_od  - 2 * wall;   // 56.8 mm bore at the rim

// ---- Print orientation: rests on XY plane at z = 0, builds upward (+Z), centred on origin ----

$fn = 64;   // round holes / rims

// Outer solid: straight spout tube + widening cone (both solid, closed at z = 0)
outer = union() {
    // Spout: z = 0 to z = 20, outer radius = spout_od/2
    cylinder(h = spout_h, d = spout_od, $fn = $fn);

    // Cone: z = 20 to z = 50, base radius = spout_od/2, top radius = cone_od/2
    translate([0, 0, spout_h])
        cylinder(h = cone_h, d1 = spout_od, d2 = cone_od, $fn = $fn);
};

// Bore: straight spout bore + conical bore, open at both ends (extends past faces)
bore = union() {
    // Spout bore: z = -1 to z = 20, radius = spout_id/2
    cylinder(h = spout_h + 1, d = spout_id, $fn = $fn);

    // Conical bore: z = 20 to z = 51, base radius = spout_id/2, top radius = cone_id/2
    translate([0, 0, spout_h])
        cylinder(h = cone_h + 1, d1 = spout_id, d2 = cone_id, $fn = $fn);
};

// Funnel = outer solid minus through-bore (open top and bottom)
difference() {
    outer;
    bore;
}