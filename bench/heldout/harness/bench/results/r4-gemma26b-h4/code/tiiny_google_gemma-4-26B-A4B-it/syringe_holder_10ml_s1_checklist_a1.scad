// Wall-mounted syringe holder for 10mL syringe
// Corrected centering and geometry to match exact specifications.

// --- Dimensions ---
block_w = 50.0;       // Width (X)
block_d = 30.0;       // Depth (Y)
block_h = 40.0;       // Height (Z)

barrel_dia = 16.5;    // Diameter of the syringe barrel channel
barrel_rad = barrel_dia / 2;

flange_w = 34.0;      // Width of the flange slot (X)
flange_h = 2.6;       // Height of the flange slot (Z)
flange_z_start = 30.0; // Bottom of the flange slot
flange_y_end = 11.0;  // How far back the slot goes (Y)

screw_hole_d = 4.5;   // Diameter for M4 screws
screw_hole_x = 19.0;  // Offset from center for screw holes (X)
screw_hole_z = 15.0;  // Height of screw holes (Z)

$fn = 64;

// --- Modeling ---

// The main block
difference() {
    // Base block centered on XY, sitting on Z=0
    // To center on Y, we translate by -block_d/2
    translate([-block_w/2, -block_d/2, 0])
        cube([block_w, block_d, block_h]);

    // 1. Syringe Barrel Channel
    // Back end is a half-circle of 8.25mm radius centered at x=0, y=15 (back face)
    // Straight sides run forward to the front face (y=-15)
    // We use a hull of a half-cylinder at the back and a rectangle at the front
    hull() {
        // Back half-circle at y = 15 (the back face)
        // We use a cylinder and rotate it to create the half-circle profile
        translate([0, block_d/2, 0])
            rotate([90, 0, 0])
                cylinder(h = barrel_dia, d = barrel_dia);
        
        // Front rectangle to ensure it cuts through the front face (y=-15)
        translate([-barrel_rad, -block_d - 1, -1])
            cube([barrel_dia, block_d + 2, block_h + 2]);
    }

    // 2. Flange Slot
    // Cut from the front face (y = -15) back to y = 11
    // X is centered, Z is 30 to 32.6
    translate([-flange_w/2, -block_d - 1, flange_z_start])
        cube([flange_w, (block_d/2 + 11) + 2, flange_h]);

    // 3. Screw Holes
    // Two M4 holes through the block along Y axis at x = +/- 19, z = 15
    for (sx = [-screw_hole_x, screw_hole_x]) {
        translate([sx, -block_d - 1, screw_hole_z])
            rotate([-90, 0, 0])
                cylinder(h = block_d + 2, d = screw_hole_d);
    }
}