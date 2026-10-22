// Replacement knob for a 6 mm D-shaft hotplate stirrer
// Print orientation: hotplate-facing side down on the bed (z = 0), builds upward (+Z)

$fn = 64;

// ---- Dimensions (mm) ----
knob_dia      = 30;   // outer cylinder diameter
knob_h        = 15;   // knob height (z = 0 .. 15)
knob_r        = knob_dia / 2;

// D-bore (blind, from bottom face)
bore_dia      = 6.2;  // circle part of the D
bore_flat     = 4.7;  // distance from flat to opposite side of circle
bore_h        = 12;   // depth of the blind bore
bore_r        = bore_dia / 2;
bore_c        = bore_flat - bore_r;  // circle centre offset from knob centre (flat side)

// Grip grooves (vertical, full height)
n_grooves     = 18;
groove_dia    = 2;
groove_r      = groove_dia / 2;

// Pointer groove (top face)
ptr_w         = 1.5;  // width
ptr_d         = 1;    // depth
ptr_len       = knob_r + 1;  // extend past outer edge for a clean cut

// ---- Body ----
module body() { cylinder(h = knob_h, r = knob_r, $fn = $fn); }

// ---- D-shaped blind bore (cut from bottom, z = 0 .. bore_h) ----
// Circle part of the D, offset toward the flat side
module d_circle() { translate([0, bore_c, -0.01])
    cylinder(h = bore_h + 0.01, r = bore_r, $fn = $fn); }

// Flat part of the D: a box that removes everything beyond the flat plane
// (flat plane is at y = 0; circle centre is at y = bore_c)
module d_flat() { translate([-bore_r, 0, -0.01])
    cube([2 * bore_r, bore_c + 0.01, bore_h + 0.01]); }

module d_bore() { union() {
    d_circle();
    d_flat();
} }

// ---- Vertical grip grooves (18, evenly spaced, full height) ----
// Each groove is a 2 mm diameter half-cylinder centred on the outer surface.
// The half-cylinder is oriented so its flat face is radial (pointing at the knob
// centre) and its curved face bites into the outer surface.
module groove() { rotate([0, 90, 0])
    translate([0, 0, -0.01])
    cylinder(h = knob_h + 0.02, r = groove_r, $fn = $fn); }

module grips() { for (i = [0 : n_grooves - 1])
    rotate([0, 0, i * 360 / n_grooves])
        translate([knob_r, 0, 0])
            groove(); }

// ---- Pointer groove (top face, from centre to outer edge, on the flat side) ----
// Flat side is +Y, so the pointer runs along +Y.
// A 1.5 mm wide, 1 mm deep slot cut into the top face.
module pointer() { translate([-ptr_w / 2, 0, knob_h - ptr_d])
    cube([ptr_w, ptr_len, ptr_d + 0.01]); }

// ---- Final part ----
difference() {
    body();
    d_bore();
    grips();
    pointer();
}