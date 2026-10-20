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

// Groove cutter parameters
// Inner radius of cutter (groove bottom)
cutter_inner_r = handle_d/2 - groove_depth;
// Outer radius of cutter (extends slightly past handle surface for clean cut)
cutter_outer_r = handle_d/2 + 0.05;
// Center and width of the cutter in the radial direction
cutter_r_center = (cutter_inner_r + cutter_outer_r) / 2;
cutter_r_width = cutter_outer_r - cutter_inner_r;

// Groove cutters
// Each cutter is a torus segment created by rotate_extrude on a square in the XY plane.
// The square is defined with X as the radial direction and Y as the axial direction.
// After rotation, Y becomes Z, and X remains radial.
groove_cutters = [for (z = groove_centers)
    rotate([90, 0, 0])
    rotate_extrude()
    square([cutter_r_width, groove_width], center=[cutter_r_center, z])
];

// Main body module
module pestle_body() {
    union() {
        // Cylindrical handle
        cylinder(r = handle_d/2, h = handle_h);
        
        // Tapered cone
        translate([0, 0, handle_h])
            cylinder(r1 = handle_d/2, r2 = cone_d_top/2, h = cone_h);
        
        // Rounded tip
        translate([0, 0, tip_center_z])
            sphere(r = tip_d/2);
    }
}

// Final part
difference() {
    pestle_body();
    for (c = groove_cutters) c;
}