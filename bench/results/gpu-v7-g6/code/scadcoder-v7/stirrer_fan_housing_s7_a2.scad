// Magnetic stirrer housing for an 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls rise to z = 40, open top

// ---------- Parameters ----------
top_thickness      = 2;     // top plate thickness
wall_thickness     = 2.5;   // wall thickness
box_height         = 40;    // total height of walls from top plate
outer_size         = 90;    // outer X and Y size of box
hole_count         = 4;     // number of screw holes in top plate
hole_size          = 4.5;   // screw hole diameter (M4)
hole_pitch         = 71.5;  // square pattern pitch for holes
cable_notch_w      = 12;    // cable notch width
cable_notch_depth  = 8;     // notch depth from open edge (z = 32 to 40)
eps                = 0.5;   // overcut for clean boolean differences

$fn = 64;

// ---------- Derived ----------
inner_size = outer_size - 2 * wall_thickness;   // 85 x 85
floor_z    = top_thickness;                     // z = 2, floor of open box

// ---------- Model ----------
difference() {
    // Solid block: top plate + walls
    translate([-outer_size/2, -outer_size/2, 0])
        cube([outer_size, outer_size, box_height]);

    // Open top (box empty above floor_z)
    translate([-inner_size/2, -inner_size/2, floor_z])
        cube([inner_size, inner_size, box_height - floor_z + eps]);

    // Screw holes in top plate, centred on plate
    for (i = [0 : hole_count - 1]) {
        a = hole_pitch * (i - (hole_count - 1) / 2);
        translate([a, a, 0])
            cylinder(d = hole_size, h = top_thickness + eps);
    }

    // Cable notch in one wall, centred along the wall, full depth
    translate([-outer_size/2, -outer_size/2, floor_z + wall_thickness - cable_notch_depth])
        cube([outer_size, cable_notch_w, cable_notch_depth + eps]);
}