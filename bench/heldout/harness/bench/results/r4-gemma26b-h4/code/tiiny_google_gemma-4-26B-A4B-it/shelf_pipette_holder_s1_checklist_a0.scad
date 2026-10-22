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

// The profile is defined in the XY plane.
// The part is extruded along Z.
// Note: The user requested the part be printed lying on its side.
// In OpenSCAD, we define the 2D profile and extrude it along Z.

module profile() {
    difference() {
        // Main C-shape body
        union() {
            // Spine (back vertical part)
            translate([0, 0]) square([spine_x_end, spine_y_end]);
            
            // Bottom Jaw
            translate([bottom_jaw_x_start, 0]) square([bottom_jaw_x_end - bottom_jaw_x_start, bottom_jaw_y_end]);
            
            // Top Jaw and Arm
            translate([top_jaw_x_start, top_jaw_y_start]) square([top_jaw_x_end - top_jaw_x_start, top_jaw_y_end - top_jaw_y_start]);
        }
        
        // The gap for the shelf (18mm) is implicitly created by the space between 
        // the bottom jaw (y=5) and top jaw (y=23.4). 
        // 23.4 - 5 = 18.4mm gap, which accommodates the 18mm shelf.
    }
}

// The user specifies the holes go through the arm along Y (vertically in use).
// Since the part is printed on its side (Z is extrusion), "vertically in use" 
// means the holes are drilled through the thickness of the arm (the Y direction).
// However, in the print orientation (XY profile, Z extrusion), 
// the "arm" is the part extending along the X axis.
// The user says: "Three round 20 mm holes go through the arm along Y (vertically in use)".
// In the print orientation (XY plane is profile), Y is the "vertical" direction of the profile.
// Therefore, the holes are cylinders oriented along the Y axis.

difference() {
    // The main extruded body
    linear_extrude(height = extrusion_length) {
        profile();
    }

    // The three pipette holes
    // They are centered at x = 42 and specific Z positions.
    // They go "through the arm along Y".
    // To cut through the Y direction, we rotate the cylinder.
    for (z_pos = [hole_z_pos_1, hole_z_pos_2, hole_z_pos_3]) {
        translate([hole_x_pos, 0, z_pos])
        rotate([0, 90, 0]) // Rotate to align cylinder with Y axis
        cylinder(h = 100, d = hole_diameter); // h is large to ensure complete cut
    }
}