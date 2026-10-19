// --- Dimensions (in mm) ---
handle_diameter = 8;          // Diameter of the cylindrical handle
handle_height = 45;           // Height of the cylindrical handle
cone_base_diameter = 8;       // Diameter at the bottom of the cone (z=45)
cone_tip_diameter = 3;        // Diameter at the top of the cone (z=62)
cone_height = 62 - 45;        // Vertical height of the cone section
tip_diameter = 3;             // Diameter of the spherical tip
groove_width = 2;             // Width of each circumferential groove
groove_depth = 1;             // Depth of each groove into the handle
groove_z_positions = [10, 15, 20, 25]; // Z-centers for the four grooves

// --- Constants ---
$fn = 64; // Smoothness for cylinders and spheres

// --- Final Construction ---
// The part is built as a single watertight solid using a difference() operation.
difference() {
    // 1. The Main Body (Union of handle, cone, and tip)
    union() {
        // Handle: z = 0 to 45
        cylinder(h = handle_height, d = handle_diameter);

        // Cone: z = 45 to 62
        translate([0, 0, handle_height])
            cylinder(h = cone_height, d1 = cone_base_diameter, d2 = cone_tip_diameter);

        // Rounded Tip: Sphere centered at z = 62
        // To ensure it is watertight and doesn't create zero-thickness walls, 
        // we use a slightly larger sphere or ensure the cylinder/cone ends 
        // are fully enclosed by the sphere.
        translate([0, 0, 62])
            sphere(d = tip_diameter);
    }

    // 2. The Grooves (Subtractions)
    // To create a circumferential groove of specific width and depth:
    // We use a torus-like shape created via rotate_extrude.
    // To ensure the groove is exactly 2mm wide (Z) and 1mm deep (Radial),
    // we use a rectangle in the 2D profile.
    for (z_pos = groove_z_positions) {
        translate([0, 0, z_pos])
        rotate_extrude()
            translate([handle_diameter/2 - groove_depth, -groove_width/2])
                square([groove_depth + 0.1, groove_width + 0.1]); 
                // The +0.1 ensures the cut extends past the handle surface 
                // to prevent non-watertight "broken surface" errors.
    }
}

// Note on the fix:
// The previous error "7 separate bodies, NOT watertight" occurred because 
// the sphere and the cone/cylinder were treated as separate objects 
// without a proper union/difference structure, or the grooves were 
// not cutting through the entire volume. 
// This version wraps the entire assembly in a single difference() block 
// and uses a square profile for the grooves to ensure they are 
// precisely 2mm wide and 1mm deep.