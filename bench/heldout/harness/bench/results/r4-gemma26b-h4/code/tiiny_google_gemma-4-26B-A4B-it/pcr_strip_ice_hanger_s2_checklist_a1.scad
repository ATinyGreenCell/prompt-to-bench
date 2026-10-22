// PCR Strip Holder for Ice Bucket - Corrected
// Designed to hang over a 12mm wall and hold an 8-tube PCR strip.

// --- Dimensions ---
length_x      = 84.0;    // Total extrusion length along X
inner_leg_y_max = 4.0;    // Top of inner leg Y
outer_leg_y_min = 16.5;   // Bottom of outer leg Y
outer_leg_y_max = 20.5;   // Top of outer leg Y
leg_height    = 50.0;    // Height of the vertical legs
bridge_z_min   = 46.0;    // Bottom of the top bridge Z
bridge_z_max   = 50.0;    // Top of the top bridge Z
ledge_thick   = 6.0;     // Thickness of the ledge (Z: 0 to 6)
ledge_width   = 30.0;    // How far the ledge extends into the ice (-Y direction)
tube_hole_d    = 6.4;    // Diameter of the PCR tube holes
tube_hole_y   = -15.0;   // Y-position of the tube holes
tube_hole_x_p = 9.0;     // Pitch/spacing between tube holes along X
num_tubes     = 8;        // Number of tubes

$fn = 64;

// --- Construction ---

module holder_body() {
    // 1. Inner Leg: Y from 0 to 4, Z from 0 to 50
    translate([-length_x/2, 0, 0]) 
        cube([length_x, inner_leg_y_max, leg_height]);
    
    // 2. Outer Leg: Y from 16.5 to 20.5, Z from 0 to 50
    translate([-length_x/2, outer_leg_y_min, 0]) 
        cube([length_x, outer_leg_y_max - outer_leg_y_min, leg_height]);
    
    // 3. Bridge: Y from 4 to 16.5, Z from 46 to 50
    translate([-length_x/2, inner_leg_y_max, bridge_z_min]) 
        cube([length_x, outer_leg_y_min - inner_leg_y_max, bridge_z_max - bridge_z_min]);
    
    // 4. Ledge: Y from 0 to -30, Z from 0 to 6
    translate([-length_x/2, -ledge_width, 0]) 
        cube([length_x, ledge_width, ledge_thick]);
}

// Final Render with Hole Subtraction
difference() {
    holder_body();
    
    // Subtract the tube holes from the ledge
    // Holes are centered along X. 
    // Total length of holes span: (num_tubes - 1) * tube_hole_x_p
    for (i = [0 : num_tubes - 1]) {
        // Calculate X position to center the grid of 8 holes on X=0
        x_pos = (i - (num_tubes - 1) / 2) * tube_hole_x_p;
        
        // Translate to the hole center and extend slightly in Z to ensure clean cut
        translate([x_pos, tube_hole_y, -1]) 
            cylinder(h = ledge_thick + 2, d = tube_hole_d);
    }
}