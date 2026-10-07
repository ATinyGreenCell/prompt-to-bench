// Pestle for grinding tissue in a microcentrifuge tube

// --- Dimensions ---
handle_diameter = 8;    // Diameter of the cylindrical handle (mm)
handle_height = 45;     // Height of the cylindrical handle (mm)
cone_start_z = 45;      // Z coordinate where the cone starts (mm)
cone_end_z = 62;        // Z coordinate where the cone ends (mm)
cone_start_diameter = 8; // Diameter at the base of the cone (mm)
cone_end_diameter = 3;   // Diameter at the tip of the cone (mm)
tip_sphere_diameter = 3;  // Diameter of the rounded tip sphere (mm)
groove_width = 2;       // Width of each circumferential groove (mm) - This is the width *along* the circumference in the cut profile.
groove_depth = 1;       // Depth of each circumferential groove (mm)
num_grooves = 4;        // Number of grip grooves

// --- Constants ---
$fn = 64; // High resolution for curves

// --- Module Definitions ---

// Cylinder handle base shape
module cylinder_handle() {
    cylinder(h = handle_height, r = handle_diameter / 2);
}

// Cone shape (tapering from cone_start_diameter to cone_end_diameter)
module tapered_cone() {
    // Hull of two circles separated by the height difference.
    hull() {
        // Base circle at start_z
        cylinder(h = 0.1, r = cone_start_diameter / 2);
        // Tip circle at end_z
        translate([0, 0, (cone_end_z - cone_start_z)]) cylinder(h = 0.1, r = cone_end_diameter / 2);
    }
}

// Rounded tip sphere
module rounded_tip() {
    // Sphere centered at Z=62
    translate([0, 0, cone_end_z]) {
        sphere(r = tip_sphere_diameter / 2);
    }
}

// --- Main Assembly ---

difference() {
    // 1. Base Body: Handle + Cone + Tip
    union() {
        // Cylindrical Handle (Z=0 to Z=45)
        translate([0, 0, 0]) cylinder_handle();

        // Tapered Cone (Z=45 to Z=62)
        translate([0, 0, cone_start_z]) tapered_cone();

        // Rounded Tip (Centered at Z=62)
        rounded_tip();
    }

    // 2. Cutouts: Four circumferential grooves in the handle region
    for (i = [1 : num_grooves]) {
        // Target Z levels for grooves: 10, 15, 20, 25
        z_level = i * 5;

        // The groove is cut by subtracting a ring shape.
        // We need the cutter to extend slightly past the handle boundaries (Z=0 to Z=45) and diameter (8mm).
        cutter_height = groove_depth + 1.0; // Extend slightly past depth (1mm -> 2.0mm total cut height)
        
        // Groove Width (2mm) means the difference between the radii should be 2mm.
        R_outer = handle_diameter / 2 + 0.5; // Outer radius of the cut (to ensure it cuts through slightly past edge)
        R_inner = R_outer - groove_width;      // Inner radius defines the center path of the groove

        translate([0, 0, z_level - cutter_height/2]) {
            difference() {
                // Outer cutter (defines the outer boundary of the cut)
                cylinder(h = cutter_height, r = R_outer);

                // Inner cutter (defines the inner boundary of the groove path)
                translate([0, 0, -1]) // Ensure it cuts through completely
                cylinder(h = cutter_height + 2, r = R_inner);
            }
        }
    }
}