// Pestle for 1.5 mL microcentrifuge tube
// Designed for FDM 3D printing, standing upright on the XY plane.

// --- Dimensions (in mm) ---
handle_dia = 8;           // Diameter of the cylindrical handle
handle_height = 45;       // Height of the cylindrical handle (z = 0 to 45)
cone_start_dia = 8;       // Diameter at the base of the cone (z = 45)
cone_end_dia = 3;         // Diameter at the top of the cone (z = 62)
cone_start_z = 45;        // Z-coordinate where the handle ends and cone begins
cone_end_z = 62;          // Z-coordinate where the cone ends
tip_dia = 3;              // Diameter of the spherical tip
tip_z = 62;               // Z-coordinate of the center of the spherical tip
groove_width = 2;         // Width of the grooves along the Z-axis
groove_depth = 1;         // Radial depth of the grooves
groove_centers = [10, 15, 20, 25]; // Z-coordinates for the centers of the four grooves
fn_val = 64;              // Resolution for curved surfaces

// --- Model Construction ---

difference() {
    // Main Body: Handle, Cone, and Tip
    union() {
        // 1. Cylindrical Handle
        cylinder(d = handle_dia, h = handle_height, $fn = fn_val);
        
        // 2. Tapered Cone
        translate([0, 0, cone_start_z]) {
            cylinder(d1 = cone_start_dia, d2 = cone_end_dia, h = cone_end_z - cone_start_z, $fn = fn_val);
        }
        
        // 3. Rounded Tip
        translate([0, 0, tip_z]) {
            sphere(d = tip_dia, $fn = fn_val);
        }
    }

    // 4. Grip Grooves
    // We use rotate_extrude to create circumferential cuts.
    // The 2D square is defined in the R-Z plane: X is radius, Y is Z.
    for (z_pos = groove_centers) {
        translate([0, 0, z_pos]) {
            rotate_extrude($fn = fn_val) {
                translate([handle_dia/2 - groove_depth, 0, -groove_width/2]) {
                    // The square is slightly oversized to ensure a clean cut through the surface
                    square([groove_depth + 0.1, groove_width + 0.1]);
                }
            }
        }
    }
}