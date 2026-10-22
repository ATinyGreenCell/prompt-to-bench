// Pipette Holder Clamp
// Designed for an 18mm thick shelf.
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
top_jaw_y_start    = 23.4;
top_jaw_y_end      = 28.4;

extrusion_z         = 105.0;

hole_diameter       = 20.0;
hole_x_center       = 42.0;
hole_y_center       = 17.5; // This is the vertical center in the profile (Y in profile, but Z in print)
hole_z_centers       = [17.5, 52.5, 87.5]; // The user specified Z positions for the holes

$fn = 64;

// The user requested the part be printed lying on its side.
// The profile is in the XY plane.
// The extrusion is along Z.
// The profile coordinates provided:
// Spine: x[0,5], y[0,28.4]
// Bottom Jaw: x[-25,5], y[0,5]
// Top Jaw/Arm: x[-25,65], y[23.4,28.4]

module profile() {
    union() {
        // Spine
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
    // Main Body
    linear_extrude(height = extrusion_z)
        profile();

    // Holes through the arm
    // The holes are "through the arm along Y (vertically in use)".
    // In the print orientation (XY profile, Z extrusion), "vertically in use" means the Y axis.
    // However, the user says "centred at x = 42 and z = 17.5, 52.5 and 87.5".
    // This implies the holes are drilled through the thickness of the arm (the Y direction).
    
    for (z_pos = hole_z_centers) {
        translate([hole_x_center, -1, z_pos])
            rotate([0, 90, 0])
                cylinder(h = 30, d = hole_diameter); // 30 is enough to clear the profile thickness
    }
}