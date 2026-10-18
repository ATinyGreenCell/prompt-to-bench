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
h_cone = z_cone_end - z_cone_start; // 17

// Tip
d_tip = 3;
z_tip_center = 62;
r_tip = d_tip / 2;

// Grooves
n_grooves = 4;
w_groove = 2; // Width in Z (total width)
d_groove = 1; // Depth
z_groove_centers = [10, 15, 20, 25];

// --- Main Body Construction ---
difference() {
    union() {
        // 1. Cylindrical Handle
        // Centered at z = 22.5 to span 0 to 45
        cylinder(
            h = h_handle,
            d = d_handle,
            center = [0, 0, z_handle_start + h_handle/2]
        );

        // 2. Conical Section
        // Tapers from 8mm at z=45 to 3mm at z=62.
        // Center of cone is at z = 45 + 17/2 = 53.5
        // Using linear_extrude with a polygon profile
        // Profile points: (radius_bottom, 0) to (radius_top, height)
        // Note: linear_extrude center defaults to 0. We must specify center.
        profile_cone = [
            d_cone_bottom/2, 0,
            d_cone_top/2, h_cone
        ];
        linear_extrude(