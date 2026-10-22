// --- Dimensions (mm) ---
block_width = 50;          // X dimension
block_depth = 30;          // Y dimension
block_height = 40;         // Z dimension

barrel_radius = 8.25;      // Half of 16.5mm channel width
flange_slot_width = 34;    // X dimension of slot
flange_slot_height = 2.6;  // Z dimension of slot
flange_slot_z_start = 30;  // Bottom of slot
flange_slot_z_end = 32.6;  // Top of slot
flange_slot_depth_end = 11; // Slot ends at y = 11 (relative to center 0,0)
                             // Note: If Y=11 is the end, and front is Y=-15, 
                             // the slot length is 11 - (-15) = 26mm.

screw_hole_diameter = 4.5; // M4 screw hole
screw_hole_x_offset = 19;  // X offset for screws
screw_hole_z_pos = 15;     // Z height for screws

// --- Constants ---
$fn = 64;

// --- Main Construction ---

// The part is centered on X and Y, resting on Z=0.
// Back face is at Y = 15, Front face is at Y = -15.

difference() {
    // 1. The Main Block
    // Positioned so Z=0 is the bottom, and X/Y are centered on 0.
    translate([-block_width/2, -block_depth/2, 0])
    cube([block_width, block_depth, block_height]);

    // 2. Barrel Channel
    // "back end is a half-circle of 8.25mm radius centred at x=0, y=0"
    // "straight sides run forward to the front face (y = -15)"
    // This means the curved part is at Y=0 and the channel extends to Y=-15.
    // To ensure a clean cut through the front face, we extend the cylinder slightly.
    translate([0, -15.01, 0])
    rotate([90, 0, 0])
    cylinder(h = 15.02, r = barrel_radius);

    // 3. Flange Slot
    // "34 mm wide (X, centred) and 2.6 mm tall (z = 30 to 32.6), 
    // cut in from the front face back to y = 11"
    // Front face is Y = -15. The slot goes from Y = -15 to Y = 11.
    // We use a small epsilon (0.01) to ensure the cut is clean.
    translate([-flange_slot_width/2, -15.01, flange_slot_z_start])
    cube([flange_slot_width, 11 - (-15.01) + 0.01, flange_slot_height]);

    // 4. Screw Holes
    // "Two 4.5 mm holes... go straight through from front to back (along Y) 
    // at x = -19 and 19, z = 15"
    // We extend the cylinder in Y to ensure it cuts through both faces.
    translate([-screw_hole_x_offset, -15.01, screw_hole_z_pos - (screw_hole_diameter/2)])
    cylinder(h = block_depth + 2, d = screw_hole_diameter);

    translate([screw_hole_x_offset, -15.01, screw_hole_z_pos - (screw_hole_diameter/2)])
    cylinder(h = block_depth + 2, d = screw_hole_diameter);
}