$fn = 128;

// --- Dimensions ---
// Handle
d_handle = 8;
h_handle = 45;

// Cone
d_cone_top = 8;
d_cone_bottom = 3;
h_cone = 17; // 62 - 45

// Tip (Sphere)
d_tip = 3;
z_tip_center = 62;

// Grooves
n_grooves = 4;
w_groove = 2; // Width in Z
d_groove = 1; // Depth
z_grooves = [10, 15, 20, 25];

// --- Construction ---

// 1. Main Body (Handle + Cone + Tip)
// We build the body as a single union of primitives to ensure watertightness.
// Handle: Cylinder from z=0 to z=45
// Cone: Linear extrusion of a trapezoid from z=45 to z=62
// Tip: Sphere centered at z=62

difference() {
    union() {
        // Handle
        cylinder(
            h = h_handle,
            d = d_handle,
            center = false
        );

        // Cone
        // Create a trapezoid profile and rotate it
        // Top radius at z=45 is 4mm, Bottom radius at z=62 is 1.5mm
        // We extrude from z=45 to z=62
        translate([0, 0, 45]) {
            linear_extrude(height = h_cone, center = false) {
                polygon(points = [
                    [-d_cone_top/2, 0],
                    [d_cone_top/2, 0],
                    [d_cone_bottom/2, h_cone],
                    [-d_cone_bottom/2, h_cone]
                ]);
            }
        }

        // Tip (Sphere)
        translate([0, 0, z_tip_center]) {
            sphere(d = d_tip);
        }
    }

    // 2. Grooves
    // Cut four circumferential grooves
    for (i = [0 : n_grooves - 1]) {
        z_pos = z_grooves[i];
        
        // Calculate rotation angle for this groove
        angle = (i / n_grooves) * 360;
        
        // Define the groove shape: A rectangular prism cut into the cylinder
        // Width in Z is w_groove, Depth is d_groove
        // To ensure clean cutting, we extend slightly past the faces (Rule 5)
        // The groove is centered at z_pos with width w_groove
        // So it spans from z_pos - w_groove/2 to z_pos + w_groove/2
        
        translate([0, 0, z_pos - w_groove/2]) {
            rotate([0, 0, angle]) {
                // The cut is a cylinder with a very large radius (effectively infinite)
                // but we only need to cut the handle diameter.
                // We use a cylinder with d = d_handle + 2*epsilon to ensure full cut
                // Height of the cut is w_groove + 0.1 (slight overcut)
                cylinder(
                    h = w_groove + 0.1,
                    d = d_handle + 0.1,
                    center = false
                );
            }
        }
    }
}