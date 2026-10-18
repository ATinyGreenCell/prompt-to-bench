// Pestle for 1.5 mL Microcentrifuge Tube
// Print Orientation: Standing upright on XY plane (Z=0)

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate hole sizes

// Handle
d_handle = 8;      // Handle diameter (mm)
h_handle = 45;     // Handle height (mm)
z_handle_start = 0;
z_handle_end = 45;

// Cone
d_cone_bottom = 8; // Cone bottom diameter (matches handle)
d_cone_top = 3;    // Cone top diameter (matches sphere)
z_cone_start = 45;
z_cone_end = 62;

// Tip (Sphere)
d_tip = 3;         // Tip diameter (mm)
z_tip_center = 62; // Center Z of the sphere

// Grooves
n_grooves = 4;     // Number of circumferential grooves
d_groove_width = 2; // Groove width in Z (mm)
d_groove_depth = 1; // Groove depth (mm)
z_groove_centers = [10, 15, 20, 25]; // Z positions of groove centers

// --- Main Body Construction ---
difference() {
    // 1. Create the main solid body
    union() {
        // Handle Cylinder
        cylinder(
            h = h_handle,
            d = d_handle,
            center = false
        );

        // Cone (tapering from 8mm to 3mm)
        // Using linear_extrude with a polygon profile for the cone
        linear_extrude(height = z_cone_end - z_cone_start, center = false) {
            polygon(
                points = [
                    [0, d_cone_bottom / 2],
                    [z_cone_end - z_cone_start, d_cone_top / 2],
                    [z_cone_end - z_cone_start, -d_cone_top / 2],
                    [0, -d_cone_bottom / 2]
                ]
            );
        }

        // Tip Sphere
        translate([0, 0, z_tip_center - d_tip/2]) {
            sphere(d = d_tip);
        }
    }

    // 2. Cut the grooves
    // We use a for loop to generate the 4 grooves
    for (i = [0 : n_grooves - 1]) {
        z_center = z_groove_centers[i];
        
        // Calculate the Z range for the groove based on center and width
        z_start = z_center - d_groove_width / 2;
        z_end = z_center + d_groove_width / 2;

        // Create the cutting shape: A cylinder with a cylindrical hole through it
        // This effectively creates a groove on the surface of the main body
        translate([0, 0, z_start]) {
            // The cutting cylinder must extend slightly past the body faces to ensure clean cuts
            // Height of cutter = groove width + safety margin
            h_cutter = d_groove_width + 0.1; 
            
            // The cutter is a cylinder with a hole in the middle
            difference() {
                // Outer cylinder of the cutter (the material being removed)
                cylinder(
                    h = h_cutter,
                    d = d_handle, // Must be wider than the handle to cut the full depth
                    center = false
                );
                
                // Inner cylinder (the hole left behind, which becomes the groove)
                cylinder(
                    h = h_cutter,
                    d = d_handle - d_groove_depth,
                    center = false
                );
            }
            
            // Rotate the cutter to place it around the circumference
            // We need to rotate the entire cutter block around the Z axis
            // Since we are inside a difference() block, we can just rotate the cutter geometry
            // However, the standard way to make circumferential grooves is to rotate a single groove shape.
            // Let's restructure the loop to rotate a single groove shape.
        }
    }
}

// --- Refactored Groove Logic for Correct Rotation ---
// Re-doing the difference block to properly rotate the grooves

difference() {
    // Main Body
    union() {
        cylinder(h = h_handle, d = d_handle, center = false);
        
        linear_extrude(height = z_cone_end - z_cone_start, center = false) {
            polygon(points = [
                [0, d_cone_bottom / 2],
                [z_cone_end - z_cone_start, d_cone_top / 2],
                [z_cone_end - z_cone_start, -d_cone_top / 2],
                [0, -d_cone_bottom / 2]
            ]);
        }
        
        translate([0, 0, z_tip_center - d_tip/2]) {
            sphere(d = d_tip);
        }
    }
    
    // Grooves
    for (i = [0 : n_grooves - 1]) {
        z_center = z_groove_centers[i];
        z_start = z_center - d_groove_width / 2;
        z_end = z_center + d_groove_width / 2;
        h_cutter = d_groove_width + 0.1; // Slightly larger than groove width
        
        // Create a single groove shape
        difference() {
            // The material to remove (cylinder matching handle diameter)
            cylinder(h = h_cutter, d = d_handle, center = false);
            
            // The hole (groove)
            cylinder(h = h_cutter, d = d_handle - d_groove_depth, center = false);
        }
        
        // Position and Rotate
        translate([0, 0, z_start]) {
            rotate([0, 0, 90 * i]) { // Rotate 90 degrees for each of the 4 grooves
                // Apply the cutter shape
                // Note: The difference() above creates a ring. We need to translate it to the correct Z.
                // Since we are inside the loop, we translate the result of the difference.
                // Actually, let's simplify: Translate the cutter to Z_start, then rotate.
                
                // Re-evaluating the structure:
                // We need to translate the cutter to z_start, then rotate around Z.
                // The previous difference() block created a ring at Z=0.
                // We need to move it to z_start before rotating.
                
                // Let's rebuild the cutter logic inside the rotation block for clarity
                difference() {
                    cylinder(h = h_cutter, d = d_handle, center = false);
                    cylinder(h = h_cutter, d = d_handle - d_groove_depth, center = false);
                }
            }
        }
    }
}