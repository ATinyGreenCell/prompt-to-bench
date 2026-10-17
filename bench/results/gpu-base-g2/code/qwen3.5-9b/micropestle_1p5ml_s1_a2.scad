$fn = 128;

// --- Dimensions ---
// Handle
d_handle = 8;
h_handle = 45;

// Cone
d_cone_top = 8;   // Diameter at z=45
d_cone_bottom = 3; // Diameter at z=62
z_cone_start = 45;
z_cone_end = 62;

// Tip (Sphere)
d_tip = 3;
z_tip_center = 62;

// Grooves
n_grooves = 4;
w_groove = 2; // Width in Z
d_groove = 1; // Depth (radius of cut cylinder)
z_grooves = [10, 15, 20, 25];

// --- Construction ---

// 1. Main Body (Handle + Cone + Tip)
difference() {
    union() {
        // Handle: Cylinder from z=0 to z=45
        cylinder(
            h = h_handle,
            d = d_handle,
            center = false
        );

        // Cone: Linear extrusion of a trapezoid
        // Top radius at z=45 is 4mm, Bottom radius at z=62 is 1.5mm
        // We extrude from z=45 to z=62
        translate([0, 0, z_cone_start]) {
            linear_extrude(height = z_cone_end - z_cone_start, center = false) {
                polygon(points = [
                    [-d_cone_top/2, 0],
                    [d_cone_top/2, 0],
                    [d_cone_bottom/2, z_cone_end - z_cone_start],
                    [-d_cone_bottom/2, z_cone_end - z_cone_start]
                ]);
            }
        }

        // Tip (Sphere)
        translate([0, 0, z_tip_center]) {
            sphere(d = d_tip);
        }
    }

    // 2. Grooves
    // Cut four circumferential grooves into the handle
    for (i = [0 : n_grooves - 1]) {
        z_pos = z_grooves[i];
        
        // Calculate rotation angle for this groove
        angle = (i / n_grooves) * 360;
        
        // Define the groove shape: A cylinder cut into the handle
        // To ensure clean cutting, diameter is slightly larger than handle
        // Height is exactly the groove width
        // Position is centered at z_pos
        
        translate([0, 0, z_pos - w_groove/2]) {
            rotate([0, 0, angle]) {
                cylinder(
                    h = w_groove,
                    d = d_handle + 0.1, // Slightly larger than handle to ensure full cut
                    center = false
                );
            }
        }
    }
}