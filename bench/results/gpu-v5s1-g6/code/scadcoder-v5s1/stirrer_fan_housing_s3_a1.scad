// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

$fn = 64;

// --- Dimensions (mm) ---
top_thickness      = 2;     // top plate thickness
wall_thickness     = 2.5;   // wall thickness
box_height         = 40;    // total height of box (open top)
outer_size         = 90;    // outer size in X and Y
screw_hole_d       = 4.5;   // M4 screw hole diameter
screw_pattern      = 71.5;  // square pitch of screw holes
notch_width        = 12;    // power cable notch width
notch_depth        = 8;     // notch depth from open edge
eps                = 0.5;   // cutter overshoot past faces

// Derived
inner_size = outer_size - 2 * wall_thickness;  // 85 mm

difference() {
    // Solid block
    translate([-outer_size/2, -outer_size/2, 0])
        cube([outer_size, outer_size, box_height]);

    // Screw holes through top plate
    for (x = [-screw_pattern/2, screw_pattern/2])
        for (y = [-screw_pattern/2, screw_pattern/2])
            translate([x, y, top_thickness])
                cylinder(d = screw_hole_d, h = box_height + eps);

    // Notch in one wall (along X, centred)
    translate([-outer_size/2, -notch_width/2, box_height - notch_depth])
        cube([outer_size, notch_width, notch_depth + eps]);
}