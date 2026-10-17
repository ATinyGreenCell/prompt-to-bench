$fn = 128;

// --- Dimensions ---
// Handle
d_handle = 8;
h_handle = 45;

// Cone
d_cone_bottom = 8;
d_cone_top = 3;
h_cone = 17; // (62 - 45)

// Tip
d_tip = 3;
z_tip_center = 62;

// Grooves
n_grooves = 4;
w_groove = 2; // Width in Z
d_groove = 1; // Depth
z_grooves = [10, 15, 20, 25]; // Center Z positions

// --- Main Body Construction ---
// We build the solid body first, then subtract the grooves.
// The body consists of a cylinder, a cone, and a sphere.

body = union(
    // 1. Cylindrical Handle
    cylinder(h = h_handle, d = d_handle, center = false),
    
    // 2. Cone (tapers from 8mm at z=45 to 3mm at z=62)
    // Cylinder for cone: height 17, bottom radius 4, top radius 1.5
    cylinder(h = h_cone, d1 = d_cone_bottom, d2 = d_cone_top, center = false),
    
    // 3. Rounded Tip (3mm sphere centered at z=62)
    translate([0, 0, z_tip_center - d_tip/2])
    sphere(d = d_tip)
);

// --- Groove Cutting ---
// We use difference to cut the grooves.
// To ensure clean cuts, the cutting shapes extend slightly past the body boundaries.

pestle = difference(
    body,
    
    for (z = z_grooves) {
        // Create a groove slot
        // The slot is a cylinder with a rectangular cross-section (width x depth)
        // We extend it slightly in Z to ensure it cuts through the entire handle wall thickness
        // and slightly in X/Y to ensure it cuts through the full diameter.
        
        translate([0, 0, z - w_groove/2])
        cylinder(
            h = w_groove + 0.1, // Extend 0.1mm past the groove width
            d1 = d_groove + 0.1, // Extend 0.1mm past the groove depth
            d2 = d_groove + 0.1,
            center = false
        )
    }
);