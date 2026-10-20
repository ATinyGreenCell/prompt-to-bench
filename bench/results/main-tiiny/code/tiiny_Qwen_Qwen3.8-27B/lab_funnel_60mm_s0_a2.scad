// Small lab funnel, printed upright (wide opening at top).
// All dimensions in mm, measured with calipers.

// --- Named dimensions ---
spout_od   = 10.0;   // outer diameter of the straight spout (tube)
spout_len  = 20.0;   // length of the straight spout, z = 0 to z = 20
cone_z0    = 20.0;   // z where the cone starts (top of spout)
cone_z1    = 50.0;   // z of the rim (top of cone)
cone_od    = 60.0;   // outer diameter of the cone at the rim
wall       = 1.6;    // wall thickness everywhere

// Derived values
spout_id   = spout_od - 2*wall;                 // spout bore = 6.8 mm
cone_id0   = spout_id;                          // cone inner diameter at z = 20
cone_id1   = cone_od  - 2*wall;                // cone inner diameter at rim = 56.8 mm
cone_h     = cone_z1 - cone_z0;                // cone height = 30 mm

$fn = 64;

// --- Outer solid: straight spout + widening cone (closed at bottom) ---
outer = union() {
    // Straight spout, z = 0 to z = 20
    cylinder(h = spout_len, d = spout_od, $fn = $fn);

    // Cone, z = 20 to z = 50, widening 10 -> 60 mm OD
    translate([0, 0, cone_z0])
        cylinder(h = cone_h, d1 = spout_od, d2 = cone_od, $fn = $fn);
};

// --- Inner cavity: straight bore + widening bore, open at top and bottom ---
// Each cutter extends 1 mm past the faces it cuts (bottom below z=0, top above z=50)
// so no faces are exactly coplanar.
inner = union() {
    // Straight bore through the spout, extended 1 mm below z = 0
    translate([0, 0, -1.0])
        cylinder(h = spout_len + 1.0, d = spout_id, $fn = $fn);

    // Widening bore through the cone, extended 1 mm above the rim (z = 50)
    translate([0, 0, cone_z0])
        cylinder(h = cone_h + 1.0, d1 = cone_id0, d2 = cone_id1, $fn = $fn);
};

// --- Funnel: outer minus inner (open at top and bottom) ---
difference() {
    outer;
    inner;
}