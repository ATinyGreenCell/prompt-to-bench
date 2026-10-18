// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls build upward (+Z)

// ---------------- Parameters ----------------
outer_size   = 90;    // outer size of box (X and Y), mm
top_plate_t  = 2;     // top plate thickness, mm (z = 0 to 2)
wall_t       = 2.5;   // wall thickness, mm (z = 2 to 40)
open_top_z   = 40;    // height of open top edge, mm
hole_d       = 4.5;   // screw hole diameter (M4), mm
hole_count   = 4;     // number of screw holes
hole_pitch   = 71.5;  // square pattern pitch for holes, mm
notch_w      = 12;    // power cable notch width, mm
notch_depth  = 8;     // notch depth from open edge, mm (z = 32 to 40)
eps          = 0.5;   // cutter overshoot past faces, mm

$fn = 64;

// ---------------- Model ----------------
difference() {
    union() {
        // Top plate
        translate([-outer_size/2, -outer_size/2, 0])
            cube([outer_size, outer_size, top_plate_t]);

        // Walls (rise from top plate to open top)
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_size/2 - wall_t : -outer_size/2,
                       sy > 0 ? outer_size/2 - wall_t : -outer_size/2,
                       top_plate_t])
                cube([wall_t, wall_t, open_top_z - top_plate_t]);
    }

    // Screw holes through top plate on square pattern
    for (i = [0 : hole_count - 1]) {
        x = (i % 2 - 0.5) * hole_pitch;
        y = (i / 2 - 0.5) * hole_pitch;
        translate([x, y, -eps])
            cylinder(d = hole_d, h = top_plate_t + 2*eps);
    }

    // Power cable notch in one wall (12 mm wide, centred along wall)
    translate([outer_size/2 - wall_t - 6, 0, open_top_z - notch_depth])
        cube([notch_w, wall_t, notch_depth + eps]);
}