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
        // The slot is a cylinder running along Z, but we need to cut it out of the handle.
        // Since the handle is a cylinder, we can subtract a cylinder that is slightly wider 
        // than the handle diameter to ensure full penetration, or simply cut a cylinder 
        // that matches the handle diameter and extends slightly beyond z=0 and z=45.
        
        // Groove geometry:
        // Width (Z): w_groove
        // Depth (Radial): d_groove
        // Diameter (XY): d_handle + 2*epsilon (to ensure full cut)
        
        translate([0, 0, z - w_groove/2])
        cylinder(
            h = w_groove + 0.1, // Extend slightly past groove width
            d = d_handle + 0.05, // Extend slightly past handle diameter
            center = false
        )
    }
);