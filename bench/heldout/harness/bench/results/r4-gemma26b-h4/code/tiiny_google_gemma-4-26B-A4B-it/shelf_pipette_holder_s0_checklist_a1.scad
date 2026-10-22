// Pipette Holder Clamp - Corrected
// Designed for an 18mm thick shelf.
// Printed lying on its side (XY plane is the profile, Z is the extrusion/length).

// --- Dimensions ---
shelf_thickness = 18.0;
spine_x_start   = 0.0;
spine_x_end     = 5.0;
spine_y_start   = 0.0;
spine_y_end     = 28.4;

bottom_jaw_x_start = -25.0;
bottom_jaw_x_end   = 5.0;
bottom_jaw_y_start = 0.0;
bottom_jaw_y_end   = 5.0;

top_jaw_x_start    = -25.0;
top_jaw_x_end      = 65.0;
top_jaw_y_start    = 23.4;
top_jaw_y_end      = 28.4;

extrusion_z         = 105.0;

hole_diameter       = 20.0;
hole_x_center       = 42.0;
hole_y_center       = 25.9; // Midpoint of top jaw (23.4 + 28.4)/2 = 25.9
hole_z_centers       = [17.5, 52.5, 87.5]; 

$fn = 64;

module profile() {
    // Using a polygon to ensure a single continuous manifold shape
    // The profile is a C-shape:
    // 1. Bottom jaw: (-25,0) to (5,0) to (5,5) to (-25,5)
    // 2. Spine: (0,5) to (5,5) to (5,28.4) to (0,28.4)
    // 3. Top jaw: (-25,23.4) to (65,23.4) to (65,28.4) to (-25,28.4)
    // We combine these using union to ensure they are one piece.
    union() {
        // Bottom Jaw
        polygon(points=[[bottom_jaw_x_start, bottom_jaw_y_start], [bottom_jaw_x_end, bottom_jaw_y_start], [bottom_jaw_x_end, bottom_jaw_y_end], [bottom_jaw_x_start, bottom_jaw_y_end]]);
        // Spine
        polygon(points=[[spine_x_start, spine_y_start], [spine_x_end, spine_y_start], [spine_x_end, spine_y_end], [spine_x_start, spine_y_end]]);
        // Top Jaw/Arm
        polygon(points=[[top_jaw_x_start, top_jaw_y_start], [top_jaw_x_end, top_jaw_y_start], [top_jaw_x_end, top_jaw_y_end], [top_jaw_x_start, top_jaw_y_end]]);
    }
}

difference() {
    // Main Body
    linear_extrude(height = extrusion_z)
        profile();

    // Holes through the arm along Y (vertically in use)
    // The arm is in the XY plane, so "vertically in use" means the Y axis.
    // We subtract cylinders along the Y axis.
    for (z_pos = hole_z_centers) {
        translate([hole_x_center, -1, z_pos]) // -1 to ensure it cuts through the face
            rotate([0, 90, 0])               // Rotate to point along Y
                cylinder(h = 10, d = hole_diameter); 
    }
}