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
d_groove = 1; // Depth (radial)
z_groove_centers = [10, 15, 20, 25];

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
    // Each groove is a cylinder cut into the handle.
    // To create a groove of 'd_groove' depth into an 8mm handle,
    // the cutting cylinder must have a diameter of (8 - 2*1) = 6mm.
    // This leaves a 1mm thick ring of material around the handle at the groove level.
    d_cut = d_handle - (2 * d_groove); 
    
    for (i = [0 : n_grooves - 1]) {
        z_c = z_groove_centers[i];
        
        // Calculate rotation angle for this groove
        angle = (i / (n_grooves - 1)) * 360;

        translate([0, 0, z_c - w_groove/2]) {
            rotate([0, 0, angle]) {
                // Cut cylinder:
                // Diameter is reduced to leave the groove depth
                // Height extends slightly past the handle to ensure clean cut
                cylinder(
                    h = w_groove + 2.0, 
                    d = d_cut, 
                    center = false
                );
            }
        }
    }
}