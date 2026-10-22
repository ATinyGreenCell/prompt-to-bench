// Wall-mounted 10 mL syringe holder (tip down, printed as used)

$fn = 64;

// Block
block_w = 50;        // X width
block_d = 30;        // Y depth
block_h = 40;        // Z height

// Barrel channel
channel_w = 16.5;    // channel width (X)
channel_r = channel_w / 2; // back half-circle radius (8.25)
channel_cx = 0;      // circle centre X
channel_cy = 0;      // circle centre Y

// Flange slot
slot_w = 34;         // X width, centred
slot_z0 = 30;        // slot bottom Z
slot_h = 2.6;        // slot height
slot_back_y = 11;    // slot back end Y

// Screw holes
screw_d = 4.5;       // M4 clearance hole diameter
screw_x = 19;        // +/- X position
screw_z = 15;        // Z position

eps = 1;             // cutter overshoot

difference() {
    // Main block
    translate([-block_w/2, -block_d/2, 0])
        cube([block_w, block_d, block_h]);

    // Barrel channel: half-circle back end + straight sides to front
    translate([channel_cx, channel_cy, -eps])
        cylinder(r = channel_r, h = block_h + 2*eps);
    translate([channel_cx - channel_r, -block_d/2 - eps, -eps])
        cube([channel_w, block_d/2 + eps + channel_cy, block_h + 2*eps]);

    // Flange slot, open to the front face
    translate([-slot_w/2, -block_d/2 - eps, slot_z0])
        cube([slot_w, (slot_back_y + block_d/2) + eps, slot_h]);

    // Screw holes through along Y
    for (sx = [-screw_x, screw_x])
        translate([sx, 0, screw_z])
            rotate([90, 0, 0])
                cylinder(d = screw_d, h = block_d + 2*eps, center = true);
}