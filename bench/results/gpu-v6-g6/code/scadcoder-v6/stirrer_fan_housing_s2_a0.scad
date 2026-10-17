// Magnetic stirrer housing (print orientation: upside down)
// Units: mm

// ---------- Parameters ----------
top_thickness      = 2;     // top plate thickness (z = 0 to 2)
wall_thickness     = 2.5;   // wall thickness
wall_height        = 40;    // total height of walls (z = 0 to 40)
outer_size         = 90;    // outer size in X and Y
hole_diameter      = 4.5;   // M4 screw hole diameter
hole_pattern_size  = 71.5;  // square pitch of screw holes
notch_width        = 12;    // cable notch width
notch_depth        = 8;     // cable notch depth from open edge (z = 32 to 40)
overcut            = 0.5;   // extra length for cutting shapes
$fn                = 96;    // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Top plate
        translate([-outer_size/2, -outer_size/2, 0])
            cube([outer_size, outer_size, top_thickness]);

        // Four walls, open at the top
        for (x = [-outer_size/2, outer_size/2])
            for (y = [-outer_size/2, outer_size/2])
                translate([x, y, 0])
                    cube([wall_thickness, wall_thickness, wall_height]);
    }

    // Screw holes through the top plate
    for (dx = [-hole_pattern_size/2, hole_pattern_size/2])
        for (dy = [-hole_pattern_size/2, hole_pattern_size/2])
            translate([dx, dy, -overcut])
                cylinder(d = hole_diameter, h = top_thickness + 2*overcut);

    // Cable notch in one wall (x = -45, centred along the wall)
    translate([-outer_size/2, -wall_thickness/2, wall_height - notch_depth])
        cube([wall_thickness + overcut, notch_width, notch_depth + overcut]);
}