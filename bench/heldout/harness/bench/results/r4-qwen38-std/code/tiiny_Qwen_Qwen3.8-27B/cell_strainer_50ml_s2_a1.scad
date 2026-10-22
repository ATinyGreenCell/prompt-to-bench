// Coarse cell strainer for a 50 mL conical tube
// Units: mm. Printed upright, resting on the XY plane (z = 0), round about Z.

$fn = 64;

// ---- Cup body (tube) ----
OD        = 25.0;   // outer diameter of the straight tube
wall      = 1.2;    // wall thickness
ID        = OD - 2*wall;   // 22.6 mm bore
H         = 32.0;  // overall height of the cup
floor_h   = 1.2;   // floor thickness (z = 0 .. 1.2)

// ---- Collar (45-degree flare + rim) that rests on the tube rim ----
collar_z0  = 26.0;  // cone starts here (25 mm dia)
collar_z1  = 30.0;  // cone ends here (33 mm dia)
collar_d0  = 25.0;  // cone base diameter
collar_d1  = 33.0;  // cone top / rim diameter
rim_z0     = 30.0;  // rim starts here
rim_z1     = 32.0;  // rim ends here (top of cup)

// ---- Floor filter holes ----
hole_d    = 1.0;   // hole diameter
grid      = 2.0;   // square grid pitch
r_max     = 10.0;  // keep holes whose centre is within this radius (81 holes)

// ---- Vent notches (air escape) ----
notch_w    = 3.0;   // notch width
notch_x    = 12.5;  // remove material beyond this distance from axis
notch_z    = 25.0;  // notches cut from this height up

// ============================
// 1. Solid cup: outer profile minus bore
// ============================
module outer_profile() {
    // straight tube
    cylinder(h = collar_z0, d = OD, $fn = $fn);
    // 45-degree flare (cone)
    translate([0, 0, collar_z0])
        cylinder(h = collar_z1 - collar_z0, r1 = collar_d0/2, r2 = collar_d1/2, $fn = $fn);
    // rim
    translate([0, 0, rim_z0])
        cylinder(h = rim_z1 - rim_z0, r = collar_d1/2, $fn = $fn);
}

module bore() {
    // extends 1 mm past the floor (bottom) and 1 mm past the top so no coplanar faces
    translate([0, 0, -1.0])
        cylinder(h = H + 2.0, d = ID, $fn = $fn);
}

// ============================
// 2. Floor holes (81, 2 mm square grid, centred, within 10 mm)
// ============================
module floor_holes() {
    for (i = [-5:5]) {
        for (j = [-5:5]) {
            if (i*i + j*j <= 25) {   // (i*2)^2 + (j*2)^2 <= 10^2  ->  i^2+j^2 <= 25
                translate([i*grid, j*grid, -1.0])
                    cylinder(h = floor_h + 2.0, d = hole_d, $fn = $fn);
            }
        }
    }
}

// ============================
// 3. Vent notches on +X and -X (remove collar & rim beyond 12.5 mm)
// ============================
module vent_notches() {
    for (s = [-1, 1]) {
        // box extends 1 mm past the top and 1 mm past the outer face -> no coplanar faces
        translate([s*notch_x, -notch_w/2, notch_z - 1.0])
            cube([1.0, notch_w, (rim_z1 - notch_z) + 2.0]);
    }
}

// ============================
// Final part
// ============================
difference() {
    outer_profile();
    bore();
    floor_holes();
    vent_notches();
}