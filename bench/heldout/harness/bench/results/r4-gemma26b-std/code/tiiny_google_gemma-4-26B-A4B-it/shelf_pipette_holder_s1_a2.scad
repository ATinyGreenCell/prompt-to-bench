// --- Dimensions ---
shelf_thickness = 18.0;      // Thickness of the shelf (mm)
clamp_gap = 18.4;            // Gap width for the shelf (mm)
spine_width = 5.0;           // Width of the vertical spine (mm)
spine_depth = 28.4;          // Depth of the spine (mm)
bottom_jaw_width = 25.0;     // Width of the bottom jaw (mm)
bottom_jaw_depth = 5.0;       // Depth of the bottom jaw (mm)
top_jaw_width = 90.0;        // Total width of the top jaw/arm (mm)
top_jaw_depth = 5.0;         // Depth of the top jaw (mm)
arm_length = 65.0;           // Length of the arm extending forward (mm)
total_height = 105.0;        // Total extrusion length (Z-axis in print)

hole_diameter = 20.0;        // Diameter of pipette holes (mm)
hole_x_offset = 42.0;        // X-coordinate of hole centers
hole_z_start = 17.5;         // First hole Z-coordinate
hole_z_end = 87.5;           // Last hole Z-coordinate
hole_z_step = 35.0;          // Increment between holes (52.5 - 17.5)

$fn = 64;

// --- Modeling ---
// The user specified:
// 1. Profile is in XY plane.
// 2. Extruded 105mm along Z.
// 3. Print orientation: Lying on its side (XY plane is the profile).
// 4. Holes: "go through the arm along Y (vertically in use)".
//    In the print orientation (Z is extrusion), "vertically in use" is the Y axis.
//    Therefore, the holes are cylinders oriented along the Y axis.
//    The previous report showed 0 holes in the slices, meaning the holes 
//    were not intersecting the solid part. 
//    The arm is at y = 23.4 to 28.4. 
//    The hole axis is Y, so the cylinder must be placed such that its 
//    center (x=42, z=17.5) is within the arm's footprint.
//    Wait, the arm is at y = 23.4 to 28.4. The hole is centered at x=42, z=17.5.
//    The arm's X range is [-25, 65]. 42 is inside.
//    The arm's Z range is [0, 105]. 17.5 is inside.
//    The hole is oriented along Y. The arm's Y range is [23.4, 28.4].
//    The previous code used `rotate([0, 90, 0])` which rotates around X.
//    A rotation of [0, 90, 0] makes the cylinder axis point along the Y axis.
//    However, the cylinder was translated to `y = -1`. 
//    If the hole is centered at x=42, z=17.5 and goes "along Y", 
//    the cylinder should be centered at y = (23.4 + 28.4)/2 = 25.9.

module profile_2d() {
    union() {
        // Spine: x [0, 5], y [0, 28.4]
        square([spine_width, spine_depth]);
        
        // Bottom jaw: x [-25, 5], y [0, 5]
        translate([-bottom_jaw_width, 0])
            square([bottom_jaw_width + spine_width, bottom_jaw_depth]);
        
        // Top jaw and arm: x [-25, 65], y [23.4, 28.4]
        // The arm extends to x = 65. The total width is 65 - (-25) = 90.
        translate([-bottom_jaw_width, 23.4])
            square([bottom_jaw_width + arm_length, top_jaw_depth]);
    }
}

difference() {
    // The extruded part
    linear_extrude(height = total_height)
        profile_2d();

    // The holes: oriented along Y (the vertical axis in use).
    // They are centered at x = 42 and z = 17.5, 52.5, 87.5.
    // To ensure they cut through the arm (which is at y = 23.4 to 28.4),
    // we center the cylinder on the arm's Y-midpoint.
    for (z_pos = [hole_z_start, hole_z_start + hole_z_step, hole_z_end]) {
        translate([hole_x_offset, (23.4 + 28.4)/2, z_pos])
            rotate([0, 90, 0])
                cylinder(d = hole_diameter, h = spine_depth + 2);
    }
}