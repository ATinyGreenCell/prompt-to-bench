$fn = 128;

// --- Dimensions ---
// Handle
d_handle = 8;
h_handle = 45;

// Cone
d_cone_top = 8;
d_cone_bottom = 3;
h_cone = 17; // 62 - 45

// Tip
d_tip = 3;
z_tip_center = 62;

// Grooves
n_grooves = 4;
w_groove = 2; // Width in Z
d_groove = 1; // Depth
z_groove_centers = [10, 15, 20, 25];

// --- Main Body Construction ---
// We build the solid first, then subtract the grooves.
// The part stands on the XY plane at z=0.

difference() {
    // 1. Create the main solid body
    union() {
        // Handle Cylinder
        cylinder(
            h = h_handle,
            d = d_handle,
            center = false
        );

        // Cone
        // Tapers from d_cone_top at z=45 to d_cone_bottom at z=62
        translate([0, 0, 45]) {
            linear_extrude(h = h_cone, center = false) {
                circle(d = d_cone_top);
                circle(d = d_cone_bottom);
            }
        }

        // Rounded Tip (Sphere)
        // Centered at z = 62, diameter 3mm
        translate([0, 0, z_tip_center - d_tip/2]) {
            sphere(d = d_tip);
        }
    }

    // 2. Cut the grooves
    // We use a loop to generate the cutting shapes.
    // Each groove is a cylinder cut through the handle.
    // We extend the cut slightly past the handle boundaries to ensure clean cuts.
    for (i = [0 : n_grooves - 1]) {
        z_c = z_groove_centers[i];
        
        // Calculate rotation angle for this groove
        angle = (i / (n_grooves - 1)) * 360;

        translate([0, 0, z_c - w_groove/2]) {
            rotate([0, 0, angle]) {
                // Cut cylinder:
                // Diameter matches handle (8mm) + small overhang for safety
                // Height covers the groove width + overhang
                cylinder(
                    h = w_groove + 0.5, 
                    d = d_handle + 0.2, 
                    center = false
                );
            }
        }
    }
}