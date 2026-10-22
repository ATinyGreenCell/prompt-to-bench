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
hole_spacing = 35.0;         // Distance between hole centers (52.5 - 17.5)
hole_x_offset = 42.0;        // X-coordinate of hole centers
hole_z_start = 17.5;         // First hole Z-coordinate
hole_z_end = 87.5;           // Last hole Z-coordinate
hole_z_step = 35.0;          // Increment between holes

$fn = 64;

// --- Modeling ---

// The part is printed lying on its side.
// In use: +Y is up, +X is away from shelf.
// In print: XY plane is the profile, Z is the extrusion.
// Therefore: 
// Profile X -> Print X
// Profile Y -> Print Y
// Profile Z -> Print Z (extrusion)

// Wait, the prompt says: "extruded 105 mm along Z (in use, +Y is up and +X points away from the shelf)".
// This implies the profile is in the XY plane and the extrusion is along Z.
// However, the prompt also says "three round 20 mm holes go through the arm along Y (vertically in use)".
// If the holes go through the arm along Y, and the extrusion is along Z, the holes are perpendicular to the extrusion.
// Let's map the user's "In Use" coordinates to "Print" coordinates:
// In Use X -> Print X
// In Use Y -> Print Y (Vertical)
// In Use Z -> Print Z (Extrusion)
// BUT the prompt says: "three round 20 mm holes... centred at x = 42 and z = 17.5, 52.5 and 87.5".
// This means the holes are drilled through the Z-axis (the extrusion direction).
// If holes go through the arm "along Y", they are perpendicular to the extrusion.
// Let's re-read: "three round 20 mm holes go through the arm along Y (vertically in use)".
// If the holes are "along Y", the axis of the hole is Y.
// If the holes are centered at z = 17.5, 52.5, 87.5, then the holes are spaced along the Z axis.
// This means the holes are drilled through the thickness of the arm (the X-Y plane).

module profile() {
    difference() {
        // Main Body (C-shape)
        union() {
            // Spine: x [0, 5], y [0, 28.4]
            translate([0, 0])
                cube([spine_width, spine_depth]);
            
            // Bottom Jaw: x [-25, 5], y [0, 5]
            translate([-bottom_jaw_width, 0])
                cube([bottom_jaw_width + spine_width, bottom_jaw_depth]);
            
            // Top Jaw and Arm: x [-25, 65], y [23.4, 28.4]
            // Note: x = 65 is the end of the arm.
            translate([-bottom_jaw_width, top_jaw_depth])
                cube([bottom_jaw_width + arm_length, top_jaw_depth]);
        }

        // The holes: "go through the arm along Y". 
        // This means the hole axis is the Y axis.
        // The centers are at x=42 and z=17.5, 52.5, 87.5.
        // To drill through the arm (which is thin in Y), the hole must be along Y.
        // The arm is at y = 23.4 to 28.4.
        // To ensure the hole cuts through, we extend the cylinder in Y.
        for (z_pos = [hole_z_start, hole_z_start + hole_z_step, hole_z_end]) {
            translate([hole_x_offset, -1, z_pos])
                rotate([0, 90, 0])
                    cylinder(d = hole_diameter, h = spine_depth + 2);
        }
    }
}

// Final Assembly
// We extrude the profile along the Z axis.
// However, the holes are described as being at specific Z coordinates.
// This means the holes are NOT through the extrusion, but rather the extrusion 
// is the length of the part, and the holes are drilled through the "thickness" of the profile.
// If the holes are "along Y", they are perpendicular to the extrusion (Z).

// Let's re-interpret: 
// The profile is the cross-section. The part is extruded 105mm along Z.
// The holes are centered at x=42 and z=17.5, 52.5, 87.5.
// If the holes are "along Y", they are perpendicular to the Z-extrusion.
// This means the holes are drilled through the profile's Y-dimension.

// Correct approach for "extruded 105mm along Z":
// 1. Create the 2D profile.
// 2. Extrude it 105mm along Z.
// 3. Subtract holes that are oriented along the Y axis.

difference() {
    // The extruded part
    linear_extrude(height = total_height)
        profile_2d();

    // The holes: oriented along Y, centered at x=42, z=17.5, 52.5, 87.5
    for (z_pos = [hole_z_start, hole_z_start + hole_z_step, hole_z_end]) {
        translate([hole_x_offset, -1, z_pos])
            rotate([0, 90, 0])
                cylinder(d = hole_diameter, h = total_height + 2);
    }
}

// Helper module for the 2D profile
module profile_2d() {
    union() {
        // Spine
        square([spine_width, spine_depth]);
        // Bottom Jaw
        translate([-bottom_jaw_width, 0])
            square([bottom_jaw_width + spine_width, bottom_jaw_depth]);
        // Top Jaw and Arm
        translate([-bottom_jaw_width, top_jaw_depth])
            square([bottom_jaw_width + arm_length, top_jaw_depth]);
    }
}