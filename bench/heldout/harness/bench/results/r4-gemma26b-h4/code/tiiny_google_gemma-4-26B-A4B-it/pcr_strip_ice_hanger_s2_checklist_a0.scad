// PCR Strip Holder for Ice Bucket
// Designed to hang over a 12mm wall and hold an 8-tube PCR strip.

// --- Dimensions ---
length_x      = 84.0;    // Total extrusion length along X
wall_gap      = 12.5;    // Gap for the bucket wall (16.5 - 4.0 = 12.5)
inner_leg_y   = 4.0;     // Y-coordinate of the inner leg face
outer_leg_y   = 20.5;    // Y-coordinate of the outer leg face
leg_thickness = 2.0;     // Thickness of the vertical legs (20.5 - 18.5 = 2.0)
leg_height    = 50.0;    // Height of the vertical legs
bridge_thick  = 4.0;     // Thickness of the top bridge (50 - 46 = 4)
bridge_height  = 50.0;   // Z-height of the top of the bridge
ledge_thick   = 6.0;     // Thickness of the ledge (Z: 0 to 6)
ledge_width   = 30.0;    // How far the ledge extends into the ice (-Y direction)
tube_hole_d    = 6.4;    // Diameter of the PCR tube holes
tube_hole_y   = -15.0;   // Y-position of the tube holes
tube_hole_x_p = 9.0;     // Pitch/spacing between tube holes along X
num_tubes     = 8;        // Number of tubes

$fn = 64;

// --- Calculations ---
// The profile is defined in the YZ plane and extruded along X.
// The profile is an upside-down U.
// Inner leg: y from 0 to 4, z from 0 to 50.
// Outer leg: y from 16.5 to 20.5, z from 0 to 50.
// Bridge: y from 4 to 16.5, z from 46 to 50.
// Ledge: y from 0 to -30, z from 0 to 6.

module profile_yz() {
    difference() {
        // Main U-shape profile
        union() {
            // Inner Leg
            translate([0, 0]) square([inner_leg_y, leg_height]);
            // Outer Leg
            translate([outer_leg_y - leg_thickness, 0]) square([leg_thickness, leg_height]);
            // Bridge
            translate([inner_leg_y, bridge_height - bridge_thick]) 
                square([outer_leg_y - inner_leg_y, bridge_thick]);
            // Ledge
            translate([-ledge_width, 0]) square([ledge_width, ledge_thick]);
        }
        
        // Subtract the tube holes from the ledge
        // Holes are centered along X. 
        // Total length of holes span: (num_tubes - 1) * tube_hole_x_p
        // We center this span on X=0.
        for (i = [0 : num_tubes - 1]) {
            x_pos = (i - (num_tubes - 1) / 2) * tube_hole_x_p;
            translate([x_pos, tube_hole_y, -1]) 
                circle(d = tube_hole_d);
        }
    }
}

// --- Final Assembly ---
// The profile is extruded along X, centered on X=0.
// The profile is in the YZ plane.
// To achieve this, we use linear_extrude on the 2D profile.

translate([-length_x / 2, 0, 0])
    linear_extrude(height = 1) // This is a placeholder; we use the 2D profile logic
    intersection() {
        // We define the 2D shape and extrude it along X.
        // However, the prompt says "profile in YZ plane extruded 84mm along X".
        // This means the 2D shape is in YZ, and we extrude along X.
        
        // Let's build the 3D object by extruding the 2D profile.
        // Since OpenSCAD extrudes along Z, we must rotate the profile.
        
        rotate([90, 0, 0]) // Rotate profile to lie in XY plane for extrusion
        linear_extrude(height = length_x)
        difference() {
            // The 2D profile (YZ)
            union() {
                // Inner Leg
                square([inner_leg_y, leg_height]);
                // Outer Leg
                translate([outer_leg_y - leg_thickness, 0]) square([leg_thickness, leg_height]);
                // Bridge
                translate([inner_leg_y, bridge_height - bridge_thick]) square([outer_leg_y - inner_leg_y, bridge_thick]);
                // Ledge
                translate([-ledge_width, 0]) square([ledge_width, ledge_thick]);
            }
            
            // Subtract holes from the ledge in 2D
            // Note: In 2D, the ledge is at Y=0 to -30. The holes are at Y=-15.
            // But our profile is rotated. Let's rethink the construction to be cleaner.
        }
    }

// --- REWRITTEN CLEAN CONSTRUCTION ---
// To avoid rotation confusion, we build the 3D parts directly.

module holder_3d() {
    // 1. The U-shape (Legs and Bridge)
    union() {
        // Inner Leg
        translate([-length_x/2, 0, 0]) cube([length_x, inner_leg_y, leg_height]);
        // Outer Leg
        translate([-length_x/2, outer_leg_y - leg_thickness, 0]) cube([length_x, leg_thickness, leg_height]);
        // Bridge
        translate([-length_x/2, inner_leg_y, bridge_height - bridge_thick]) cube([length_x, outer_leg_y - inner_leg_y, bridge_thick]);
        // Ledge
        translate([-length_x/2, -ledge_width, 0]) cube([length_x, ledge_width, ledge_thick]);
    }
}

// Final Render
difference() {
    holder_3d();
    
    // Subtract the tube holes
    for (i = [0 : num_tubes - 1]) {
        x_pos = (i - (num_tubes - 1) / 2) * tube_hole_x_p;
        translate([x_pos, tube_hole_y, -1]) 
            cylinder(h = ledge_thick + 2, d = tube_hole_d);
    }
}