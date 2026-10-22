// Pipette Holder Clamp
// Designed for an 18mm shelf.
// Printed lying on its side (XY plane is the profile, Z is the extrusion/length).

// --- Dimensions ---
shelf_thickness = 18.0;
spine_x_end     = 5.0;
spine_y_end     = 28.4;

bottom_jaw_x_start = -25.0;
bottom_jaw_x_end   = 5.0;
bottom_jaw_y_end    = 5.0;

top_jaw_x_start    = -25.0;
top_jaw_x_end      = 65.0;
top_jaw_y_start     = 23.4;
top_jaw_y_end       = 28.4;

extrusion_length    = 105.0;
hole_diameter       = 20.0;
hole_x_pos          = 42.0;
hole_z_pos_1        = 17.5;
hole_z_pos_2        = 52.5;
hole_z_pos_3        = 87.5;

$fn = 64;

// --- Geometry Construction ---

module profile() {
    union() {
        // Spine (back vertical part)
        square([spine_x_end, spine_y_end]);
        
        // Bottom Jaw
        translate([bottom_jaw_x_start, 0]) 
            square([bottom_jaw_x_end - bottom_jaw_x_start, bottom_jaw_y_end]);
        
        // Top Jaw and Arm
        translate([top_jaw_x_start, top_jaw_y_start]) 
            square([top_jaw_x_end - top_jaw_x_start, top_jaw_y_end - top_jaw_y_start]);
    }
}

difference() {
    // The main extruded body
    linear_extrude(height = extrusion_length) {
        profile();
    }

    // The three pipette holes
    // Holes are centered at x = 42 and specific Z positions.
    // They go through the arm along the Y axis.
    // To ensure they cut through, we center them at the Y-midpoint of the arm.
    // Arm Y-midpoint = (23.4 + 28.4) / 2 = 25.9
    for (z_pos = [hole_z_pos_1, hole_z_pos_2, hole_z_pos_3]) {
        translate([hole_x_pos, (top_jaw_y_start + top_jaw_y_end) / 2, z_pos])
        rotate([0, 90, 0]) 
        cylinder(h = 100, d = hole_diameter); 
    }
}