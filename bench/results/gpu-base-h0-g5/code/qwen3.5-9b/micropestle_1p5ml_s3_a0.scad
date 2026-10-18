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
// We build the solid body first, then subtract the grooves.
// The body consists of the cylinder, the cone, and the sphere.

difference() {
    union() {
        // 1. Cylindrical Handle
        cylinder(
            h = h_handle,
            d = d_handle,
            center = [0, 0, z_handle_start + h_handle/2]
        );

        // 2. Conical Section
        // Using a cylinder with a slight taper approximation or linear_extrude with polygon
        // For exact linear taper:
        h_cone = z_cone_end - z_cone_start;
        // Create a polygon profile for the cone side view
        // Points: (d_cone_bottom/2, 0), (d_cone_top/2, h_cone)
        // We extrude this profile along Z
        profile_cone = [
            d_cone_bottom/2, 0,
            d_cone_top/2, h_cone
        ];
        linear_extrude(
            h = h_cone,
            center = [0, 0, z_cone_start + h_cone/2]
        ) {
            polygon(points = profile_cone);
        }

        // 3. Rounded Tip (Sphere)
        sphere(
            r = d_tip/2,
            center = [0, 0, z_tip_center]
        );
    }

    // --- Cut Grooves ---
    // We cut 4 grooves into the handle section.
    // Each groove is a rectangular prism cut through the cylinder.
    for (i = [0 : n_grooves - 1]) {
        z_c = z_groove_centers[i];
        
        // Calculate the Z range for the groove
        z_start = z_c - w_groove/2;
        z_end = z_c + w_groove/2;

        // Ensure the cut stays within the handle bounds to avoid artifacts
        // (Though the difference operation handles intersection naturally, 
        // keeping it clean is good practice)
        z_start = max(z_start, z_handle_start);
        z_end = min(z_end, z_handle_end);

        // The groove is a hole through the cylinder.
        // We define a cylinder that is slightly larger than the handle diameter
        // to ensure a clean cut even if tolerances vary slightly, 
        // but strictly speaking, we just need to cut the material.
        // To ensure the cut goes all the way through without leaving a thin wall 
        // due to floating point issues, we extend the cutter slightly in X/Y.
        d_cutter = d_handle + 0.1; 
        
        translate([0, 0, z_start]) {
            cylinder(
                h = z_end - z_start,
                d = d_cutter,
                center = [0, 0, z_c]
            );
        }
    }
}