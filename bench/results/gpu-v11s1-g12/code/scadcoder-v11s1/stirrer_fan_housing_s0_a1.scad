// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls build upward (+Z)

$fn = 64;

// ---- Dimensions (mm) ----
plate_thickness   = 2;     // top plate thickness (z = 0 to 2)
wall_thickness    = 2.5;   // side walls thickness
box_height        = 40;    // outer height of box (top at z = 40)
outer_size        = 90;    // outer X and Y size of box
hole_size         = 4.5;   // screw holes diameter (M4)
hole_pattern      = 71.5;  // square pitch of screw holes
notch_width       = 12;    // power cable notch width
notch_depth       = 8;     // notch depth from open edge (z = 32 to 40)
eps               = 0.5;   // cutter overshoot past faces

// ---- Model ----
difference() {
    union() {
        // Top plate
        translate([-outer_size/2, -outer_size/2, 0])
            cube([outer_size, outer_size, plate_thickness]);

        // Four side walls, rising from top plate to z = box_height
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_size/2 - wall_thickness : -outer_size/2,
                       sy > 0 ? outer_size/2 - wall_thickness : -outer_size/2,
                       plate_thickness])
                cube([wall_thickness, wall_thickness, box_height - plate_thickness]);
    }

    // Screw holes through top plate on centred square pattern
    for (x = [-hole_pattern/2, hole_pattern/2])
        for (y = [-hole_pattern/2, hole_pattern/2])
            translate([x, y, -eps])
                cylinder(d = hole_size, h = plate_thickness + 2*eps);

    // Power cable notch in one wall, centred along the wall
    translate([outer_size/2 - wall_thickness - eps, -notch_width/2, plate_thickness])
        cube([wall_thickness + 2*eps, notch_width, notch_depth + eps]);
}