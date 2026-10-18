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

    // 2. Cut the circumferential grooves
    // We use a loop to generate rectangular prisms that wrap around the handle.
    for (i = [0 : n_grooves - 1]) {
        z_c = z_groove_centers[i];
        
        // Calculate rotation angle for this groove
        angle = (i / (n_grooves - 1)) * 360;

        // Calculate the radius at which the groove is centered
        // The groove is 1mm deep, so it cuts from the surface (radius 4) inwards to radius 3.
        // The center of the cut is at radius 3.5.
        r_groove_center = (d_handle / 2) - (d_groove / 2);

        translate([0, 0, z_c - w_groove/2]) {
            rotate([0, 0, angle]) {
                // Cut shape: A rectangular prism
                // Width (Z) = w_groove
                // Depth (X) = d_groove (radial depth)
                // Length (Y) = Circumference of the handle (approx)
                // We make it slightly longer than the circumference to ensure it wraps fully.
                // Circumference = pi * 8 ≈ 25.13 mm.
                l_groove = (pi * d_handle) + 2.0; 
                
                cube(
                    size = [d_groove, l_groove, w_groove],
                    center = false
                );
            }
        }
    }
}