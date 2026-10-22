// Anti-vibration foot for benchtop instrument
// Print orientation: wide base on bed (z = 0), narrowing upward

$fn = 128;

// ---- Dimensions (mm) ----
base_d     = 30;    // frustum diameter at bottom (z = 0)
top_d      = 16;    // frustum diameter at flat top
height     = 12;    // overall height of frustum

recess_d   = 24;    // rubber pad recess diameter (bottom face)
recess_h   = 2;     // rubber pad recess depth

hole_d     = 5.5;   // through screw hole diameter

eps        = 0.5;   // overshoot for clean boolean cuts

// ---- Model ----
difference() {
    // Main frustum body
    cylinder(h = height, d1 = base_d, d2 = top_d);

    // Bottom recess for rubber pad
    translate([0, 0, -eps])
        cylinder(h = recess_h + eps, d = recess_d);

    // Central through hole for screw
    translate([0, 0, -eps])
        cylinder(h = height + 2 * eps, d = hole_d);
}
