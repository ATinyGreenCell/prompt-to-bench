// Buffer tank for mini horizontal gel-electrophoresis box
// Units: mm. Print orientation: open top, resting on XY plane at z = 0.

$fn = 64;

// ---- Tank ----
outer_x      = 120;   // tank outer length (X)
outer_y      = 70;    // tank outer width (Y)
tank_h       = 40;    // tank outer height (Z)
wall         = 3;     // tank wall thickness
floor_t      = 3;     // tank floor thickness

// ---- Gel-tray platform ----
plat_x       = 60;    // platform length in X (centred)
plat_y       = 70;    // platform width in Y (full inner width)
plat_top_z   = 13;    // platform top height above inner floor
                // (note: user gave z = 13 even though inner floor is at z = 3)

// ---- Electrode holes ----
hole_d       = 2;     // electrode hole diameter
hole_y       = 0;     // electrode hole Y position
hole_z       = 30;    // electrode hole Z position

// ---- Misc ----
eps          = 0.5;   // cutter overshoot past faces

// Inner dimensions
inner_x = outer_x - 2*wall;
inner_z = tank_h - floor_t;

// Platform legs (simplified) extending from top down to the floor
leg_h = plat_top_z + floor_t;

difference() {
    union() {
        // Tank body
        cube([outer_x, outer_y, tank_h]);
        // Raised platform
        translate([(outer_x - plat_x)/2, 0, plat_top_z])
            cube([plat_x, plat_y, leg_h]);
    }

    // Chamber divider: runs along Y, sits on top of the floor,
    // leaving an open gap above the platform so the chambers connect.
    translate([(inner_x - plat_x)/2 - eps, 0, floor_t])
        cube([plat_x + 2*eps, outer_y, inner_z - plat_top_z - 1]);

    // Electrode wires: horizontal holes along X through each end wall
    for (s = [-1, 1])
        translate([s * (outer_x/2 - hole_d/2), hole_y, hole_z])
            rotate([-90, 0, 0]) cylinder(d = hole_d, h = outer_x + 2*eps);
}