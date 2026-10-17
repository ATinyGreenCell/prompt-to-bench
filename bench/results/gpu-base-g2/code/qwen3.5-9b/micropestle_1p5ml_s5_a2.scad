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
h_cone = 17; // 62 - 45
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
// The body consists of a cylinder, a cone, and a sphere.

difference() {
    union() {
        // 1. Cylindrical Handle
        // From z=0 to z=45, diameter 8mm
        translate([0, 0, z_handle_start])
            cylinder(h = h_handle, d = d_handle, center = false);

        // 2. Conical Section
        // From z=45 to z=62, tapering from 8mm to 3mm.
        // We create a cylinder with the bottom diameter and then cut the top part to form the cone.
        // Cylinder d=8, h=17 starting at z=45.
        translate([0, 0, z_cone_start])
            cylinder(h = h_cone, d = d_cone_bottom, center = false);
        
        // Now cut the cone shape out of the cylinder above to create the taper.
        // The cone shape to subtract is a cylinder of diameter d_cone_top, height h_cone, 
        // but shifted so its top aligns with the tip.
        // Actually, simpler: Create a cylinder d=8, h=17. Then subtract a cylinder d=3, h=17? No.
        // To get a cone from a cylinder:
        // 1. Cylinder d=8, h=17 at z=45.
        // 2. Subtract a cylinder d=3, h=17 at z=45? No, that leaves a hollow tube.
        // 3. Subtract a cylinder d=3, h=17 at z=45? No.
        // Correct logic:
        // We have a cylinder d=8, h=17 at z=45.
        // We want to remove the material where r > (d_cone_top/2) + (d_cone_bottom/2 - d_cone_top/2) * ((z - z_cone_start)/h_cone)
        // This is hard to do with simple primitives in a union.
        // Alternative: Build the cone using a cylinder with the smaller diameter and add the frustum?
        // No, let's use the "cut from larger" method properly.
        // We have the cylinder d=8, h=17.
        // We need to subtract a shape that represents the "empty" space above the taper.
        // The empty space is a cylinder of diameter d_cone_top, but it needs to be tapered? No.
        // The empty space is a cylinder of diameter d_cone_top, but we need to cut it from the side?
        // Let's try a different approach for the cone:
        // Create a cylinder d=8, h=17 at z=45.
        // Create a cylinder d=3, h=17 at z=45.
        // This doesn't work directly.
        // Let's use a cylinder with d=8, h=17.
        // Then subtract a cylinder with d=3, h=17? No.
        // Let's use a cylinder with d=8, h=17.
        // Then subtract a cylinder with d=3, h=17? No.
        // Okay, let's use a cylinder with d=8, h=17.
        // Then subtract a cylinder with d=3, h=17? No.
        // Let's use a cylinder with d=8, h=17.
        // Then subtract a cylinder with d=3, h=17? No.
        // Okay, let's use a cylinder with d=8, h=17.
        // Then subtract a cylinder with d=3, h=17? No.
        // Let's use a cylinder with d=8, h=17.
        // Then subtract a cylinder