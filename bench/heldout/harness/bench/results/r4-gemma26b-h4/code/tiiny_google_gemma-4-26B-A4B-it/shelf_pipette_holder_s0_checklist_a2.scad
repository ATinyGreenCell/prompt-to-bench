// Pipette Holder Clamp - Corrected v3
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
hole_y_center       = 25.9; // Midpoint of top jaw (23.4 + 28.4)/2
hole_z_centers       = [17.5, 52.5, 87.5]; 

$fn = 64;

module profile() {
    union() {
        // Spine
        polygon(points=[[spine_x_start, spine_y_start], [spine_x_end, spine_y_start], [spine_x_end, spine_y_end], [spine_x_start, spine_y_end]]);
        // Bottom Jaw
        polygon(points=[[bottom_jaw_x_start, bottom_jaw_y_start], [bottom_jaw_x_end, bottom_jaw_y_start], [bottom_jaw_x_end, bottom_jaw_y_end], [bottom_jaw_x_start, bottom_jaw_y_end]]);
        // Top Jaw/Arm
        polygon(points=[[top_jaw_x_start, top_jaw_y_start], [top_jaw_x_end, top_jaw_y_start], [top_jaw_x_end, top_jaw_y_end], [top_jaw_x_start, top_jaw_y_end]]);
    }
}

difference() {
    // Main Body
    linear_extrude(height = extrusion_z)
        profile();

    // Holes through the arm along Y
    // To ensure they cut through, we translate the cylinder so its center is at hole_y_center
    // and its height spans the entire Y range of the part.
    for (z_pos = hole_z_centers) {
        translate([hole_x_center, 0, z_pos]) // Start at y=0
            rotate([0, 90, 0])               // Rotate to point along Y
                cylinder(h = 30, d = hole_diameter); // h=30 is > max Y (28.4)
    }
}