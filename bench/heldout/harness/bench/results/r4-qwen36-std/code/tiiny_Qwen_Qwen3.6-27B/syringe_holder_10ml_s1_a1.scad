// Wall-mounted 10 mL Syringe Holder
// Dimensions measured with calipers

// Block dimensions
block_w = 50;  // Width (X)
block_d = 30;  // Depth (Y)
block_h = 40;  // Height (Z)

// Barrel channel
barrel_dia = 16;       // Syringe barrel diameter
channel_w = 16.5;      // Channel width (clearance)
channel_r = channel_w / 2;  // Radius of back half-circle

// Flange slot
flange_w = 34;         // Slot width (X)
flange_h = 2.6;        // Slot height (Z)
flange_z_start = 30;   // Bottom of slot
flange_y_end = 11;     // Depth from front (y = -15 to y = 11)

// Wall screw holes
screw_dia = 4.5;       // Hole diameter for M4 screws
screw_x = 19;          // X position of holes (±)
screw_z = 15;          // Z position of holes

// Print quality
$fn = 64;

// Main block, centred on origin in X and Y, resting on z=0
// X: -25 to 25, Y: -15 to 15, Z: 0 to 40
difference() {
    // Solid block
    translate([-block_w/2, -block_d/2, 0])
        cube([block_w, block_d, block_h]);

    // Barrel channel: half-circle at back (y=15) extending to front (y=-15)
    // The half-circle is centred at x=0, y=15 (back face)
    // We model the channel as a union of a half-cylinder at the back and a rectangular prism
    
    // Half-cylinder at the back (cutting into the block from y=15 inward)
    // Orient cylinder along Y axis, centred at (0, 15, block_h/2)
    translate([0, 15, block_h/2])
        rotate([90, 0, 0])  // Orient cylinder along Y
        cylinder(r=channel_r, h=block_h, center=true);
    
    // Rectangular part of the channel (straight sides)
    // From y = 15 - channel_r = 6.75 to y = -15
    // Depth = 6.75 - (-15) = 21.75
    // Centre Y = (6.75 + (-15)) / 2 = -4.125
    translate([0, -4.125, block_h/2])
        cube([channel_w, 21.75, block_h], center=true);

    // Flange slot
    // 34 mm wide (X, centred), 2.6 mm tall (z=30 to 32.6), cut from front (y=-15) back to y=11
    // Depth of cut: from y=-15 to y=11, so length = 26 mm
    // Centre Y = (-15 + 11) / 2 = -2
    // Centre Z = 30 + 2.6/2 = 31.3
    translate([0, -2, 31.3])
        cube([flange_w, 26, flange_h], center=true);

    // Wall screw holes (through Y, from front to back)
    // Two holes at x = -19 and 19, z = 15
    for (sx = [-screw_x, screw_x]) {
        translate([sx, 0, screw_z])
            rotate([90, 0, 0])  // Orient along Y
            cylinder(r=screw_dia/2, h=block_d + 2, center=true);  // +2 for overcut
    }
}