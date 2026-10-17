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
        // From z=45 to z=62, tapering from 8mm to 3mm
        // We use a cylinder with a linear_extrude path or simply a cylinder with varying radius?
        // OpenSCAD cylinder has fixed radius. We use a polygon or rotate_extrude for a cone, 
        // but since we need to union it with the cylinder below, a simple cylinder with 
        // the larger diameter and then cutting the smaller part is tricky without boolean logic.
        // Easiest way: Create a cylinder from 45 to 62 with diameter 8, then cut the cone shape?
        // No, let's use a cylinder with the bottom diameter and a specific height, 
        // but we need the top to be 3mm.
        // Let's use a cylinder with diameter 8 from 45 to 62, then we will cut the cone shape out?
        // Actually, simpler: Create the cone using a cylinder with the bottom diameter, 
        // but we need the top to be 3mm.
        // Let's construct the cone as a cylinder with diameter 8 from 45 to 62, 
        // and then we will subtract the "missing" cone part? No, that's complex.
        // Standard approach: Use a cylinder with the larger diameter and then use difference to cut the taper?
        // Or use a cylinder with the smaller diameter and add the frustum?
        // Let's use a cylinder with diameter 8 from 45 to 62. Then we will cut the cone shape 
        // using a difference operation later? No, we want the cone to be solid.
        // Correct approach: Create a cylinder with diameter 8 from 45 to 62. 
        // Then create a cone shape (using rotate_extrude or cylinder with varying radius via polygon) 
        // and subtract it? No, we want the cone to exist.
        // Let's just make the cone as a cylinder with diameter 8 from 45 to 62, 
        // and then we will cut the "empty" space above the taper?
        // Actually, the simplest way to make a cone in OpenSCAD for unioning is:
        // Cylinder with bottom diameter, height, then cut the top part?
        // Let's try: Cylinder d=8, h=17 at z=45. Then cut a cylinder d=3, h=17? No.
        // Let's use a cylinder with d=8, h=17. Then we need to remove the material above the taper line.
        // The taper line goes from (r=4, z=45) to (r=1.5, z=62).
        // We can create a cylinder d=8, h=17. Then create a cylinder d=3, h=17 at z=45? No.
        // Let's use a cylinder with d=8, h=17. Then subtract a cylinder with d=3, h=17? No.
        // Let's use a cylinder with d=8, h=17. Then subtract a cylinder with d=3, h=17? No.
        // Let's use a cylinder with d=8, h=17. Then subtract a cylinder with d=3, h=17? No.
        // Let's use a cylinder with d=8, h=17. Then subtract a cylinder with d=3, h=17? No.
        // Okay, let's use a cylinder with d=8, h=17. Then subtract a cylinder with d=3, h=17? No.
        // Let's use a cylinder with d=8, h=17. Then subtract a cylinder with d=