// Dimensions
handle_d = 8;          // Handle diameter (mm)
handle_h = 45;         // Handle height, z=0 to z=45 (mm)
cone_d_bottom = 8;     // Cone bottom diameter at z=45 (mm)
cone_d_top = 3;        // Cone top diameter at z=62 (mm)
cone_h = 17;           // Cone height, z=45 to z=62 (mm)
tip_d = 3;             // Tip sphere diameter (mm)
tip_center_z = 62;     // Tip sphere center Z position (mm)
groove_width = 2;      // Groove width in Z (mm)
groove_depth = 1;      // Groove depth into handle (mm)
groove_centers = [10, 15, 20, 25]; // Groove center Z positions (mm)

$fn = 64;

// Main body
pestle_body = union() {
    // Cylindrical handle
    cylinder(r = handle_d/2, h = handle_h, center = false);
    // Tapered cone
    translate([0, 0, 45]) cylinder(r1 = cone_d_bottom/2, r2 = cone_d_top/2, h = cone_h, center = false);
    // Rounded tip
    translate([0, 0, tip_center_z]) sphere(r = tip_d/2, center = true);
};

// Groove cutters (extend slightly past groove faces to avoid coplanar surfaces)
groove_cutters = [for (z = groove_centers) 
    translate([0, 0, z]) cylinder(r = handle_d/2, h = groove_width + 0.1, center = true)];

// Final part
difference() {
    pestle_body;
    for (c = groove_cutters) c;
}