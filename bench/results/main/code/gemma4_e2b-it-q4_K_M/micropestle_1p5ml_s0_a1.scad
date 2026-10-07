// Dimensions for the Pestle design

// Handle dimensions
handle_diameter = 8;      // Diameter of the cylindrical handle (mm)
handle_height = 45;       // Height of the cylindrical handle (mm)
handle_start_z = 0;       // Starting Z position of the handle

// Cone dimensions
cone_base_diameter = handle_diameter; // Diameter at z=45 (8 mm)
cone_top_diameter = 3;              // Diameter at z=62 (3 mm)
cone_height = 62 - 45;              // Height of the conical section (17 mm)
cone_start_z = 45;                  // Starting Z position of the cone

// Tip dimensions
tip_diameter = 3;           // Diameter of the rounded tip (mm)
tip_z = 62;                  // Z position of the sphere center

// Groove dimensions
groove_width = 2;            // Width of the circumferential grooves (mm)
groove_depth = 1;            // Depth of the circumferential grooves (mm)
groove_z_positions = [10, 15, 20, 25]; // Z positions for the grooves

// --- Handle Construction ---

// 1. Cylindrical Handle
cylinder_handle = cylinder(r = handle_diameter / 2, h = handle_height, center = false);

// 2. Circumferential Grooves on the Handle
for (z = groove_z_positions) {
    // Create a cutter shape for the groove at the specified Z level
    // The cutter needs to be slightly larger than the handle radius to ensure cutting happens around it.
    cutter_radius = handle_diameter / 2 + 0.1;

    // We model the subtraction by creating a cylinder that is rotated around the Z-axis and extruded along the depth.
    translate([0, 0, z - handle_start_z]) {
        rotate([90, 0, 0]) { // Rotate to align the cutter's axis with the circumference plane (X-Y plane)
            // The cylinder defining the groove cut: radius is half the groove width, height is the depth.
            cylinder(r = groove_width / 2, h = groove_depth + 0.01, center = false);
        }
    }
}

// --- Cone Construction ---

// 3. Cone (using rotate_extrude for a smooth cone shape)
// Define the profile: A trapezoid in the R-Z plane.
cone_profile = polygon(points = [
    [cone_base_diameter / 2, 0],      // Base radius at Z=0 relative to the cone section start
    [cone_top_diameter / 2, cone_height] // Top radius at Z=cone_height
]);

// Rotate the profile around the center axis (Z-axis) to create the cone shape.
cone_body = rotate_extrude(angle = 360)
    polygon(points = [
        [cone_base_diameter / 2, 0],
        [cone_top_diameter / 2, cone_height]
    ]);

// Translate the cone so its base starts at Z=45 (relative to global origin)
translate([0, 0, cone_start_z]) {
    cone_body;
}


// --- Rounded Tip Construction ---

// 4. Rounded Tip (Sphere)
sphere_tip = sphere(r = tip_diameter / 2, center = true);

// Translate the sphere to its correct Z position
translate([0, 0, tip_z]) {
    sphere_tip;
}

// Combine all parts
union() {
    cylinder_handle;
    cone_body;
    sphere_tip;
}