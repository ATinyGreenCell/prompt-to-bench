// Anti-vibration foot for benchtop instrument
// Print orientation: wide base on bed (z = 0), narrowing upward

// ---- Parameters (mm) ----
base_d      = 50;    // frustum diameter at bottom (z = 0)
top_d       = 36;    // frustum diameter at flat top
height      = 15;    // overall height
recess_d    = 44;    // rubber pad recess diameter (bottom face)
recess_h    = 2;     // rubber pad recess depth
screw_d     = 5.5;   // central screw through-hole diameter
eps         = 0.5;   // cutter overlap past faces

$fn = 128;

difference() {
    // Main frustum body
    cylinder(h = height, d1 = base_d, d2 = top_d);

    // Rubber pad recess in bottom face
    translate([0, 0, -eps])
        cylinder(h = recess_h + eps, d = recess_d);

    // Central screw through-hole
    translate([0, 0, -eps])
        cylinder(h = height + 2 * eps, d = screw_d);
}
