// Magnetic stirrer housing for an 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls rise to z = 40, open top

// ---------- Parameters ----------
top_thickness      = 2;     // top plate thickness
wall_thickness     = 2.5;   // wall thickness
box_height         = 40;    // total height to open edge
outer_size         = 90;    // outer X and Y size of box
screw_hole_d       = 4.5;   // M4 screw hole diameter
screw_hole_pitch   = 71.5;  // square pattern pitch for screw holes
cable_notch_w      = 12;    // cable notch width
cable_notch_depth  = 8;     // notch depth from open edge (z = 32 to 40)
eps                = 0.5;   // cutter overshoot past faces

$fn = 128;

// ---------- Derived ----------
inner_size = outer_size - 2 * wall_thickness;   // 85 x 85
floor_z    = top_thickness;                     // z = 2, floor of open box

// ---------- Model ----------
difference() {
    // Solid block: top plate + walls
    translate([-outer_size/2, -outer_size/2, 0])
        cube([outer_size, outer_size, box_height]);

    // Open top (through the walls)
    translate([-inner_size/2, -inner_size/2, floor_z])
        cube([inner_size, inner_size, box_height - floor_z + eps]);

    // Screw holes in top plate, centred on plate
    for (sx = [-screw_hole_pitch/2, screw_hole_pitch/2],
         sy = [-screw_hole_pitch/2, screw_hole_pitch/2])
        translate([sx, sy, -eps])
            cylinder(d = screw_hole_d, h = top_thickness + 2*eps);

    // Cable notch in one wall, centred along the wall
    translate([-outer_size/2, -outer_size/2, floor_z])
        cube([outer_size, cable_notch_w, cable_notch_depth]);
}