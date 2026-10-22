// Coarse cell strainer for a 50 mL conical tube
// Printed upright, rotationally symmetric about Z

$fn = 96;

// ---- Cup ----
cup_od        = 25.0;   // cup outer diameter
wall          = 1.2;    // cup wall thickness
cup_bore      = cup_od - 2*wall; // 22.6 mm bore
cup_h         = 32.0;   // total height (z = 0 .. 32)
floor_t       = 1.2;    // floor thickness (z = 0 .. 1.2)

// ---- Collar ----
cone_z0       = 26.0;   // cone start height (at cup OD)
cone_z1       = 30.0;   // cone end height (at rim OD)
rim_od        = 33.0;   // rim outer diameter
// rim runs from cone_z1 up to cup_h

// ---- Floor holes ----
hole_d        = 1.0;    // hole diameter
hole_pitch    = 2.0;    // square grid pitch
hole_r_max    = 10.0;   // keep holes with centre within this radius
hole_n        = 5;      // grid index range -hole_n..hole_n

// ---- Vent notches ----
notch_w       = 3.0;    // notch width (Y)
notch_r       = 12.5;   // material removed beyond this radius (X)
notch_z0      = 25.0;   // notch starts at this height

eps           = 0.5;    // overcut for clean differences

// ---------------------------------------------------------------
module body() {
    rotate_extrude($fn = 128)
        polygon([
            [0,            0],
            [cup_od/2,     0],
            [cup_od/2,     cone_z0],
            [rim_od/2,     cone_z1],
            [rim_od/2,     cup_h],
            [0,            cup_h]
        ]);
}

module floor_holes() {
    for (i = [-hole_n : hole_n])
        for (j = [-hole_n : hole_n])
            if ((i*hole_pitch)*(i*hole_pitch) + (j*hole_pitch)*(j*hole_pitch)
                <= hole_r_max*hole_r_max + 1e-6)
                translate([i*hole_pitch, j*hole_pitch, -eps])
                    cylinder(d = hole_d, h = floor_t + 2*eps, $fn = 32);
}

module vent_notches() {
    for (s = [0, 1])
        mirror([s, 0, 0])
            translate([notch_r, -notch_w/2, notch_z0])
                cube([rim_od/2 - notch_r + eps,
                      notch_w,
                      cup_h - notch_z0 + eps]);
}

difference() {
    body();
    // bore
    translate([0, 0, floor_t])
        cylinder(d = cup_bore, h = cup_h - floor_t + eps, $fn = 128);
    // floor mesh (81 holes)
    floor_holes();
    // air vents through collar and rim
    vent_notches();
}