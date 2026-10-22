// PCR Strip Holder for Ice Bucket - Corrected Orientation
// Designed to hang over a 12mm wall and hold an 8-tube PCR strip.

// --- Dimensions ---
length_x      = 84.0;    // Extrusion length along X
wall_gap      = 12.5;    // Gap for the bucket wall (16.5 - 4.0 = 12.5)
inner_leg_h    = 50.0;    // Height of the inner leg
outer_leg_h    = 50.0;    // Height of the outer leg
leg_thickness  = 4.0;     // Thickness of the legs (20.5 - 16.5 = 4.0)
bridge_h       = 4.0;     // Height of the top bridge (50 - 46 = 4)
ledge_thick    = 6.0;     // Thickness of the ledge (z = 0 to 6)
ledge_depth    = 30.0;    // Depth of the ledge into the ice (y = 0 to -30)
tube_hole_d    = 6.4;     // Diameter of the PCR tube holes
tube_pitch     = 9.0;     // Spacing between tube holes along X
num_tubes      = 8;       // Number of tubes

$fn = 64;

// --- Construction ---

// We define the 2D profile in the YZ plane.
// To extrude along X, we must rotate the 2D shape 90 degrees around X
// so that the extrusion direction (Z) aligns with the X axis.
module profile_yz() {
    // Inner Leg: y from 0 to 4, z from 0 to 50
    square([4, inner_leg_h]);
    
    // Outer Leg: y from 16.5 to 20.5, z from 0 to 50
    translate([16.5, 0]) square([leg_thickness, outer_leg_h]);
    
    // Bridge: y from 4 to 16.5, z from 46 to 50
    translate([4, 46]) square([wall_gap, bridge_h]);
    
    // Ledge: y from -30 to 0, z from 0 to 6
    translate([-ledge_depth, 0]) square([ledge_depth, ledge_thick]);
}

// Final Assembly
difference() {
    // 1. Create the 3D body
    // We rotate the 2D profile 90 degrees around X so that the 
    // extrusion (Z) goes along the X axis.
    // Then we translate to center it on X.
    translate([-length_x / 2, 0, 0])
    rotate([0, 90, 0])
    linear_extrude(height = length_x) {
        profile_yz();
    }

    // 2. Subtract the tube holes
    // The holes are vertical (along Z).
    // In the extruded part, the "ledge" is now in the XZ plane.
    // The user wants holes at y = -15.
    // Because we rotated the profile, the original Y (ledge depth) 
    // is now the Z axis of the 3D part.
    // The original Z (height) is now the Y axis of the 3D part.
    // The original X (extrusion) is now the X axis of the 3D part.
    
    // Let's re-map based on the rotation:
    // Original Profile Y -> 3D Z
    // Original Profile Z -> 3D Y
    // Original Profile X -> 3D X
    
    // Ledge is at original Y = -30 to 0. In 3D, this is Z = -30 to 0.
    // Ledge thickness is original Z = 0 to 6. In 3D, this is Y = 0 to 6.
    // Tube position is original Y = -15. In 3D, this is Z = -15.
    // Tube holes are vertical (original Z). In 3D, this is Y.
    
    for (i = [0 : num_tubes - 1]) {
        // X position: centered on 0
        let (x_pos = (i - (num_tubes - 1) / 2) * tube_pitch)
        
        // Translate to hole location:
        // X: x_pos
        // Y: -1 (to ensure it cuts through the ledge height)
        // Z: -15 (the target Y position in the original profile)
        translate([x_pos, -1, -15]) 
            cylinder(h = 8, d = tube_hole_d);
    }
}