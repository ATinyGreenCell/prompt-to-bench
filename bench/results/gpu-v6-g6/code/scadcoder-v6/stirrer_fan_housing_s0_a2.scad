// Magnetic stirrer housing (print orientation: upside down)
// Units: mm

// ---- Top plate ----
plate_t      = 2;     // plate thickness (z = 0 to 2)
plate_x      = 90;    // plate outer size in X
plate_y      = 90;    // plate outer size in Y

// ---- Walls ----
wall_t       = 2.5;   // wall thickness
wall_top_z   = 40;    // open top of box (walls rise from plate to this)

// ---- Screw holes ----
hole_d       = 4.5;   // M4 screw hole diameter
hole_n       = 4;     // number of holes
hole_pitch   = 71.5;  // square pattern side length

// ---- Cable notch ----
notch_w      = 12;    // notch width along wall
notch_bottom = 8;     // notch depth from open edge (z = 32 to 40)

// ---- Misc ----
eps          = 0.5;   // cutter overshoot past faces
$fn          = 64;    // curve resolution

difference() {
    // Solid body: top plate + four walls, open top
    union() {
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? plate_x/2 - wall_t : -plate_x/2,
                       sy > 0 ? plate_y/2 - wall_t : -plate_y/2,
                       0])
                cube([wall_t, wall_t, wall_top_z]);
    }

    // Screw holes through top plate
    for (i = [0 : hole_n - 1]) {
        a = hole_pitch * i / (hole_n - 1);
        translate([a - hole_d/2, a - hole_d/2, -eps])
            cube([hole_d, hole_d, plate_t + 2*eps]);
    }

    // Cable notch in one wall (x = 39.0, z = 32 to 40)
    translate([39.0 - notch_w/2, -plate_y/2 - eps, notch_bottom])
        cube([notch_w, plate_y + 2*eps, notch_w]);
}