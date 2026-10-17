// Magnetic stirrer housing for an 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls rise to z = 40, open top

// ---------- Parameters ----------
top_thickness      = 2;     // top plate thickness
wall_thickness     = 2.5;   // wall thickness
box_height         = 40;    // total height of walls (open top at z = 40)
outer_size         = 90;    // outer X and Y size of box
screw_hole_d       = 4.5;   // M4 screw hole diameter
screw_hole_pitch   = 71.5;  // square pattern pitch for screw holes
cable_notch_w      = 12;    // cable notch width
cable_notch_depth  = 8;     // notch depth from open edge (z = 32 to 40)
eps                = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------- Derived ----------
inner_size = outer_size - 2 * wall_thickness;   // 85 x 85 mm open top
first_hole = (outer_size - screw_hole_pitch) / 2; // 9.25 mm offset from centre

// ---------- Model ----------
difference() {
    // Solid box: top plate + walls, open at top
    translate([-outer_size / 2, -outer_size / 2, 0])
        cube([outer_size, outer_size, box_height]);

    // Open top (through the walls)
    translate([-inner_size / 2, -inner_size / 2, top_thickness])
        cube([inner_size, inner_size, box_height - top_thickness + eps]);

    // Screw holes through the top plate
    for (sx = [-first_hole, first_hole], sy = [-first_hole, first_hole])
        translate([sx, sy, -eps])
            cylinder(d = screw_hole_d, h = top_thickness + 2 * eps);

    // Cable notch in one wall, centred along the wall
    translate([-outer_size / 2, 0, top_thickness + wall_thickness - cable_notch_depth])
        cube([cable_notch_w, outer_size, cable_notch_depth + eps]);
}