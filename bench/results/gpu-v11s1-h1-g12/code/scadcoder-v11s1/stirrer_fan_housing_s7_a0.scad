// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls build upward (+Z)

$fn = 64;

// ---- Dimensions (mm) ----
plate_thickness   = 2;     // top plate thickness (z = 0 to 2)
wall_thickness    = 2.5;   // side walls thickness (z = 2 to 40)
box_height        = 40;    // outer top of walls (z = 40)
outer_size        = 90;    // outer X and Y size of box
hole_size         = 4.5;   // M4 screw holes diameter
hole_pattern      = 71.5;  // square pitch of screw holes
notch_width       = 12;    // cable notch width in wall
notch_depth       = 8;     // cable notch depth from open edge
eps               = 0.5;   // cutter overshoot past faces

// ---- Derived ----
total_height = plate_thickness + wall_thickness; // 42 mm

// ---- Model ----
difference() {
    union() {
        // Top plate
        translate([-outer_size/2, -outer_size/2, 0])
            cube([outer_size, outer_size, plate_thickness]);

        // Four side walls, rising from top plate to open top
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? -outer_size/2 : outer_size/2 - wall_thickness,
                       sy > 0 ? -outer_size/2 : outer_size/2 - wall_thickness,
                       plate_thickness])
                cube([wall_thickness, wall_thickness, box_height - plate_thickness]);
    }

    // Screw holes through top plate on 71.5 mm square pattern
    for (i = [0 : 3]) {
        x = (i % 2 - 0.5) * hole_pattern;
        y = (i / 2 - 0.25) * hole_pattern;
        translate([x, y, -eps])
            cylinder(d = hole_size, h = plate_thickness + 2*eps);
    }

    // Cable notch in one wall, 12 mm wide, reaching 8 mm down from open edge
    translate([-outer_size/2 + wall_thickness - notch_width/2,
               -outer_size/2 + wall_thickness - notch_width/2,
               total_height - notch_depth])
        cube([notch_width, notch_width, notch_depth + eps]);
}