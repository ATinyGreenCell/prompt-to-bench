// Replacement knob for a hotplate stirrer with a 6 mm D-shaft.
// Units: mm. Print orientation: hotplate-facing side down on the bed (z = 0).

$fn = 64;

// ---- Named dimensions (measured with calipers) ----
knob_dia      = 30;   // outer cylinder diameter
knob_h        = 15;   // knob height (builds +Z from z = 0)
knob_r        = knob_dia / 2;   // 15

d_bore_dia    = 6.2;  // D-bore circular portion diameter
d_bore_r      = d_bore_dia / 2; // 3.1
d_bore_flat   = 4.7;  // distance from the flat side to the opposite side of the circle
d_bore_depth  = 12;   // blind bore depth into the knob

n_grooves     = 18;   // number of vertical grip grooves
groove_dia    = 2;    // grip groove diameter
groove_r      = groove_dia / 2; // 1

ptr_w         = 1.5;  // pointer groove width
ptr_d         = 1;    // pointer groove depth

// Derived: the D-bore flat is offset from the circle centre by this amount
// (flat at x = +off, opposite arc at x = -d_bore_r, so flat-to-opposite = off + d_bore_r)
d_bore_off    = d_bore_flat - d_bore_r; // 1.6

// ---- Base knob (rests on z = 0, centred on origin in X/Y) ----
knob = cylinder(h = knob_h, r = knob_r, $fn = $fn);

// ---- D-shaped blind bore (cut from the bottom face, 12 mm up) ----
// Circle + a box that removes the region beyond the flat side, then extruded.
module d_bore() { difference(
    circle(r = d_bore_r, $fn = $fn),
    translate([d_bore_off, 0]) square([d_bore_off + d_bore_r + 1, 2 * d_bore_r + 2], center = false)
); }
d_bore_cut = linear_extrude(h = d_bore_depth) d_bore();

// ---- Vertical grip grooves (full height, centred on the outer surface) ----
grooves = for (i = [0 : n_grooves - 1])
    rotate([0, 0, i * 360 / n_grooves])
        translate([knob_r, 0, 0])
            cylinder(h = knob_h + 2, r = groove_r, $fn = $fn);   // extends 1 mm past each face

// ---- Pointer groove on the top face (same side as the D flat, i.e. +X) ----
// 1.5 mm wide, 1 mm deep, running from the centre to the outer edge.
ptr_cut = translate([0, 0, knob_h - ptr_d])
    cube([knob_r + 1, ptr_w, ptr_d + 1], center = [false, true, false]);

// ---- Final part ----
difference(
    knob,
    d_bore_cut,
    grooves,
    ptr_cut
);