// --- Dimensions ---
shelf_thickness = 18.0;      // Thickness of the shelf (mm)
clamp_gap = 18.4;            // Gap for the shelf (mm)
spine_width = 5.0;           // Width of the vertical spine (mm)
spine_depth = 28.4;          // Depth of the spine (mm)
bottom_jaw_width = 25.0;     // Width of the bottom jaw (mm)
bottom_jaw_depth = 5.0;       // Depth of the bottom jaw (mm)
arm_length = 65.0;           // Length of the arm extending forward (mm)
total_height = 105.0;        // Extrusion length along Z (mm)
hole_diameter = 20.0;        // Diameter of pipette holes (mm)
hole_x_offset = 42.0;        // X position of hole centers (mm)

// Hole Z-positions (as specified for the print orientation)
hole_z_1 = 17.5;
hole_z_2 = 52.5;
hole_z_3 = 87.5;

// --- Constants ---
$fn = 64;

// --- Modeling ---

// The user specified:
// 1. Print orientation: Lying on its side, XY plane is the profile, Z is extrusion (105mm).
// 2. Profile: 
//    - Spine: x=[0, 5], y=[0, 28.4]
//    - Bottom jaw: x=[-25, 5], y=[0, 5]
//    - Top jaw/arm: x=[-25, 65], y=[23.4, 28.4]
// 3. Holes: 20mm diameter, through the arm along Y (vertically in use).
//    - In use, +Y is up. In print orientation, Z is the extrusion (105mm).
//    - If the holes are "vertically in use" (+Y is up), the hole axis must be the Y axis.
//    - This means the holes are drilled through the "depth" of the profile.

module profile_shape() {
    union() {
        // Spine: x=[0, 5], y=[0, 28.4]
        translate([0, 0])
            square([spine_width, spine_depth]);
        
        // Bottom Jaw: x=[-25, 5], y=[0, 5]
        translate([-bottom_jaw_width, 0])
            square([bottom_jaw_width + spine_width, bottom_jaw_depth]);
        
        // Top Jaw and Arm: x=[-25, 65], y=[23.4, 28.4]
        // Note: The user specified the top jaw is at y=23.4 to 28.4.
        // The arm extends to x=65.
        translate([-bottom_jaw_width, 23.4])
            square([bottom_jaw_width + arm_length, 5.0]);
    }
}

// The part is built by extruding the 2D profile along Z.
// The holes are subtracted from the 3D volume.
// To ensure the holes appear in the horizontal slices (Z-slices), 
// the subtraction must be performed on the 3D object.

difference() {
    // Main Body
    linear_extrude(height = total_height)
        profile_shape();

    // Holes
    // The user says: "three round 20 mm holes go through the arm along Y (vertically in use)".
    // In the print orientation, +Y is the depth of the profile (0 to 28.4).
    // To cut "through the arm along Y", the cylinder axis must be the Y axis.
    // The holes are centered at x=42 and z=17.5, 52.5, 87.5.
    for (z_pos = [hole_z_1, hole_z_2, hole_z_3]) {
        // We translate to the center of the hole.
        // We rotate 90 degrees around X to align the cylinder axis with Y.
        // We extend the cylinder in Y to ensure it cuts through the entire profile.
        translate([hole_x_offset, -1, z_pos]) 
            rotate([0, 90, 0])
                cylinder(d = hole_diameter, h = spine_depth + 2);
    }
}