// Pestle for grinding tissue in a microcentrifuge tube

// --- Dimensions ---
handle_diameter = 8;    // Diameter of the cylindrical handle (mm)
handle_height = 45;     // Height of the cylindrical handle (mm)
cone_start_z = 45;      // Z coordinate where the cone starts (mm)
cone_end_z = 62;        // Z coordinate where the cone ends (mm)
cone_start_diameter = 8; // Diameter at the base of the cone (mm)
cone_end_diameter = 3;   // Diameter at the tip of the cone (mm)
tip_sphere_diameter = 3;  // Diameter of the rounded tip sphere (mm)
groove_width = 2;       // Width of each circumferential groove (mm)
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
    // Use hull or linear_extrude on a profile for precise tapering.
    // Since we need it centered and defined by Z coordinates, we use hull of two cylinders/circles.
    translate([0, 0, cone_start_z]) {
        hull() {
            cylinder(h = 0.1, r = cone_start_diameter / 2); // Base circle at start_z
            translate([0, 0, (cone_end_z - cone_start_z)]) cylinder(h = 0.1, r = cone_end_diameter / 2); // Tip circle at end_z
        }
    }
}

// Rounded tip sphere
module rounded_tip() {
    translate([0, 0, cone_end_z]) {
        sphere(r = tip_sphere_diameter / 2);
    }
}

// Circumferential groove cutter (a rectangular slice rotated around Z)
module groove_cutter(z_level) {
    // The cut is a rectangle of width 'groove_width' and depth 'groove_depth',
    // extruded vertically, but we need to define the shape in XY plane at specific Z levels.

    // We model this as a thin cylinder/block that cuts through the handle material.
    // Since it's circumferential, we use a torus-like cut or a simple extrusion of a rectangle rotated around Z.

    // A simpler approach for cutting grooves: extrude a rectangular profile and rotate it 360 degrees.
    // The profile is defined in the XY plane at the desired depth/width.
    
    // We define the shape to be cut as a thin block that wraps around the handle.
    // This block has a height of groove_depth, and its cross-section is 'groove_width' wide along the circumference.

    // Create a rectangular profile (cross-section) in the XY plane: width = groove_width, thickness = 0.1 (to ensure it cuts through).
    difference() {
        // The material to be cut away (a thin ring/block)
        rotate_extrude(angle = 360)
        translate([handle_diameter / 2 - groove_width / 2, 0]) // Position the profile relative to center
        square([groove_width, 0.1]);

        // We need this cutter to only affect the handle region (Z=0 to Z=45) and be centered at z_level.
        // Since we are using difference() on the main body, we just define the shape that removes material.
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
        // Calculate target Z levels for grooves: 10, 15, 20, 25
        z_level = i * 5;

        // The cutter must be large enough to cut through the handle diameter (8mm) and extend slightly past.
        cutter_radius = (handle_diameter / 2) + 0.5; // Slightly larger than half diameter
        cutter_height = groove_depth + 1.0;          // Extend slightly past depth

        // Create a thick, tall cylinder that wraps around the handle at the specified Z level.
        // We use difference() on this cutter to ensure it only cuts where needed (i.e., within the handle).
        translate([0, 0, z_level - groove_depth/2]) {
            cylinder(h = cutter_height, r = cutter_radius);
        }

        // To make it circumferential and narrow (groove_width), we use a subtraction approach:
        // Subtract a cylinder of radius R_outer from a cylinder of radius R_inner.
        // This creates the groove shape when subtracted from the main body.

        translate([0, 0, z_level - groove_depth/2]) {
            difference() {
                // Outer cutter (defines the width of the cut)
                cylinder(h = cutter_height, r = handle_diameter / 2 + groove_width/2);

                // Inner cutter (defines the center path of the groove)
                translate([0, 0, -1]) // Ensure it cuts through completely
                cylinder(h = cutter_height + 2, r = handle_diameter / 2 - groove_width/2);
            }
        }
    }
}