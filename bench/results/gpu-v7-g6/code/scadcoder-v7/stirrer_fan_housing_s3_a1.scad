// Magnetic stirrer housing for an 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls rise to z = 40, open top.

// ---------- Parameters ----------
top_thickness      = 2;     // top plate thickness
wall_thickness     = 2.5;   // wall thickness
box_height         = 40;    // total height (top plate + walls)
outer_size         = 90;    // outer X and Y size of box
hole_count         = 4;     // number of screw holes in top plate
hole_size          = 4.5;   // screw hole diameter (M4)
hole_pitch         = 71.5;  // square pattern pitch between hole centres
notch_width        = 12;    // cable notch width
notch_depth        = 8;     // notch depth from open edge (z = 32 to z = 40)
eps                = 0.5;   // cutter overshoot past faces
$fn                = 96;    // curve resolution

// ---------- Derived ----------
inner_size = outer_size - 2 * wall_thickness;   // 85 x 85
floor_z    = top_thickness;                     // z = 2 (floor of walls)
ceiling_z  = box_height;                        // z = 40 (open top)

// ---------- Model ----------
difference() {
    // Solid box: top plate + walls, open at top
    translate([-outer_size/2, -outer_size/2, 0])
        cube([outer_size, outer_size, box_height]);

    // Open top: remove everything above ceiling_z - eps
    translate([-outer_size/2, -outer_size/2, ceiling_z - eps])
        cube([outer_size, outer_size, eps + 0.01]);

    // Screw holes in top plate, centred square pattern
    for (i = [0 : hole_count - 1]) {
        a = i < hole_count / 2 ? hole_pitch : -hole_pitch;
        b = i % 2 == 0 ? hole_pitch : -hole_pitch;
        translate([a - hole_size/2, b - hole_size/2, -eps])
            cylinder(d = hole_size, h = top_thickness + 2*eps);
    }

    // Cable notch in one wall, centred along the wall
    translate([-outer_size/2, -notch_width/2, floor_z])
        cube([outer_size, notch_width, notch_depth + eps]);
}