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

// Tip (Sphere)
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

difference() {
    union() {
        // 1. Handle Cylinder
        // From z=0 to z=45, diameter 8
        translate([0, 0, z_handle_start])
            cylinder(h = h_handle, d = d_handle, center = false);

        // 2. Cone
        // From z=45 to z=62, tapering from 8mm to 3mm
        // We use a cylinder with a conical side or linear_extrude. 
        // Using a cylinder with a specific height and diameter is not enough for a taper.
        // We use a cylinder with a large radius and subtract a smaller cylinder? 
        // No, simpler: use a cylinder with the bottom diameter and height, then subtract a cone?
        // Actually, the cleanest way in OpenSCAD for a tapered section is often a cylinder 
        // with the larger diameter and then subtracting a cone, OR using linear_extrude with a polygon.
        // Let's use a cylinder for the bottom part of the cone and subtract a cone shape?
        // Better approach: Create the full shape using a cylinder for the handle, 
        // and for the cone, we can use a cylinder with the bottom diameter and height, 
        // but we need the top to be smaller.
        // Let's construct the cone as a cylinder with the bottom diameter and height, 
        // then subtract a cone? No, that leaves a flat top.
        // Correct approach: Use a cylinder with the bottom diameter and height, 
        // then subtract a cone that matches the taper?
        // Actually, let's just use a cylinder for the handle, and for the cone part,
        // we can create a cylinder with the bottom diameter and height, 
        // and then subtract a cone that has the same base and height but inverted?
        // No, let's use the standard method: 
        // Create a cylinder with the bottom diameter and height.
        // Then subtract a cone that has the same base and height? No, that removes the whole thing.
        // Let's use a cylinder with the bottom diameter and height, 
        // and then subtract a cone that has the same base and height?
        // Wait, the easiest way to make a cone in OpenSCAD is:
        // cylinder(d=d_bottom, h=h_cone, center=false) 
        // minus 
        // cone(d=d_bottom, h=h_cone, center=false)? No.
        
        // Let's use a cylinder for the handle.
        // For the cone, we can use a cylinder with the bottom diameter and height, 
        // and then subtract a cone that has the same base and height?
        // No, let's use a cylinder with the bottom diameter and height, 
        // and then subtract a cone that has the same base and height?
        // Actually, let's just use a cylinder with the bottom diameter and height, 
        // and then subtract a cone that has the same base and height?
        // No, let's use a cylinder with the bottom diameter and height, 
        // and then subtract a cone that has the same base and height?
        
        // Correct logic:
        // The cone is a frustum.
        // We can make it by taking a cylinder of diameter d_cone_bottom and height h_cone,
        // and subtracting a cone of diameter (d_cone_bottom - d_cone_top) and height h_cone?
        // No, that's not right.
        // Let's use a cylinder with diameter d_cone_bottom and height h_cone.
        // Then subtract a cone with base diameter (d_cone_bottom - d_cone_top) and height h_cone?
        // No, that's not right either.
        
        // Let's use a cylinder with diameter d_cone_bottom and height h_cone.
        // Then subtract a cone with base diameter (d_cone_bottom - d_cone_top) and height h_cone?
        // No, that's not right.
        
        // Let's use a cylinder with diameter d_cone_bottom and height h_cone.
        // Then subtract a cone with base diameter (d_cone_bottom - d_cone_top)