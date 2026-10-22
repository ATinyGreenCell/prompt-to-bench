// PCR Strip Holder for Ice Bucket
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

// --- Calculations ---
// The profile is defined in the YZ plane.
// Inner leg: y from 0 to 4, z from 0 to 50.
// Outer leg: y from 16.5 to 20.5, z from 0 to 50.
// Bridge: y from 4 to 16.5, z from 46 to 50.
// Ledge: y from -30 to 0, z from 0 to 6.

// Calculate X-offset for the holes to be centered
// Holes are at [i - (n-1)/2] * pitch
// For 8 tubes, indices are -3.5, -2.5, -1.5, -0.5, 0.5, 1.5, 2.5, 3.5
// Total span = (8-1) * 9 = 63mm.

module profile_yz() {
    difference() {
        // Main U-shape profile
        union() {
            // Inner Leg
            translate([0, 0]) square([leg_thickness, inner_leg_h]);
            // Outer Leg
            translate([wall_gap + leg_thickness, 0]) square([leg_thickness, outer_leg_h]);
            // Bridge
            translate([0, 46]) square([wall_gap + 2 * leg_thickness, bridge_h]);
            // Ledge
            translate([-ledge_depth, 0]) square([ledge_depth + leg_thickness, ledge_thick]);
        }
        
        // Subtract the tube holes from the ledge
        // Holes are at y = -15 (relative to the profile's Y=0)
        // In our profile, the ledge is from y = -30 to 0.
        // We need to translate the holes to the correct Y position.
        // The ledge is part of the profile, so we subtract holes from the extruded shape.
        for (i = [0 : num_tubes - 1]) {
            let (x_pos = (i - (num_tubes - 1) / 2) * tube_pitch)
            translate([x_pos, -15, -1]) 
                cylinder(h = ledge_thick + 2, d = tube_hole_d);
        }
    }
}

// --- Final Assembly ---
// The profile is extruded along X.
// The user wants it centered on X, so we translate by -length_x/2.
// The profile is in YZ plane, so we extrude along X.

translate([-length_x / 2, 0, 0])
    linear_extrude(height = length_x)
        profile_yz();