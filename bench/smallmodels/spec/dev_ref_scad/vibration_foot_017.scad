// Anti-vibration foot for benchtop instrument
// Print orientation: wide base on bed (z = 0), narrow top at z = 12

// ---------------- Parameters ----------------
base_d      = 50;    // frustum diameter at bottom (z = 0)
top_d       = 40;    // frustum diameter at flat top
foot_h      = 12;    // overall height of foot

recess_d    = 44;    // rubber pad recess diameter (bottom face)
recess_h    = 3;     // rubber pad recess depth

screw_d     = 5.5;   // through-hole diameter for screw

eps         = 0.5;   // overshoot for clean boolean cuts
$fn         = 128;   // curve resolution

// ---------------- Model ----------------
difference() {
    // Main frustum body
    cylinder(h = foot_h, d1 = base_d, d2 = top_d);

    // Rubber pad recess in bottom face
    translate([0, 0, -eps])
        cylinder(h = recess_h + eps, d = recess_d);

    // Central screw hole, full height
    translate([0, 0, -eps])
        cylinder(h = foot_h + 2 * eps, d = screw_d);
}
