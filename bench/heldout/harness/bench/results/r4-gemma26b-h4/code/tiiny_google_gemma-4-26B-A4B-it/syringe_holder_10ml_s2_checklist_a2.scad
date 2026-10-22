// Wall-mounted syringe holder for 10mL syringe
// Designed for FDM printing, standing on the XY plane.

// --- Dimensions ---
block_w = 50.0;      // Block width (X)
block_d = 30.0;      // Block depth (Y)
block_h = 40.0;      // Block height (Z)

barrel_dia = 16.5;   // Width of the vertical barrel channel
barrel_rad = barrel_dia / 2;

flange_w = 34.0;     // Width of the flange slot (X)
flange_h = 2.6;      // Height of the flange slot (Z)
flange_z_start = 30.0; // Bottom of the flange slot
flange_y_depth = 11.0; // How far back the slot goes from the front face

screw_hole_d = 4.5;  // Diameter for M4 screws
screw_hole_x = 19.0; // Offset of screw holes from center (X)
screw_hole_z = 15.0; // Height of screw holes (Z)

$fn = 64;

// --- Modeling ---

// The block is centered on X and Y.
// X: -25 to 25
// Y: -15 to 15 (Back face at y=15, Front face at y=-15)
// Z: 0 to 40

difference() {
    // 1. The main block
    translate([-block_w/2, -block_d/2, 0])
        cube([block_w, block_d, block_h]);

    // 2. Barrel Channel (Subtracted)
    // "a 16.5 mm wide vertical barrel channel runs through the full height"
    // "its back end is a half-circle of 8.25 mm radius centred at x = 0, y = 0"
    // "its straight sides run forward to the front face (y = -15)"
    // This implies the profile in XY is a rectangle from y=-15 to y=0 
    // and a semi-circle centered at (0,0) extending to y=8.25.
    translate([0, 0, -1])
    linear_extrude(height = block_h + 2) {
        union() {
            // Rectangular part: x from -8.25 to 8.25, y from -15 to 0
            translate([-barrel_rad, -15, 0])
                square([barrel_dia, 15]);
            
            // Semi-circle part: centered at (0,0) with radius 8.25
            // We use a circle and cut it to keep only the part where y > 0
            difference() {
                circle(d = barrel_dia);
                translate([-barrel_rad, -barrel_rad, 0])
                    square([barrel_dia, barrel_rad]);
            }
        }
    }

    // 3. Flange Slot (Subtracted)
    // "34 mm wide (X, centred) and 2.6 mm tall (z = 30 to 32.6), 
    // is cut in from the front face back to y = 11."
    // Front face is at y = -15.
    // Slot goes from y = -15 to y = 11.
    translate([-flange_w/2, -15 - 1, flange_z_start])
        cube([flange_w, flange_y_depth + 2, flange_h]);

    // 4. Screw Holes (Subtracted)
    // "Two 4.5 mm holes for M4 wall screws go straight through from front to back (along Y) 
    // at x = -19 and 19, z = 15."
    for (sx = [-screw_hole_x, screw_hole_x]) {
        translate([sx, -15 - 1, screw_hole_z])
            cube([screw_hole_d, block_d + 2, screw_hole_d]);
    }
}