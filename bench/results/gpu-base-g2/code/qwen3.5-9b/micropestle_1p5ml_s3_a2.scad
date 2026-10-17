$fn = 128;

// --- Dimensions ---
// Handle
d_handle = 8;
h_handle = 45;
z_handle_start = 0;
z_handle_end = 45;

// Cone
d_cone_bottom = 8;
d_cone_top = 3;
z_cone_start = 45;
z_cone_end = 62;

// Tip
d_tip = 3;
z_tip_center = 62;

// Grooves
n_grooves = 4;
w_groove = 2; // Width in Z
d_groove = 1; // Depth
z_groove_centers = [10, 15, 20, 25];

// --- Main Body Construction ---
difference() {
    union() {
        // 1. Cylindrical Handle
        // Centered at z = 22.5 (half of 45)
        translate([0, 0, z_handle_start + h_handle/2]) {
            cylinder(h = h_handle, d = d_handle);
        }

        // 2. Conical Section
        // Constructed using rotate_extrude with a polygon profile.
        // Profile: Line from (radius_bottom, 0) to (radius_top, height)
        h_cone = z_cone_end - z_cone_start;
        r_start = d_cone_bottom / 2;
        r_end = d_cone_top / 2;
        
        // The rotate_extrude creates a shape centered at its own origin.
        // We need to translate it so it starts at z_cone_start.
        // The profile is in the XY plane. The extrusion is along Z.
        // Points: [x, y]. x is radius, y is height.
        // Line from (r_start, 0) to (r_end, h_cone).
        
        translate([0, 0, z_cone_start]) {
            rotate_extrude() {
                polygon(points = [[r_start, 0], [r_end, h_cone]]);
            }
        }

        // 3. Tip Sphere
        translate([0, 0, z_tip_center]) {
            sphere(d = d_tip);
        }
    }

    // --- Cut Grooves ---
    // Grooves are cylindrical holes cut into the handle.
    // They are centered at specific Z heights.
    // Width in Z is w_groove.
    // Depth is d_groove.
    // Diameter of groove cutter = Handle Diameter - 2 * Depth
    
    d_cutter = d_handle - 2 * d_groove;
    
    for (z_c = z_groove_centers) {
        translate([0, 0, z_c - w_groove/2]) {
            cylinder(
                h = w_groove,
                d = d_cutter,
                center = [0, 0, 0]
            );
        }
    }
}